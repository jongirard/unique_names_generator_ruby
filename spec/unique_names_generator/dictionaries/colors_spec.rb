# frozen_string_literal: true

require_relative '../../spec_helper'
require 'unique_names_generator/dictionaries/colors'

RSpec.describe UniqueNamesGenerator::Dictionaries::Colors do
  it 'responds to list_all' do
    expect(UniqueNamesGenerator::Dictionaries::Colors).to respond_to(:list_all)
  end

  it 'returns the correct list of colors' do
    expect(
      UniqueNamesGenerator::Dictionaries::Colors.list_all
    ).to eq(UniqueNamesGenerator::Dictionaries::Colors::TERMS)
  end
end
