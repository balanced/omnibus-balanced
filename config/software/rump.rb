#
# Author:: Noah Kantrowitz <noah@coderanger.net>
#
# Copyright 2014, Balanced, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name 'rump'

dependency 'setuptools'
dependency 'pip'

source git: 'git@github.com:balanced/rump.git'
version ENV['RUMP_VERSION'] || 'ohaul'

relative_path 'rump'

always_build true

build do
  command(
    ["#{install_dir}/embedded/bin/pip",
     "install",
     "--install-option=--prefix=#{install_dir}/embedded",
     ".",
     "kazoo>=1.3.1",
     "newrelic>=1.13.1.31",
     "raven==3.5.2"].join(" "),
    :cwd => "#{project_dir}/src")
end
