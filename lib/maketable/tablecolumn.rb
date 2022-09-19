# frozen_string_literal: true

module Maketable
  class TableColumn
    def initialize(column_index, key, data_hs, month_range)
      @column_index = column_index
      @key = key
      @data_hs = data_hs
      @month_range = month_range
    end

    def show
      pp @month_range
      pp @column_index
      pp @key
      pp @data_hs
    end

    def output_key(output_hs, output_row)
      lh, sep, rh = @key.partition("//")
      if sep == ""
        output_hs[output_row] = @key
      else
        output_hs[output_row] = lh
        output_row += 1
        output_hs[output_row] = rh
      end
      output_row += 1
      output_row
    end

    def make_output(output_hs, start_row, month_index, day_range_index)
      output_row = start_row
      if @data_hs
        m_info = @data_hs[month_index]
        if m_info && m_info[day_range_index] && !m_info[day_range_index].empty?
          m_info[day_range_index].each do |item|
            output_hs[output_row] = item.desc_str
            output_row += 1
          end
        end
      end
      if output_row == start_row
        output_hs[output_row] = ""
        output_row += 1
      end
      output_row
    end
  end
end
