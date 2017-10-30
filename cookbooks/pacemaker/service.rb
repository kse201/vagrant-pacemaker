%w[pcsd].each do |name|
  service name do
    action %i[enable start]
  end
end
