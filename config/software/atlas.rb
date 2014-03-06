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
require 'fileutils'

# https://aur.archlinux.org/packages/at/atlas-lapack/PKGBUILD
name 'atlas'
version '3.10.1'

dependency 'gfortran'
dependency 'lapack'

source :url => "http://downloads.sourceforge.net/project/math-atlas/Stable/#{version}/atlas#{version}.tar.bz2",
       :md5 => '78753e869231cc1417a92eebaa076718'

env = {
  'LDFLAGS' => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  'CFLAGS' => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  'LD_RUN_PATH' => "#{install_dir}/embedded/lib"
}

cache_dir = "#{::File.dirname(::File.dirname(project_dir))}/cache"
build_dir = "#{::File.dirname(project_dir)}/ATLAS/build"

always_build  true
relative_path 'ATLAS/build'

::FileUtils.rm_r(build_dir, :force => true)

build do
  block do
    ::FileUtils.rm_r(build_dir, :force => true)
    ::FileUtils.mkdir_p(build_dir)
  end
  command [
    "../configure --prefix=#{install_dir}/embedded",
    '-b 64 ',#'-C if gfortran', # architecture is 64bit
    '-Fa alg -fPIC',
    "--with-netlib-lapack-tarfile=#{cache_dir}/lapack-3.5.0.tgz"
  ].join(' '), :env => env
  command 'make build', :env => env
  command 'make time', :env => env
  command 'make install', :env => env
  command "patch -p1 -i #{Omnibus.project_root}/config/patches/#{name}/makefiles.patch", :cwd => "#{build_dir}/lib"
  command 'make -f makefile.shared.mt', :env => env, :cwd => "#{build_dir}/lib"

  # copy and symlink to proper names
  command "cp *.so #{install_dir}/embedded/lib", :cwd => "#{build_dir}/lib"
  command "ln -s #{install_dir}/embedded/lib/libblas.so #{install_dir}/embedded/lib/libblas.so.3"
  command "ln -s #{install_dir}/embedded/lib/libatlas.so #{install_dir}/embedded/lib/libatlas.so.3gf"
  %w(liblapack.so liblapack.so.3gf).each do |dest|
    command "ln -s #{install_dir}/embedded/lib/liblapack.so.3 #{install_dir}/embedded/lib/#{dest}"
  end
end

