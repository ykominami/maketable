# frozen_string_literal: true

require "pathname"
require "byebug"

module Maketable
  TEST_DATA_DIR = Pathname.new(__dir__).parent.join("test_data")
  EXIT_COD_OF_ERROR_OCURRENT = 1
  EXIT_COD_OF_ILLEGAL_STATE = 2
  EXIT_COD_OF_ILLEGAL_ACTION = 3

  class Error < StandardError; end
  class InvalidYearError < Error; end
  class InvalidObjectError < Error; end
  class InvalidFormatError < Error; end
  class InvalidLevelChangeError < Error; end
  class NoParentItemxError < Error; end
  class InvalidParentLevelError < Error; end
  class InvalidDataString < Error; end
  # Your code goes here...
end

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
require_relative "maketable/errorx"
