#!/usr/bin/env ruby
# encoding: UTF-8
require 'net/http'
require 'open-uri'
require 'json'
require 'socket'
require 'optparse'

def banner()
red = "\033[01;31m"
green = "\033[01;32m"


puts "\n"
puts"                      ¤ø„¸ ø„¸¸„¨,,ø„¸ „ø¤º°¨¸        "
puts"                      ¨°º¤ø„¸ Cyb3rMeth0d „ø¤º°¨      "
puts"                     ¸„ø¤º°¨♥ RESOLVE CLOUD♥¨°º¤ø„¸   "
puts"                     ¸„ø¤º°¨¸ ø„¸,,¸„¨ø„¸ ¨°º¤ø„      "





puts "#{green}Herramienta simple escrita en Ruby para sacar ip en tiempo real camufladas en CloudFlare."
puts "#{green}La herramienta es bastante simple, usa CrimeFlare para permitir un desvío a los dominios protegidos de CloudFlare."
puts "\n"
puts "#{green}Contacto: #{red}https://github.com/Cyb3rMeth0d"
puts "\n"
puts "#{red}[!]Esta es una versión reescrita de la popular herramienta llamada 'HatCloud'. ¡Muchos de los errores han sido reparados!"

puts "\n"
puts "#{green}Obtener comandos:"
puts "#{green}-h - Obtener ayuda para los comandos"
puts "\n"
end

options = {:bypass => nil, :massbypass => nil}
parser = OptionParser.new do|opts|

    opts.banner = "Ejemplo: ReverseCloud.rb -b <target site> or ruby ReverseCloud.rb --byp <target site>"
    opts.on('-b ','--byp ', 'Descubre IP real (omite CloudFlare)', String)do |bypass|
    options[:bypass]=bypass;
    end

    opts.on('-o', '--out', 'Siguiente release.', String) do |massbypass|
        options[:massbypass]=massbypass

    end

    opts.on('-h', '--help', 'Ayuda') do
        banner()
        puts opts
        puts "Ejemplo: ./ReverseCloud.rb -b <domain> or ruby ReverseCloud.rb --byp <domain>"
        exit
    end
end

parser.parse!


banner()

if options[:bypass].nil?
    puts "Insertar URL, dominio o sitio web protegido por CloudFlare. Incluido con: -b o --byp"
else
	option = options[:bypass]
	payload = URI ("http://www.crimeflare.info/cgi-bin/cfsearch.cgi")
	request = Net::HTTP.post_form(payload, 'cfS' => options[:bypass])

	response =  request.body
	nscheck = /No working nameservers are registered/.match(response)
	if( !nscheck.nil? )
		puts "[-] No hay una URL válida. ¿Es este un sitio protegido por CloudFlare?\n"
		exit
	end
	regex = /(\d*\.\d*\.\d*\.\d*)/.match(response)
	if( regex.nil? || regex == "" )
		puts "[-] No hay una URL válida. ¿Es este un sitio protegido por CloudFlare?\n"
		puts "[-] Alternativa, ¿Quizás CrimeFlare está caído?\n"
		puts "[-] Intenta hacerlo manualmente - http://www.crimeflare.info\n"
		exit
	end
	ip_real = IPSocket.getaddress (options[:bypass])

	puts "[+] Sitio de análisis: #{option} "
	puts "[+] IP Cloudflare es #{ip_real} "
	puts "[+] IP real es #{regex}"
	target = "http://ip-api.com/json/#{regex}"
	url = URI(target).read
	json = JSON.parse(url)
	puts "[+] Hostname: " + json['hostname']
	puts "[+] Ciudad: "  + json['city']
	puts "[+] Región: " + json['country']
	puts "[+] Localización: " + json['loc']
	puts "[+] Organización: " + json['org']

end
