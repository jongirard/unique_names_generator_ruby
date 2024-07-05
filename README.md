# UniqueNamesGenerator

Unique Names Generator is a Ruby package for generating random and unique names. Generation utilizes PRNG (pseudo random number generation) for either fully random or seeded name generation. It comes with a list of various dictionaries out of the box, but you can also provide custom ones. Inspired by the great "Unique Names Generator" available on [NPM](https://www.npmjs.com/package/unique-names-generator) by Andrea Sonny. Ported from the [Elixir version](https://github.com/jongirard/unique_names_generator) built by myself.

## Installation

The package can be installed from [RubyGems](https://rubygems.org/gems/unique_names_generator)
by adding `unique_names_generator` to your list of gemfile dependencies:

Add this line to your application's Gemfile:

```
gem 'unique_names_generator', "~> 0.1.0"
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

In a nutshell, you can begin generating randon names with UniqueNamesGenerator by simply specifying an array of one or more dictionaries via `UniqueNamesGenerator.generate`. Available dictionary types are `[:adjectives, :animals, :colors, :languages, :names, :numbers, :star_wars]`.

```ruby
UniqueNamesGenerator.generate([:adjectives, :animals])
# => Generates ex: "dramatic_limpet"

UniqueNamesGenerator.generate([:adjectives, :colors, :animals])
# => Generates ex: "tremendous_brown_cat"

UniqueNamesGenerator.generate([:adjectives, :names, :numbers])
# => Generates ex: "doubtful_wanda_979"
```

To use custom dictionaries, simply include your array of strings as part of the dictionaries array:

```ruby
drinks = ['Sprite', 'Coca-Cola', 'Juice', 'Tea']
UniqueNamesGenerator.generate([:colors, drinks])
# => Generates ex: "cyan_sprite"
```

### Config options

UniqueNamesGenerator can be used with either the default provided config (`separator: '_', style: :lowercase, creativity: 0`) or by specifying any of your own configuration options for seeding, seperator, style and creativity.

#### More details on possible options

- **Separator options**: Any ASCII character string such as underscore, dash or blank space. `nil` for no space.
  - ex: '_', '-', ' ' or `nil` for no space.
- **Style options**: Atom, one of `:lowercase`, `:uppercase`, `:capital`.
- **Creativity options**: An integer or float between 1 and 10.

```ruby
UniqueNamesGenerator.generate([:colors, :animals], style: :capital, separator: ' ')
# => Generates ex: "Lavender Marlin"

UniqueNamesGenerator.generate([:colors, :adjectives, :animals], creativity: 8, style: :capital, separator: ' ')
# => Generates ex: "Yellow Local Hippopotamus"
```

#### What is creativity?
Using the creativity option changes how UniqueNamesGenerator selects terms from the dictionaries in use, essentially acting as a multiplier. For dictionaries with a similar length of terms, while using a seed the selection may at times appear to be alphabetical or closely related (ex: "Amber Anakin Skywalker"). Utilizing the `creative` option with a value between 1 and 10 will use a sequential multiplier for subsequenet dictionaries yielding a seemingly more "random" or "creative" result whilst still allowing for seeded generation.

```ruby
UniqueNamesGenerator.generate([:colors, :adjectives, :animals], creativity: 8, seed: 'f6da7a28-5ae6-4d6b-b3b8-a197b99ed4eb')

# => Seed "f6da7a28-5ae6-4d6b-b3b8-a197b99ed4eb" with creativity of 8 always generates: "plum_flying_cobra"
```

### Seeded Generation

A seed can be used to deterministically generate a name. As long as the provided seed is the same, then the generated name will also always be the same. Simply provide a string or integer as the value of the seed key, ie; `seed: 'hello'`. 

_(**Usecase example:** generate a username for an authenticated user based on UUID. Ex: `13a5d03e-61d0-4b5b-ae3b-57953c268c5f` will always generate the name "beige_boba_fett_145" when used together with the colors/star_wars/numbers dictionaries)._

```ruby
UniqueNamesGenerator.generate([:colors, :star_wars, :numbers], seed: '13a5d03e-61d0-4b5b-ae3b-57953c268c5f')
# => Seed "13a5d03e-61d0-4b5b-ae3b-57953c268c5f" always generates: "beige_boba_fett_145"
```

## License
This project is licensed under the MIT License - see the [LICENSE file](https://github.com/jongirard/unique_names_generator_ruby/blob/development/LICENSE) for details.