module Maketable
  class Utilx
    class << self
      def make_table_format(data:, format: :trac_wiki)
        lines = []
        #p "make_table_format | data=#{data}"
        case format
        when :trac_wiki
          #p data.size
          #p data
          line = %(|| #{data.join(" || ")} ||)
          lines << line
        when :markdown
          lines << %(| #{data.join(" | ")} |)
        else
          raise InvalidFormatError
        end
        lines
      end
    end
  end
end