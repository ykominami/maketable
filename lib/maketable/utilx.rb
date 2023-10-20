# frozen_string_literal: true
require 'pathname'

module Maketable
  # 拡張ユーティリティクラス
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

      def get_file_path( path , default_path )
        src_pn = nil
        if path
          pn = Pathname.new( path )
          if pn.exist?
            src_pn = pn
          end
        end
        if pn == nil
            yaml_file = test_file_x_pn( default_path )
            pn = Pathname.new( yaml_file )
            if pn.exist?
              src_pn = pn
            end  
        end
        src_pn
      end
  
      def test_file_base_pn
        if ENV["TEST_DATA_DIR"]
          Pathname.new(ENV["TEST_DATA_DIR"])
        else
          # Maketable::TEST_DATA_DIR
          TEST_DATA_DIR
        end
      end
      
      def test_file_pn
        @test_file_pn = test_file_base_pn + "test.yml"
      end
      
      def test_file_x_pn(fname)
        @test_file_pn = test_file_base_pn + fname
      end  
    end
  end
end
