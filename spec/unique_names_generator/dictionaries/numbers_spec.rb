# frozen_string_literal: true

require_relative '../../spec_helper'
require 'unique_names_generator/dictionaries/numbers'

RSpec.describe UniqueNamesGenerator::Dictionaries::Numbers do
  it 'responds to list_all' do
    expect(UniqueNamesGenerator::Dictionaries::Numbers).to respond_to(:list_all)
  end

  it 'returns the correct list of numbers as strings' do
    expect(
      UniqueNamesGenerator::Dictionaries::Numbers.list_all
    ).to eq(UniqueNamesGenerator::Dictionaries::Numbers::TERMS.map(&:to_s))
  end
end
