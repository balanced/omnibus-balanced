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

name 'blas'

source :url => 'http://www.netlib.org/blas/blas.tgz',
       :md5 => '5e99e975f7a1e3ea6abcad7c6e7e42e6'

relative_path "#{name.upcase}"

LIB_PATH = %W(#{install_dir}/embedded/lib #{install_dir}/embedded/lib64 #{install_dir}/embedded/libexec)
env = {
  'LDFLAGS' => "-Wl,-rpath,#{LIB_PATH.join(' -Wl,-rpath,')} -L#{LIB_PATH.join(' -L')} -I#{install_dir}/embedded/include",
  'CFLAGS' => "-L#{LIB_PATH.join(' -L')} -I#{install_dir}/embedded/include",
  'LD_RUN_PATH' => "#{LIB_PATH.join(':')}",
  'PATH' => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}


build do
  command 'make all', :env => env
  command "cp -p blas_LINUX.a #{install_dir}/embedded/lib/libblas.a"
end