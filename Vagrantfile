# -*- mode: ruby -*-
# vi: set ft=ruby :

boxes = [
  {:name => :cassandra1, :ip => '172.28.128.4', :ssh_port => 2201, :cpus => 1, :mem => 512, :seed => '172.28.128.4,172.28.128.5'},
  {:name => :cassandra2, :ip => '172.28.128.5', :ssh_port => 2202, :cpus => 1, :mem => 512, :seed => '172.28.128.4,172.28.128.5'},
  {:name => :cassandra3, :ip => '172.28.128.6', :ssh_port => 2203, :cpus => 1, :mem => 512, :seed => '172.28.128.4,172.28.128.5'}
]
# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.0"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  boxes.each do |opts|

    config.vm.define opts[:name] do |config|
      # Set the version of chef to install using the vagrant-omnibus plugin
      config.omnibus.chef_version = :latest
      config.vm.box = "opscode_ubuntu-12.04_provisionerless"
      config.vm.box_url = "https://opscode-vm-bento.s3.amazonaws.com/vagrant/opscode_ubuntu-12.04_provisionerless.box"
      #    config.vm.box       = "elatov/opensuse13-64"
      #    config.vm.box_url   = "https://vagrantcloud.com/elatov/opensuse13-64/version/1/provider/virtualbox.box"
      config.vm.network "private_network", ip: opts[:ip]
      #config.vm.network  "private_network", type:"dhcp"
      config.vm.network "forwarded_port", guest: 22, host: opts[:ssh_port]
      config.vm.hostname = "%s.vagrant" % opts[:name].to_s
      config.vm.synced_folder "~/shared", "/vagrant"

      config.vm.provider "virtualbox" do |vb|
        # Use VBoxManage to customize the VM
        vb.customize ["modifyvm", :id, "--cpus", opts[:cpus]] if opts[:cpus]
        vb.customize ["modifyvm", :id, "--memory", opts[:mem]] if opts[:mem]
      end

      # Provider-specific configuration so you can fine-tune various
      # backing providers for Vagrant. These expose provider-specific options.
      # Example for VirtualBox:
      #
      # config.vm.provider :virtualbox do |vb|
      #   # Don't boot with headless mode
      #   vb.gui = true
      #
      #   # Use VBoxManage to customize the VM. For example to change memory:
      #   vb.customize ["modifyvm", :id, "--memory", "1024"]
      # end
      #
      # View the documentation for the provider you're using for more
      # information on available options.

      # The path to the Berksfile to use with Vagrant Berkshelf
      # config.berkshelf.berksfile_path = "./Berksfile"

      # Enabling the Berkshelf plugin. To enable this globally, add this configuration
      # option to your ~/.vagrant.d/Vagrantfile file
      config.berkshelf.enabled = true

      # An array of symbols representing groups of cookbook described in the Vagrantfile
      # to exclusively install and copy to Vagrant's shelf.
      # config.berkshelf.only = []

      # An array of symbols representing groups of cookbook described in the Vagrantfile
      # to skip installing and copying to Vagrant's shelf.
      # config.berkshelf.except = []


      config.vm.provision :chef_solo do |chef|
        chef.log_level = :debug

        chef.json = {
            mysql: {
                server_root_password: 'rootpass',
                server_debian_password: 'debpass',
                server_repl_password: 'replpass'
            },
            java: {
                install_flavor: 'oracle',
                jdk_version: '7',
                oracle: {
                    accept_oracle_download_terms: true
                }
            },
            cassandra: {
                config: {
                    seed: opts[:seed].to_s,
                    listen_address: opts[:ip].to_s
                }
            }
        }

        chef.run_list = [
            "recipe[apt::default]",
            "recipe[java::default]",
            "recipe[myapp::default]"
        ]
      end
    end
  end

end
