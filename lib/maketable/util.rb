# frozen_string_literal: true

require "date"

module Maketable
  # ユーティリティクラス
  class Util
    class << self
      def make_date_list(year, month, max = 12)
        @dt_list = []
        dt = nil
        month.upto(month + max - 1) do |x|
          dt = if dt
                 dt.next_month
               else
                 Date.new(year, x)
               end
          @dt_list << dt
        end
        @dt_list
      end

      def convert_index(month)
        month -= 12 if month > 12
        month
      end

      def make_date_hash(year, month, max = 12)
        @dt_hash = {}
        dt = nil
        month.upto(month + max - 1) do |x|
          dt = if dt
                 dt.next_month
               else
                 Date.new(year, x)
               end
          y = convert_index(x)
          @dt_hash[y] = dt
        end
        @dt_hash
      end

      def make_month_order(src, date_hash)
        if src.instance_of?(Hash)
          dest_hash = {}
          src.each do |k, v|
            dest_hash[k] = make_month_order(v, date_hash)
          end
          dest_hash
        elsif src.instance_of?(Array)
          dest_array = []
          src.each do |v|
            dest_array << make_month_order(v, date_hash)
          end
          dest_array
        elsif src.instance_of?(Integer)
          date_hash[src]
        else
          raise InvalidObjectError
        end
      end
    end
  end
end
