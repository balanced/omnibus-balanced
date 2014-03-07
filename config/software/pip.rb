[]#
# Copyright:: Copyright (c) 2013-2014 Chef Software, Inc.
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

name 'pip'
version '1.5.4'

dependency 'python'

# If setuptools (or distribute) is not already installed,
# get-pip.py will install setuptools for you.
source :url => 'https://raw.github.com/pypa/pip/645180e2714b4ffcf40363a608239e089c9dafab/contrib/get-pip.py',
       :md5 => '49808f380bf193aef5be27e2d7f90503'

build do
  command "#{install_dir}/embedded/bin/python get-pip.py"
end