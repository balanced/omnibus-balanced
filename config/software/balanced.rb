#
# Author:: Noah Kantrowitz <noah@coderanger.net>
# Author:: Mahmoud Abdelkader <mahmoud@balancedpayments.com>
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

name 'balanced'

dependency 'pip'

dependency 'libxml2'
dependency 'libxslt'
dependency 'libpq'

source git: 'git@github.com:PoundPay/balanced.git'
version ENV['BALANCED_VERSION'] || 'fixit'

relative_path 'balanced'

always_build true

build do
  block do
    project = self.project
    if project.name == 'balanced'
      shell = Mixlib::ShellOut.new('git describe --tags', cwd: self.project_dir)
      shell.run_command
      if shell.exitstatus == 0
        build_version = shell.stdout.chomp
        build_version = build_version[1..-1] if build_version[0] == 'v'
        project.build_version build_version
        project.build_iteration ENV['BALANCED_PACKAGE_ITERATION'] ? ENV['BALANCED_PACKAGE_ITERATION'].to_i : 1
      end
    end
  end

  env = {
	  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
	  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
	  "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
	  "PATH" => "/opt/balanced/embedded/bin:#{ENV['PATH']}",
  }

  command "#{install_dir}/embedded/bin/pip install --upgrade --install-option=--prefix=#{install_dir}/embedded .", env: env
end
