#
# Cookbook Name:: cocoon
# Recipe:: _ruby
#
# Copyright (C) 2014 FullStack
#

#
# Install Ruby Build Dependencies
#
package 'libxslt-dev'
package 'libxml2-dev'
package 'build-essential'
package 'libpq-dev'
package 'libsqlite3-dev'
package 'libffi-dev'
#
# Add apt-add-repository.
#
package 'software-properties-common'

#
# Add brightbox ruby repo.
#