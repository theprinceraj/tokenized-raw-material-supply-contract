module SupplyChainAptos::RawMaterialSupply {
    use std::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a raw material supply contract
    struct SupplyContract has key {
        material_name: vector<u8>,
        quantity: u64,
        price_per_unit: u64,
        supplier: address,
        buyer: address,
        is_fulfilled: bool
    }

    /// Error codes
    const E_NOT_AUTHORIZED: u64 = 1;
    const E_CONTRACT_FULFILLED: u64 = 2;
    const E_INSUFFICIENT_PAYMENT: u64 = 3;

    /// Create a new supply contract
    public entry fun create_contract(
        supplier: &signer,
        buyer: address,
        material_name: vector<u8>,
        quantity: u64,
        price_per_unit: u64
    ) {
        let supplier_addr = signer::address_of(supplier);

        let contract = SupplyContract {
            material_name,
            quantity,
            price_per_unit,
            supplier: supplier_addr,
            buyer,
            is_fulfilled: false
        };

        move_to(supplier, contract);
    }

    /// Fulfill the supply contract by paying for the materials
    public entry fun fulfill_contract(
        buyer: &signer,
        supplier_addr: address
    ) acquires SupplyContract {
        let buyer_addr = signer::address_of(buyer);
        let contract = borrow_global_mut<SupplyContract>(supplier_addr);

        // Verify the buyer is authorized
        assert!(contract.buyer == buyer_addr, E_NOT_AUTHORIZED);
        // Verify the contract is not already fulfilled
        assert!(!contract.is_fulfilled, E_CONTRACT_FULFILLED);

        let total_payment = contract.quantity * contract.price_per_unit;
        
        // Transfer payment from buyer to supplier
        let payment = coin::withdraw<AptosCoin>(buyer, total_payment);
        coin::deposit<AptosCoin>(supplier_addr, payment);

        // Mark contract as fulfilled
        contract.is_fulfilled = true;
    }

    #[test(admin = @0x1234, buyer = @0x5678)]
    public entry fun test_supply_contract(
        admin: &signer,
        buyer: &signer
    ) acquires SupplyContract {
        // Create test accounts
        aptos_framework::account::create_account_for_test(signer::address_of(admin));
        aptos_framework::account::create_account_for_test(signer::address_of(buyer));

        // Create a supply contract
        create_contract(
            admin,
            signer::address_of(buyer),
            b"Steel",
            100,
            10
        );

        // Fulfill the contract
        fulfill_contract(buyer, signer::address_of(admin));
    }
} 