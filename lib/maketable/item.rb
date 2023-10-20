# frozen_string_literal: true

module Maketable
  class Item
    attr_reader :desc_str, :date_tail
    attr_accessor :date_head

    def initialize(desc_str, year_str, index)
      @desc_str = desc_str
      @year_str = year_str
      @index = index
      @date_head = nil
      @date_tail = nil
    end

    def show(level)
      indent = " " * level
      puts "#{indent}desc_str=#{@desc_str}"
    end

    def analzye_no_comma_pattern(left, desc_str)
      head, sep, tail = left.partition("-")
      if sep == ""
        date_str = %(#{@year_str}/#{left})
        begin
          datetime_head = DateTime.parse(date_str)
          @date_head = datetime_head.to_date
          raise InvalidDataString if @date_head.nil?
        rescue StandardError => e
          puts e.message
          puts "A0 desc_str=#{desc_str}"
          puts "A1 date_str=#{date_str}"
          Errorx.error_occur
        end
      else
        begin
          date_str = %(#{@year_str}/#{head})
          datetime_head = DateTime.parse(date_str)
          @date_head = datetime_head.to_date
          raise InvalidDataString if @date_head.nil?
        rescue StandardError => e
          puts e.message
          puts "A1 desc_str=#{desc_str}"
          puts "A1 date_str=#{date_str}"
          Errorx.error_occur
        end

        begin
          lh, _sep, _rh = head.partition("/")
          date_str = %(#{@year_str}/#{lh}/#{tail})
          datetime_tail = DateTime.parse(date_str)
          @date_tail = datetime_tail.to_date
          raise InvalidDataString if @date_tail.nil?
        rescue StandardError => e
          puts e.message
          puts "A2 desc_str=#{desc_str}"
          puts "A2 date_str=#{date_str}"
          Errorx.error_occur
        end
      end
    end

    def analzye_comma_pattern(head, tail)
      begin
        datetime_head = DateTime.parse(%(#{@year_str}/#{head}))
        @date_head = datetime_head.to_date
      rescue StandardError => e
        puts e.message
        puts "A3 desc_str=#{desc_str}"
        puts "A3 date_str=#{date_str}"
        Errorx.error_occur
      end

      lh, _sep, _rh = head.partition("/")
      begin
        datetime_tail = DateTime.parse(%(#{@year_str}/#{lh}/#{tail}))
        @date_tail = datetime_tail.to_date
      rescue StandardError => e
        puts e.message
        puts "A4 desc_str=#{desc_str}"
        puts "A4 date_str=#{date_str}"
        Maketable::Errorx.error_occur
      end
    end

    def analyze
      # byebug
      # puts "@desc_str=#{@desc_str}|"
      left, _sep, _right = @desc_str.partition(" ")
      head, sep, tail = left.partition(",")
      if sep == ""
        analzye_no_comma_pattern(left, @desc_str)
      else
        analzye_comma_pattern(head, tail)
      end
      Errorx.check_error_and_exit
    end

    def make_next_month_item
      dest = Item.new(@desc_str, @year_str, -1)
      dest.analyze
      next_month = @date_head.next_month
      dest.date_head = next_month
      dest
    end
  end
end
