cd /home
sudo chmod 777 /home
sudo git clone https://github.com/Stabien/esgi-challenge-s4

wait

cd esgi-challenge-s4/back
sudo cp /tmp/.env.local ./.env.local
sudo docker compose up -d
