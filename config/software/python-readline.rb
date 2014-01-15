#
# Author:: Noah Kantrowitz <noah@coderanger.net>
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

name 'python-readline'
version '6.2.4.1'

dependency 'setuptools'
dependency 'readline'

source url: "https://pypi.python.org/packages/source/r/readline/readline-#{version}.tar.gz", md5: '578237939c81fdbc2c8334d168b17907'

relative_path "readline-#{version}"

build do
  env = { "CFLAGS" => "-I#{install_dir}/embedded/include",
          "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib" }
  command "#{install_dir}/embedded/bin/pip install -I --build #{install_dir}/embedded readline", env: env
end
