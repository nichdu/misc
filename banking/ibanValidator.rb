#!/usr/bin/env ruby
#encoding:UTF-8

require 'getoptlong'


# specify the options we accept and initialize
# the option parser


opts = GetoptLong.new(
  [ "--iban",    "-i",            GetoptLong::REQUIRED_ARGUMENT ]
)

puts 'ACHTUNG: Eine gültige IBAN bedeutet nicht, dass das Konto existert'


# process the parsed options
iban = ''

opts.each do |opt, arg|
	case opt
		when '--iban'
			iban = arg
	end
end

iban.strip!

if iban == ''
	puts 'Usage: ibanValidator --iban IBAN'
	exit 1
end

if !/[0-9A-Za-z]{4,34}/.match(iban)
	puts 'Die IBAN muss 4 bis 34 Stellen haben und aus Buchstaben und Zahlen bestehen.'
	exit 3
end

# Prüfziffer validieren
testiban = iban[4,iban.length] << iban[0,4]
testiban.gsub!(/[ABCDEFGHIJKLMNOPQRSTUVWXYZ]/, 'A' => 10, 'B' => 11, 'C' => 12, 'D' => 13, 'E' => 14, 'F'=>15,'G'=>16,'H'=>17,'I'=>18,'J'=>19,'K'=>20,'L'=>21,'M'=>22,'N'=>23,'O'=>24,'P'=>25,'Q'=>26,'R'=>27,'S'=>28,'T'=>29,'U'=>30,'V'=>31,'W'=>32,'X'=>33,'Y'=>34,'Z'=>35)
pruef = (testiban.to_i % 97)
valid = pruef == 1 ? 'gültig' : 'ungültig'
puts "Die angegebene IBAN ist #{valid}!"
