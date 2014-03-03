name "isl"
version "0.11.1"

dependency "gmp"

source url: "ftp://gcc.gnu.org//pub/gcc/infrastructure/isl-0.11.1.tar.bz2",
       md5: "bce1586384d8635a76d2f017fb067cd2"

relative_path "#{name}-#{version}"

configure_env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}

build do
  command(["./configure",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{install_dir}/embedded",
           "--with-gmp=system",
           "--with-gmp-prefix=#{install_dir}/embedded"].join(" "),
          env: configure_env)
  command "make", env: configure_env
  command "make check"
  command "make install"
end
