# frozen_string_literal: true

require_relative '../../spec_helper'
require 'unique_names_generator/dictionaries/names'

RSpec.describe UniqueNamesGenerator::Dictionaries::Names do
  it 'responds to list_all' do
    expect(UniqueNamesGenerator::Dictionaries::Names).to respond_to(:list_all)
  end

  it 'returns the correct list of colors' do
    expect(
      UniqueNamesGenerator::Dictionaries::Names.list_all
    ).to eq(UniqueNamesGenerator::Dictionaries::Names::TERMS)
  end
end
