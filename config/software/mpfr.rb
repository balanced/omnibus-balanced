name "mpfr"
version "2.4.2"

dependency "gmp"

source url: "ftp://gcc.gnu.org//pub/gcc/infrastructure/mpfr-2.4.2.tar.bz2",
       md5: "89e59fe665e2b3ad44a6789f40b059a0"

relative_path "#{name}-#{version}"

configure_env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}

build do
  command "./configure --prefix=#{install_dir}/embedded --disable-dependency-tracking", env: configure_env
  command "make", env: configure_env
  command "make check"
  command "make install"
end
