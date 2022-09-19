# frozen_string_literal: true

require "pathname"

module Maketable
  # 階層化テキストモジュール
  module HireText
    # 階層化テキストクラス
    class Hire
      @root = Struct.new(:children, :memo, :first_level, :second_level, :third_level)
      @first_level = Struct.new(:text, :memo, :children)
      @second_level = Struct.new(:text, :memo, :children)
      @third_level = Struct.new(:text, :memo, :children)

      def self.create_md_from_setting_yaml_file(yaml_file, opt = nil)
        obj = Cli.load_setting_yaml_file(yaml_file)
        # p obj
        instance = if opt.nil?
                     new(obj["input_file"], obj["output_md_file"])
                   else
                     LimitedMarkDown.new(obj["output_md_file"], obj["output_file"], obj["table_format"])
                   end
        [instance, obj]
      end

      def self.make_root
        @root.new([], nil, nil, nil)
      end

      def self.make_first_level(root, line)
        root.first_level = @first_level.new(line, [], [])
        root.second_level = root.third_level = nil
        root.children << root.first_level
      end

      def self.make_second_level(root, line)
        root.second_level = @second_level.new(line, [], [])
        root.third_level = nil
        root.first_level.children << root.second_level
      end

      def self.make_third_level(root, line)
        root.third_level = @third_level.new(line, [], [])
        root.second_level.children << root.third_level
      end

      def self.add_zero_level_memo(root, line)
        root.memo << line
      end

      def self.add_first_level_memo(root, line)
        root.first_level.memo << line
      end

      def self.add_second_level_memo(root, line)
        root.second_level.memo << line
      end

      def self.add_third_level_memo(root, line)
        root.third_level.memo << line
      end

      def self.error(line)
        puts "ERROR: #{line}"
        exit 100
      end

      def self.no_cation
        # do nothing
      end

      def initialize(input_file, output_file)
        @infile = input_file
        @outfile = output_file

        @input_file_pn = Pathname.new(input_file)
        @lines = File.readlines(@input_file_pn).map(&:chomp)

        @state = State.new

        @line_no = 0
      end

      def next_line
        return nil if @lines.size == @line_no

        line = @lines[@line_no]
        @line_no += 1
        line
      end

      def back_to_previous_line
        @line_no -= 1
      end

      def next_event
        line = next_line
        return nil unless line

        if @state.cur_state == :START
          if line =~ /^■/
            event = :BLACK_SQUARE
            _left, _mid, right = line.partition("■ ")
            text = right
          else
            event = :SOMETHING
            text = line
          end

        elsif line =~ /^■/
          event = :BLACK_SQUARE
          _left, _mid, right = line.partition("■ ")
          text = right
        elsif line =~ /^- /
          event = :HYPHEN1
          _left, _mid, right = line.partition("- ")
          text = right
          # puts "HYPHEN1"
          # puts text
        elsif line =~ /^  - /
          event = :HYPHEN2
          _left, _mid, right = line.partition("- ")
          text = right
          # puts "HYPHEN2"
          # puts text
        elsif line[0] != " "
          event = :SPACE0
          text = line
        elsif line =~ /^ ([^ ]|$)/
          event = :SPACE1
          _left, _mid, right = line.partition(" ")
          text = right
        elsif line =~ /^  ([^ ]|$)/
          event = :SPACE2
          _left, _mid, right = line.partition("  ")
          text = right
        elsif line =~ /^   ([^ ]|$)/
          event = :SPACE3
          _left, _mid, right = line.partition("   ")
          text = right
        elsif line =~ /^    ([^ ]|$)/
          event = :SPACE4
          _left, _mid, right = line.partition("    ")
          text = right
        elsif line =~ /^     ([^ ]|$)/
          event = :SPACE5
          _left, _mid, right = line.partition("     ")
          text = right
        elsif line =~ /^      ([^ ]|$)/
          event = :SPACE6
          _left, _mid, right = line.partition("      ")
          text = right
        elsif line.strip.size.zero?
          event = :BLANK_LINE
          text = ""
        elsif line =~ /^ *([^ ]|$)/
          event = :START1
          _left, _mid, right = line.partition("* ")
          text = right
        elsif line =~ /^  *([^ ]|$)/
          event = :START2
          _left, _mid, right = line.partition("* ")
          text = right
        else
          event = :X
          text = line
        end

        [event, text]
      end

      def skip_head_lines
        while next_event[0] == :SOMETHING
          # puts "skil_head_lines event=#{event}"
        end
        back_to_previous_line
      end

      def parse
        @root = self.class.make_root
        skip_head_lines
        while (ary = next_event)
          event, text = ary
          # puts "event=#{event}|text=#{text}"
          # next_state = @state.peek_next_state(event)
          next_action = @state.next_action(event)
          # puts "next_state=#{next_state}|next_action=#{next_action}"
          case next_action
          when :AC_MAKE_FIRST_LEVEL
            self.class.make_first_level(@root, text)
          when :AC_MAKE_SECOND_LEVEL
            self.class.make_second_level(@root, text)
          when :AC_MAKE_THIRD_LEVEL
            self.class.make_third_level(@root, text)
          when :AC_ADD_ZERO_LEVEL_MEMO
            self.class.add_zero_level_memo(@root, text)
          when :AC_ADD_FIRST_LEVEL_MEMO
            self.class.add_first_level_memo(@root, text)
          when :AC_ADD_SECOND_LEVEL_MEMO
            self.class.add_second_level_memo(@root, text)
          when :AC_ADD_THIRD_LEVEL_MEMO
            self.class.add_third_level_memo(@root, text)
          when :AC_ERROR
            self.class.error(text)
          when :AC_NO_ACTION
            self.class.no_cation
          else
            raise
          end
          next if event == :X

          next_state = @state.peek_next_state(event)
          @state.set_next_state(next_state)
        end
        # pp @root
      end

      def hire2md
        @output_lines = []
        @root.children.each do |fl|
          @output_lines << "# #{fl.text}"
          fl.memo.each do |t|
            @output_lines << " #{t}"
          end
          fl.children.each do |sl|
            @output_lines << "## #{sl.text}"
            sl.memo.each do |t|
              @output_lines << "  #{t}"
            end
            sl.children.each do |tl|
              @output_lines << "### #{tl.text}"
              sl.memo.each do |t|
                @output_lines << "   #{t}"
              end
            end
          end
        end
        @output_lines.join("\n")
      end

      def output_file(str)
        File.write(@outfile, str)
      end
    end
  end
end
