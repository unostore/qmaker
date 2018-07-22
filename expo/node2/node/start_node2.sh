#!/bin/bash
set -u
set -e

NETID=36657
RA_PORT=22003
R_PORT=22000
W_PORT=22001
NODE_MANAGER_PORT=22004
WS_PORT=22005
CURRENT_NODE_IP=10.50.0.3

GLOBAL_ARGS="--raft --nodiscover --networkid $NETID --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,raft --emitcheckpoints"

echo "[*] Starting Constellation node" > qdata/constellationLogs/constellation_node2.log

constellation-node node2.conf 2>> qdata/constellationLogs/constellation_node2.log &
sleep 1

echo "[*] Starting node2 node" >> qdata/gethLogs/node2.log
echo "[*] geth --verbosity 6 --datadir qdata" $GLOBAL_ARGS" --raftport $RA_PORT --rpcport "$R_PORT "--port "$W_PORT "--nat extip:"$CURRENT_NODE_IP>> qdata/gethLogs/node2.log

PRIVATE_CONFIG=qdata/node2.ipc geth --verbosity 6 --datadir qdata $GLOBAL_ARGS --rpccorsdomain "*" --raftport $RA_PORT --rpcport $R_PORT --port $W_PORT --ws --wsaddr 0.0.0.0 --wsport $WS_PORT --wsorigins '*' --wsapi --nat extip:$CURRENT_NODE_IP 2>>qdata/gethLogs/node2.log &
