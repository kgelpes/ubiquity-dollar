export type StateType = {
    provider?: any;
    web3Provider?: any;
    walletAddress?: null | string;
    chainId?: null | number;
};

export type ActionType =
    | {
        type: "SET_WEB3_PROVIDER";
        provider?: StateType["provider"];
        web3Provider?: StateType["web3Provider"];
        walletAddress?: StateType["walletAddress"];
        chainId?: StateType["chainId"];
    }
    | {
        type: "SET_ADDRESS";
        walletAddress?: StateType["walletAddress"];
    }
    | {
        type: "SET_CHAIN_ID";
        chainId?: StateType["chainId"];
    }
    | {
        type: "RESET_WEB3_PROVIDER";
    };