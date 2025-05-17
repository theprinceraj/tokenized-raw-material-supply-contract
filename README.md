# Aptos Supply Chain Smart Contract

This project implements a tokenized raw material supply chain smart contract on the Aptos blockchain. It enables suppliers and buyers to create and fulfill supply contracts using Aptos tokens.

## Features

- Create supply contracts for raw materials
- Specify material details, quantity, and price
- Secure payment processing using Aptos tokens
- Contract fulfillment tracking
- Built-in test cases

## Prerequisites

- [Aptos CLI](https://aptos.dev/tools/aptos-cli/install-cli/)
- [Move](https://move-language.github.io/move/introduction.html) programming language knowledge
- An Aptos account (can be created using the Aptos CLI)

## Project Structure

```
aptos-workshop/
├── sources/
│   └── project.move      # Main smart contract code
├── Move.toml             # Project configuration and dependencies
└── README.md            # This file
```

## Smart Contract Overview

The contract provides two main functions:

1. `create_contract`: Allows suppliers to create new supply contracts
   - Parameters: supplier, buyer address, material name, quantity, price per unit
   - Creates a new contract and stores it in the supplier's account

2. `fulfill_contract`: Allows buyers to fulfill contracts
   - Parameters: buyer and supplier address
   - Handles the payment transfer and marks the contract as fulfilled

## Setup and Deployment

1. Initialize the project (if not already done):
```bash
aptos init
```

2. Compile the contract:
```bash
aptos move compile
```

3. Deploy the contract:
```bash
aptos move publish
```

## Testing

The contract includes built-in test cases. To run the tests:

```bash
aptos move test
```

## Usage Example

1. Create a new supply contract:
```move
create_contract(
    supplier,
    buyer_address,
    b"Steel",  // material name
    100,       // quantity
    10         // price per unit
);
```

2. Fulfill a contract:
```move
fulfill_contract(
    buyer,
    supplier_address
);
```

## Error Codes

- `E_NOT_AUTHORIZED (1)`: Unauthorized access attempt
- `E_CONTRACT_FULFILLED (2)`: Attempt to fulfill an already fulfilled contract
- `E_INSUFFICIENT_PAYMENT (3)`: Insufficient payment for contract fulfillment

## Security Considerations

- All transactions are signed and verified
- Payment processing is handled through Aptos's secure coin module
- Contract state changes are atomic and verified

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is licensed under the MIT License - see the LICENSE file for details. 