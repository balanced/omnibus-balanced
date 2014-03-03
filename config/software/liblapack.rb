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

name 'liblapack'
version '3.5.0'

source :url => "http://www.netlib.org/lapack/lapack-#{version}.tgz",
       :md5 => 'e7ba742120bd75339ac4c6fbdd8bce92'

relative_path "lapack-#{version}"

env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  command [ "./configure",
            "--prefix=#{install_dir}/embedded",
            "--with-includes=#{install_dir}/embedded/include",
            "--with-libraries=#{install_dir}/embedded/lib" ].join(" "), :env => env
  command "make -j #{max_build_jobs}", :env => { "LD_RUN_PATH" => "#{install_dir}/embedded/lib"}
  command "mkdir -p #{install_dir}/embedded/include/postgresql"
  command "make -C src/include install"
  command "make -C src/interfaces install"
  command "make -C src/bin/pg_config install"
end
