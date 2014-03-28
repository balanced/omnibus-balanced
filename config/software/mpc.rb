#
# Copyright:: Copyright (c) 2014 Balanced, Inc.
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
name "mpc"
version "1.0.1"

dependency "gmp"
dependency "mpfr"

source url: "ftp://ftp.gnu.org/gnu/mpc/mpc-1.0.1.tar.gz",
       md5: "b32a2e1a3daa392372fbd586d1ed3679"

relative_path "#{name}-#{version}"

configure_env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}

build do
  command(["./configure",
           "--prefix=#{install_dir}/embedded",
           "--disable-dependency-tracking",
           "--with-gmp=#{install_dir}/embedded",
           "--with-mpfr=#{install_dir}/embedded"].join(" "),
          env: configure_env)
  command "make", env: configure_env
  command "make check"
  command "make install"
end
