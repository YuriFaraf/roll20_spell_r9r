require 'nokogiri'
require 'open-uri'
require_relative 'spell'

module Reader
  def find_spell(name)
    doc = Nokogiri::HTML(URI.open("https://dnd.su/spells/?search=#{name}"))
    # Нужна проверка на существование
    body = doc.css('.paper-1').first # Что, если нужное заклинание не первое в списке?
    # По обоим комментам сверху - можно рассмотреть проверку по spell name

    spell = Spell.new

    spell.name = body.css('.item-link').to_s.gsub(/<[^>]*>/, '').gsub(/ \[.*/, '')

    spell.level, spell.school = body.css('.size-type-alignment').to_s.gsub(/<[^>]*>/, '').strip.split(', ')

    list = body.css('li') - body.css('.desc')

    list.css('li').to_a.each do |i|
      i = i.to_s
      strong = i.scan(/<strong>.*<\/strong>/).first&.gsub(/<[^>]*>/, '')
      case strong
        when 'Время накладывания:' then spell.casting_time = i.gsub(/<strong>.*<\/strong>/, '').gsub(/<[^>]*>/, '').strip
        when 'Дистанция:' then spell.range = i.gsub(/<strong>.*<\/strong>/, '').gsub(/<[^>]*>/, '').strip
        when 'Компоненты:' then spell.components = i.gsub(/<strong>.*<\/strong>/, '').gsub(/<[^>]*>/, '').strip
        when 'Длительность:' then spell.duration = i.gsub(/<strong>.*<\/strong>/, '').gsub(/<[^>]*>/, '').strip
        when 'Классы:' then spell.classes = i.gsub(/<strong>.*<\/strong>/, '').gsub(/<[^>]*>/, '').strip
        when 'Архетипы:' then spell.classes = spell.classes + ', ' + i.gsub(/<strong>.*<\/strong>/, '').gsub(/<[^>]*>/, '').strip
        when 'Источник:' then spell.sourse = i.scan(/\".*\"/).first
      end
    end

    spell.description = body.css('.desc').to_s.gsub(/<[^>]*>/, '').strip

    spell
  end
  module_function :find_spell
end