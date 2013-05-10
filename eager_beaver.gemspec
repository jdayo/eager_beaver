$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "eager_beaver/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "eager_beaver"
  s.version     = EagerBeaver::VERSION
  s.authors     = ["Joseph Emmanuel Dayo"]
  s.email       = ["joseph.dayo@gmail.com"]
  s.homepage    = ""
  s.summary     = "Allow you to force eager loading"
  s.description = "Allow Class.descendants and Class.ancestors to work even in Rails development ode."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1.12"

  s.add_development_dependency "sqlite3"
end
