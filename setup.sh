if ! command -v cowsay &> /dev/null
then
    echo "El paquete 'cowsay' no está instalado. se procede a instalar."
    sudo apt-get update
    sudo apt-get install -y cowsay
fi

sudo apt-get install -y nginx
echo "haz provisionado la máquina virtual desde un script"
