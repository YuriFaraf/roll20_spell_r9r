require_relative 'lib/reader.rb'
require_relative 'lib/spell.rb'

# URI кириллицу не сожрёт, только ASCII
spell_name = 'minor'

spell = Reader.find_spell(spell_name)

list = %i(name level school casting_time range components duration classes sourse description)

list.each do |e|
  puts "#{e.to_s}: #{spell.send(e)}"
end

