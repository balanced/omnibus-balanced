#
# Author:: Victor Lin <victorlin@balancedpayments.com>
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

name 'justitia'

dependency 'pip'

dependency 'libxml2'
dependency 'libxslt'
dependency 'libpq'

source :git => 'git+ssh://git@github.com/balanced/justitia.git'
version ENV['JUSTITIA_VERSION'] || 'master'

relative_path 'justitia'

always_build true

build do
  block do
    project = self.project
    if project.name == 'justitia'
      shell = Mixlib::ShellOut.new('git describe --tags', cwd: self.project_dir)
      shell.run_command
      if shell.exitstatus == 0
        build_version = shell.stdout.chomp
        build_version = build_version[1..-1] if build_version[0] == 'v'
        project.build_version build_version
        project.build_iteration ENV['JUSTITIA_PACKAGE_ITERATION'] ? ENV['JUSTITIA_PACKAGE_ITERATION'].to_i : 1
      end
    end
  end
  
  # install requirements
  env = {
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
    "PATH" => "/opt/justitia/embedded/bin:#{ENV['PATH']}",
  }
  [
    'uwsgi',
    'psycopg2',
    'newrelic',
    '.'
  ].each do |target|
    command "#{ install_dir }/embedded/bin/pip install --no-use-wheel --upgrade " \
            "--install-option=--prefix=#{ install_dir }/embedded #{ target }", env: env
  end

  # get current git revision and write to file for justitia
  block do
    project = self.project
    if project.name == 'justitia'
      # get git revision
      shell = Mixlib::ShellOut.new('git rev-parse HEAD', cwd: self.project_dir)
      shell.run_command
      if shell.exitstatus != 0
        return
      end
      git_revision = shell.stdout.chomp
      # write the revision.txt file
      File.open("#{ install_dir }/embedded/lib/python2.7/site-packages/justitia/revision.txt", 'wt') do |revfile|  
        revfile.puts git_revision
      end
    end
  end

end
