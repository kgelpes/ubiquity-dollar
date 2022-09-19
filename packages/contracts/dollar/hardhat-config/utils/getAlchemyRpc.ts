import { warn } from "./warn";
export function getAlchemyRpc(network: "mainnet" | "ropsten" | "rinkeby"): string | undefined {
  if (process.env.API_KEY_ALCHEMY?.length) {
    return `https://eth-${network}.alchemyapi.io/v2/${process.env.API_KEY_ALCHEMY}`;
  } else {
    warn("Please set the API_KEY_ALCHEMY environment variable to your Alchemy API key");
  }
}
