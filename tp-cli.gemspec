Gem::Specification.new do |spec|
  spec.name		= "tp-cli"
  #{MAJOR: incompatible}.{MINOR added feature}.{PATCH bugfix}-{LABEL}
  spec.version		= "0.0.1"
  author_list = {
    "Anne Vetto" => "anne@lrdesign.com",
    "Tony Delgado-Willis" => "tonydw@lrdesign.com",
    "Evan Dorn" => "evan@lrdesign.com"
  }
  spec.authors		= author_list.keys
  spec.email		= spec.authors.map {|name| author_list[name]}
  spec.summary		= "Timepulse Command Line Interface"
  spec.description	= <<-EndDescription
  CLI tool for submitting activity information to Timepulse
  EndDescription

  spec.rubyforge_project= spec.name.downcase
  spec.homepage        = "https://github.com/TimePulse/tp-cli"
  spec.required_rubygems_version = Gem::Requirement.new(">= 0") if spec.respond_to? :required_rubygems_version=

  # Do this: y$@"
  # !!find lib bin doc spec spec_help -not -regex '.*\.sw.' -type f 2>/dev/null
  spec.files		= %w[ .envrc.example .gitignore Gemfile Gemfile.lock LICENSE.txt README.md Rakefile bin/tp_cli lib/tp_cli.rb lib/config.rb spec/spec_helper.rb spec/tp_cli_spec.rb tp-cli.gemspec]

  # spec.test_file        = "spec_help/gem_test_suite.rb"
  spec.licenses = ["MIT"]
  spec.require_paths = %w[lib/]
  spec.rubygems_version = "1.3.5"

  spec.has_rdoc		= true
  spec.extra_rdoc_files = Dir.glob("doc/**/*")
  spec.rdoc_options	= %w{--inline-source }
  spec.rdoc_options	+= %w{--main doc/README }
  spec.rdoc_options	+= ["--title", "#{spec.name}-#{spec.version} Documentation"]

  #spec.add_dependency("", "> 0")
  spec.add_dependency 'typhoeus', '~> 0.8'
  spec.add_dependency 'valise', '~> 1.1'

  #spec.post_install_message = "Thanks for installing my gem!"
end
