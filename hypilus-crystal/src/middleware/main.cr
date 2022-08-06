require "kemal"

module MainMiddleware
    class Handler < Kemal::Handler
        def call(env : HTTP::Server::Context)
            # Set my headers
            env.response.headers["X-Powered-By"] = "Kemal (Crystal)"
    
            call_next env
        end
    end
end