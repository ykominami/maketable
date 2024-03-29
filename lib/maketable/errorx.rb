# frozen_string_literal: true

module Maketable
  # エラー処理クラス
  class Errorx
    @error_occrence_count = 0

    class << self
      def error_occur
        @error_occrence_count += 1
      end

      def check_error_and_exit
        exit(::Maketable::EXIT_COD_OF_ERROR_OCURRENT) if @error_occrence_count.positive?
        # exit(::Maketable::EXIT_COD_OF_ERROR_OCURRENT) 
      end
    end
  end
end
