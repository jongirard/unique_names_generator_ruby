# frozen_string_literal: true

module UniqueNamesGenerator
  # Generate a seed from a string
  module Seed
    class << self
      def generate_seed(seed)
        return nil if seed.nil?

        transformed_string = transform_string(seed)
        seed_decimal = mulberry32(transformed_string)
        remove_decimal(seed_decimal)
      end

      def transform_string(seed)
        return seed if seed.integer?

        seed += "\x00"
        ascii_values = seed.bytes

        joined_values = ascii_values.join
        joined_values.to_i
      end

      def remove_decimal(seed)
        (seed * 10**16).to_i
      end

      def mulberry32(seed)
        t = seed + 0x6d2b79f5

        t = imul(bxor(t, bsr(t, 15)), t | 1)
        t = bxor(t, bsr(t, 7))
        t = bxor(t, t + imul(bxor(t, bsr(t, 7)), t | 61))

        bxor(t, bsr(t, 14)) / 4294967296.0
      end

      private

      def imul(a, b)
        (a * b) & 0xFFFFFFFF
      end

      def bxor(a, b)
        a ^ b
      end

      def bsr(a, b)
        a >> b
      end
    end
  end
end
