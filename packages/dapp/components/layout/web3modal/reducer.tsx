import { initialState } from "../Web3Modal";
import { ActionType, StateType } from "./web3modaltypes";

export function reducer(state: StateType, action: ActionType): StateType {
  switch (action.type) {
    case "SET_WEB3_PROVIDER":
      return {
        ...state,
        provider: action.provider,
        web3Provider: action.web3Provider,
        walletAddress: action.walletAddress,
        chainId: action.chainId,
      };
    case "SET_ADDRESS":
      return {
        ...state,
        walletAddress: action.walletAddress,
      };
    case "SET_CHAIN_ID":
      return {
        ...state,
        chainId: action.chainId,
      };
    case "RESET_WEB3_PROVIDER":
      return initialState;
    default:
      throw new Error();
  }
}
