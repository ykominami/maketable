# frozen_string_literal: true

module Maketable
  class OutputTable
    def initialize(month_range, hs_table, month_range_x_index, year, day_range_group)
      @row_index = 0
      @col_index = 0
      @max_row_index = 0

      @month_range = month_range
      @hs_table = hs_table
      @tc_ary = []
      @month_range_x_index = month_range_x_index
      @year = year
      @day_range_group = day_range_group

      @label_width = 2
      @width = @hs_table.keys.size + @label_width
      @output_table = Array.new(@width) { [] }

      @hs_table.keys.each_with_index do |column, index|
        # p "OutputTable initialize column=#{column} index=#{index}"
        @tc_ary << TableColumn.new(index, column, @hs_table[column][@month_range_x_index], @month_range)
      end
    end

    def make_table
      @months_of_year = 12
      @month_index_conv = { 4 => 4, 5 => 5, 6 => 6, 7 => 7, 8 => 8, 9 => 9, 10 => 10, 11 => 11, 12 => 12, 13 => 1,
                            14 => 2, 15 => 3 }

      output_pad = 2

      @month_first = 4
      @month_last = 3
      @day_range_first = 0
      @day_range_last = 2

      @tc_first = 0
      @tc_last = (@tc_ary.size - 1)

      @label_item_list = Order.make_table_row_label(@month_first)
      start_row = 0
      make_output_table_header(output_pad, start_row)
      start_row = 2
      make_output_table(output_pad, start_row)
    end

    def make_output_table_header(output_pad, start_row)
      # byebug
      max_row = 0
      @tc_first.upto(@tc_last) do |tc_index|
        output_column_index = tc_index + output_pad
        next_row = start_row
        next_row = @tc_ary[tc_index].output_key(@output_table[output_column_index], next_row)
        max_row = next_row if max_row < next_row
      end
      max_row
    end

    def make_table_row_label(start_row, month_index, day_range_index)
      index = month_index - @month_first
      item = @label_item_list[index]
      date = item.date_head
      content = if day_range_index == 0
                  %(#{date.year}-#{date.month})
                else
                  ""
                end
      @output_table[0][start_row] = content
    end

    def make_output_table(output_pad, start_row)
      # p "OutputTable make_output_table output_pad=#{output_pad} start_row=#{start_row}"
      max_row = 0
      tc_start_row = start_row

      @month_first.upto(@month_first + @months_of_year - 1) do |m_index|
        # p "OutputTable make_output_table m_index=#{m_index}"
        month_index = @month_index_conv[m_index]
        @day_range_first.upto(@day_range_last) do |day_range_index|
          # p "OutputTable make_output_table day_range_index=#{day_range_index}"
          make_table_row_label(tc_start_row, m_index, day_range_index)
          # p "OutputTable make_output_table @tc_first=#{@tc_first} @tc_last=#{@tc_last}"
          @tc_first.upto(@tc_last) do |tc_index|
            # p "OutputTable make_output_table tc_index=#{tc_index}"
            output_column_index = tc_index + output_pad
            next_row = tc_start_row
            tc = @tc_ary[tc_index]
            # p @tc_ary
            next_row = tc.make_output(@output_table[output_column_index], next_row, month_index, day_range_index)
            max_row = next_row if max_row < next_row
          end
          tc_start_row = max_row
        end
      end
      max_row
    end

    def make_table_format(head_flag:, data:, format: :trac_wiki)
      lines = []
      case format
      when :trac_wiki
        lines << %(|| #{data.join(" || ")} ||)
      when :markdown
        lines << %(| #{data.join(" | ")} |)
        if head_flag
          data.size
          lines << %(|#{Array.new(data.size) { "-" }.join("|")}|)
        end
      else
        raise InvalidFormatError
      end
      lines
    end

    def show(max_row, table_format)
      lineno = 0
      lines = []
      0.upto(max_row - 1) do |j|
        ary = []
        0.upto(@width - 1) do |i|
          ary << if @output_table[i]
                   @output_table[i][j] || ""
                 else
                   ""
                 end
        end
        lines = make_table_format(head_flag: (lineno == 0), data: ary, format: table_format)
        lines.map { |l| puts l }
        lineno += 1
      end
    end
  end
end
