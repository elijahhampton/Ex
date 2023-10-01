// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { ERC20Burnable, ERC20 } from "openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import { Ownable } from "@openzeppelin/contract/access/Ownable.sol";

/**
 * @title ExEngine
 * @author Elijah Hampton
 *
 * This system is designed to manage the peg for the stabecoin Ex. This system has the following properties:
 * - Exogenous Collateral
 * - Dollar Pegged
 * - Algoritmicall stable
 *
 * The system that runs Ex should always be over collateralized. At no point, should the value of all collateral <= the $ backed value
 * of all the Ex in the system.
 *
 * This contract is the core of the ExEngine stablecoin system. It handles all the logic for mining and redeeming Ex,
 * as well as depositing and withdrawal collateral.
 */
contract ExEngine {
    constructor() {}

    function depositCollateralAndMintEx() external {}

    function depositCollateral() external {}

    function redeemCollateralForEx() external {}

    function redeemCollateral() external {}

    function mintEx() external {}

    function burnEx() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}
}