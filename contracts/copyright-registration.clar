;; Copyright Registration Contract
;; Establishes ownership of creative works with blockchain proof

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-INVALID-INPUT (err u101))
(define-constant ERR-NOT-FOUND (err u102))
(define-constant ERR-ALREADY-EXISTS (err u103))

;; Data Variables
(define-data-var next-work-id uint u1)

;; Data Maps
(define-map copyrighted-works
  { work-id: uint }
  {
    title: (string-ascii 100),
    creator: principal,
    work-type: (string-ascii 50),
    registration-timestamp: uint,
    license-type: (string-ascii 50),
    content-hash: (string-ascii 64),
    metadata-uri: (optional (string-ascii 200))
  }
)

(define-map work-ownership
  { work-id: uint }
  {
    current-owner: principal,
    original-creator: principal,
    transfer-count: uint
  }
)

(define-map creator-works
  { creator: principal }
  { work-ids: (list 100 uint) }
)

(define-map work-licenses
  { work-id: uint }
  {
    license-terms: (string-ascii 200),
    commercial-use: bool,
    derivative-works: bool,
    attribution-required: bool
  }
)

;; Public Functions

;; Register a new copyrighted work
(define-public (register-work (title (string-ascii 100)) (work-type (string-ascii 50)) (license-type (string-ascii 50)) (content-hash (string-ascii 64)))
  (let
    (
      (work-id (var-get next-work-id))
      (current-time (unwrap! (get-block-info? time (- block-height u1)) ERR-INVALID-INPUT))
    )
    (asserts! (> (len title) u0) ERR-INVALID-INPUT)
    (asserts! (> (len work-type) u0) ERR-INVALID-INPUT)
    (asserts! (> (len license-type) u0) ERR-INVALID-INPUT)
    (asserts! (> (len content-hash) u0) ERR-INVALID-INPUT)

    ;; Store work information
    (map-set copyrighted-works
      { work-id: work-id }
      {
        title: title,
        creator: tx-sender,
        work-type: work-type,
        registration-timestamp: current-time,
        license-type: license-type,
        content-hash: content-hash,
        metadata-uri: none
      }
    )

    ;; Set initial ownership
    (map-set work-ownership
      { work-id: work-id }
      {
        current-owner: tx-sender,
        original-creator: tx-sender,
        transfer-count: u0
      }
    )

    ;; Update creator's work list
    (update-creator-works tx-sender work-id)

    ;; Increment work ID counter
    (var-set next-work-id (+ work-id u1))

    (ok work-id)
  )
)

;; Set license terms for a work
(define-public (set-license-terms (work-id uint) (license-terms (string-ascii 200)) (commercial-use bool) (derivative-works bool) (attribution-required bool))
  (let
    (
      (ownership (unwrap! (map-get? work-ownership { work-id: work-id }) ERR-NOT-FOUND))
    )
    (asserts! (is-eq tx-sender (get current-owner ownership)) ERR-UNAUTHORIZED)

    (map-set work-licenses
      { work-id: work-id }
      {
        license-terms: license-terms,
        commercial-use: commercial-use,
        derivative-works: derivative-works,
        attribution-required: attribution-required
      }
    )

    (ok true)
  )
)

;; Transfer work ownership
(define-public (transfer-work-ownership (work-id uint) (new-owner principal))
  (let
    (
      (ownership (unwrap! (map-get? work-ownership { work-id: work-id }) ERR-NOT-FOUND))
    )
    (asserts! (is-eq tx-sender (get current-owner ownership)) ERR-UNAUTHORIZED)
    (asserts! (not (is-eq tx-sender new-owner)) ERR-INVALID-INPUT)

    (map-set work-ownership
      { work-id: work-id }
      {
        current-owner: new-owner,
        original-creator: (get original-creator ownership),
        transfer-count: (+ (get transfer-count ownership) u1)
      }
    )

    ;; Update new owner's work list
    (update-creator-works new-owner work-id)

    (ok true)
  )
)

;; Update work metadata URI
(define-public (update-metadata-uri (work-id uint) (metadata-uri (string-ascii 200)))
  (let
    (
      (work-info (unwrap! (map-get? copyrighted-works { work-id: work-id }) ERR-NOT-FOUND))
      (ownership (unwrap! (map-get? work-ownership { work-id: work-id }) ERR-NOT-FOUND))
    )
    (asserts! (is-eq tx-sender (get current-owner ownership)) ERR-UNAUTHORIZED)

    (map-set copyrighted-works
      { work-id: work-id }
      (merge work-info { metadata-uri: (some metadata-uri) })
    )

    (ok true)
  )
)

;; Verify work authenticity by content hash
(define-public (verify-work-authenticity (work-id uint) (provided-hash (string-ascii 64)))
  (let
    (
      (work-info (unwrap! (map-get? copyrighted-works { work-id: work-id }) ERR-NOT-FOUND))
    )
    (ok (is-eq (get content-hash work-info) provided-hash))
  )
)

;; Read-only Functions

;; Get work information
(define-read-only (get-work-info (work-id uint))
  (map-get? copyrighted-works { work-id: work-id })
)

;; Get work ownership details
(define-read-only (get-work-ownership (work-id uint))
  (map-get? work-ownership { work-id: work-id })
)

;; Get work license terms
(define-read-only (get-work-license (work-id uint))
  (map-get? work-licenses { work-id: work-id })
)

;; Get works by creator
(define-read-only (get-creator-works (creator principal))
  (map-get? creator-works { creator: creator })
)

;; Verify current ownership
(define-read-only (verify-ownership (work-id uint) (claimed-owner principal))
  (match (map-get? work-ownership { work-id: work-id })
    ownership (is-eq (get current-owner ownership) claimed-owner)
    false
  )
)

;; Check if work exists
(define-read-only (work-exists (work-id uint))
  (is-some (map-get? copyrighted-works { work-id: work-id }))
)

;; Get registration timestamp
(define-read-only (get-registration-timestamp (work-id uint))
  (match (map-get? copyrighted-works { work-id: work-id })
    work-info (some (get registration-timestamp work-info))
    none
  )
)

;; Get current work ID counter
(define-read-only (get-next-work-id)
  (var-get next-work-id)
)

;; Private Functions

;; Update creator's work list
(define-private (update-creator-works (creator principal) (work-id uint))
  (let
    (
      (current-works (default-to { work-ids: (list) } (map-get? creator-works { creator: creator })))
      (work-list (get work-ids current-works))
    )
    (map-set creator-works
      { creator: creator }
      { work-ids: (unwrap-panic (as-max-len? (append work-list work-id) u100)) }
    )
  )
)
