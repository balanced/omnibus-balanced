name "sqlite3"
version "3.8.4.1"

dependency "libxslt"

version_tag = version.split('.').map { |part| '%02d' % part.to_i }.join[1..-1]
year = "2014"

source :url => "http://www.sqlite.org/#{year}/sqlite-autoconf-#{version_tag}.tar.gz",
       :md5 => "6b8cb7b9063a1d97f7b5dc517e8ee0c4"

relative_path "sqlite-autoconf-#{version_tag}"

env = {
  "LDFLAGS" => "-Wl,-rpath,#{install_dir}/embedded/lib -L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "CFLAGS" => "-L#{install_dir}/embedded/lib -I#{install_dir}/embedded/include",
  "LD_RUN_PATH" => "#{install_dir}/embedded/lib"
}

build do
  command "./configure --prefix=#{install_dir}/embedded --disable-readline", :env => env
  command "make -j #{max_build_jobs}", :env => env
  command "make install"
end
