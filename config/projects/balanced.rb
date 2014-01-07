
name "balanced"
maintainer "CHANGE ME"
homepage "CHANGEME.com"

replaces        "balanced"
install_path    "/opt/balanced"
build_version   Omnibus::BuildVersion.new.semver
build_iteration 1

# creates required build directories
dependency "preparation"

# balanced dependencies/components
# dependency "somedep"

# version manifest file
dependency "version-manifest"

exclude "\.git*"
exclude "bundler\/git"
