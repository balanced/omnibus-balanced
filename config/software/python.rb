#
# Copyright:: Copyright (c) 2013 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

name "python"
version "2.7.6"

dependency "readline"
dependency "ncurses"
dependency "zlib"
dependency "openssl"
dependency "bzip2"


source :url => "http://python.org/ftp/python/#{version}/Python-#{version}.tgz",
       :md5 => '1d8728eb0dfcac72a0fd99c17ec7f386'

relative_path "Python-#{version}"

env = {
  "CFLAGS" => "-I#{install_dir}/embedded/include -O3 -g -pipe",
  "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib"
}

build do
  command ["./configure",
           "--prefix=#{install_dir}/embedded",
           "--enable-unicode=ucs4",
           "--enable-shared",
           # NOTICE: we will encounter dependencies check failure if the building
           # environment happens to have these libraries installed. For solving
           # this issue, I disable these module here. We can add these back
           # once support for those library is ready. Reference to issue:
           # https://github.com/opscode/omnibus-software/pull/70
           "--without-sqlite3",
           "--without-dbm",
           "--without-gdbm",
           ].join(" "), :env => env
  command "make", :env => env
  command "make install", :env => env

  ## There exists no configure flag to tell Python to not compile readline support :(
  #block do
  #  FileUtils.rm_f(Dir.glob("#{install_dir}/embedded/lib/python2.7/lib-dynload/readline.*"))
  #end
end