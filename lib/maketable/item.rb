# frozen_string_literal: true

module Maketable
  class Item
    attr_reader :desc_str, :date_tail
    attr_accessor :date_head

    def initialize(desc_str, year_str)
      @desc_str = desc_str
      @year_str = year_str
      @date_head = nil
      @date_tail = nil
    end

    def output(level)
      indent = " " * level
      puts "#{indent}desc_str=#{@desc_str}"
    end

    def analyze
      # byebug
      left, _sep, _right = @desc_str.partition(" ")
      head, sep, tail = left.partition(",")
      if sep == ""
        head, sep, tail = left.partition("-")
        if sep == ""
          date_str = %(#{@year_str}/#{left})
          p "date_str=#{date_str}"
          datetime_head = DateTime.parse(date_str)
          @date_head = datetime_head.to_date
        else
          datetime_head = DateTime.parse(%(#{@year_str}/#{head}))
          @date_head = datetime_head.to_date
          lh, _sep, _rh = head.partition("/")
          datetime_tail = DateTime.parse(%(#{@year_str}/#{lh}/#{tail}))
          @date_tail = datetime_tail.to_date
        end
      else
        datetime_head = DateTime.parse(%(#{@year_str}/#{head}))
        @date_head = datetime_head.to_date
        lh, _sep, _rh = head.partition("/")
        datetime_tail = DateTime.parse(%(#{@year_str}/#{lh}/#{tail}))
        @date_tail = datetime_tail.to_date
      end
    end

    def make_next_month_item
      dest = Item.new(@desc_str, @year_str)
      dest.analyze
      next_month = @date_head.next_month
      dest.date_head = next_month
      dest
    end
  end
end
