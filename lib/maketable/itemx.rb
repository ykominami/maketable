# frozen_string_literal: true

module Maketable
  class Itemx
    attr_reader :parent

    def self.init
      @root = Itemx.new(:root)
      @cur_itemx = @root
      @cur_level = 0
      @max_level = @cur_level
      @itemx_by_level = {}
      @itemx_by_level[@cur_level] = @root
    end

    def self.get_root
      @root
    end

    def self.show
      pp @root
    end

    def self.show_tree
      @root.show_tree(0)
    end

    def self.reset_under_level(level)
      (level + 1).upto(@max_level) do |index|
        @itemx_by_level[index] = nil
      end
    end

    def self.add(level, name)
      puts "Itemx.add level=#{level} name=#{name}"
      if @cur_level < level
        # p "@cur_level=#{@cur_level} level=#{level}"
        raise InvalidLevelChangeError if @cur_level != (level - 1)

        @max_level = level
      elsif @cur_level > level
        reset_under_level(level)
      end
      current_itemx = @itemx_by_level[level]
      if current_itemx
        itemx = Itemx.new(name, current_itemx.parent)
        if current_itemx.parent
          current_itemx.parent.add_child(itemx)
        else
          raise NoParentItemxError
        end
      else
        parent_level = level - 1
        if parent_level >= 0
          parent = @itemx_by_level[parent_level]
          itemx = Itemx.new(name, parent)
          if parent
            parent.add_child(itemx)
          else
            puts %(parent_level=#{parent_level})
            pp @itemx_by_level
            raise NoParentItemxError
          end
        else
          raise InvalidParentLevelError
        end
      end
      @itemx_by_level[level] = itemx
      @cur_level = level
    end

    def initialize(name = nil, parent = nil)
      @name = name
      @children = []
      @parent = parent
    end

    def add_name(name)
      @name = name
    end

    def add_parent(parent)
      @parent = parent
    end

    def add_child(itemx)
      @children << itemx
    end

    def show_tree(level)
      indent = "  " * level
      puts %(#{indent}#{@name})
      @children.map { |x| x.show_tree(level + 1) }
    end
  end
end
