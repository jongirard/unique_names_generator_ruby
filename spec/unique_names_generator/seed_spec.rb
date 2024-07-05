# frozen_string_literal: true

require_relative '../spec_helper'
require 'unique_names_generator/seed'

RSpec.describe UniqueNamesGenerator::Seed do
  describe '.generate_seed' do
    it 'can generate a reproducible seed from a given string' do
      expect(UniqueNamesGenerator::Seed.generate_seed('9004cd60-3c0f-491f-b2e8-cba7c6ad570c')).to eq(8943858325947076)
    end
  end
end
