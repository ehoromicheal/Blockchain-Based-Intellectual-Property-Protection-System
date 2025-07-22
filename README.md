# Blockchain-Based Intellectual Property Protection System

A comprehensive suite of Clarity smart contracts for protecting and managing intellectual property rights on the Stacks blockchain.

## Overview

This system provides five core contracts that work together to create a complete IP protection ecosystem:

1. **Patent Filing Timestamp Contract** - Creates immutable proof of invention dates and establishes priority
2. **Copyright Registration Contract** - Establishes ownership of creative works with blockchain verification
3. **Licensing Revenue Distribution Contract** - Automates royalty payments to IP owners
4. **Prior Art Verification Contract** - Validates patent novelty against existing blockchain records
5. **IP Infringement Detection Contract** - Monitors and reports unauthorized use of protected IP

## Key Features

### Patent Protection
- Immutable timestamp recording for invention disclosure
- Priority date establishment for patent applications
- Inventor verification and ownership tracking
- Patent status management (pending, granted, expired)

### Copyright Management
- Creative work registration with metadata storage
- Ownership verification and transfer capabilities
- License type specification and management
- Revenue tracking for licensed works

### Automated Licensing
- Smart contract-based royalty distribution
- Multi-party revenue sharing with configurable percentages
- Automatic payment processing for IP usage
- License term and condition enforcement

### Prior Art Database
- Blockchain-based prior art storage and verification
- Patent novelty checking against existing records
- Searchable invention database with categorization
- Conflict detection for similar inventions

### Infringement Monitoring
- IP usage tracking and violation detection
- Automated alert system for unauthorized use
- Evidence collection and timestamping
- Dispute resolution workflow support

## Contract Architecture

Each contract is designed to be independent while maintaining data consistency across the system. The contracts use standardized data structures and error handling patterns.

### Data Types
- **IP Records**: Core intellectual property information
- **Ownership Data**: Creator and current owner details
- **License Terms**: Usage rights and restrictions
- **Revenue Shares**: Payment distribution configurations
- **Timestamps**: Immutable date/time records

### Security Features
- Multi-signature requirements for critical operations
- Access control with role-based permissions
- Input validation and sanitization
- Reentrancy protection mechanisms

## Getting Started

### Prerequisites
- Clarinet CLI installed
- Node.js 18+ for testing
- Stacks wallet for contract deployment

### Installation

\`\`\`bash
# Clone the repository
git clone <repository-url>
cd ip-protection-blockchain

# Install dependencies
npm install

# Run tests
npm test

# Deploy contracts (testnet)
clarinet deploy --testnet
\`\`\`

### Usage Examples

#### Register a Patent
\`\`\`clarity
(contract-call? .patent-timestamp register-patent
"Revolutionary AI Algorithm"
"Detailed technical description..."
"Technology/AI")
\`\`\`

#### Register Copyright
\`\`\`clarity
(contract-call? .copyright-registration register-work
"My Novel Title"
"Literary Work"
"Creative Commons"
"QmHash123...")
\`\`\`

#### Set Up Licensing
\`\`\`clarity
(contract-call? .licensing-revenue add-license-agreement
u1 ; IP ID
'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7 ; licensee
u1000 ; fee amount
u365) ; duration in days
\`\`\`

## Testing

The test suite covers all contract functions with comprehensive scenarios:

\`\`\`bash
# Run all tests
npm test

# Run specific test file
npm test patent-timestamp.test.js

# Run with coverage
npm run test:coverage
\`\`\`

## Contract Deployment

### Testnet Deployment
\`\`\`bash
clarinet deploy --testnet
\`\`\`

### Mainnet Deployment
\`\`\`bash
clarinet deploy --mainnet
\`\`\`

## API Reference

### Patent Timestamp Contract
- \`register-patent\`: Record new patent with timestamp
- \`update-patent-status\`: Change patent status
- \`get-patent-info\`: Retrieve patent details
- \`verify-priority\`: Check invention priority

### Copyright Registration Contract
- \`register-work\`: Register creative work
- \`transfer-ownership\`: Change work ownership
- \`get-work-info\`: Retrieve work details
- \`verify-ownership\`: Confirm current owner

### Licensing Revenue Contract
- \`add-license-agreement\`: Create new license
- \`distribute-revenue\`: Process royalty payments
- \`get-license-info\`: Retrieve license terms
- \`calculate-royalties\`: Compute payment amounts

### Prior Art Verification Contract
- \`add-prior-art\`: Record existing invention
- \`check-novelty\`: Verify patent uniqueness
- \`search-prior-art\`: Find similar inventions
- \`get-art-details\`: Retrieve prior art info

### IP Infringement Detection Contract
- \`report-infringement\`: File violation report
- \`verify-infringement\`: Validate violation claims
- \`get-infringement-status\`: Check report status
- \`resolve-dispute\`: Process resolution

## Error Codes

| Code | Description |
|------|-------------|
| u100 | Unauthorized access |
| u101 | Invalid input parameters |
| u102 | Resource not found |
| u103 | Duplicate entry |
| u104 | Insufficient funds |
| u105 | Operation not permitted |
| u106 | Contract state error |
| u107 | Time constraint violation |

## Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions and support, please open an issue on the GitHub repository or contact the development team.
