name "cloog"
version "0.18.0"

dependency "gmp"
dependency "isl"

source url: "ftp://gcc.gnu.org//pub/gcc/infrastructure/cloog-0.18.0.tar.gz",
       md5: "be78a47bd82523250eb3e91646db5b3d"

relative_path "cloog-#{version}"

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
           "--with-bits=gmp",
           "--with-gmp=system",
           "--with-gmp-prefix=#{install_dir}/embedded",
           "--with-isl=system",
           "--with-isl-prefix=#{install_dir}/embedded"].join(" "),
          env: configure_env)
  command "make", env: configure_env
  command "make check"
  command "make install"
end
