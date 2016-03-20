Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |vb|
    disk = './sd_card.vmdk'
    physical_disk_id = '2'

    # Create SD Card mapping to a disk
    unless File.exist?(disk)
      vb.customize [
        'createrawvmdk', :id,
        '--filename', disk,
        '--rawdisk', "/dev/disk#{physical_disk_id}"
        ]
    end

    # Attach SD Card image to the VM
    vb.customize [
      'storageattach', :id,
      '--storagectl', 'SATA Controller',
      '--port', 1,
      '--device', 0,
      '--type', 'hdd',
      '--medium', disk
    ]
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yml"
  end

end
