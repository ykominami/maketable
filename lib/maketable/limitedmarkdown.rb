# frozen_string_literal: true

require "yaml"
require "pathname"
module Maketable
  class LimitedMarkDown
    class << self
      def create_md_from_setting_yaml_file(yaml_file)
        obj = Cli.load_setting_yaml_file(yaml_file)

        lmd = new(obj["input_file"], obj["output_file"], obj["table_format"])
        [lmd, obj]
      end
    end

    # 初期化
    def initialize(infile, outfile, table_format)
      @infile = infile
      @outfile = outfile
      # puts "outfile=#{outfile}"
      @table_format = table_format
      @indent = {}
      @re_heading = Regexp.new("^(#+)(\s*)(.+)")
      # @re_label = Regexp.new("(.+)\[<(.+)>\]")
      @re_label = Regexp.new("(.+)<<(.+)>>")
      @lines = []
      @table = {}
      # @max_tag_size = 0
      @items_count = 0
      @columns_count = 0
      @cur_level = 0
      @labels = []
    end

    def table_width
      @items_count + @columns_count
    end

    def create_table_header(labels)
      line_no = 0
      @table[line_no] ||= Array.new(table_width)
      labels.each_with_index do |label, index|
        @table[line_no][@items_count + index] = label
      end
      line_no += 1
      case @table_format
      when :markdown
        @table[line_no] ||= Array.new(table_width, "-")
        line_no += 1
      end
      line_no
    end

    def create_table_body(lines, next_lineno)
      lines.each_with_index do |x, index|
        ind = next_lineno + index
        @table[ind] ||= Array.new(table_width)
        @table[ind][x[0]] = x[1]
        x[2, (x.size - 1)].each_with_index do |val, index_inner|
          @table[ind][@items_count + index_inner] = val
        end
      end
    end

    def make_table
      width = table_width
      0.upto(@table.keys.size) do |lineno|
        arr = []
        0.upto(width) do |index|
          arr << @table[lineno][index]
        end
      end
    end

    def add_label(level, label)
      # jo
      if @cur_level < level
        raise if (@cur_level + 1) != level

        (level + 1).upto(@labels.size - 1) do |ind|
          @labels[ind] = nil
        end
      end
      @labels[level] = label
      @cur_level = level
    end

    def label
      if @cur_level >= 1
        @labels[1, @cur_level]
      else
        []
      end
    end

    def output_file(str)
      File.write(@outfile, str)
    end

    def md2table(columns_count, header_labels, format, fields)
      # p fields
      lines = []
      raise unless columns_count

      @columns_count = columns_count
      max_heading_size = 0
      arr = File.readlines(@infile)
      arr.each_with_index do |l, _index|
        next unless l

        next unless @re_heading.match(l)

        heading = Regexp.last_match[1]
        level = heading.size
        max_heading_size = level if max_heading_size < level
        l2 = Regexp.last_match[3]
        if @re_label.match(l2)
          content = Regexp.last_match[1]
          label = Regexp.last_match[2]
          add_label(level, label)
          while content.sub!(" ", "")
          end
        else
          content = l2
        end

        data_fields = content.split("||", -1)
        desc = data_fields.shift
        arrx = data_fields.zip(fields).map do |field, x|
          next unless x

          if x["name"] == "ラベル"
            x["value"] = label.join("-")
          elsif field =~ x["re"]
            x["value"] = Regexp.last_match(1)
          end
          x["value"]
        end

        lx = [level - 1, desc].concat(arrx)
        lines << lx
      end
      @items_count = max_heading_size
      next_lineno = create_table_header(header_labels)
      create_table_body(lines, next_lineno)
      table = []
      0.upto(@table.keys.size - 1) do |lineno|
        l = Utilx.make_table_format(data: @table[lineno], format: format).join("\n")
        table << l
      end
      table.join("\n")
    end
  end
end
