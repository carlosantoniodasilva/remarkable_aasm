if RAILS_ENV == "test"

  require 'remarkable_activerecord'

  require File.join(File.dirname(__FILE__), "lib", "remarkable_aasm")

  require 'spec'
  require 'spec/rails'

  Remarkable.include_matchers!(Remarkable::AASM, Spec::Rails::Example::ModelExampleGroup)
end

