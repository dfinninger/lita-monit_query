require 'lita/handlers/monit/connection'

module Lita
  module Handlers
    class MonitQuery < Handler
      config :address
      config :port
      config :username
      config :password

      route(/^monit summary/, :summary, command: true, help: { "monit summary" => "get a summary of all monit tracked nodes" })

      def summary(resp)
        monit = get_monit

        resp.reply render_template("summary", data: monit.summary)
      end

      private

      def get_monit
        ::Monit::Connection.new(
          address: config.address,
          port: config.port,
          user: config.username,
          pass: config.password
        )
      end

    end

    Lita.register_handler(MonitQuery)
  end
end
