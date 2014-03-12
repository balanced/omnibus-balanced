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
name "cloog"
version "0.18.0"

dependency "gmp"
dependency "isl"

source url: "ftp://gcc.gnu.org//pub/gcc/infrastructure/cloog-0.18.0.tar.gz",
       md5: "be78a47bd82523250eb3e91646db5b3d"

relative_path "cloog-#{version}"

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
           "--with-bits=gmp",
           "--with-gmp=system",
           "--with-gmp-prefix=#{install_dir}/embedded",
           "--with-isl=system",
           "--with-isl-prefix=#{install_dir}/embedded"].join(" "),
          env: configure_env)
  command "make", env: configure_env
  command "make check"
  command "make install"
end
