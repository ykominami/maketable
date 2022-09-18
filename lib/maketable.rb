# frozen_string_literal: true

require_relative "maketable/version"
require_relative "maketable/item"
require_relative "maketable/order"
require_relative "maketable/maketable"
require_relative "maketable/outputtable"
require_relative "maketable/tablecolumn"
require_relative "maketable/util"
require_relative "maketable/limitedmarkdown"
require_relative "maketable/utilx"
require_relative "maketable/hiretext"
require_relative "maketable/cli"

require "pathname"
require "byebug"
module Maketable
  #  TEST_DATA_DIR = Pathname.new(__dir__).parent + "test_data"
  TEST_DATA_DIR = Pathname.new(__dir__).parent.parent.join("maketable_test_data")

  class Error < StandardError; end
  class InvalidYearError < Error; end
  class InvalidObjectError < Error; end
  class InvalidFormatError < Error; end
  class InvalidLevelChangeError < Error; end
  class NoParentItemxError < Error; end
  class InvalidParentLevelError < Error; end
  # Your code goes here...
end
