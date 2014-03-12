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
name "isl"
version "0.11.1"

dependency "gmp"

source url: "ftp://gcc.gnu.org//pub/gcc/infrastructure/isl-0.11.1.tar.bz2",
       md5: "bce1586384d8635a76d2f017fb067cd2"

relative_path "#{name}-#{version}"

configure_env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}

build do
  command(["./configure",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{install_dir}/embedded",
           "--with-gmp=system",
           "--with-gmp-prefix=#{install_dir}/embedded"].join(" "),
          env: configure_env)
  command "make", env: configure_env
  command "make check"
  command "make install"
end
