group node[:cluster_group]

user node[:cluster_user] do
  password node[:cluster_password]
  gid node[:cluster_group]
end

template '/etc/hosts' do
  source 'templates/hosts.erb'
  action :create
  variables({
    num_node: node[:num_node],
    hostname_prefix: node[:hostname_prefix],
    address_prefix: node[:address_prefix]
    })
end

template '/etc/corosync/corosync.conf' do
  source 'templates/corosync.conf.erb'
  action :create
  variables({
    cluster_name: node[:cluster_name],
    token_coefficient: node[:token_coefficient],
    num_node: node[:num_node],
    ring_number: node[:ring_number],
    hostname_prefix: node[:hostname_prefix]
    })
end

remote_file '/etc/sysconfig/pacemaker' do
  source 'files/pacemaker'
end

remote_file '/var/lib/pacemaker/cib/cib.xml' do
  source 'files/cib.xml'
end

service 'pcsd' do
  action [:enable, :start]
end

nodes = Array.new(node[:num_node]){|i| "%s%02d" % [node[:hostname_prefix], i + 1] }.join(' ')
execute 'auth cluster node' do
  command "
  pcs cluster auth #{nodes} -u #{node[:cluster_user]} -p  #{node[:cluster_password]} --force
  pcs cluster setup --name #{node[:cluster_name]} #{nodes} --force
  pcs resource defaults resource-stickiness=INFINITY
  "
end

# execute 'register cluster resource' do
# end
