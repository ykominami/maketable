# frozen_string_literal: true

require "maketable"
require "date"
require "pp"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def test_file_base_pn
  if ENV["TEST_DATA_DIR"]
    Pathname.new(ENV["TEST_DATA_DIR"])
  else
    Maketable::TEST_DATA_DIR
  end
end

def test_file_pn
  @test_file_pn = test_file_base_pn.join("test.yml")
end

def test_file_x_pn(fname)
  @test_file_pn = test_file_base_pn.join(fname)
end
