name "mpc"
version "0.8.1"

dependency "gmp"
dependency "mpfr"

source url: "ftp://gcc.gnu.org//pub/gcc/infrastructure/mpc-0.8.1.tar.gz",
       md5: "5b34aa804d514cc295414a963aedb6bf"

relative_path "#{name}-#{version}"

configure_env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}

build do
  command(["./configure",
           "--prefix=#{install_dir}/embedded",
           "--disable-dependency-tracking",
           "--with-gmp=#{install_dir}/embedded",
           "--with-mpfr=#{install_dir}/embedded"].join(" "),
          env: configure_env)
  command "make", env: configure_env
  command "make check"
  command "make install"
end
