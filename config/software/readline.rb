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

name "readline"
version "6.2"

source :url => "ftp://ftp.cwru.edu/pub/bash/readline-6.2.tar.gz",
       :md5 => "67948acb2ca081f23359d0256e9a271c"

relative_path "#{name}-#{version}"

build do
  env = { "CFLAGS" => "-I#{install_dir}/embedded/include",
          "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib" }
      
  configure_command = ["./configure",
                        "--prefix=#{install_dir}/embedded" ].join(" ")
                    
  command configure_command, :env => env
  command "make", :env => env
  command "make install", :env => env

end