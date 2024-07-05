# frozen_string_literal: true

require_relative '../../spec_helper'
require 'unique_names_generator/dictionaries/adjectives'

RSpec.describe UniqueNamesGenerator::Dictionaries::Adjectives do
  it 'responds to list_all' do
    expect(UniqueNamesGenerator::Dictionaries::Adjectives).to respond_to(:list_all)
  end

  it 'returns the correct list of colors' do
    expect(
      UniqueNamesGenerator::Dictionaries::Adjectives.list_all
    ).to eq(UniqueNamesGenerator::Dictionaries::Adjectives::TERMS)
  end
end
