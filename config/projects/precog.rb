#
# Author:: Noah Kantrowitz <noah@coderanger.net>
# Author:: Mahmoud Abdelkader <mahmoud@balancedpayments.com>
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

name 'precog'
maintainer 'Balanced <dev@balancedpayments.com>'
homepage 'https://github.com/balanced/precog'

replaces 'precog'
install_path '/opt/precog'
build_version '0'
build_iteration 1

# creates required build directories
dependency 'preparation'

# precog dependencies/components
dependency 'precog'
dependency 'ipython'

# version manifest file
dependency 'version-manifest'

exclude '\.git*'
exclude 'bundler\/git'
