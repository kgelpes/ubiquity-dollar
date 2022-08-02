#!/usr/bin/env bash

# hardhat node must first instantiate in a seperate process, which takes 10-15 seconds on my machine
# only after the node is ready then this faucet can run successfully

assistant() {
    sleep 10

    curl http://127.0.0.1:8545 >/dev/null # check if node is ready

    if [ $? -eq 0 ]; then
        echo
        echo "[ 🚰 ] Faucet activating..."
        echo
        # yarn hardhat faucet --network localhost

        for var in "$@"; do
            cd protocols/"$var" || exit 1
            yarn deploy
            cd ../..
        done

    else
        echo
        echo "[ 🚰 ] Retrying faucet in 10 seconds..."
        echo
        assistant
    fi
}

assistant "dollar" "ubiquistick" &

yarn hardhat node --hostname 0.0.0.0 --fork-block-number 14800000
