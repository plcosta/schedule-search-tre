require 'rubygems'
require 'bundler/setup'

require 'httparty'
require 'uniform_notifier'
require 'terminal-notifier'

LOCATIONS = [
  { id: 11, name: 'CEATE' },
  { id: 165, name: 'CSU' },
  { id: 158, name: 'NORTH SHOPPING JOQUEI' },
  { id: 159, name: 'BENFICA' },
  { id: 164, name: 'IGUATEMI' },
  { id: 162, name: 'PARANGABA' },
  { id: 163, name: 'RIOMAR KENNEDY' },
  { id: 161, name: 'RIOMAR PAPICU' },
  { id: 167, name: 'VIA SUL' },
  { id: 174, name: 'UECE' },
  { id: 183, name: 'NORTH SHOPPING' }
]

UniformNotifier.terminal_notifier = true

while true
  LOCATIONS.each do |location|
    response = HTTParty.post(
        'http://apps.tre-ce.jus.br/agendabio/publico/registrarAgendamentoEleitor.do?acao=atualizarDia',
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'X-Requested-With': 'XMLHttpRequest',
          'Referer': 'http://apps.tre-ce.jus.br/agendabio/publico/registrarAgendamentoEleitor.do?acao=load',
          'Accept': '*/*'
        },
        body: { 'local': location[:id] }
    )
    puts '----'
    puts location[:name]
    puts response.body

    unless response.body.include?('AGUARDE')
      puts '********* VAGA DISPONIVEL *********'
      puts location[:name]
      UniformNotifier.active_notifiers.each do |notifier|
        notifier.out_of_channel_notify("Vaga Disponível: #{location[:name]}")
      end
    end
  end
  sleep 30
end
