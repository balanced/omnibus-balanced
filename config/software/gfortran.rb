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
