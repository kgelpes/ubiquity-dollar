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

    function setUp() public virtual {
        manager = UbiquityAlgorithmicDollarManager(
            0x4DA97a8b831C345dBe6d16FF7432DF2b7b776d98
        );
        uad3CRVPool = IMetaPool(manager.stableSwapMetaPoolAddress());

        twapOracle = TWAPOracle(manager.twapOracleAddress());
        twapOracle.update();
    }
}

contract LiveStateTest is LiveState {
    function testLiveTwapUpdate() public {
        console.log("twap", twapOracle.consult(manager.dollarTokenAddress()));
    }
}
