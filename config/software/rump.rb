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

dependency 'pip'

source git: 'git@github.com:balanced/rump.git'
version ENV['RUMP_VERSION'] || 'master'

relative_path 'rump'

always_build true

build do
  block do
    project = self.project
    if project.name == 'rump'
      shell = Mixlib::ShellOut.new('git describe --tags', cwd: self.project_dir)
      shell.run_command
      if shell.exitstatus == 0
        build_version = shell.stdout.chomp
        build_version = build_version[1..-1] if build_version[0] == 'v'
        project.build_version build_version
        project.build_iteration ENV['RUMP_PACKAGE_ITERATION'] ? ENV['RUMP_PACKAGE_ITERATION'].to_i : 1
      end
    end
  end
  command 'rm -rf /tmp/rump-build'
  command "#{install_dir}/embedded/bin/pip install --no-use-wheel --upgrade --install-option=--prefix=#{install_dir}/embedded file://#{project_dir}/src#egg=rump[kazoo,newrelic] -b /tmp/rump-build", cwd: "#{project_dir}/src"
  command "#{install_dir}/embedded/bin/pip install --no-use-wheel --upgrade --install-option=--prefix=#{install_dir}/embedded 'sterling[util,web] >=3.1.1,<4.0' -b /tmp/rump-build", cwd: "#{project_dir}/src"
  command "#{install_dir}/embedded/bin/pip install --no-use-wheel --upgrade --install-option=--prefix=#{install_dir}/embedded brache[router] -b /tmp/rump-build"
  command "ln -fs #{install_dir}/embedded/bin/rump #{install_dir}/bin/rump"
  command "ln -fs #{install_dir}/embedded/bin/rumpd #{install_dir}/bin/rumpd"
end
