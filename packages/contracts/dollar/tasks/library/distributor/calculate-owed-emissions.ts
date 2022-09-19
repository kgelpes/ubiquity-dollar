import "@nomiclabs/hardhat-waffle";
import "hardhat-deploy";
import { HardhatRuntimeEnvironment } from "hardhat/types/runtime";
import { Investor, InvestorWithTransfers } from "./distributor-library/investor-types";
import { Tranche } from "./distributor-library/log-filters/transfers-to-investors";
import { getTotalSupply } from "./owed-emissions-library/getTotalSupply";
import { sumTotalSentToContacts } from "./owed-emissions-library/sumTotalSentToContacts";
import { vestingMath } from "./owed-emissions-library/vestingMath";
import { ethers } from "ethers";

export async function calculateOwedUbqEmissions(
  investors: Investor[],
  tranches: Tranche[],
  hre: HardhatRuntimeEnvironment
): Promise<({ owed: number } & InvestorWithTransfers)[]> {
  const totals = await sumTotalSentToContacts(investors, tranches);

  const totalSupplyBigNumber = await getTotalSupply(hre);
  const totalSupply = parseInt(ethers.utils.formatEther(totalSupplyBigNumber));

  const toSend = totals.map((investor: InvestorWithTransfers) => {
    const shouldGet = vestingMath({ investorAllocationPercentage: investor.percent, totalSupply });
    return Object.assign({ owed: shouldGet - investor.transferred }, investor);
  });

  return toSend;
}
