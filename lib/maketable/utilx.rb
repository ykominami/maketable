module Maketable
  class Utilx
    class << self
      def make_table_format(data:, format: :trac_wiki)
        lines = []
        case format
        when :trac_wiki
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