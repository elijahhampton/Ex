pragma solidity ^0.8.18;

import { ERC20Burnable, ERC20 } from "openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import { Ownable } from "@openzeppelin/contract/access/Ownable.sol";

/**
 * @title Ex
 * @author Elijah Hampton
 * Collateral: Exogenous (ETH & BTC)
 * Minting: Algorithmic
 * Relative Stability: Pegged to USD
 *
 * This contract is governed by DSCEngine. This contract is just the ERC20 implementation of
 * the stablecoin system.
 */
contract Ex is ERC20Burnable, Ownable {
    error Ex_MustBeMoreThanZero();
    error Ex_BurnAmountExceedsBalance();
    error Ex_NotZeroAddress();

    constructor() ERC20("Ex", "EXC") {}

    function burn(uint256 _amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if (_amount <= 0) {
            revert Ex_MustBeMoreTHanZero();
        }
        if (balance < _amount) {
            revert Ex_BurnAmountExceedsBalance();
        }

        super.burn(_amount);
    }

    function mint(address _to, uint256 _amount) external onlyOwner returns(bool) {
        if (_to == address(0)) {
            revert Ex_NotZeroAddress();
        }

        if (_amount <= 0) {
            revert Ex_MustBeMoreThanZero();
        }

        _mint(_to, _amount);
        return true;
    }
}