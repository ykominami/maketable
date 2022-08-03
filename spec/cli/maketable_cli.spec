require 'spec_helper'
require 'pry'
require 'aruba/rspec'

RSpec.describe "CLI", type: :aruba do
  before(:each) do
    cmdline = "ruby -v"
    run_command(cmdline)
  end
  it "DateTime List", ycmd: 1 do
    expect(last_command_started).to be_successfully_executed
  end
end
