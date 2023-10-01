// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import { ERC20Burnable, ERC20 } from "openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import { Ownable } from "@openzeppelin/contract/access/Ownable.sol";
import { ReentrancyGuard} from "openzeppelin/contract/security/ReentrancyGuard.sol";
import { IERC20 } from "openzeppelin/contracts/token/ERC20/IERC20.sol";
import Ex from "./Ex.sol";
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
contract ExEngin is ReentrancyGuard {
    constructor(
        address[] memory tokenAddresses, 
        address[] memory priceFeedAddresses, 
        address exAddress) {
        if (tokenAddress.length != priceFeedAddresses.length) {
            revert ExEngine_TokenAddressesAndPriceFeedAddressesMustBeSameLength();
        }

        // Example ETH, USD / USD, MKR
        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            s_priceFeeds[tokenAddresses[i]] = priceFeedAddresses[i];
        }

        i_ex = Ex(exAddress);
    }

    // Errors
    error ExEngine_NeedsMoreThanZero();
    error ExEngine_TokenAddressesAndPriceFeedAddressesMustBeSameLength();
    error ExEngine_NotAllowedToken();
    error ExEngine_TransferFailed();

    // State variables
    mapping(address token => address priceFeed) private s_priceFeeds; //tokenToPriceFeed
    mapping(address user => mapping(address token => uint256 amount)) private 
        s_collateralDeposited;
    mapping(address user => uint256 amountExMinted) private s_ExMinted;

    // Events
    event CollateralDeposited(address indexed user, address indexed token, uint256 amount);

    Ex private immutable i_ex;

    // Modifiers
    modifier moreThanZero(uint256 amount) {
        if (amount == 0) {
            revert ExEngine_NeedsMoreThanZero();
        }
        _;
    }

    modifier isAllowedToken(address token) {
        if (s_priceFeeds[token] == address(0)) {
            revert ExEngine_NotAllowedToken();
        }
    }

    // Functions
    function depositCollateralAndMintEx() external {}

    /**
     * @notice Follows CEI
     * @param tokenCollateralAddress The address of the token to deposit as collateral
     * @param amountCollateral The amount of collateral to deposit
     */
    function depositCollateral(
        address tokenCollateralAddress, 
        uint256 amountCollateral) external
        moreThanZero((amountCollateral))
        isAllowedToken(tokenCollateralAddress) 
        nonReentrant
        {
            s_collateralDeposited[msg.sender] += amountCollateral;
            emit CollateralDeposited(msg.sender, tokenCollateralAddress, amountCollateral);

            bool success = IERC20(tokenCollateralAddress).transerFrom(msg.sender, address(this), ammountCollateral);
            if (!success) {
                revert ExEngine_TransferFailed();
            }

    }

    function redeemCollateralForEx() external {}

    function redeemCollateral() external {}

    /**
     * @notice follows CEI
     * @param amountExToMint The amount of Ex to mint
     * @notice They must have more collateral value than the minimum threshold
     */
    function mintEx(uint256 amountExToMint) external moreThanZero(amountExToMint) noReentrant {
        s_ExMinted[msg.sender] += amountExToMint;

        revertIfHealthFactorIsBroken(msg.sender);
    }

    function burnEx() external {}

    function liquidate() external {}

    function getHealthFactor() external view {}

    // Internal
    // Health Factor = sum of((collateral_in_ETH[i] * liquidation_threshold[i])) / total_borrows_in_eth
    function revertIfHealthFactorIsBroken(address sender) internal view {

    }
}