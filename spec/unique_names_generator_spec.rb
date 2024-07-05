# frozen_string_literal: true

require 'spec_helper'
require 'unique_names_generator'

RSpec.describe UniqueNamesGenerator do
  describe '.generate' do
    it 'can generate a name with default config and packaged dictionary' do
      expect(UniqueNamesGenerator.generate([:star_wars])).to be_a(String)
    end

    it 'can generate a name with a custom dictionary only' do
      words = ['lorem', 'ipsum']
      result = UniqueNamesGenerator.generate([words])

      expect(words).to include(result)
    end

    it 'can generate a name with multiple packaged dictionaries' do
      result = UniqueNamesGenerator.generate([:colors, :adjectives])

      combined_list = (
        UniqueNamesGenerator::Dictionaries::Colors.list_all +
        UniqueNamesGenerator::Dictionaries::Adjectives.list_all
      )

      result.split('_').each do |word|
        expect(combined_list).to include(word)
      end
    end

    it 'can generate a name with numbers' do
      result = UniqueNamesGenerator.generate([:colors, :numbers])

      combined_list = (
        UniqueNamesGenerator::Dictionaries::Colors.list_all +
        UniqueNamesGenerator::Dictionaries::Numbers.list_all
      )

      result.split('_').each do |word|
        expect(combined_list).to include(word)
      end
    end

    it 'can generate different random results' do
      result1 = UniqueNamesGenerator.generate([:colors, :names])
      result2 = UniqueNamesGenerator.generate([:colors, :names])

      expect(result1).not_to eq(result2)
    end

    it 'can deterministically generate a word using multiple packaged dictionaries' do
      result = UniqueNamesGenerator.generate(
        [:adjectives, :animals, :numbers], seed: 'a5372f76-a4ad-483c-8e48-794caf1b26a0'
      )

      expect(result).to eq('interesting_jaguar_446')
    end

    it 'can deterministically generate a word using multiple packaged and custom dictionaries' do
      drinks = ['Tea', 'Juice', 'Coffee']
      result = UniqueNamesGenerator.generate(
        [:adjectives, drinks, :numbers], seed: 'a5372f76-a4ad-483c-8e48-794caf1b26a0'
      )

      expect(result).to eq('interesting_juice_446')
    end

    it 'raises an ArgumentError when a string dictionary reference is used' do
      expect { UniqueNamesGenerator.generate(['colors', :adjectives]) }.to raise_error(
        ArgumentError, 'Dictionary contains invalid dictionary type'
      )
    end

    it 'raises an ArgumentError when a non-dictionary atom is used' do
      typo = :numgberrs
      expect { UniqueNamesGenerator.generate([:adjectives, typo]) }.to raise_error(
        ArgumentError, "Invalid dictionary: #{typo}"
      )
    end

    it 'calls generate_name_original when creativity is explicity 0' do
      expect(UniqueNamesGenerator).to receive(:generate_name_original)

      UniqueNamesGenerator.generate([:colors, :star_wars], creativity: 0)
    end

    it 'calls generate_name_original when creativity is default 0' do
      expect(UniqueNamesGenerator).to receive(:generate_name_original)

      UniqueNamesGenerator.generate([:colors, :star_wars])
    end

    it 'does not call generate_name_original when creativity is greater than 0' do
      expect(UniqueNamesGenerator).not_to receive(:generate_name_original)
      expect(UniqueNamesGenerator).to receive(:generate_name_creatively)

      UniqueNamesGenerator.generate([:colors, :star_wars], creativity: 8)
    end

    it 'preserves original capitalization for words with non-letter characters' do
      mock_star_wars = ['R4-P17', 'Qui-Gon Jinn']
      mock_adjectives = ['leading', 'icy']

      expect(
        UniqueNamesGenerator.generate([mock_adjectives, mock_star_wars], style: :capital, separator: '-', seed: 'abc')
      ).to eq('Icy-Qui-Gon-Jinn')

      expect(
        UniqueNamesGenerator.generate([mock_adjectives, mock_star_wars], style: :capital, separator: '-', seed: 'def')
      ).to eq('Leading-R4-P17')
    end
  end

  describe 'seed-based generation' do
    {
      'hello' => 'azure_biggs_darklighter',
      'b81e8f38-a7bf-44dc-bbc7-5c4eaacb0b04' => 'moccasin_owen_lars',
      '79d06dff-6cc8-4cd0-a2ad-f2df3351c33c' => 'aquamarine_bib_fortuna'
    }.each do |input, expected_output|
      it "generates a predicted word based on a PRNG string seed of #{input}" do
        expect(UniqueNamesGenerator.generate([:colors, :star_wars], seed: input)).to eq(expected_output)
      end
    end

    {
      'hello' => 'white_ki-adi-mundi',
      'b81e8f38-a7bf-44dc-bbc7-5c4eaacb0b04' => 'violet_jango_fett',
      '79d06dff-6cc8-4cd0-a2ad-f2df3351c33c' => 'teal_darth_maul'
    }.each do |input, expected_output|
      it "generates a predicted word based on a PRNG string seed of #{input} and creativity value of 8" do
        expect(UniqueNamesGenerator.generate([:colors, :star_wars], seed: input, creativity: 8)).to eq(expected_output)
      end
    end

    {
      3 => 'blush_cow',
      50 => 'magenta_mongoose',
      5049483 => 'moccasin_ocelot'
    }.each do |input, expected_output|
      it "generates a predicted word based on a PRNG integer seed of #{input}" do
        expect(UniqueNamesGenerator.generate([:colors, :animals], seed: input)).to eq(expected_output)
      end
    end
  end

  describe 'custom configurations' do
    it 'can generate a word using a custom separator string' do
      expect(UniqueNamesGenerator.generate([:colors, :animals], seed: 'pigeon', separator: ' ')).to eq('rose sawfish')
    end

    it 'can generate a word without spaces by setting separator to nil' do
      expect(UniqueNamesGenerator.generate([:colors, :animals], seed: 'pigeon', separator: nil)).to eq('rosesawfish')
    end

    it 'can generate a word using a custom separator string and capitalized word style' do
      expect(
        UniqueNamesGenerator.generate([:colors, :animals], seed: 'pigeon', separator: ' ', style: :capital)
      ).to eq('Rose Sawfish')
    end

    it 'can generate a word using a custom separator string and uppercased word style' do
      expect(
        UniqueNamesGenerator.generate([:colors, :animals], seed: 'soccer', separator: '-', style: :uppercase)
      ).to eq('LAVENDER-MARLIN')
    end
  end

  describe 'creativity' do
    it 'raises an ArgumentError when creativity is out of range' do
      expect { UniqueNamesGenerator.generate([:colors], creativity: 11) }.to raise_error(
        ArgumentError, 'Outside creativity range. Must be between 0 and 10.'
      )

      expect { UniqueNamesGenerator.generate([:colors], creativity: -1) }.to raise_error(
        ArgumentError, 'Outside creativity range. Must be between 0 and 10.'
      )
    end

    it 'generates different results with different creativity levels' do
      result1 = UniqueNamesGenerator.generate([:colors, :animals, :numbers], seed: 'test', creativity: 0)
      result2 = UniqueNamesGenerator.generate([:colors, :animals, :numbers], seed: 'test', creativity: 5)
      expect(result1).not_to eq(result2)
    end
  end
end
