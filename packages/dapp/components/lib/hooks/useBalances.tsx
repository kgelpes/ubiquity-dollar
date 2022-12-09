import { erc1155BalanceOf } from "@/lib/utils";
import { BigNumber, Contract } from "ethers";
import { createContext, useContext, useEffect, useState } from "react";
import useManagerManaged from "./contracts/useManagerManaged";
import useNamedContracts from "./contracts/useNamedContracts";
import useWalletAddress from "./useWalletAddress";
import { ChildrenShim } from "./children-shim";

export interface Balances {
  dollar: BigNumber;
  _3crv: BigNumber;
  dollar3crv: BigNumber;
  credit: BigNumber;
  creditNft: BigNumber;
  governance: BigNumber;
  stakingShares: BigNumber;
  usdc: BigNumber;
  dai: BigNumber;
  usdt: BigNumber;
}

type RefreshBalances = () => Promise<void>;

export const BalancesContext = createContext<[Balances | null, RefreshBalances]>([null, async () => {}]);

export const BalancesContextProvider: React.FC<ChildrenShim> = ({ children }) => {
  const [balances, setBalances] = useState<Balances | null>(null);
  const [walletAddress] = useWalletAddress();
  const managedContracts = useManagerManaged();
  const namedContracts = useNamedContracts();

  async function refreshBalances() {
    if (walletAddress && managedContracts && namedContracts) {
      const [uad, _3crv, uad3crv, ucr, ubq, ucrNft, stakingShares, usdc, dai, usdt] = await Promise.all([
        managedContracts.dollarToken.balanceOf(walletAddress),
        managedContracts._3crvToken.balanceOf(walletAddress),
        managedContracts.dollarMetapool.balanceOf(walletAddress),
        managedContracts.creditToken.balanceOf(walletAddress),
        managedContracts.governanceToken.balanceOf(walletAddress),
        erc1155BalanceOf(walletAddress, managedContracts.creditNft as unknown as Contract),
        erc1155BalanceOf(walletAddress, managedContracts.stakingToken as unknown as Contract),
        namedContracts.usdc.balanceOf(walletAddress),
        namedContracts.dai.balanceOf(walletAddress),
        namedContracts.usdt.balanceOf(walletAddress),
      ]);

      setBalances({
        dollar: uad,
        _3crv,
        dollar3crv: uad3crv,
        credit: ucr,
        creditNft: ucrNft,
        governance: ubq,
        stakingShares,
        usdc,
        dai,
        usdt,
      });
    }
  }

  useEffect(() => {
    refreshBalances();
  }, [walletAddress, managedContracts]);

  return <BalancesContext.Provider value={[balances, refreshBalances]}>{children}</BalancesContext.Provider>;
};

const useBalances = () => useContext(BalancesContext);

export default useBalances;
