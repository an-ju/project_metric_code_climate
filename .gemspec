# -*- encoding: utf-8 -*-
# stub: code_climate_project_metrics 0.0.5 ruby lib

Gem::Specification.new do |s|
  s.name = "project_metric_code_climate"
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Sam Joseph", 'An Ju']
  s.date = "2016-07-21"
  s.description = "Project metrics from code climate"
  s.email = "an_ju@berkeley.edu"
  s.homepage = "https://github.com/an-ju/project_metric_code_climate"
  s.licenses = ["MIT"]
  s.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.rubygems_version = "2.5.1"
  s.summary = "ProjectMetricCodeClimate"

  s.add_development_dependency "bundler", "~> 1.17"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_runtime_dependency 'faraday'
end
