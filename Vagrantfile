require 'getoptlong'

opts = GetoptLong.new(
  [ '--with-image', GetoptLong::NO_ARGUMENT ],
  [ '--disk-id', GetoptLong::OPTIONAL_ARGUMENT ]
)

disk_id=''
make_image_file=false
opts.each do |opt, arg|
  case opt
  when '--with-image'
    make_image_file = true
  when '--disk-id'
    disk_id = arg
  end
end

if disk_id != ''
  mount_point_dir = '/dev'
  pid = `sudo launchctl list | grep diskarbitrationd | awk '{print $1}'`.strip
  system("sudo kill -SIGCONT #{pid}")
  Dir.entries(mount_point_dir).select{|d| d.start_with?("#{disk_id}s")}
    .each{|p| system("diskutil unmountDisk #{mount_point_dir}/#{disk_id}")}
  system("sudo chmod 0777 #{mount_point_dir}/#{disk_id}")
  system("sudo kill -SIGSTOP #{pid}")
end

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |vb|
    disk = './sd_card.vmdk'

    # Create SD Card mapping to a disk
    unless File.exist?(disk)
      vb.customize [
        'internalcommands',
        'createrawvmdk',
        '-filename', disk,
        '-rawdisk', "/dev/#{disk_id}"
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

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "playbook.yml"
    # ansible.verbose = "vv"
    # ansible.start_at_task = "Copy boot files to the first partition"
    ansible.ask_sudo_pass = true
    ansible.extra_vars = {
      local_disk_id: "#{disk_id}",
      make_image_file: "#{make_image_file}"
    }
  end
  config.vm.provision "shell", inline: "sudo kill -SIGCONT #{pid}"

end
