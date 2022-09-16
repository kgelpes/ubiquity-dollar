import WalletConnectProvider from "@walletconnect/web3-provider";
import { useCallback, useEffect, useReducer } from "react";
import Web3Modal from "web3modal";
import { reducer } from "./web3modal/reducer";
import { initWeb3Provider } from "./web3modal/initWeb3Provider";
import { setEvents } from "./web3modal/setEvents";
import { StateType } from "./web3modal/web3modaltypes";

const INFURA_ID = "09d9ad2ad2d441c2aceadad9e2784d57";

const providerOptions = {
  walletconnect: {
    package: WalletConnectProvider, // required
    options: {
      infuraId: INFURA_ID, // required
    },
  },
};

export let web3Modal: Web3Modal;
if (typeof window !== "undefined") {
  web3Modal = new Web3Modal({
    network: "mainnet", // optional
    cacheProvider: true,
    providerOptions, // required
  });
}

export const initialState: StateType = {
  provider: null,
  web3Provider: null,
  walletAddress: null,
  chainId: null,
};

export const ConnectWallet = (): JSX.Element => {
  const [state, dispatch] = useReducer(reducer, initialState);
  const { provider, web3Provider, walletAddress } = state;

  console.log(state);

  const connect = useCallback(initWeb3Provider(dispatch), []);

  const disconnect = useCallback(
    async function () {
      await web3Modal.clearCachedProvider();
      if (provider?.disconnect && typeof provider.disconnect === "function") {
        await provider.disconnect();
      }
      dispatch({
        type: "RESET_WEB3_PROVIDER",
      });
    },
    [provider]
  );

  // Auto connect to the cached provider
  useEffect(() => {
    if (web3Modal.cachedProvider) {
      connect();
    }
  }, [connect]);

  // A `provider` should come with EIP-1193 events. We'll listen for those events
  // here so that when a user switches accounts or networks, we can update the
  // local React state with that new information.
  useEffect(setEvents(provider, dispatch, disconnect), [provider, disconnect]);

  return (
    <>
      {web3Provider ? (
        <button className="button" type="button" onClick={disconnect}>
          Disconnect
        </button>
      ) : (
        <button className="button" type="button" onClick={connect}>
          Connect
        </button>
      )}
      {walletAddress && (
        <div>
          <span>{shortenAddress(walletAddress)}</span>
        </div>
      )}
    </>
  );
};

export default ConnectWallet;

function shortenAddress(walletAddress: string) {
  return walletAddress.slice(0, 6) + "..." + walletAddress.slice(-4);
}
