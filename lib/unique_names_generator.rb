# frozen_string_literal: true

# An implementation of a unique_names_generator in Ruby
# with support for PRNG/seeds

require_relative './unique_names_generator/seed'

require_relative './unique_names_generator/dictionaries/adjectives'
require_relative './unique_names_generator/dictionaries/animals'
require_relative './unique_names_generator/dictionaries/colors'
require_relative './unique_names_generator/dictionaries/languages'
require_relative './unique_names_generator/dictionaries/names'
require_relative './unique_names_generator/dictionaries/numbers'
require_relative './unique_names_generator/dictionaries/star_wars'

# UniqueNamesGenerator implementation
module UniqueNamesGenerator
  module_function

  def generate(dictionaries, separator: '_', style: :lowercase, seed: nil, creativity: 0)
    @separator = separator
    @style = style
    @seed = seed
    @creativity = creativity

    if creativity.negative? || creativity > 10
      raise ArgumentError, 'Outside creativity range. Must be between 0 and 10.'
    end

    generate_name(dictionaries)
  end

  def match_word_list(dictionary)
    module_name = camelize_dictionary(dictionary)
    begin
      dictionary = Dictionaries.const_get(module_name)
      dictionary.list_all
    rescue NameError
      raise_invalid_dictionary(dictionary)
    end
  end

  def word_list(dictionary)
    case dictionary
    when Array
      dictionary if dictionary.all? { |item| item.is_a?(String) }
    when Symbol
      match_word_list(dictionary)
    else
      raise ArgumentError, 'Dictionary contains invalid dictionary type'
    end
  end

  def random_seeded_float
    seed_value = Seed.generate_seed(@seed)

    prng = @seed.nil? ? Random.new : Random.new(seed_value)
    prng.rand
  end

  def map_dictionaries(dictionaries)
    dictionaries.map { |dictionary| word_list(dictionary) }
  end

  def split_with_separator(word)
    if @separator.nil?
      word.split(/(?=[A-Z])/)
    else
      word.split(@separator)
    end
  end

  def format_parts(parts)
    parts.map do |part|
      if part.match?(/[^a-zA-Z]/) && @style == :capital
        # Preserve original capitalization for parts with non-letter characters
        part
      else
        format_word(part, @style)
      end
    end.join(@separator)
  end

  def format_multi_word(word, original_word)
    if original_word.include?(' ') || original_word.include?('-')
      parts = split_with_separator(word)
      format_parts(parts)
    else
      format_word(word, @style)
    end
  end

  def generate_name(dictionaries)
    if @creativity.nil? || @creativity.zero?
      generate_name_original(dictionaries)
    else
      generate_name_creatively(dictionaries)
    end
  end

  def generate_name_original(dictionaries)
    map_dictionaries(dictionaries).reduce(nil) do |acc, x|
      rnd = (random_seeded_float * x.length).floor
      original_word = x[rnd]

      output_word(acc, original_word)
    end
  end

  def generate_name_creatively(dictionaries)
    word_lists = map_dictionaries(dictionaries)

    word_lists.each_with_index.reduce(nil) do |acc, (word_list, index)|
      creativity = calculate_creativity(index)
      rnd = (random_seeded_float * word_list.length * creativity).floor
      original_word = word_list[rnd % word_list.length] # Ensure we don't go out of bounds

      output_word(acc, original_word)
    end
  end

  def output_word(acc, original_word)
    word = format_with_separator(original_word)
    word = format_multi_word(word, original_word)

    if acc
      "#{acc}#{@separator}#{word}"
    else
      word
    end
  end

  def calculate_creativity(index)
    if index.zero?
      @creativity # Base creativity for the first dictionary
    else
      @creativity * (2 + index * 0.5) # Increase creativity for subsequent dictionaries
    end
  end

  def camelize_dictionary(dictionary)
    dictionary.to_s.split('_').map(&:capitalize).join
  end

  def raise_invalid_dictionary(dictionary)
    raise ArgumentError, "Invalid dictionary: #{dictionary}"
  end

  def format_with_separator(word)
    if @separator.nil?
      # If separator is empty, just remove spaces without changing case
      word.gsub(/\s+/, '')
    else
      # If there's a separator, use it to replace spaces
      word.gsub(/\s+/, @separator)
    end
  end

  def format_word(word, style)
    case style
    when :lowercase
      word.downcase
    when :uppercase
      word.upcase
    when :capital
      word.capitalize
    else
      word
    end
  end

  private_class_method(
    *%i[
      generate_name
      match_word_list
      word_list
      random_seeded_float
      map_dictionaries
      camelize_dictionary
      raise_invalid_dictionary
      format_with_separator
      format_multi_word
      format_parts
      format_word
      split_with_separator
      generate_name_original
      generate_name_creatively
      calculate_creativity
      output_word
    ]
  )
end
