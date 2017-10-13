service 'firewalld' do
  action :start
end

execute "enable ha port" do
  command """
  firewall-cmd --permanent --add-service=high-availability
  """
end
