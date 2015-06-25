require 'net/http'
require 'json'

module Monit
  class Connection
    def initialize(address: 'localhost', port: 8080, user: nil, pass: nil)
      @address = address
      @port = port.to_s
      @user = user
      @pass = pass
      @header = {
        'Host' => @address,
        'Referer' => "#{@address}/index.csp",
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Connection' => 'keepalive',
        'Cookie' => nil
      }

      connect
    end

    def connect
      @http ||= Net::HTTP.new(@address, @port)

      get_id
      login
    end

    def connected?
      defined? @http
    end

    def summary
      JSON.parse(get('/status/hosts/summary').body)
    end

    private

    def get_id
      @header['Cookie'] = @http.get('/index.csp').response['Set-Cookie'].split(';').first
    end

    def login
      get("/z_security_check?z_username=#{@user}&z_password=#{@pass}")
    end

    def logout
      get('/login/logout.csp')
    end

    def get(path = nil)
      req = Net::HTTP::Get.new(path)

      @header.each do |k,v|
        req[k] = v
      end

      @http.request(req)
    end

  end
end
