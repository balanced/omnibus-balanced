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

name 'precog'


dependency 'libxml2'
dependency 'libxslt'
dependency 'libpq'
dependency 'pip'
dependency 'numpy'
dependency 'scipy'
dependency 'scikit-learn'

source git: 'git@github.com:balanced/precog.git'
version ENV['PRECOG_VERSION'] || 'omnibussed'

relative_path 'precog'

always_build true

LIB_PATH = %W(#{install_dir}/embedded/lib #{install_dir}/embedded/lib64 #{install_dir}/embedded/libexec)

# gotta use the ENV file hack thing <- ?
env = {
  'LDFLAGS' => "-Wl,-rpath=#{LIB_PATH.join(' -Wl,-rpath=')} -L#{LIB_PATH.join(' -L')} -I#{install_dir}/embedded/include",
  'CFLAGS' => "-L#{LIB_PATH.join(' -L')} -I#{install_dir}/embedded/include",
  'PATH' => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}

build do

  block do
    project = self.project
    if project.name == 'precog'
      shell = Mixlib::ShellOut.new('git describe --tags', cwd: self.project_dir)
      shell.run_command
      if shell.exitstatus == 0
        build_version = shell.stdout.chomp
        build_version = build_version[1..-1] if build_version[0] == 'v'
        project.build_version build_version
        project.build_iteration ENV['PRECOG_PACKAGE_ITERATION'] ? ENV['PRECOG_PACKAGE_ITERATION'].to_i : 1
      end
    end
  end

  temporary_build_dir = '/tmp/precog-build'
  command "mkdir -p #{install_dir}/embedded/var/lib"
  command "#{project_dir}/scripts/download-data", cwd: "#{install_dir}/embedded/var/lib"
  command "rm -rf #{temporary_build_dir} && #{install_dir}/embedded/bin/pip install -v --no-use-wheel -b #{temporary_build_dir} --upgrade --install-option=--prefix=#{install_dir}/embedded .", env: env
end
