# frozen_string_literal: true

require_relative '../../spec_helper'
require 'unique_names_generator/dictionaries/animals'

RSpec.describe UniqueNamesGenerator::Dictionaries::Animals do
  it 'responds to list_all' do
    expect(UniqueNamesGenerator::Dictionaries::Animals).to respond_to(:list_all)
  end

  it 'returns the correct list of colors' do
    expect(
      UniqueNamesGenerator::Dictionaries::Animals.list_all
    ).to eq(UniqueNamesGenerator::Dictionaries::Animals::TERMS)
  end
end
