# frozen_string_literal: true

module Rubysmith
  module Text
    # Inserts content before or after a line for a given pattern in an array of lines.
    class Inserter
      def initialize lines, kind = :after
        @lines = lines.dup
        @kind = kind
      end

      def call content, pattern
        lines.index { |line| line.match? pattern }
             .then { |index| lines.insert index + offset, content if index }
        lines
      end

      private

      attr_reader :lines, :kind

      def offset
        case kind
          when :before then 0
          when :after then 1
          else fail StandardError, "Unknown kind of insert: #{kind}."
        end
      end
    end
  end
end
