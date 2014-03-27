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
name "mpfr"
version "3.1.2"

dependency "gmp"

source url: "http://www.mpfr.org/mpfr-3.1.2/mpfr-3.1.2.tar.bz2",
       md5: "ee2c3ac63bf0c2359bf08fc3ee094c19"

relative_path "#{name}-#{version}"

configure_env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}

build do
  command "./configure --prefix=#{install_dir}/embedded --disable-dependency-tracking", env: configure_env
  command "make", env: configure_env
  command "make check"
  command "make install"
end
