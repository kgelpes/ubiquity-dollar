import { HardhatEthersHelpers } from "@nomiclabs/hardhat-ethers/types";
import { BigNumber } from "ethers";
import { UbiquityAlgorithmicDollarManager } from "../../../../artifacts/types/UbiquityAlgorithmicDollarManager";
import { UbiquityGovernance } from "../../../../artifacts/types/UbiquityGovernance";

interface GetTotalSupply {
  ethers: typeof import("ethers/lib/ethers") & HardhatEthersHelpers;
}

export async function getTotalSupply({ ethers }: GetTotalSupply): Promise<BigNumber> {
  const manager = (await ethers.getContractAt(
    "UbiquityAlgorithmicDollarManager",
    "0x4DA97a8b831C345dBe6d16FF7432DF2b7b776d98"
  )) as UbiquityAlgorithmicDollarManager;
  const ubqTokenAddress = await manager.governanceTokenAddress();
  const ubqToken = (await ethers.getContractAt("UbiquityGovernance", ubqTokenAddress)) as UbiquityGovernance;
  const totalSupply = await ubqToken.totalSupply();
  // const totalSupply = ethers.utils.formatEther(await ubqToken.totalSupply());
  // return parseInt(totalSupply);
  return totalSupply;
}
