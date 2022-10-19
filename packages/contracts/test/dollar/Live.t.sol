// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../helpers/LiveTestHelper.sol";
import "../../src/dollar/TWAPOracle.sol";
import "../../src/dollar/UbiquityAlgorithmicDollarManager.sol";
import "../../src/dollar/interfaces/IMetaPool.sol";

contract LiveState is Test {
    using stdStorage for StdStorage;
    UbiquityAlgorithmicDollarManager manager;
    TWAPOracle twapOracle;
    IMetaPool uad3CRVPool;
    ERC20Ubiquity uad;
    IERC20 dai;
    IERC20 threeCrv;
    address mock_addr1 = address(0x123);
    address mock_addr2 = address(0x234);

    function setUp() public virtual {
        manager = UbiquityAlgorithmicDollarManager(
            0x4DA97a8b831C345dBe6d16FF7432DF2b7b776d98
        );
        address daiWhale = address(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
        address threeCrvWhale = address(
            0xd632f22692FaC7611d2AA1C0D552930D43CAEd3B
        );
        threeCrv = IERC20(0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490);
        uad3CRVPool = IMetaPool(manager.stableSwapMetaPoolAddress());

        twapOracle = TWAPOracle(manager.twapOracleAddress());
        twapOracle.update();

        // add some dai to an account

        uad = ERC20Ubiquity(manager.dollarTokenAddress());
        address uadWhale = address(0xefC0e701A824943b469a694aC564Aa1efF7Ab7dd);
        console.log("daiWhale balance", dai.balanceOf(daiWhale));
        vm.prank(daiWhale);
        dai.transfer(mock_addr1, 100000e18);
        console.log("dai balance", dai.balanceOf(mock_addr1));
        vm.prank(threeCrvWhale);
        threeCrv.transfer(mock_addr1, 100000e18);
        console.log("threeCrv balance", threeCrv.balanceOf(mock_addr1));
        vm.prank(uadWhale);
        uad.transfer(mock_addr1, 100000e18);
        console.log("uad balance", uad.balanceOf(mock_addr1));
        vm.startPrank(mock_addr1);
        threeCrv.approve(address(uad3CRVPool), 100000e18);
        uad.approve(address(uad3CRVPool), 100000e18);
        dai.approve(address(uad3CRVPool), 100000e18);
        vm.stopPrank();
    }
}

contract LiveStateTest is LiveState {
    function printInfo() public {
        console.log(
            "uad Price",
            twapOracle.consult(manager.dollarTokenAddress())
        );
        console.log("twap timestamp", twapOracle.pricesBlockTimestampLast());
        console.log("pool timestamp", uad3CRVPool.block_timestamp_last());
    }

    function testLiveTwapUpdate() public {
        printInfo();
        vm.startPrank(mock_addr1);
        uint256[2] memory _amounts;
        _amounts[0] = 0;
        _amounts[1] = 50000e18;
        console.log(
            "will twap update now ?",
            uad3CRVPool.block_timestamp_last() -
                twapOracle.pricesBlockTimestampLast() >
                0
        );
        // we have to update the block_timestamp_last in order to be able to update the twap price
        console.log("--adding liquidity 50k 3crv");
        uad3CRVPool.add_liquidity(_amounts, 0, mock_addr1);
        console.log(
            "will twap update now ?",
            uad3CRVPool.block_timestamp_last() -
                twapOracle.pricesBlockTimestampLast() >
                0
        );
        console.log("uad balance", uad.balanceOf(mock_addr1));
        console.log("threeCrv balance", threeCrv.balanceOf(mock_addr1));
        printInfo();
        // call twap update
        console.log("--call twap update");
        twapOracle.update();
        printInfo();
        console.log("--1h later");
        skip(3601);
        printInfo();
        console.log("--swapping 10k uAD");

        uad3CRVPool.exchange_underlying(0, 2, 10000e18, 0);

        console.log(
            "will twap update right after a swap ?",
            uad3CRVPool.block_timestamp_last() -
                twapOracle.pricesBlockTimestampLast() >
                0
        );

        console.log("uad balance", uad.balanceOf(mock_addr1));
        console.log("threeCrv balance", threeCrv.balanceOf(mock_addr1));
        printInfo();
        // call twap update
        console.log("--call twap update");
        twapOracle.update();
        printInfo();
    }
}
