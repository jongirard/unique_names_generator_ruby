# frozen_string_literal: true

require_relative '../../spec_helper'
require 'unique_names_generator/dictionaries/star_wars'

RSpec.describe UniqueNamesGenerator::Dictionaries::StarWars do
  it 'responds to list_all' do
    expect(UniqueNamesGenerator::Dictionaries::StarWars).to respond_to(:list_all)
  end

  it 'returns the correct list of colors' do
    expect(
      UniqueNamesGenerator::Dictionaries::StarWars.list_all
    ).to eq(UniqueNamesGenerator::Dictionaries::StarWars::TERMS)
  end
end
