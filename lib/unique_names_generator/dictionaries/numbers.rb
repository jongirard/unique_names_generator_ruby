# frozen_string_literal: true

module UniqueNamesGenerator
  module Dictionaries
    # Dictionary containing numbers
    module Numbers
      TERMS = (1..999).freeze

      def self.list_all
        TERMS.map(&:to_s)
      end
    end
  end
end
