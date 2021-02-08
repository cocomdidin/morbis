cd ../
docker-compose down
docker builder prune --force
docker-compose up -d

sleep 2
echo ''
echo ''
echo 'Docker Already Restarting....'
echo 'Mantap Slur.....'
sleep 2