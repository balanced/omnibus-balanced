name "rump"
maintainer "dev@balancedpayments.com"
homepage "https://github.com/balanced/rump"

replaces        "rump"
install_path    "/opt/rump"
build_version   "0.1.0"
build_iteration 1

# creates required build directories
dependency "preparation"

# balanced dependencies/components
dependency "rump"

# version manifest file
dependency "version-manifest"

exclude "\.git*"
exclude "bundler\/git"
