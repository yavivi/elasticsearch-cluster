# -*- mode: ruby -*-
# vi: set ft=ruby :

$num_nodes = (ENV['ES_NUM_NODES'].to_i || 1)
$ip_base = "192.168.10"
$node_mem = "2048"

if $num_nodes < 1
    puts "Invalid number of nodes configured. Defaulting to 1"
    $num_nodes = 1
elsif $num_nodes > 5 then
    puts "Too Large number of nodes. Using 5"
    $num_nodes = 5
end

puts "Starting #{$num_nodes} nodes..."

Vagrant.configure("2") do |config|

    # Collect Nodes IPs
    node_ips = []
    for i in 2..($num_nodes+1)
        ip = $ip_base + "." + i.to_s
        node_ips.push(ip) 
    end

    # Loop over nodes
    (1..$num_nodes).each do |i|
        node_name = "node-#{i}"
        node_ip = node_ips[i-1]
        
        es_port = 9200 + (i-1)
        ki_port = 5601 + (i-1)

        config.vm.define node_name do |node|
            node.vm.box = "ubuntu/xenial64"
            node.vm.provision :shell, inline: "sed 's/127\.0\.0\.1.*#{node_name}.*/#{node_ip} #{node_name}/' -i /etc/hosts"
            #node.vm.provision :shell, inline: "echo '#{node_ip} #{node_name}' >> /etc/hosts"
            
            (1..$num_nodes).each do |j|
                nip = node_ips[j-1]
                host_name = "node-#{j}"
                node.vm.provision :shell, inline: "echo '#{nip} #{host_name}' >> /etc/hosts"
            end

            node.vm.provision :shell, path: "node-bootstrap.sh", args: "#{node_name}"
            
            node.vm.network "forwarded_port", guest: 9200, host: es_port
            node.vm.network "forwarded_port", guest: 5601, host: ki_port

            node.vm.provider "virtualbox" do |vb|
                vb.memory = $node_mem
                vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
                vb.customize ["modifyvm", :id, "--nictype2", "virtio"]
            end
            node.vm.network "private_network", ip: node_ip, netmask: "255.255.0.0"
            node.vm.hostname = node_name
        end
    end


end
