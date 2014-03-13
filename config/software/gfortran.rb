#
# Copyright:: Copyright (c) 2014 Balanced, Inc.
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
name "gfortran"
version "4.8.2"

dependency "gmp"
dependency "mpc"
dependency "mpfr"
dependency "cloog"
dependency "isl"

source url: "http://ftpmirror.gnu.org/gcc/gcc-4.8.2/gcc-4.8.2.tar.bz2",
       md5: "a3d7d63b9cb6b6ea049469a0c4a43c9d"

relative_path "gcc-build"

configure_env = {
  "LDFLAGS" => [
    "-Wl,-rpath #{install_dir}/embedded/lib",
    "-L#{install_dir}/embedded/lib",
    "-I#{install_dir}/embedded/include"].join(" "),
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}

build do
  block do
    FileUtils.mkdir_p(File.join(Omnibus.config.source_dir, "gcc-build"))
    FileUtils.move(File.join(Omnibus.config.source_dir, "gcc-#{version}/"),
      File.join(Omnibus.config.source_dir, "gcc-build/"))
    # Added by Mahmoud:
    # - This is a quick hack to try to get all the paths to work
    #   correctly. For some reason, even when passing linker flags down
    #   stuff gets linked to system path. I don't know how to fix.
    FileUtils.ln_s(
        "#{install_dir}/embedded/lib",
        "#{install_dir}/embedded/lib64",
        :force => true
    )
  end

  command(["./gcc-#{version}/configure",
           "--prefix=#{install_dir}/embedded",
           "--enable-languages=c,fortran",
           "--with-gmp=#{install_dir}/embedded",
           "--with-mpfr=#{install_dir}/embedded",
           "--with-mpc=#{install_dir}/embedded",
           "--with-cloog=#{install_dir}/embedded",
           "--with-isl=#{install_dir}/embedded",
           "--enable-checking=release",
           "--disable-bootstrap",
           "--disable-multilib",
           "--disable-build-poststage1-with-cxx",
           "--disable-libstdcxx-pch"].join(" "),
          env: configure_env)
  command "make", env: configure_env
  command "make check-fortran"
  command "make install"
end
