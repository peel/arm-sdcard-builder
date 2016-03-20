Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |vb|
    disk = './sd_card.vmdk'
    physical_disk_id = '3'

    # Create SD Card mapping to a disk
    unless File.exist?(disk)
      vb.customize [
        'internalcommands',
        'createrawvmdk',
        '-filename', disk,
        '-rawdisk', "/dev/disk#{physical_disk_id}"
        ]
    end

    # Attach SD Card image to the VM
    vb.customize [
      'storageattach', :id,
      '--storagectl', 'SATAController',
      '--port', 1,
      '--device', 0,
      '--type', 'hdd',
      '--medium', disk
    ]
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.ask_sudo_pass = true
  end

end
