// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

<<<<<<< HEAD
import {UbiquityDollarManager} from
    "../../src/dollar/core/UbiquityDollarManager.sol";
import {UbiquityGovernanceToken} from "../../src/dollar/core/UbiquityGovernanceToken.sol";
import {CreditRedemptionCalculator} from
    "../../src/dollar/core/CreditRedemptionCalculator.sol";
import {CreditNFTRedemptionCalculator} from
    "../../src/dollar/core/CreditNFTRedemptionCalculator.sol";
import {DollarMintCalculator} from
    "../../src/dollar/core/DollarMintCalculator.sol";
import {DollarMintExcess} from
    "../../src/dollar/core/DollarMintExcess.sol";
import {MockCreditNFT} from "../../src/dollar/mocks/MockCreditNFT.sol";
import {MockDollarToken} from "../../src/dollar/mocks/MockDollarToken.sol";
import {MockTWAPOracleDollar3pool} from "../../src/dollar/mocks/MockTWAPOracleDollar3pool.sol";
import {MockCreditToken} from "../../src/dollar/mocks/MockCreditToken.sol";
=======
import {UbiquityAlgorithmicDollarManager} from "../../src/dollar/UbiquityAlgorithmicDollarManager.sol";
import {UbiquityGovernance} from "../../src/dollar/UbiquityGovernance.sol";
import {UARForDollarsCalculator} from "../../src/dollar/UARForDollarsCalculator.sol";
import {CouponsForDollarsCalculator} from "../../src/dollar/CouponsForDollarsCalculator.sol";
import {DollarMintingCalculator} from "../../src/dollar/DollarMintingCalculator.sol";
import {ExcessDollarsDistributor} from "../../src/dollar/ExcessDollarsDistributor.sol";
import {MockDebtCoupon} from "../../src/dollar/mocks/MockDebtCoupon.sol";
import {MockDollarToken} from "../../src/dollar/mocks/MockDollarToken.sol";
import {MockTWAPOracleDollar3pool} from "../../src/dollar/mocks/MockTWAPOracleDollar3pool.sol";
import {MockAutoRedeem} from "../../src/dollar/mocks/MockAutoRedeem.sol";
>>>>>>> d07f5405 (Updated product names according to previous PR)

import "forge-std/Test.sol";
import "forge-std/console.sol";

contract MockCreditNFTRedemptionCalculator {
    constructor() {}

    function getCreditNFTAmount(uint256 dollarsToBurn)
        external
        pure
        returns (uint256)
    {
        return dollarsToBurn;
    }
}

abstract contract LocalTestHelper is Test {
    address public constant NATIVE_ASSET = address(0);

    address public admin = address(0x123abc);
    address public treasuryAddress = address(0x111222333);

    function helpers_deployUbiquityDollarManager()
        public
        returns (address)
    {
<<<<<<< HEAD
        UbiquityDollarManager _manager =
            new UbiquityDollarManager(admin);
=======
        UbiquityAlgorithmicDollarManager _manager = new UbiquityAlgorithmicDollarManager(
                admin
            );
>>>>>>> d07f5405 (Updated product names according to previous PR)

        vm.startPrank(admin);
        // deploy credit NFT token
        MockCreditNFT _creditNFT = new MockCreditNFT(100);
        _manager.setCreditNFTAddress(address(_creditNFT));

<<<<<<< HEAD
        // deploy dollar token
        MockDollarToken _dollarToken = new MockDollarToken(10000e18);
        _manager.setDollarTokenAddress(address(_dollarToken));

        // deploy twapPrice oracle
        MockTWAPOracleDollar3pool _twapOracle =
        new MockTWAPOracleDollar3pool(address(0x100), address(_dollarToken), address(0x101), 100, 100);
=======
        // deploy uAD token
        MockDollarToken _uAD = new MockDollarToken(10000e18);
        _manager.setDollarTokenAddress(address(_uAD));

        // deploy twapPrice oracle
        MockTWAPOracleDollar3pool _twapOracle = new MockTWAPOracleDollar3pool(
            address(0x100),
            address(_uAD),
            address(0x101),
            100,
            100
        );
>>>>>>> d07f5405 (Updated product names according to previous PR)
        _manager.setTwapOracleAddress(address(_twapOracle));

        // deploy governance token
        UbiquityGovernanceToken _governanceToken = new UbiquityGovernanceToken(address(_manager));
        _manager.setGovernanceTokenAddress(address(_governanceToken));

<<<<<<< HEAD
        // deploy CreditNFTRedemptionCalculator
        MockCreditNFTRedemptionCalculator _creditNFTRedemptionCalculator =
            new MockCreditNFTRedemptionCalculator();
        _manager.setCreditNFTCalculatorAddress(
            address(_creditNFTRedemptionCalculator)
=======
        // deploy couponsForDollarCalculator
        MockCouponsForDollarsCalculator couponsForDollarsCalculator = new MockCouponsForDollarsCalculator();
        _manager.setCouponCalculatorAddress(
            address(couponsForDollarsCalculator)
>>>>>>> d07f5405 (Updated product names according to previous PR)
        );

        // deploy credit token
        MockCreditToken _creditToken = new MockCreditToken(0);
        _manager.setCreditTokenAddress(address(_creditToken));

<<<<<<< HEAD
        // deploy CreditRedemptionCalculator
        CreditRedemptionCalculator _creditRedemptionCalculator =
            new CreditRedemptionCalculator(address(_manager));
        _manager.setCreditCalculatorAddress(address(_creditRedemptionCalculator));

        // deploy DollarMintCalculator
        DollarMintCalculator _dollarMintCalculator =
            new DollarMintCalculator(address(_manager));
        _manager.setDollarMintCalculatorAddress(address(_dollarMintCalculator));
=======
        // deploy UARDollarCalculator
        UARForDollarsCalculator _uarDollarCalculator = new UARForDollarsCalculator(
                address(_manager)
            );
        _manager.setUARCalculatorAddress(address(_uarDollarCalculator));

        // deploy dollarMintingCalculator
        DollarMintingCalculator _mintingCalculator = new DollarMintingCalculator(
                address(_manager)
            );
        _manager.setDollarMintingCalculatorAddress(address(_mintingCalculator));
>>>>>>> d07f5405 (Updated product names according to previous PR)

        // set treasury address
        _manager.setTreasuryAddress(treasuryAddress);

        vm.stopPrank();

        return address(_manager);
    }
}
