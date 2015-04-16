# -*- mode: ruby -*-
# vi: set ft=ruby :
# See https://github.com/discourse/discourse/blob/master/docs/VAGRANT.md
#

Vagrant.configure('2') do |config|
  config.vm.box = 'chef/ubuntu-14.04'
  config.omnibus.chef_version = :latest
  config.ssh.forward_agent = true

  config.librarian_chef.cheffile_dir = "chef"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]

    # Who has a single core cpu these days anyways?
    cpu_count = 2

    # Determine the available cores in host system.
    # This mostly helps on linux, but it couldn't hurt on MacOSX.
    if RUBY_PLATFORM =~ /linux/
      cpu_count = `nproc`.to_i
    elsif RUBY_PLATFORM =~ /darwin/
      cpu_count = `sysctl -n hw.ncpu`.to_i
    end

    # Assign additional cores to the guest OS.
    vb.customize ["modifyvm", :id, "--cpus", cpu_count]
    vb.customize ["modifyvm", :id, "--ioapic", "on"]

    # This setting makes it so that network access from inside the vagrant guest
    # is able to resolve DNS using the hosts VPN connection.
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end

  config.vm.network :private_network, type: 'dhcp'
  config.vm.network :forwarded_port, guest: 3000, host: 4000
  config.vm.network :forwarded_port, guest: 1080, host: 4080 # Mailcatcher

  nfs_setting = RUBY_PLATFORM =~ /darwin/ || RUBY_PLATFORM =~ /linux/
  config.vm.synced_folder ".", "/vagrant", id: "vagrant-root", :nfs => nfs_setting

  chef_cookbooks_path = ["chef/cookbooks","chef/site-cookbooks"]
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = chef_cookbooks_path
    chef.add_recipe :apt
    chef.add_recipe 'redis'
    chef.add_recipe 'git'
    chef.add_recipe 'postgresql::server'
    chef.add_recipe 'recipe[cocoon]'
    chef.add_recipe 'ruby_build'
    chef.add_recipe 'rbenv::user'
    chef.add_recipe "rbenv::vagrant"
    #chef.add_recipe 'nginx'
    chef.add_recipe 'vim'
    
    #chef.add_recipe 'recipe[kickinespresso]'

    #chef.add_recipe 'recipe[imagemagick]'

    chef.json = {
      :redis      => {
        :bind        => "127.0.0.1",
        :port        => "6379",
        :config_path => "/etc/redis/redis.conf",
        :daemonize   => "yes",
        :timeout     => "300",
        :loglevel    => "notice"
      },
      :git        => {
        :prefix => "/usr/local"
      },
      :postgresql => {
        :config   => {
          :listen_addresses => "*",
          :port             => "5432"
        },
        :pg_hba   => [
          {
            :type   => "local",
            :db     => "postgres",
            :user   => "postgres",
            :addr   => nil,
            :method => "trust"
          },
          {
            :type   => "host",
            :db     => "all",
            :user   => "all",
            :addr   => "0.0.0.0/0",
            :method => "md5"
          },
          {
            :type   => "host",
            :db     => "all",
            :user   => "all",
            :addr   => "::1/0",
            :method => "md5"
          }
        ],
        :password => {
          :postgres => "password"
        }
      },
      :rbenv      => {
        :user_installs => [
          {
            :user   => "vagrant",
            :rubies => [
              "2.2.0"
            ],
            :global => "2.2.0"
          }
        ]
      }
    }
  end
end
