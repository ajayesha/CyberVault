# CyberVault-DataOptions 

> *"Welcome to the data underground, netrunner. Your neural link is your lifeline."*

A cyberpunk-themed smart contract for trading encrypted data packets in the digital underground. Built on the Stacks blockchain with Clarity, CyberVault enables netrunners to upload, trade, and execute data contracts in a decentralized cyber-economy.

## 🔌 Overview

CyberVault-DataOptions is a decentralized marketplace where "netrunners" (users) can:
- Upload encrypted data packets to the network
- Create derivative contracts based on data streams
- Trade upload and download rights
- Execute data contracts with automated credit transfers
- Build reputation through successful transactions

## 🧠 Core Concepts

### Netrunners
Users of the system who can jack into the network to trade data. Each netrunner has:
- A cyber wallet with credits
- A profile tracking their coded and downloaded packets
- The ability to create and execute data contracts

### Data Contracts
Smart contracts representing data packets with properties:
- **Packet ID**: Unique identifier
- **Coder**: Original uploader
- **Client**: Optional buyer/executor
- **Protocol Type**: Upload (1) or Download (2) stream
- **Execution Price**: Cost to execute the contract
- **Access Fee**: Fee paid to the coder
- **Deadline**: Expiration timestamp
- **Data Size**: Size of the packet
- **Encryption Status**: Whether data is encrypted
- **Execution Status**: Whether contract has been executed

### Credits
The native currency of the cyber-economy. Credits can be:
- Deposited via `jack-in-credits`
- Withdrawn via `jack-out-credits`
- Transferred between netrunners automatically during contract execution

## 🚀 Getting Started

### Prerequisites
- Stacks wallet (Leather, Xverse, etc.)
- STX tokens for transaction fees
- Understanding of Clarity smart contracts

### Basic Workflow

1. **Jack In**: Deposit credits to your cyber wallet
   ```clarity
   (contract-call? .cybervault-dataoptions jack-in-credits u1000)
   ```

2. **Upload Data**: Create a data contract (function not shown in provided code)

3. **Execute Contracts**: Purchase and execute data contracts

4. **Jack Out**: Withdraw credits when needed
   ```clarity
   (contract-call? .cybervault-dataoptions jack-out-credits u500)
   ```

## 📡 Contract Functions

### Public Functions

#### Credit Management

**`jack-in-credits (amount uint)`**
- Deposits credits to the caller's cyber wallet
- Creates wallet if it doesn't exist
- Returns: `(ok true)`

**`jack-out-credits (amount uint)`**
- Withdraws credits from caller's wallet
- Validates sufficient balance
- Returns: `(ok true)` or `ERR-INSUFFICIENT-CREDITS`

### Private Functions

**`wire-transfer (sender principal) (receiver principal) (amount uint)`**
- Transfers credits between two netrunners
- Validates sender has sufficient credits
- Automatically updates both wallets

**`update-netrunner-profiles (user principal) (packet-id uint) (is-coder bool)`**
- Updates user's transaction history
- Tracks coded vs downloaded packets
- Maintains lists up to 20 entries each

**`is-netrunner()`**
- Authorization check for admin functions
- Returns true if caller is the contract deployer

## 🗺️ Data Structures

### CyberWallets
```clarity
{ hacker: principal } -> { credits: uint }
```
Maps each netrunner to their credit balance.

### DataContracts
```clarity
{ packet-id: uint } -> {
    coder: principal,
    client: (optional principal),
    protocol-type: uint,
    execution-price: uint,
    access-fee: uint,
    deadline: uint,
    data-size: uint,
    is-encrypted: bool,
    is-executed: bool,
    upload-timestamp: uint
}
```
Complete data contract specifications.

### NetrunnerProfiles
```clarity
{ user: principal } -> {
    coded: (list 20 uint),
    downloaded: (list 20 uint)
}
```
Transaction history for reputation tracking.

## ⚠️ Error Codes

| Code | Constant | Description |
|------|----------|-------------|
| u1 | `ERR-CONNECTION-TIMEOUT` | Network connection failed |
| u2 | `ERR-INVALID-BANDWIDTH` | Insufficient bandwidth for operation |
| u3 | `ERR-ACCESS-DENIED` | Unauthorized access attempt |
| u4 | `ERR-FILE-NOT-FOUND` | Requested data packet not found |
| u5 | `ERR-INSUFFICIENT-CREDITS` | Not enough credits for transaction |
| u6 | `ERR-ALREADY-DECRYPTED` | Data packet already decrypted |
| u7 | `ERR-CORRUPTED-DATA` | Data integrity check failed |
| u8 | `ERR-NEURAL-LINK-DOWN` | Network connection unavailable |

## 🔧 Protocol Types

- **Upload Stream (u1)**: Contract for uploading data to the network
- **Download Stream (u2)**: Contract for downloading existing data

## 🔮 Roadmap & Missing Functions

Based on the contract structure, the following functions appear to be planned but not yet implemented:

- `upload-data-packet`: Create new data contracts
- `execute-data-contract`: Purchase and execute contracts
- `decrypt-data`: Decrypt purchased data packets
- `check-bandwidth`: Validate network capacity
- `get-market-feed`: Retrieve current market data

## 🛡️ Security Considerations

- All credit transfers are atomic and validated
- Profile updates are limited to 20 entries to prevent bloat
- Access controls distinguish between regular users and admin
- Error handling prevents invalid state transitions

## 🌐 Integration

### Frontend Integration
```javascript
import { StacksMainnet } from '@stacks/network';
import { callReadOnlyFunction } from '@stacks/transactions';

// Check user's credit balance
const balance = await callReadOnlyFunction({
  network: new StacksMainnet(),
  contractAddress: 'CONTRACT_ADDRESS',
  contractName: 'cybervault-dataoptions',
  functionName: 'get-credits', // When implemented
  functionArgs: [principalCV(userAddress)],
});
```

### Smart Contract Interactions
- Deploy on Stacks mainnet or testnet
- Interact via Stacks CLI or web applications
- Monitor events for real-time updates
