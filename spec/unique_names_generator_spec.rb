# frozen_string_literal: true

require 'spec_helper'
require 'unique_names_generator'

RSpec.describe UniqueNamesGenerator::Generator do
  describe '#generate' do
    it 'can generate a name with default config and packaged dictionary' do
      generator = described_class.new([:star_wars])

      expect(generator.generate).to be_a(String)
    end

    it 'can generate a name with a custom dictionary only' do
      words = ['lorem', 'ipsum']
      generator = described_class.new([words])
      result = generator.generate

      expect(words).to include(result)
    end

    it 'can generate a name with multiple packaged dictionaries' do
      generator = described_class.new([:colors, :adjectives])
      result = generator.generate

      combined_list = (
        UniqueNamesGenerator::Dictionaries::Colors.list_all +
        UniqueNamesGenerator::Dictionaries::Adjectives.list_all
      )

      result.split('_').each do |word|
        expect(combined_list).to include(word)
      end
    end

    it 'can generate a name with numbers' do
      generator = described_class.new([:colors, :numbers])
      result = generator.generate

      combined_list = (
        UniqueNamesGenerator::Dictionaries::Colors.list_all +
        UniqueNamesGenerator::Dictionaries::Numbers.list_all
      )

      result.split('_').each do |word|
        expect(combined_list).to include(word)
      end
    end

    it 'can generate different random results' do
      generator = described_class.new([:colors, :names])
      result1 = generator.generate
      result2 = generator.generate

      expect(result1).not_to eq(result2)
    end

    it 'can deterministically generate a word using multiple packaged dictionaries' do
      generator = described_class.new([:adjectives, :animals, :numbers])
      result = generator.generate(seed: 'a5372f76-a4ad-483c-8e48-794caf1b26a0')

      expect(result).to eq('interesting_jaguar_446')
    end

    it 'can deterministically generate a word using multiple packaged and custom dictionaries' do
      drinks = ['Tea', 'Juice', 'Coffee']
      generator = described_class.new([:adjectives, drinks, :numbers])
      result = generator.generate(seed: 'a5372f76-a4ad-483c-8e48-794caf1b26a0')

      expect(result).to eq('interesting_juice_446')
    end

    it 'raises an ArgumentError when a string dictionary reference is used' do
      expect { described_class.new(['colors', :adjectives]) }.to raise_error(
        ArgumentError, 'Dictionary contains invalid dictionary type'
      )
    end

    it 'raises an ArgumentError when a non-dictionary atom is used' do
      typo = :numgberrs
      expect { described_class.new([:adjectives, typo]) }.to raise_error(
        ArgumentError, "Invalid dictionary #{typo}"
      )
    end

    it 'preserves original capitalization for words with non-letter characters' do
      mock_star_wars = ['R4-P17', 'Qui-Gon Jinn']
      mock_adjectives = ['leading', 'icy']
      generator = described_class.new([mock_adjectives, mock_star_wars], style: :capital, separator: '-')

      expect(generator.generate(seed: 'abc')).to eq('Icy-Qui-Gon-Jinn')
      expect(generator.generate(seed: 'def')).to eq('Leading-R4-P17')
    end
  end

  describe 'seed-based generation' do
    let(:kwargs) {{ creativity: 0 }}
    let(:dictionaries) {[:colors, :star_wars]}
    let(:generator) { described_class.new(dictionaries, **kwargs) }

    context 'when creativity is 0 with colors/star_wars dictionaries' do
      {
        'hello' => 'azure_biggs_darklighter',
        'b81e8f38-a7bf-44dc-bbc7-5c4eaacb0b04' => 'moccasin_owen_lars',
        '79d06dff-6cc8-4cd0-a2ad-f2df3351c33c' => 'aquamarine_bib_fortuna'
      }.each do |input, expected_output|
        it "generates a predicted word based on a PRNG string seed of #{input}" do
          expect(generator.generate(seed: input)).to eq(expected_output)
        end
      end
    end

    context 'when creativity is 0 with colors/animals dictionaries' do
      let(:dictionaries) {[:colors, :animals]}

      {
        3 => 'blush_cow',
        50 => 'magenta_mongoose',
        5049483 => 'moccasin_ocelot'
      }.each do |input, expected_output|
        it "generates a predicted word based on a PRNG integer seed of #{input}" do
          expect(generator.generate(seed: input)).to eq(expected_output)
        end
      end
    end

    context 'when creativity is 8 with colors/star_wars dictionaries' do
      let(:kwargs) {{ creativity: 8 }}

      {
        'hello' => 'white_ki-adi-mundi',
        'b81e8f38-a7bf-44dc-bbc7-5c4eaacb0b04' => 'violet_jango_fett',
        '79d06dff-6cc8-4cd0-a2ad-f2df3351c33c' => 'teal_darth_maul'
      }.each do |input, expected_output|
        it "generates a predicted word based on a PRNG string seed of #{input}" do
          expect(generator.generate(seed: input)).to eq(expected_output)
        end
      end
    end
  end

  describe 'custom configurations' do
    it 'can generate a word using a custom separator string' do
      generator = described_class.new([:colors, :animals], separator: ' ')
      expect(generator.generate(seed: 'pigeon')).to eq('rose sawfish')
    end

    it 'can generate a word without spaces by setting separator to nil' do
      generator = described_class.new([:colors, :animals], separator: nil)
      expect(generator.generate(seed: 'pigeon')).to eq('rosesawfish')
    end

    it 'can generate a word using a custom separator string and capitalized word style' do
      generator = described_class.new([:colors, :animals], separator: ' ', style: :capital)
      expect(generator.generate(seed: 'pigeon')).to eq('Rose Sawfish')
    end

    it 'can generate a word using a custom separator string and uppercased word style' do
      generator = described_class.new([:colors, :animals], separator: '-', style: :uppercase)
      expect(generator.generate(seed: 'soccer')).to eq('LAVENDER-MARLIN')
    end
  end

  describe 'creativity' do
    it 'raises an ArgumentError when creativity is out of range' do
      expect { described_class.new([:colors], creativity: 11) }.to raise_error(
        ArgumentError, 'Outside creativity range. Must be between 0 and 10.'
      )

      expect { described_class.new([:colors], creativity: -1) }.to raise_error(
        ArgumentError, 'Outside creativity range. Must be between 0 and 10.'
      )
    end

    it 'generates different results with different creativity levels' do
      generator1 = described_class.new([:colors, :animals, :numbers], creativity: 0)
      generator2 = described_class.new([:colors, :animals, :numbers], creativity: 5)
      result1 = generator1.generate(seed: 'test')
      result2 = generator2.generate(seed: 'test')

      expect(result1).not_to eq(result2)
    end
  end
end
