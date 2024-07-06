![Ruby CI](https://github.com/jongirard/unique_names_generator_ruby/actions/workflows/ruby.yml/badge.svg)

# UniqueNamesGenerator

Unique Names Generator is a Ruby package for generating random and unique names. Generation utilizes PRNG (pseudo random number generation) for either fully random or seeded name generation. It comes with a list of various dictionaries out of the box, but you can also provide custom ones. Inspired by the great "Unique Names Generator" available on [NPM](https://www.npmjs.com/package/unique-names-generator) by Andrea Sonny. Ported from the [Elixir version](https://github.com/jongirard/unique_names_generator) built by myself.

## Installation

The package can be installed from [RubyGems](https://rubygems.org/gems/unique_names_generator)
by adding `unique_names_generator` to your list of gemfile dependencies:

Add this line to your application's Gemfile:

```
gem 'unique_names_generator', '~> 0.2.0'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install unique_names_generator
```

## Usage

In a nutshell, you can begin generating random names with UniqueNamesGenerator by simply creating a Generator instance and specifying an array of one or more dictionaries. Available dictionary types are `[:adjectives, :animals, :colors, :languages, :names, :numbers, :star_wars]`.

```ruby
generator = UniqueNamesGenerator::Generator.new([:adjectives, :animals])
generator.generate

# => Generates ex: "dramatic_limpet"

generator = UniqueNamesGenerator::Generator.new([:adjectives, :colors, :animals])
generator.generate

# => Generates ex: "tremendous_brown_cat"

generator = UniqueNamesGenerator::Generator.new([:adjectives, :names, :numbers])
generator.generate

# => Generates ex: "doubtful_wanda_979"
```

To use custom dictionaries, simply include your array of strings as part of the dictionaries array:

```ruby
drinks = ['Sprite', 'Coca-Cola', 'Juice', 'Tea']

generator = UniqueNamesGenerator::Generator.new([:colors, drinks])
generator.generate

# => Generates ex: "cyan_sprite"
```

### Config options

UniqueNamesGenerator can be used with either the default provided config (`separator: '_', style: :lowercase, creativity: 0`) or by specifying any of your own configuration options for seeding, seperator, style and creativity.

#### More details on possible options
- **Dictionaries**: [Array<Symbol, Array<String>>] List of dictionaries to use for name generation. Can be symbols referring to built-in dictionaries or custom arrays of strings.
- **Separator**: [String] Character(s) used to join words in the generated name. Default: '_'. `nil` can be used for no space.
  - ex: '_', '-', ' ' or `nil` for no space.
- **Style**: [Symbol] Capitalization style for generated names.
  - Options: `:lowercase`, `:uppercase`, `:capital`. Default: `:lowercase`
- **Creativity**: [Integer] Level of creativity in name generation, affecting word selection. Must be between 0 and 10. A Float value can also be used. Default: 0

```ruby
generator = UniqueNamesGenerator::Generator.new([:colors, :animals], style: :capital, separator: ' ')
generator.generate

# => Generates ex: "Lavender Marlin"

generator = UniqueNamesGenerator::Generator.new([:colors, :adjectives, :animals], creativity: 8, style: :capital, separator: ' ')
generator.generate

# => Generates ex: "Yellow Local Hippopotamus"
```

#### What is creativity?
Using the creativity option changes how `UniqueNamesGenerator` selects terms from the dictionaries in use, essentially acting as a multiplier. For dictionaries with a similar term length, while using a seed, the selection may at times appear to be alphabetical or closely related (ex: "Amber Anakin Skywalker"). Utilizing the `creative` option with a value between 1 and 10 will use a sequential multiplier for subsequent dictionaries providing a seemingly more "random" or "creative" result whilst still allowing for seeded generation.

```ruby
generator = UniqueNamesGenerator::Generator.new([:colors, :adjectives, :animals], creativity: 8)
generator.generate(seed: 'f6da7a28-5ae6-4d6b-b3b8-a197b99ed4eb')

# => Seed "f6da7a28-5ae6-4d6b-b3b8-a197b99ed4eb" with creativity of 8 always generates: "plum_flying_cobra"
```

### Seeded Generation

A seed can be used to deterministically generate a name. As long as the provided seed and creativity values are the same between runs, then the generated name will also always be the same. Simply provide a string or integer as an argument to the generate method, ie; `seed: 'hello'`. 

_(**Usecase example:** generate a username for an authenticated user based on UUID. Ex: `13a5d03e-61d0-4b5b-ae3b-57953c268c5f` will always generate the name "coral_greedo_320" when used together with the colors/star_wars/numbers dictionaries)._

```ruby
generator = UniqueNamesGenerator::Generator.new([:colors, :star_wars, :numbers])
generator.generate(seed: '13a5d03e-61d0-4b5b-ae3b-57953c268c5f')

# => Seed "13a5d03e-61d0-4b5b-ae3b-57953c268c5f" always generates: "coral_greedo_320"
```

## License
This project is licensed under the MIT License - see the [LICENSE file](https://github.com/jongirard/unique_names_generator_ruby/blob/development/LICENSE) for details.