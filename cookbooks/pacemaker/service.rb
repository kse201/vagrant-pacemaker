%w[corosync pacemaker ].each do |name|
  service name do
    action [:enable, :start]
  end
end
