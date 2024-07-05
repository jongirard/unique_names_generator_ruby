# frozen_string_literal: true

module UniqueNamesGenerator
  # Generate a reproducible seed from a given string
  module Seed
    class << self
      def generate_seed(seed)
        return nil if seed.nil?

        transformed_string = transform_string(seed)
        seed_decimal = mulberry32(transformed_string)
        remove_decimal(seed_decimal)
      end

      private

      def transform_string(seed)
        return seed if seed.is_a?(Integer)

        seed += "\x00"
        ascii_values = seed.bytes

        joined_values = ascii_values.join
        joined_values.to_i
      end

      def remove_decimal(seed)
        (seed * 10**16).to_i
      end

      def mulberry32(seed)
        t = (seed + 0x6d2b79f5) & 0xffffffff

        t = ((t ^ (t >> 15)) * (t | 1)) & 0xffffffff
        t = (t ^ (t >> 7)) & 0xffffffff
        t = (t ^ (t + ((t ^ (t >> 7)) * (t | 61) & 0xffffffff))) & 0xffffffff

        ((t ^ (t >> 14)) & 0xffffffff) / 4294967296.0
      end
    end
  end
end
