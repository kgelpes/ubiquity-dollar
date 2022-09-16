import { useState } from "react";
import useWeb3 from "./useWeb3";

const useWalletAddress = () => {
  // const [state, setState] = useState("");
  const [{ walletAddress }] = useWeb3();
  // const { walletAddress } = state;
  // console.log({ state });
  return [walletAddress];
  // return [undefined];
};

export default useWalletAddress;
