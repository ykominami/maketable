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

    def analyze
      error_occrence_count = 0
      # byebug
      # puts "@desc_str=#{@desc_str}|"
      left, _sep, _right = @desc_str.partition(" ")
      head, sep, tail = left.partition(",")
      if sep == ""
        head, sep, tail = left.partition("-")
        if sep == ""
          date_str = %(#{@year_str}/#{left})
          begin
            datetime_head = DateTime.parse(date_str)
            @date_head = datetime_head.to_date
            raise InvalidDataString if @date_head.nil?
          rescue StandardError => exc
            puts exc.message
            puts "A0 desc_str=#{desc_str}"
            error_occrence_count += 1
          end
        else
          begin
            date_str = %(#{@year_str}/#{head})
            datetime_head = DateTime.parse(date_str)
            @date_head = datetime_head.to_date
            raise InvalidDataString if @date_head.nil?
          rescue StandardError => exc
            puts exc.message
            puts "A1 desc_str=#{desc_str}"
            puts "A1 date_str=#{date_str}"
            error_occrence_count += 1
          end

          begin
            lh, _sep, _rh = head.partition("/")
            date_str = %(#{@year_str}/#{lh}/#{tail})
            datetime_tail = DateTime.parse(date_str)
            @date_tail = datetime_tail.to_date
            raise InvalidDataString if @date_tail.nil?
          rescue StandardError => exc
            puts exc.message
            puts "A2 desc_str=#{desc_str}"
            puts "A2 date_str=#{date_str}"
            error_occrence_count += 1
          end
        end
      else
        begin
          date_str = %(#{@year_str}/#{head})
          datetime_head = DateTime.parse(date_str)
          @date_head = datetime_head.to_date
          raise InvalidDataString if @date_head.nil?
        rescue StandardError => exc
          puts exc.message
          puts "A3 desc_str=#{desc_str}"
          puts "A3 date_str=#{date_str}"
          error_occrence_count += 1
        end
        lh, _sep, _rh = head.partition("/")
        begin
          date_str = %(#{@year_str}/#{lh}/#{tail})
          datetime_tail = DateTime.parse(date_str)
          @date_tail = datetime_tail.to_date
          raise InvalidDataString if @date_head.nil?
        rescue StandardError => exc
          puts exc.message
          puts "A4 desc_str=#{desc_str}"
          puts "A4 date_str=#{date_str}"
          error_occrence_count += 1
        end
      end

      if error_occrence_count > 0
        exit(::Maketable::EXIT_COD_OF_ERROR_OCURRENT)
      end
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
