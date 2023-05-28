// taken from OpenZeppelin: https://github.com/OpenZeppelin/cairo-contracts/blob/42a160f1f011414e5044b5174e56dcaa73876aae/src/openzeppelin/token/erc20.cairo

use starknet::ContractAddress;

trait IERC20 {
    fn name() -> felt252;
    fn symbol() -> felt252;
    fn decimals() -> u8;
    fn total_supply() -> u256;
    fn who_is_owner() -> ContractAddress;
    fn balance_of(account: ContractAddress) -> u256;
    fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256;
    fn transfer(recipient: ContractAddress, amount: u256) -> bool;
    fn transfer_from(sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool;
    fn approve(spender: ContractAddress, amount: u256) -> bool;
    fn burn(owner: ContractAddress, amount: u256) -> bool;
}

#[contract]
mod ERC20 {
    use zeroable::Zeroable;
    use super::IERC20;
    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use starknet::contract_address::ContractAddressZeroable;

    struct Storage {
        _name: felt252,
        _symbol: felt252,
        _total_supply: u256,
        _balances: LegacyMap<ContractAddress, u256>,
        _allowances: LegacyMap<(ContractAddress, ContractAddress), u256>,
        _owner: ContractAddress,
    }

    #[event]
    fn Transfer(from: ContractAddress, to: ContractAddress, value: u256) {}

    #[event]
    fn Approval(owner: ContractAddress, spender: ContractAddress, value: u256) {}

    impl ERC20 of IERC20 {
        fn name() -> felt252 {
            _name::read()
        }

        fn symbol() -> felt252 {
            _symbol::read()
        }

        fn decimals() -> u8 {
            18_u8
        }

        fn total_supply() -> u256 {
            _total_supply::read()
        }

        fn balance_of(account: ContractAddress) -> u256 {
            _balances::read(account)
        }

        fn who_is_owner() -> ContractAddress {
            _owner::read()
        }
        

        fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256 {
            _allowances::read((owner, spender))
        }

        fn transfer(recipient: ContractAddress, amount: u256) -> bool {
            let sender = get_caller_address();
            _transfer(sender, recipient, amount);
            true
        }

        fn transfer_from(
            sender: ContractAddress, recipient: ContractAddress, amount: u256
        ) -> bool {
            let caller = get_caller_address();
            _spend_allowance(sender, caller, amount);
            _transfer(sender, recipient, amount);
            true
        }

        fn approve(spender: ContractAddress, amount: u256) -> bool {
            let caller = get_caller_address();
            _approve(caller, spender, amount);
            true
        }

        fn burn(owner: ContractAddress, amount: u256) -> bool {
            assert(owner == _owner::read(), 'No es el owner del contrato');
            assert(total_supply() > amount, 'Total supply insuficiente');
            _balances::write(owner,  _balances::read(owner) - amount);
            _total_supply::write(total_supply() - amount);
            true
        }
    }

    #[constructor]
    fn constructor(
        name: felt252, symbol: felt252, initial_supply: u256, recipient: ContractAddress
    ) {
        initializer(name, symbol);
        _mint(recipient, initial_supply);
        _owner::write(recipient);
    }

    #[view]
    fn name() -> felt252 {
        ERC20::name()
    }

    #[view]
    fn symbol() -> felt252 {
        ERC20::symbol()
    }

    #[view]
    fn decimals() -> u8 {
        ERC20::decimals()
    }

    #[view]
    fn total_supply() -> u256 {
        ERC20::total_supply()
    }

    #[view]
    fn balance_of(account: ContractAddress) -> u256 {
        ERC20::balance_of(account)
    }

    #[view]
    fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256 {
        ERC20::allowance(owner, spender)
    }

    #[view]
    fn who_is_owner() -> ContractAddress {
        _owner::read()
    }
    

    #[external]
    fn transfer(recipient: ContractAddress, amount: u256) -> bool {
        ERC20::transfer(recipient, amount)
    }

