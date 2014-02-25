#
# Author:: Victor Lin <bornstub@gmail.com>
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


name "sqlite3"
version "3.8.3"

dependency "readline"

source :url => "http://www.sqlite.org/2014/sqlite-autoconf-3080300.tar.gz",
       :md5 => "11572878dc0ac74ae370367a464ab5cf"

relative_path "sqlite-autoconf-3080300"

prefix="#{install_dir}/embedded"
libdir="#{prefix}/lib"

env = {
  "LDFLAGS" => "-L#{libdir} -I#{prefix}/include",
  "CFLAGS" => "-L#{libdir} -I#{prefix}/include",
  "LD_RUN_PATH" => libdir
}

build do
  # TODO: we should remove `--enable-readline=no` once it is available in
  # omnibus-software
  command "./configure --prefix=#{install_dir}/embedded", :env => env
  command "make", :env => env
  command "make install", :env => env
end