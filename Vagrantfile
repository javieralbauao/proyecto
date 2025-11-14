Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/focal64"
  config.vm.hostname = "linux-proyecto"

  config.vm.network "private_network", ip: "192.168.56.30"

  config.vm.synced_folder "./data", "/data", create: true

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = 2
  end

  config.vm.provision "file",
    source: "./ssh_keys/id_rsa.pub",
    destination: "/home/vagrant/id_rsa.pub"

end
