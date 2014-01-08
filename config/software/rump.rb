name "rump"
version "0.1.0"

dependency "python"
dependency "pip"
dependency "rsync"

source :url => "https://s3-us-west-1.amazonaws.com/omniefd/#{name}-#{version}.tar.gz",
       :md5 => "9da9db4d4e47a073407692e697368699"
       
relative_path "#{name}-#{version}"

prefix="#{install_dir}/embedded"
libdir="#{prefix}/lib"
bindir="#{prefix}/bin"

build do
  command "#{prefix}/bin/pip install -e .[kazoo,raven,newrelic]"
end
