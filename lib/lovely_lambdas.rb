require_relative 'lovely_lambdas/create_interceptor'
require_relative 'lovely_lambdas/create_sequence'
require_relative 'lovely_lambdas/pass'

module LL

  # The VERSION file must be in the root directory of the library.
  VERSION_FILE = File.expand_path('../../VERSION', __FILE__)

  VERSION = File.exist?(VERSION_FILE) ?
    File.read(VERSION_FILE).chomp : '(could not find VERSION file)'

end
