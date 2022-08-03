# frozen_string_literal: true

require "yaml"
require "date"
require "pp"

module Maketable
  class Maketable
    def initialize(yamlfile, year)
      @yamlfile = yamlfile
      @yaml = YAML.load_file(@yamlfile)
      raise InvalidYearError if year.nil?
      raise InvalidYearError unless year.instance_of?(Integer)

      @year = year
      @year_str = @year.to_s

      @hs = {}
      @hs_items = {}
      @hs_table = {}
      @columns = []

      @num_of_columns = @yaml.keys.size
      @label_width = 2
      @start_month = 4
      @month_range_group = 1
      @day_range_group = 3
      @month_range = Order.get_month_range(@start_month, @month_range_group)
      @day_range_array = Order.get_day_range_array(@day_range_group)
      @month_range_x_index = 0
    end

    def show
      pp @yaml
    end

    def analyze
      analyze_level1
      # item_sort
      analyze_level2
      @hs
    end

    def output_any(level, item)
      indent = " " * level
      if item.instance_of?(String)
        puts "#{indent}#{item}"
      elsif item.instance_of?(Array)
        item.each do |x|
          output_any(level + 1, x)
        end
      elsif item.instance_of?(Hash)
        output_hash( level + 1, item)
      else
        item.output(level)
      end
    end

    def output_hash(level, hash)
      indent_k = " " * level
      level_v = level + 1
      indent_v = " " * level_v

      hash.keys.each do |k|
        puts "#{indent_k}#{k}"
        output_any(level_v, hash[k])
      end
    end

    def xhs_items_0
      output_hash(0, @hs_items)
    end
 
    def next_dir( dir )
      if dir == :v
        :h
      else
        :v
      end
    end

    def xhs_items_sub_v(v, h, output_hs, list)
      puts "xhs_items_sub_v|v=#{v}|h=#{h}"
      @v = v
      @h = h
      output_hs[@v] ||= {}

      if list.instance_of?(String)
        puts "xhs_items_sub_v|String"
        output_hs[@v][@h] = list
        global_position_update(@v, @h, :h)
      elsif list.instance_of?(Array)
        puts "xhs_items_sub_v|Array"
        list.each do |item|
          xhs_items_sub_h(@v, @h, output_hs, item)
          global_position_update(v, h, :h)
        end
      elsif list == nil
        puts "xhs_items_sub_v|Nil"
        output_hs[@v][@h] = nil
        global_position_update(@v, @h, :h)
      else
        puts "xhs_items_sub_v|Hash"
        # Hashとみなす
        list.keys.each do |key|
          output_hs[@v][@h] = key
          xhs_items_sub_h(@v, @h, output_hs, list[key] )
          global_position_update(@v, @h, :h)
        end
      end
    end

    def xhs_items_sub_h(v, h, output_hs, list)
      @v = v
      @h = h
      output_hs[@v] ||= {}

      if list.instance_of?(String)
        output_hs[@v][@h] = list
        global_position_update(v, h, :v)
      elsif list.instance_of?(Array)
        list.each do |item|
          xhs_items_sub_v(@v, @h, output_hs, item)
          global_position_update(v, h, :v)
        end
      elsif list == nil
        output_hs[@v][@h] = nil
        global_position_update(v, h, :v)
      else
        # Hashとみなす
        list.keys.each do |key|
          output_hs[@v][@h] = nil
          xhs_items_sub_h(@v, @h, output_hs, list[key] )
          global_position_update(v, h, :v)
        end
      end
    end

    def global_position_update(v, h, dir)
      if dir == :h
        @h += 1
        @v = v
      else
        @h = h
        @v += 1
      end
    end

    def xhs_items
      v = 0
      h = 0
      @hs = {}
      dir = :v
      @v = v
      @h = h
      next_dir = next_dir(dir)

      @yaml.keys.each do |key|
        puts "xhs_items|key=#{key}"
        @hs[@v] ||= {}
        @hs[@v][@h] = key
        puts "xhs_items|@hs[#{@v}][#{@h}]=#{ @hs[@v][@h] }"
        if dir == :v
          xhs_items_sub_v(@v, @h, @hs, @yaml[key] )
        else
          xhs_items_sub_h(@v, @h, @hs, @yaml[key] )
        end
        global_position_update(v, h, dir)
      end

      pp @hs
    end

    def analyze_2
      puts "analyze_2"
      @yaml.each do |k, v|
        unless v
          @hs[k] = []
          @hs_items[k] = []
          next
        end
        v.each do |str|
          item = Item.new(str, @year_str)
          #item.analyze
          @hs_items[k] ||= []
          @hs_items[k] << item
        end
        #@hs_items[k] = @hs_items[k].sort_by(&:date_head)
      end
    end

    def analyze_level1
      @yaml.each do |k, v|
        unless v
          @hs[k] = []
          @hs_items[k] = []
          next
        end
        v.each do |str|
          item = Item.new(str, @year_str)
          item.analyze
          @hs_items[k] ||= []
          @hs_items[k] << item
        end
        @hs_items[k] = @hs_items[k].sort_by(&:date_head)
      end
    end

    def analyze_level2
      @hs_items.each do |column, v|
        if v.empty?
          @hs_table[column] = {}
          @hs_table[column][@month_range_x_index] = {}
        else
          v.each do |item|
            Order.order(@month_range, @day_range_array, column, item, @hs_table)
          end
        end
      end
      @hs_table
    end

    def output(table_format = :trac_wiki)
      ot = OutputTable.new(@month_range, @hs_table, @month_range_x_index, @year, @day_range_group)
      max_row = ot.make_table
      ot.output(max_row, table_format)
    end
  end
end
