name "gmp"
version "4.3.2"

source :url => "ftp://gcc.gnu.org//pub/gcc/infrastructure/gmp-4.3.2.tar.bz2",
       :md5 => "dd60683d7057917e34630b4a787932e8"

relative_path "#{name}-#{version}"

configure_env = {
  "LDFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "PATH" => "#{install_dir}/embedded/bin:#{ENV['PATH']}"
}

build do
  patch source: "patch-aa"

  command "./configure --prefix=#{install_dir}/embedded", env: configure_env
  command "make", env: configure_env
  command "make check"
  command "make install"
end
