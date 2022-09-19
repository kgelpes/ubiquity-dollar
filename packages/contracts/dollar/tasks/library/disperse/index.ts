import { UbiquityGovernance } from "../../../artifacts/types/UbiquityGovernance";
import { UbiquityAlgorithmicDollarManager } from "../../../artifacts/types/UbiquityAlgorithmicDollarManager";
import { ActionType } from "hardhat/types/runtime";
import { BigNumber, Wallet } from "ethers";
import { HardhatRuntimeEnvironment } from "hardhat/types/runtime";
import DISPERSE_ABI from "./fixtures/disperse-abi.json";
const DISPERSE_ADDRESS = "0xD152f549545093347A162Dce210e7293f1452150";

import { recipients, values } from "./fixtures/recipients-and-values.json"; // { recipients: string[]; values: BigNumber[] }

// prompts the script to verify with the manager contract, in order to make sure that this is the current/latest deployment of the governance token.
const UbiquityGovernanceTokenDefaultAddress = "0x4e38d89362f7e5db0096ce44ebd021c3962aa9a0";

interface TaskArgs {
  investors: string; // path to json file containing a list of investors
  token: string; // address of the token
}

export async function disperse(taskArgs: TaskArgs, hre: HardhatRuntimeEnvironment) {
  if (!process.env.UBQ_DISTRIBUTOR) {
    throw new Error("No distributor private key found. Please set process.env.UBQ_DISTRIBUTOR");
  }

  const DISTRIBUTOR_EOA = new Wallet(process.env.UBQ_DISTRIBUTOR);
  const DISPERSE_APP = await hre.ethers.getContractAt(DISPERSE_ABI, DISPERSE_ADDRESS, DISTRIBUTOR_EOA);

  if (taskArgs.token === UbiquityGovernanceTokenDefaultAddress) {
    taskArgs.token = (await getUbiquityGovernance(hre.ethers)).address;
  }

  throw new Error("TODO: need to make a manual user review and confirmation before executing this script");
  // const transaction = await DISPERSE_APP.disperseToken(taskArgs.token, recipients, values);
}

async function getUbiquityGovernance(ethers) {
  const manager = (await ethers.getContractAt(
    "UbiquityAlgorithmicDollarManager",
    "0x4DA97a8b831C345dBe6d16FF7432DF2b7b776d98"
  )) as UbiquityAlgorithmicDollarManager;
  const ubqTokenAddress = await manager.governanceTokenAddress();
  return (await ethers.getContractAt("UbiquityGovernance", ubqTokenAddress)) as UbiquityGovernance;
}

// import "@nomiclabs/hardhat-waffle";
// import "hardhat-deploy";

export const description = "Distributes investor emissions";

export const optionalParams = {
  token: ["Token address", UbiquityGovernanceTokenDefaultAddress],
};
export const action = (): ActionType<any> => _distributor;
