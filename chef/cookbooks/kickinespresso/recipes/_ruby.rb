#
# Cookbook Name:: kickinespresso
# Recipe:: _ruby
#
# Copyright (C) 2014 KickinEspresso
#

#
# Install Ruby Build Dependencies
#
package 'libxslt-dev'
package 'libxml2-dev'
package 'build-essential'
package 'libpq-dev'
package 'libsqlite3-dev'

#
# Add apt-add-repository.
#
package 'software-properties-common'

#
# Add brightbox ruby repo.
#
execute 'apt-add-repository ppa:brightbox/ruby-ng -y' do
  not_if 'which ruby | grep -c 2.2'
end

#
# Update dependencies.
#
execute 'apt-get update' do
  ignore_failure true
end

#
# Install Ruby 2.2
#
package 'ruby2.2'
package 'ruby2.2-dev'

#
# Install Bundler, build it against the newly installed 2.2 gem binary
#
gem_package 'bundler' do
  gem_binary('/usr/bin/gem2.2')
end

#
# Install yajl-ruby, required for re-provisioning Chef.
#
gem_package 'yajl-ruby' do
  gem_binary('/usr/bin/gem2.2')
end

#
# Install Rails.
#
gem_package 'rails' do
  gem_binary('/usr/bin/gem2.2')
end
