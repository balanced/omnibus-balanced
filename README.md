# balanced Omnibus project

This project creates full-stack platform-specific packages for
`balanced`!

## Installation

Use the [balanced-omnibus](https://github.com/balanced-cookbooks/balanced-omnibus)
cookbook to setup the builder lab, do NOT use or build a Vagrantfile  with this
repository.

## Ok, what's this project for?

We use [Omnibus](https://github.com/opscode/omnibus-ruby) to essentially build
self-compacted packages (i.e. `deb`, `rpm`, etc.) to avoid many moving parts for
your application to run when deploying a particular application to your server.

This project is supposed to create an "omnibus" installer for your application.
How that's defined is why this repository exists :)

## I want to know more about this "Omnibus"

These blog posts are a pretty good explanation:

- http://blog.scoutapp.com/articles/2013/06/21/omnibus-tutorial-package-a-standalone-ruby-gem
- http://blog.opsfab.com/2014/01/09/omnibus-inspircd-part-two.html
- http://blog.gemnasium.com/post/60091868742/creating-full-stack-installers-with-omnibus

If you are familiar with the Ruby eco-system, you will probably notice that Omnibus is a gem.
Omnibus's gem lives at [Omnibus](https://github.com/opscode/omnibus-ruby). Opscode has
pre-written some software recipes to install common gems that they need, but, sometimes
that's not good enough or not customized enough for our use case.

That's why Omnibus is a gem, because if you want to make modifications to the
software repository provided by default or add your own definitions, just point
it to your fork.

### Using Your Own Software Definitions

These are Opscode's software definitions.  We like that others get utility out of them, but they
are not meant to be comprehensive of all software on the planet.  We won't, for example, support building
every version of ruby ever released.  You have at least three choices for writing your own
software definitions.

### Software Definitions in your Project

If you only have one project you can fork or add software definitions directly into the `config/software`
directory of your project.  The chef client build [uses this approach](https://github.com/opscode/omnibus-chef/tree/master/config/software).

### Fork omnibus-software

You can make a fork of omnibus-software (or use a repo named omnibus-software) and update the Gemfile in
your project to point at your git repo instead of opscode's.

### Use a gem other than omnibus-software

You can use the `software_gem` config option in omnibus.rb in the root of your project to point at a differently
named gem.  If you wanted to release 'your' omnibus-software gem to rubygems.org or something you could use this
feature to avoid a name collision there.

## Cool, what do I need to do to start hacking?

- Put your project in the `config/projects` directory
- Create a recipe in the `config/software` directory
- Use the [balanced-omnibus](https://github.com/balanced-cookbooks/balanced-omnibus) to setup and iterate on your lab
