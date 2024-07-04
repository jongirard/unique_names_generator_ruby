# .pryrc
def reload!
  load './lib/unique_names_generator.rb'
  puts 'Reloaded unique_names_generator.rb'
end

puts 'Custom commands loaded:'
puts 'reload! - Reloads the unique_names_generator.rb file'
