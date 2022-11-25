docker compose  -f "docker-compose.yml" up -d --build backend1
bc -rpcuser=polaruser -rpcpassword=polarpass -rpcport=18443 -getinfo
docker compose  -f "docker-compose.yml" up -d --build alice
su-exec taro tarod --network=regtest --lnd.macaroonpath=/home/lnd/.lnd/data/chain/bitcoin/regtest/admin.macaroon --lnd.tlspath=/home/lnd/.lnd/tls.cert --tarodir=/home/taro/.taro --rpclisten=0.0.0.0:10029 --restlisten=0.0.0.0:8089 --lnd.host=alice:10009


