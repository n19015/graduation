require 'rubygems'
require 'mqtt'
require 'serialport'

sp = SerialPort.new('/dev/ttyACM0', 9600, 8, 1, SerialPort::NONE)

client = MQTT::Client.connect(
           host: 'エンドポイント', #iot coreの設定にあるエンドポイント
           port: 8883,
           ssl: true,
           cert_file: '証明書ファイル', #.pem.crt
           key_file: '秘密鍵ファイル', #private.pem.key
           ca_file: 'rootCA.pem')
loop do
  sp.write('123')
  str =  sp.gets.to_s
  heat = str.slice(0, 4)
  puts heat
  sleep 1
  if heat.to_i >= 34.5 then
    client.publish('iot/topic', "#{heat}")
  end
end

sp.close
