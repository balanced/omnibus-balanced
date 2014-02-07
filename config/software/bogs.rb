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

name 'bogs'

dependency 'pip'
dependency 'setuptools'

source git: 'https://github.com/bninja/bogs.git'
version 'v0.1.1'

relative_path 'bogs'

build do
  env = {
    "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
    "LD_RUN_PATH" => "#{install_dir}/embedded/lib",
    "PATH" => "/opt/brache/embedded/bin:#{ENV['PATH']}",
  }

  command "#{install_dir}/embedded/bin/pip install --upgrade --install-option=--prefix=#{install_dir}/embedded .", env: env
end
