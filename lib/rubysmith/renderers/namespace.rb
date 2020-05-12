# frozen_string_literal: true

require "refinements/strings"

module Rubysmith
  module Renderers
    # Renders single or multiple modules with correct, two-space indentation for templates.
    class Namespace
      using Refinements::Strings

      def initialize namespace
        @namespace = namespace
        @modules = namespace.split "::"
        @depth = namespace.scan("::").length
      end

      def call content
        "#{prefix}#{body content}#{suffix.chomp}"
      end

      private

      attr_reader :namespace, :modules, :depth

      def prefix
        modules.each.with_index.reduce "" do |snippet, (module_name, index)|
          %(#{snippet}#{"module".indent index} #{module_name}\n)
        end
      end

      # :reek:FeatureEnvy
      def body content
        content.lstrip.split("\n").reduce "" do |snippet, line|
          next "#{snippet}\n" if line.blank?

          "#{snippet}#{line.gsub(/^\s{2}/, "").indent depth + 1}\n"
        end
      end

      def suffix
        modules.each.with_index.reduce "" do |snippet, (_, index)|
          %(#{snippet}#{"end".indent depth - index}\n)
        end
      end
    end
  end
end
