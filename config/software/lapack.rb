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

name 'lapack'
version '3.5.0'

source :url => "http://www.netlib.org/lapack/lapack-#{version}.tgz",
       :md5 => 'b1d3e3e425b2e44a06760ff173104bdf'

relative_path "lapack-#{version}"

LIB_PATH = %W(#{install_dir}/embedded/lib #{install_dir}/embedded/lib64 #{install_dir}/embedded/libexec)

env = {
  'LDFLAGS' => "-Wl,-rpath,#{LIB_PATH.join(' -Wl,-rpath,')} -L#{LIB_PATH.join(' -L')} -I#{install_dir}/embedded/include",
  'CFLAGS' => "-L#{LIB_PATH.join(' -L')} -I#{install_dir}/embedded/include",
  'LD_RUN_PATH' => "#{LIB_PATH.join(':')}",
  'PATH' => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}

#if you want to build lapack, use uncomment this code out, but I just
#need to download the tar ball to use it for atlas.
build do
  command 'cp INSTALL/make.inc.gfortran make.inc'
  patch :source => 'lapack-fpic-gfortran.patch', :plevel => 0

  command "make -j #{max_build_jobs} blaslib", :env => env
  command "make -j #{max_build_jobs} lib", :env => env
  %w(liblapack.a librefblas.a libtmglib.a).each do |library|
    command "cp #{library} #{install_dir}/embedded/lib"
  end
  command "ln -sf librefblas.a libblas.a", :cwd => "#{install_dir}/embedded/lib/"
end
