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

name "gmp"
version "5.1.3"

source :url => "https://gmplib.org/download/gmp/gmp-5.1.3.tar.bz2",
       :md5 => "a082867cbca5e898371a97bb27b31fea"

relative_path "#{name}-#{version}"

configure_env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}

build do
  patch source: "patch-aa"

  command "./configure --prefix=#{install_dir}/embedded", env: configure_env
  command "make", env: configure_env
  command "make check"
  command "make install"
end
