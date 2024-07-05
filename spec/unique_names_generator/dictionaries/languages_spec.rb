# frozen_string_literal: true

require_relative '../../spec_helper'
require 'unique_names_generator/dictionaries/languages'

RSpec.describe UniqueNamesGenerator::Dictionaries::Languages do
  it 'responds to list_all' do
    expect(UniqueNamesGenerator::Dictionaries::Languages).to respond_to(:list_all)
  end

  it 'returns the correct list of colors' do
    expect(
      UniqueNamesGenerator::Dictionaries::Languages.list_all
    ).to eq(UniqueNamesGenerator::Dictionaries::Languages::TERMS)
  end
end
