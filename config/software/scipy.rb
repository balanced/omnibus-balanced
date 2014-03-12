#
# Copyright:: Copyright (c) 2012 Opscode, Inc.
# License:: Apache License, Version 2.0
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

name 'scipy'
version '0.13.0'

dependency 'numpy'
dependency 'pip'

source :url => "http://downloads.sourceforge.net/project/scipy/scipy/#{version}/scipy-#{version}.tar.gz",
       :md5 => 'ffa1e9bfd2bbdf3f17f4cf8139084098'

relative_path "scipy-#{version}"

LIB_PATH = %W(#{install_dir}/embedded/lib #{install_dir}/embedded/lib64 #{install_dir}/embedded/libexec)

env = {
  'LDFLAGS' => "-Wl,-rpath=#{LIB_PATH.join(' -Wl,-rpath=')} -L#{LIB_PATH.join(' -L')} -I#{install_dir}/embedded/include -shared",
  'CFLAGS' => "-L#{LIB_PATH.join(' -L')} -I#{install_dir}/embedded/include",
  'PATH' => "#{install_dir}/embedded/bin:#{ENV['PATH']}",
}

build do
  temporary_build_dir = '/tmp/scipy-build'
  command "rm -rf #{temporary_build_dir}"
  command "#{install_dir}/embedded/bin/pip install -b #{temporary_build_dir} --upgrade --install-option=--prefix=#{install_dir}/embedded .", env: env
end
