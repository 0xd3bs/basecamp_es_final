use basecamp_es_final::ERC20::ERC20;
use starknet::contract_address_const;
use starknet::ContractAddress;
use starknet::testing::set_caller_address;
use integer::u256;
use integer::u256_from_felt252;
use debug::PrintTrait;

const NAME: felt252 = 'DB Coin Basecamp-ES';
const SYMBOL: felt252 = 'DBC';

// Helper function
fn setup() -> (ContractAddress, u256) {
    let initial_supply: u256 = u256_from_felt252(1000000);
    let account: ContractAddress = contract_address_const::<1>();
    let decimals: u8 = 18_u8;

    // Set account as default caller
    set_caller_address(account);

    ERC20::constructor(NAME, SYMBOL, initial_supply, account);
    (account, initial_supply)
}

// Testing
#[test]
#[available_gas(2000000)]
fn test_transfer() {
    let (sender, supply) = setup();

    let recipient: ContractAddress = contract_address_const::<2>();
    let amount: u256 = u256_from_felt252(100);
    ERC20::transfer(recipient, amount);

    assert(ERC20::balance_of(recipient) == amount, 'Balance should eq amount');
    assert(ERC20::balance_of(sender) == supply - amount, 'Should eq supply - amount');
    assert(ERC20::total_supply() == supply, 'Total supply should not change');
}

#[test]
#[available_gas(2000000)]
fn test_transfer_from() {
    let (sender, supply) = setup();
    let recipient: ContractAddress = contract_address_const::<4>();
    let amount: u256 = u256_from_felt252(150);


    ERC20::approve(sender, amount);
    ERC20::transfer_from(sender, recipient, amount);

    assert(ERC20::balance_of(recipient) == amount, 'Balance does not match.');
    assert(ERC20::balance_of(sender) == supply - amount, 'Should eq supply - amount');
    assert(ERC20::total_supply() == supply, 'Total supply should not change');    
}

#[test]
#[available_gas(2000000)]
#[should_panic]
fn test_burn_by_owner_fake_owner() {
    let (owner, supply) = setup();
    let fake_owner: ContractAddress = contract_address_const::<6>();
    let amount: u256 = u256_from_felt252(100);

    // Set account as default caller
    set_caller_address(fake_owner);

    ERC20::burn_by_owner(amount);
}

#[test]
#[available_gas(2000000)]
fn test_burn() {
    let (account, supply) = setup();
    let amount: u256 = u256_from_felt252(100);
    ERC20::burn(account, amount);
    
    assert(ERC20::total_supply() == supply - amount, 'Total supply not change');
    
    // El balance del owner es igual al Supply inicial
    assert(ERC20::balance_of(account) == supply - amount, 'Balance Of not change');

}

#[test]
#[available_gas(2000000)]
#[should_panic]
fn test_burn_fake_owner() {
    let (account, supply) = setup();
    let fake_owner: ContractAddress = contract_address_const::<7>();
    let amount: u256 = u256_from_felt252(100);

    // Set account as default caller
    set_caller_address(fake_owner);

    ERC20::burn(fake_owner, amount);

    assert(ERC20::total_supply() == supply, 'Total supply not change');
}