#!/usr/bin/env ruby
#encoding:UTF-8

require 'getoptlong'


# specify the options we accept and initialize
# the option parser


opts = GetoptLong.new(
  [ "--konto",    "-k",            GetoptLong::REQUIRED_ARGUMENT ],
  [ "--blz",    "-b",            	GetoptLong::REQUIRED_ARGUMENT ]
)

puts 'ACHTUNG: Bisher nur für deutsche Kontonummern'


# process the parsed options
blz = konto = ''

opts.each do |opt, arg|
	case opt
		when '--konto'
			konto = arg
		when '--blz'
			blz = arg
	end
end

blz.strip!
konto.strip!

if blz == '' || konto == ''
	puts 'Usage: iban --blz BLZ --konto KONTO'
	exit 1
end

if !/[0-9]{8}/.match(blz)
	puts 'Die Bankleitzahl muss eine achtstellige Zahl sein.'
	exit 2
end

if !/[0-9]{1,10}/.match(konto)
	puts 'Die Kontonummer muss eine maximal zehnstellige Ziffer sein.'
	exit 3
end

if konto.length < 10
	tmp = ''
	(1..(10 - konto.length)).each do
		tmp << '0'
	end
	tmp << konto
	konto = tmp
	puts 'ACHTUNG: Bei Kontonummern < 10 Stellen kann eine korrekte Berechnung nicht garantiert werden.'
end

# Prüfziffer berechnen
vorliban = blz.to_s << konto.to_s << 'DE00'
vorliban.gsub!(/[ABCDEFGHIJKLMNOPQRSTUVWXYZ]/, 'A' => 10, 'B' => 11, 'C' => 12, 'D' => 13, 'E' => 14, 'F'=>15,'G'=>16,'H'=>17,'I'=>18,'J'=>19,'K'=>20,'L'=>21,'M'=>22,'N'=>23,'O'=>24,'P'=>25,'Q'=>26,'R'=>27,'S'=>28,'T'=>29,'U'=>30,'V'=>31,'W'=>32,'X'=>33,'Y'=>34,'Z'=>35)
pruef = (98 - vorliban.to_i % 97).to_s
if pruef.length < 2
	pruef = '0' << pruef
end

# IBAN generieren
iban = 'DE' << pruef << blz.to_s << konto.to_s
ibanFormatted = ''
i = 0
iban.each_char do |c|
	ibanFormatted << c # Fixnum#chr converts any number to the ASCII char it represents
	i = (i + 1) % 4
	if i == 0
		ibanFormatted << ' '
	end
end

# Ausgeben
puts 'IBAN: ' << iban
puts 'Formatiert: ' << ibanFormatted