#
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
#
require 'fileutils'

# https://aur.archlinux.org/packages/at/atlas-lapack/PKGBUILD
name 'atlas'
version '3.10.1'

dependency 'gfortran'
dependency 'lapack'

# cache the SHIT out of this build...it's fucking EXPENSIVE.
always_build false

source :url => "http://downloads.sourceforge.net/project/math-atlas/Stable/#{version}/atlas#{version}.tar.bz2",
       :md5 => '78753e869231cc1417a92eebaa076718'


LIB_PATH = %W(#{install_dir}/embedded/lib #{install_dir}/embedded/lib64 #{install_dir}/embedded/libexec)

LIB_PATH.join(' -L')
env = {
  'LDFLAGS' => "-L#{LIB_PATH.join(' -L')} -I#{install_dir}/embedded/include",
  'CFLAGS' => "-L#{LIB_PATH.join(' -L')} -I#{install_dir}/embedded/include",
  'LD_RUN_PATH' => "#{LIB_PATH.join(':')}",
  'PATH' => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}

base_src_directory = ::File.dirname(project_dir)
cache_dir = "#{::File.dirname(base_src_directory)}/cache"
atlas_root = "#{base_src_directory}/ATLAS"
build_dir = "#{atlas_root}/build"

# Atlas is exploding a broken symlink which causes Omnibus to freak out
::FileUtils.rm_f("#{build_dir}/tune/blas/gemv/CASES")

relative_path 'ATLAS/build'

build do
  block do
    ::FileUtils.mkdir_p("#{build_dir}/lib")
    # ::FileUtils.copy("#{base_src_directory}/lapack-3.5.0/make.inc.example", "#{atlas_root}/Make.inc")
  end

  command [
    "../configure --prefix=#{install_dir}/embedded",
    '-b 64', # architecture is 64bit
    '-Fa alg -fPIC',
    "-C if #{install_dir}/embedded/bin/gfortran",
    "--with-netlib-lapack-tarfile=#{cache_dir}/lapack-3.5.0.tgz"
  ].join(' '), :env => env
  command 'make build', :env => env
  command 'make time', :env => env
  command 'make install', :env => env
  command "patch -p1 -i #{Omnibus.project_root}/config/patches/#{name}/makefiles.patch", :cwd => "#{build_dir}/lib"
  command 'make -f makefile.shared.mt', :env => env, :cwd => "#{build_dir}/lib"

  # copy and symlink to proper names
  command "cp *.so #{install_dir}/embedded/lib", :cwd => "#{build_dir}/lib"
  command "ln -sf #{install_dir}/embedded/lib/libblas.so #{install_dir}/embedded/lib/libblas.so.3"
  command "ln -sf #{install_dir}/embedded/lib/libatlas.so #{install_dir}/embedded/lib/libatlas.so.3gf"
  %w(liblapack.so liblapack.so.3gf).each do |dest|
    command "ln -sf #{install_dir}/embedded/lib/liblapack.so.3 #{install_dir}/embedded/lib/#{dest}"
  end
end

