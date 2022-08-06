require "kemal"

module MainMiddleware
  class Handler < Kemal::Handler
    def call(env : HTTP::Server::Context)
      # Set my headers
      env.response.headers["X-Powered-By"] = "Kemal (Crystal)"
      env.response.headers["X-Hypilus-Language"] = "Crystal (https://crystal-lang.org)"

      call_next env
    end
  end
end
