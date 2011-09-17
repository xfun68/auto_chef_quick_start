current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "xfun68"
client_key               "#{current_dir}/xfun68.pem"
validation_client_name   "lazyist-validator"
validation_key           "#{current_dir}/lazyist-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/lazyist"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
