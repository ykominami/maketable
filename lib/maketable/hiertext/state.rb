# frozen_string_literal: true

require "pathname"

module Maketable
  module HireText
    class State
      attr_reader :cur_state

      def state_hash
        {
          START: {
            BLACK_SQUARE: :FIRST_LEVEL,
            HYPHEN1: :ERROR,
            HYPHEN2: :ERROR,
            SPACE0: :ZERO_LEVEL_MEMO,
            SPACE1: :ZERO_LEVEL_MEMO,
            SPACE2: :ERROR,
            SPACE3: :ERROR,
            SPACE4: :ERROR,
            SPACE5: :ERROR,
            SPACE6: :ERROR,
            BLANK_LINE: :START,
            STAR1: :ERROR,
            STAR2: :ERROR
          },
          FIRST_LEVEL: {
            BLACK_SQUARE: :FIRST_LEVEL,
            HYPHEN1: :SECOND_LEVEL,
            HYPHEN2: :ERROR,
            SPACE0: :FIRST_LEVEL_MEMO,
            SPACE1: :FIRST_LEVEL_MEMO,
            SPACE2: :FIRST_LEVEL_MEMO,
            SPACE3: :FIRST_LEVEL_MEMO,
            SPACE4: :FIRST_LEVEL_MEMO,
            SPACE5: :FIRST_LEVEL_MEMO,
            SPACE6: :FIRST_LEVEL_MEMO,
            BLANK_LINE: :FIRST_LEVEL,
            STAR1: :FIRST_LEVEL_MEMO,
            STAR2: :FIRST_LEVEL_MEMO
          },
          SECOND_LEVEL: {
            BLACK_SQUARE: :FIRST_LEVEL,
            HYPHEN1: :SECOND_LEVEL,
            HYPHEN2: :THIRD_LEVEL,
            SPACE0: :SECOND_LEVEL_MEMO,
            SPACE1: :SECOND_LEVEL_MEMO,
            SPACE2: :SECOND_LEVEL_MEMO,
            SPACE3: :SECOND_LEVEL_MEMO,
            SPACE4: :SECOND_LEVEL_MEMO,
            SPACE5: :SECOND_LEVEL_MEMO,
            SPACE6: :SECOND_LEVEL_MEMO,
            BLANK_LINE: :SECOND_LEVEL,
            STAR1: :SECOND_LEVEL_MEMO,
            STAR2: :SECOND_LEVEL_MEMO
          },
          THIRD_LEVEL: {
            BLACK_SQUARE: :FIRST_LEVEL,
            HYPHEN1: :SECOND_LEVEL,
            HYPHEN2: :THIRD_LEVEL,
            SPACE0: :THIRD_LEVEL_MEMO,
            SPACE1: :THIRD_LEVEL_MEMO,
            SPACE2: :THIRD_LEVEL_MEMO,
            SPACE3: :THIRD_LEVEL_MEMO,
            SPACE4: :THIRD_LEVEL_MEMO,
            SPACE5: :THIRD_LEVEL_MEMO,
            SPACE6: :THIRD_LEVEL_MEMO,
            BLANK_LINE: :THIRD_LEVEL,
            STAR1: :THIRD_LEVEL_MEMO,
            STAR2: :THIRD_LEVEL_MEMO
          },
          FIRST_LEVEL_MEMO: {
            BLACK_SQUARE: :FIRST_LEVEL,
            HYPHEN1: :SECOND_LEVEL,
            HYPHEN2: :ERROR,
            SPACE0: :FIRST_LEVEL_MEMO,
            SPACE1: :FIRST_LEVEL_MEMO,
            SPACE2: :FIRST_LEVEL_MEMO,
            SPACE3: :FIRST_LEVEL_MEMO,
            SPACE4: :FIRST_LEVEL_MEMO,
            SPACE5: :FIRST_LEVEL_MEMO,
            SPACE6: :FIRST_LEVEL_MEMO,
            BLANK_LINE: :FIRST_LEVEL_MEMO,
            STAR1: :FIRST_LEVEL_MEMO,
            STAR2: :FIRST_LEVEL_MEMO
          },
          SECOND_LEVEL_MEMO: {
            BLACK_SQUARE: :FIRST_LEVEL,
            HYPHEN1: :SECOND_LEVEL,
            HYPHEN2: :THIRD_LEVEL,
            SPACE0: :SECOND_LEVEL_MEMO,
            SPACE1: :SECOND_LEVEL_MEMO,
            SPACE2: :SECOND_LEVEL_MEMO,
            SPACE3: :SECOND_LEVEL_MEMO,
            SPACE4: :SECOND_LEVEL_MEMO,
            SPACE5: :SECOND_LEVEL_MEMO,
            SPACE6: :SECOND_LEVEL_MEMO,
            BLANK_LINE: :SECOND_LEVEL_MEMO,
            STAR1: :SECOND_LEVEL_MEMO,
            STAR2: :SECOND_LEVEL_MEMO
          },
          THIRD_LEVEL_MEMO: {
            BLACK_SQUARE: :FIRST_LEVEL,
            HYPHEN1: :SECOND_LEVEL,
            HYPHEN2: :THIRD_LEVEL,
            SPACE0: :THIRD_LEVEL_MEMO,
            SPACE1: :THIRD_LEVEL_MEMO,
            SPACE2: :THIRD_LEVEL_MEMO,
            SPACE3: :THIRD_LEVEL_MEMO,
            SPACE4: :THIRD_LEVEL_MEMO,
            SPACE5: :THIRD_LEVEL_MEMO,
            SPACE6: :THIRD_LEVEL_MEMO,
            BLANK_LINE: :THIRD_LEVEL_MEMO,
            STAR1: :THIRD_LEVEL_MEMO,
            STAR2: :THIRD_LEVEL_MEMO
          }
        }
      end

      def action_hash
        {
          START: {
            BLACK_SQUARE: :AC_MAKE_FIRST_LEVEL,
            HYPHEN1: :AC_ERROR,
            HYPHEN2: :AC_ERROR,
            SPACE0: :AC_ZERO_LEVEL_MEMO,
            SPACE1: :AC_ZERO_LEVEL_MEMO,
            SPACE2: :AC_ERROR,
            SPACE3: :AC_ERROR,
            SPACE4: :AC_ERROR,
            SPACE5: :AC_ERROR,
            SPACE6: :AC_ERROR,
            BLANK_LINE: :AC_NO_ACTION,
            STAR1: :AC_ERROR,
            STAR2: :AC_ERROR
          },
          FIRST_LEVEL: {
            BLACK_SQUARE: :AC_MAKE_FIRST_LEVEL,
            HYPHEN1: :AC_MAKE_SECOND_LEVEL,
            HYPHEN2: :AC_ERROR,
            SPACE0: :AC_ADD_FIRST_LEVEL_MEMO,
            SPACE1: :AC_ADD_FIRST_LEVEL_MEMO,
            SPACE2: :AC_ADD_FIRST_LEVEL_MEMO,
            SPACE3: :AC_ADD_FIRST_LEVEL_MEMO,
            SPACE4: :AC_ADD_FIRST_LEVEL_MEMO,
            SPACE5: :AC_ADD_FIRST_LEVEL_MEMO,
            SPACE6: :AC_ADD_FIRST_LEVEL_MEMO,
            BLANK_LINE: :AC_NO_ACTION,
            STAR1: :AC_ADD_FIRST_LEVEL_MEMO,
            STAR2: :AC_ADD_FIRST_LEVEL_MEMO
          },
          SECOND_LEVEL: {
            BLACK_SQUARE: :AC_MAKE_FIRST_LEVEL,
            HYPHEN1: :AC_MAKE_SECOND_LEVEL,
            HYPHEN2: :AC_MAKE_THIRD_LEVEL,
            SPACE0: :AC_ADD_SECOND_LEVEL_MEMO,
            SPACE1: :AC_ADD_SECOND_LEVEL_MEMO,
            SPACE2: :AC_ADD_SECOND_LEVEL_MEMO,
            SPACE3: :AC_ADD_SECOND_LEVEL_MEMO,
            SPACE4: :AC_ADD_SECOND_LEVEL_MEMO,
            SPACE5: :AC_ADD_SECOND_LEVEL_MEMO,
            SPACE6: :AC_ADD_SECOND_LEVEL_MEMO,
            BLANK_LINE: :AC_MAKE_SECOND_LEVEL,
            STAR1: :AC_ADD_SECOND_LEVEL_MEMO,
            STAR2: :AC_ADD_SECOND_LEVEL_MEMO
          },
          THIRD_LEVEL: {
            BLACK_SQUARE: :AC_MAKE_FIRST_LEVEL,
            HYPHEN1: :AC_MAKE_SECOND_LEVEL,
            HYPHEN2: :AC_MAKE_THIRD_LEVEL,
            SPACE0: :AC_ADD_THIRD_LEVEL_MEMO,
            SPACE1: :AC_ADD_THIRD_LEVEL_MEMO,
            SPACE2: :AC_ADD_THIRD_LEVEL_MEMO,
            SPACE3: :AC_ADD_THIRD_LEVEL_MEMO,
            SPACE4: :AC_ADD_THIRD_LEVEL_MEMO,
            SPACE5: :AC_ADD_THIRD_LEVEL_MEMO,
            SPACE6: :AC_ADD_THIRD_LEVEL_MEMO,
            BLANK_LINE: :AC_MAKE_THIRD_LEVEL,
            STAR1: :AC_ADD_THIRD_LEVEL_MEMO,
            STAR2: :AC_ADD_THIRD_LEVEL_MEMO
          },
          FIRST_LEVEL_MEMO: {
            BLACK_SQUARE: :AC_MAKE_FIRST_LEVEL,
            HYPHEN1: :AC_MAKE_SECOND_LEVEL,
            HYPHEN2: :AC_ERROR,
            SPACE0: :AC_ADD_FIRST_LEVEL_MEMO,
            SPACE1: :AC_ADD_FIRST_LEVEL_MEMO,
            SPACE2: :AC_ADD_FIRST_LEVEL_MEMO,
            SPACE3: :AC_ADD_FIRST_LEVEL_MEMO,
            SPACE4: :AC_ADD_FIRST_LEVEL_MEMO,
            SPACE5: :AC_ADD_FIRST_LEVEL_MEMO,
            SPACE6: :AC_ADD_FIRST_LEVEL_MEMO,
            BLANK_LINE: :AC_NO_ACTION,
            STAR1: :AC_ADD_FIRST_LEVEL_MEMO,
            STAR2: :AC_ADD_FIRST_LEVEL_MEMO
          },
          SECOND_LEVEL_MEMO: {
            BLACK_SQUARE: :AC_MAKE_FIRST_LEVEL,
            HYPHEN1: :AC_MAKE_SECOND_LEVEL,
            HYPHEN2: :AC_MAKE_THIRD_LEVEL,
            SPACE0: :AC_ADD_SECOND_LEVEL_MEMO,
            SPACE1: :AC_ADD_SECOND_LEVEL_MEMO,
            SPACE2: :AC_ADD_SECOND_LEVEL_MEMO,
            SPACE3: :AC_ADD_SECOND_LEVEL_MEMO,
            SPACE4: :AC_ADD_SECOND_LEVEL_MEMO,
            SPACE5: :AC_ADD_SECOND_LEVEL_MEMO,
            SPACE6: :AC_ADD_SECOND_LEVEL_MEMO,
            BLANK_LINE: :AC_NO_ACTION,
            STAR1: :AC_ADD_SECOND_LEVEL_MEMO,
            STAR2: :AC_ADD_SECOND_LEVEL_MEMO
          },
          THIRD_LEVEL_MEMO: {
            BLACK_SQUARE: :AC_MAKE_FIRST_LEVEL,
            HYPHEN1: :AC_MAKE_SECOND_LEVEL,
            HYPHEN2: :AC_MAKE_THIRD_LEVEL,
            SPACE0: :AC_ADD_THIRD_LEVEL_MEMO,
            SPACE1: :AC_ADD_THIRD_LEVEL_MEMO,
            SPACE2: :AC_ADD_THIRD_LEVEL_MEMO,
            SPACE3: :AC_ADD_THIRD_LEVEL_MEMO,
            SPACE4: :AC_ADD_THIRD_LEVEL_MEMO,
            SPACE5: :AC_ADD_THIRD_LEVEL_MEMO,
            SPACE6: :AC_ADD_THIRD_LEVEL_MEMO,
            BLANK_LINE: :AC_NO_ACTION,
            STAR1: :AC_ADD_THIRD_LEVEL_MEMO,
            STAR2: :AC_ADD_THIRD_LEVEL_MEMO
          }
        }
      end

      def initialize
        @cur_state = :START
        @state_hash = state_hash
        @action_hash = action_hash
      end

      def add_next_state(next_state)
        @cur_state = next_state
      end

      def peek_next_state(event)
        begin
          c_state = @state_hash[@cur_state][event]
        rescue StandardError => e
          puts e.message
          puts e.backtrace
          puts "@cur_state=#{@cur_state}"
          exit(::Maketable::EXIT_COD_OF_ILLEGAL_STATE)
        end
        c_state
      end

      def next_action(event)
        begin
          c_action = @action_hash[@cur_state][event]
        rescue StandardError => e
          puts e.message
          puts e.backtrace
          puts "@cur_state=#{@cur_state}"
          exit(::Maketable::EXIT_COD_OF_ILLEGAL_ACTION)
        end
        @cur_action = c_action
      end
    end
  end
end
