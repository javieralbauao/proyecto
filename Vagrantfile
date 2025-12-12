Vagrant.configure("2") do |config|

  config.vm.define "web" do |web|
    web.vm.box = "minimal/xenial64"
    web.vm.hostname = "web"

    web.vm.network "private_network", ip: "192.168.56.10"
    web.vm.network "forwarded_port", guest: 80, host: 8080

    web.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
    end

    web.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update -y
      sudo apt-get install -y ansible
    SHELL

    web.vm.provision "ansible_local" do |ansible|
      ansible.install  = false
      ansible.playbook = "site.yml"
      ansible.tags     = ["web"]
    end
  end

  config.vm.define "monitoring" do |mon|
    mon.vm.box = "minimal/xenial64"
    mon.vm.hostname = "monitoring"

    mon.vm.network "private_network", ip: "192.168.56.11"
    mon.vm.network "forwarded_port", guest: 9090, host: 9090
    mon.vm.network "forwarded_port", guest: 3000, host: 3000

    mon.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
    end

    mon.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update -y
      sudo apt-get install -y ansible
    SHELL

    mon.vm.provision "ansible_local" do |ansible|
      ansible.install  = false
      ansible.playbook = "site.yml"
      ansible.tags     = ["monitoring"]
    end
  end
end