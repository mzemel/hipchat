require 'net/http'
require 'uri'
require 'openssl'

class HipchatMessenger

  AUTH_TOKEN = "bxQXa5apHFGVOGJ8Dk2Gq60qCsjgNM66htnfhMsA"

  attr_accessor :message, :user

  def initialize(message = "Hey!", user = "1144776")
    @message = message
    @user    = user
    puts send_message.body
  end

  private

  def send_message_url
    "https://api.hipchat.com/v2/user/#{user}/message?auth_token=#{AUTH_TOKEN}"
  end

  def send_message
    uri = URI.parse(send_message_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE if http.use_ssl?
    request = Net::HTTP::Post.new(uri.request_uri)
    request.add_field("Content-Type", "text/plain")
    request.body = message
    http.request(request)
  end
end

class PeterPoker

  attr_accessor :filename

  def initialize(filename)
    @filename = filename
  end

  def read_me_a_story!
    lines.each do |line|
      HipchatMessenger.new(line)
      sleep rand(10..60)
    end
  end

  def lines
    @lines ||= File.read(filename).split(".")
  end
end

poker = PeterPoker.new("twilight.txt")
poker.read_me_a_story!
