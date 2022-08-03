# frozen_string_literal: true

module Maketable
  class Order
    @order_month = {
      1 => {
        1 => [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]],
        2 => [[1, 2, 3, 4, 5, 6], [7, 8, 9, 10, 11, 12]],
        3 => [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]],
        4 => [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]]
      },
      4 => {
        1 => [[4, 5, 6,   7,   8, 9,   10, 11,   12,   1, 2, 3]],
        2 => [[4, 5, 6,   7,   8, 9], [10, 11,   12,   1, 2, 3]],
        3 => [[4, 5, 6,   7], [8, 9,   10, 11], [12,   1, 2, 3]],
        4 => [[4, 5, 6], [7,   8, 9], [10, 11,   12], [1, 2, 3]]
      }
    }
    @order_month_1 = {
      1 => [[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]],
      2 => [[1, 2, 3, 4, 5, 6], [7, 8, 9, 10, 11, 12]],
      3 => [[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12]],
      4 => [[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, 12]]
    }
    @order_month_4 = {
      1 => [[4, 5, 6,   7,   8, 9,   10, 11,   12,   1, 2, 3]],
      2 => [[4, 5, 6,   7,   8, 9], [10, 11,   12,   1, 2, 3]],
      3 => [[4, 5, 6,   7], [8, 9,   10, 11], [12,   1, 2, 3]],
      4 => [[4, 5, 6], [7,   8, 9], [10, 11,   12], [1, 2, 3]]
    }

    @order_month_a = {}

    @order_day = {
      1 => [[1, 31]],
      2 => [[1, 15], [16, 31]],
      3 => [[1, 10], [11, 20], [21, 31]],
      4 => [[1, 8], [9, 16], [17, 24], [25, 31]],
      5 => [[1, 6], [7, 12], [13, 18], [19, 24], [25, 31]]
    }

    @day_range_label = {
      1 => { 0 => "" },
      2 => { 0 => "上", 1 => "下" },
      3 => { 0 => "上", 1 => "中", 2 => "下" },
      4 => { 0 => "1", 1 => "2", 2 => "3", 3 => "4" },
      5 => { 0 => "1", 1 => "2", 2 => "3", 3 => "4", 4 => "5" }
    }

    class << self
      def make_month_order(year, start_month, max)
        # datetime_hash = Util.make_datetime_hash(year, start_month, max)
        date_hash = Util.make_date_hash(year, start_month, max)
        # Util.make_month_order(@order_month, datetime_hash)
        Util.make_month_order(@order_month, date_hash)
      end

      def make_month_order_1(year, max)
        start_month = 1
        # datetime_hash = Util.make_datetime_hash(year, start_month, max)
        date_hash = Util.make_date_hash(year, start_month, max)
        # Util.make_month_order(@order_month_1, datetime_hash)
        Util.make_month_order(@order_month_1, date_hash)
      end

      def make_month_order_4(year, max)
        start_month = 4
        # datetime_hash = Util.make_datetime_hash(year, start_month, max)
        date_hash = Util.make_date_hash(year, start_month, max)
        # Util.make_month_order(@order_month_4, datetime_hash)
        Util.make_month_order(@order_month_4, date_hash)
      end

      def make_month_order_a(year, max)
        @order_month_a[1] = make_month_order_1(year, max)
        @order_month_a[4] = make_month_order_4(year, max)
        @order_month_a
      end

      def get_day_range_label(day_range, index)
        @day_range_label[day_range][index]
      end

      def month_range_index(range_array, target)
        range_array.index { |v| v.include?(target) }
      end

      def month_range_index_a(range_array, target)
        range_array.index { |v| v.include?(target) }
      end

      def day_range_index(range_array, target)
        range_array.index { |v| v.first <= target && v.last >= target }
      end

      def get_month_range(start_month, month_range_group)
        @order_month[start_month][month_range_group]
      end

      def get_day_range_array(day_range_group)
        @order_day[day_range_group]
      end

      def order(month_range, day_range_array, column, item, hs_table)
        # month = item.datetime_head.month
        month = item.date_head.month
        # day = item.datetime_head.day
        day = item.date_head.day

        m_r_index = month_range_index(month_range, month)
        d_r_index = day_range_index(day_range_array, day)

        hs_table[column] ||= {}
        hs_table[column][m_r_index] ||= {}
        hs_table[column][m_r_index][month] ||= {}
        hs_table[column][m_r_index][month][d_r_index] ||= []
        hs_table[column][m_r_index][month][d_r_index] << item
      end

      def make_table_row_label(start_month)
        start_day = "#{start_month}/1"
        @order_month[1][1][0].each_with_object([]) do |_x, list|
          list << if list.empty?
                    item = Item.new(start_day, @year)
                    item.analyze
                    item
                  else
                    list.last.make_next_month_item
                  end
        end
      end
    end
  end
end
