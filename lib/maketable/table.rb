module Maketable
  class Table
    def initialize(start_dir)
      @axi = {}
      @start_dir = start_dir
      @cur_dir = @start_dir
    end
  end
end
