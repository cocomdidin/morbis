cd ../
docker-compose down
docker builder prune --force
docker-compose up -d --build

sleep 2
echo ''
echo ''
echo 'Docker Already Builded....'
echo 'Mantap Slur.....'
sleep 10