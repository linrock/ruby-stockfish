# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$:.unshift(lib) unless $:.include?(lib)

require 'stockfish/version'


Gem::Specification.new do |s|
  s.name = "stockfish"
  s.version = Stockfish::VERSION
  s.authors = ["Linmiao Xu"]
  s.email = ["linmiao.xu@gmail.com"]

  s.summary = "Ruby client for the Stockfish chess engine"
  s.description = "Ruby client for the Stockfish chess engine"
  s.license = "MIT"

  s.files = `git ls-files -z`.split("\0")

  s.add_development_dependency "rake",     "~> 10.0"
  s.add_development_dependency "minitest", "~> 5.0"
  s.add_development_dependency "pry",      "~> 0.10"
end