    #[external]
    fn transfer_from(sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool {
        ERC20::transfer_from(sender, recipient, amount)
    }

    #[external]
    fn approve(spender: ContractAddress, amount: u256) -> bool {
        ERC20::approve(spender, amount)
    }

    #[external]
    fn increase_allowance(spender: ContractAddress, added_value: u256) -> bool {
        _increase_allowance(spender, added_value)
    }

    #[external]
    fn decrease_allowance(spender: ContractAddress, subtracted_value: u256) -> bool {
        _decrease_allowance(spender, subtracted_value)
    }

    #[external]
    fn burn(owner : ContractAddress, amount: u256) -> bool{
        ERC20::burn(owner, amount)
    }     

    ///
    /// Internals
    ///

    fn initializer(name_: felt252, symbol_: felt252) {
        _name::write(name_);
        _symbol::write(symbol_);
    }

    fn _increase_allowance(spender: ContractAddress, added_value: u256) -> bool {
        let caller = get_caller_address();
        _approve(caller, spender, _allowances::read((caller, spender)) + added_value);
        true
    }

    fn _decrease_allowance(spender: ContractAddress, subtracted_value: u256) -> bool {
        let caller = get_caller_address();
        _approve(caller, spender, _allowances::read((caller, spender)) - subtracted_value);
        true
    }

    fn _mint(recipient: ContractAddress, amount: u256) {
        assert(!recipient.is_zero(), 'ERC20: mint to 0');
        _total_supply::write(_total_supply::read() + amount);
        _balances::write(recipient, _balances::read(recipient) + amount);
        Transfer(Zeroable::zero(), recipient, amount);
    }

    fn _approve(owner: ContractAddress, spender: ContractAddress, amount: u256) {
        assert(!owner.is_zero(), 'ERC20: approve from 0');
        assert(!spender.is_zero(), 'ERC20: approve to 0');
        _allowances::write((owner, spender), amount);
        Approval(owner, spender, amount);
    }

    fn _transfer(sender: ContractAddress, recipient: ContractAddress, amount: u256) {
        assert(!sender.is_zero(), 'ERC20: transfer from 0');
        assert(!recipient.is_zero(), 'ERC20: transfer to 0');
        _balances::write(sender, _balances::read(sender) - amount);
        _balances::write(recipient, _balances::read(recipient) + amount);
        Transfer(sender, recipient, amount);
    }

    fn _spend_allowance(owner: ContractAddress, spender: ContractAddress, amount: u256) {
        let current_allowance = _allowances::read((owner, spender));
        let ONES_MASK = 0xffffffffffffffffffffffffffffffff_u128;
        let is_unlimited_allowance =
            current_allowance.low == ONES_MASK & current_allowance.high == ONES_MASK;
        if !is_unlimited_allowance {
            _approve(owner, spender, current_allowance - amount);
        }
    }
}

#[cfg(test)]
mod tests{
 
    use integer::u256;
    use integer::u256_from_felt252;
    use starknet::ContractAddress;
    use starknet::contract_address_const;
    use super::ERC20;

    const NAME: felt252 = 'DB Coin Basecamp-ES';
    const SYMBOL: felt252 = 'DBC';

    #[test]
    #[available_gas(2000000)]
    fn test_01_constructor(){
        let initial_supply: u256 = u256_from_felt252(1000000);
        let total_supply: u256 = u256_from_felt252(1000000);
        let account: ContractAddress = contract_address_const::<1>();
        let decimals: u8 = 18_u8;

        ERC20::constructor(NAME, SYMBOL, initial_supply, account);

        //let res_name = ERC20::get_name();
        //assert(res_name == NAME, 'Name does not match.');

        let res_symbol = ERC20::symbol();
        assert(res_symbol == SYMBOL, 'Symbol does not match.');

        // Test decimals
        //assert(ERC20::get_decimals() == decimals, 'Decimals does not match.');

        // Test total_supply
        assert(ERC20::total_supply() == total_supply, 'Total_supply does not match.');

        // IMPORTATE: When implementing functions like _transfer and _approve, some checks needed to be
        // done. During the contract compilation process, an error was encountered: The value does not
        // fit within the range of type core::felt252. This error occurred because the ASCII value did
        // not fit inside a felt252. It is important to note that the ASCII value must fit inside a felt252.
        // Short Strings. En resumen el literaral del assert no puede superar los 31 Caracteres,
        // tomado de https://github.com/codeWhizperer/min-cairo-project

        // Test the balance of the account variable
        assert(ERC20::balance_of(account) == initial_supply, 'Balance of does not match.');

        // Test del owner del contrato
        assert(ERC20::who_is_owner() == contract_address_const::<1>(), 'Se esperaba el owner');

    }
}