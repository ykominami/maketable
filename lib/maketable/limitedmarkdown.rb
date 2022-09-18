require 'yaml'
require 'pathname'
module Maketable
  class LimitedMarkDown
    class << self
      def create_from_yaml_file(yaml_file)
        yaml_file_pn = Pathname.new(yaml_file)
        yaml_file_parent_pn = yaml_file_pn.parent
        obj = YAML.load_file(yaml_file_pn)
        input_file_pn = Pathname.new(obj["input_file"])
        output_file_pn = Pathname.new(obj["output_file"])

        obj["input_file"] = yaml_file_parent_pn + input_file_pn if !input_file_pn.exist?
        obj["output_file"] = yaml_file_parent_pn + output_file_pn if !output_file_pn.exist?

        colums_count = obj["columns_count"]
        table_format = obj["table_format"]
        headers = obj["headers"]
        fields = obj["fields"]
        table_format = obj["table_format"]
        #format = :markdown
        fields.map{ |hs|
          hs["re"] = Regexp.new("^#{hs["name"]}:([^|]*)$")
        }

        lmd = self.new(obj["input_file"], obj["output_file"])
        [lmd, obj]
      end
    end
    # 初期化
    def initialize(infile, outfile)
      @infile = infile
      @outfile = outfile
      @indent = {}
      @re_heading = Regexp.new("^(#+)(\s*)(.+)")
      #@re_label = Regexp.new("(.+)\[<(.+)>\]")
      @re_label = Regexp.new("(.+)<<(.+)>>")
      @lines = []
      @table = {}
      #@max_tag_size = 0
      @items_count = 0
      @columns_count = 0
      @cur_level = 0
      @labels = []
    end

    # 
    def get_table_width
      @items_count + @columns_count
    end

    def create_table_header(labels)
      line_no = 0
      @table[line_no] ||= Array.new(get_table_width)
      labels.each_with_index do |label, index|
        @table[line_no][@items_count + index] = label
      end
      line_no += 1
    end

    def create_table_body(lines, next_lineno)
      lines.each_with_index do |x, index|
        ind = next_lineno + index
        @table[ind] ||= Array.new(get_table_width)
        @table[ind][x[0]] = x[1]
        x[2,(x.size - 1)].each_with_index do |val, index|
          @table[ind][@items_count + index] = val
        end
      end
    end

    def make_table
      width = get_table_width
      0.upto(@table.keys.size) do |lineno|
        arr = []
        0.upto(width) do |index|
          arr << @table[lineno][index]
        end
      end
    end

    def add_label(level, label)
      if @cur_level < level
        raise if (@cur_level + 1) != level
        @labels[level] = label
      elsif @cur_level == level
        @labels[level] = label
      else
        (level + 1).upto(@labels.size - 1) do |ind|
          @labels[ind] = nil
        end 
        @labels[level] = label
      end
      @cur_level = level
    end

    def get_label
      #p "@cur_level=#{@cur_level}"
      if 1 < @cur_level
        @labels[1,@cur_level]
      else
        []
      end
    end

    def output(str)
      File.open(@outfile, "w"){ |f|
        f.write(str)
      }
    end

    def md2table(columns_count, header_labels, format, fields)
      #p fields
      lines = []
      raise unless columns_count
      @columns_count = columns_count
      max_heading_size = 0
      arr = File.readlines(@infile)
      arr.each_with_index do |l, index|
        next unless l
        if @re_heading.match(l)
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
            #p "F content=#{content}"
          end

          data_fields = content.split('||', -1)
          #p fields

          desc = data_fields.shift
          status = data_fields.shift
          arrx = data_fields.zip(fields).map{ |field, x|
            if field =~ x["re"]
              x["value"] = Regexp.last_match(1)
            end
            x["value"]
          }

          lx = [level - 1, desc, status, get_label.join("-")].concat(arrx)
          #puts "lx=#{lx}"
          lines << lx
        end
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
