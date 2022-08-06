struct Error
    property status_code : Int32
    property error : String?
    class_property codes = {
        400 => "Bad Request",
        401 => "Unauthorized",
        403 => "Forbidden",
        404 => "Not Found",
        405 => "Method Not Allowed",
        500 => "Internal Server Error",
    }

    def initialize(@status_code : Int32, @error : String | ::Nil = nil)
    end

    def out(env : HTTP::Server::Context)
        env.response.content_type = "application/json"
        env.response.status_code = self.status_code

        self.to_json
    end

    def to_json(json : JSON::Builder)
        json.object do
            json.field "message", "#{status_code}: #{Error.codes[status_code]}"
            if error
                json.field "error", error
            end
            json.field "code", 0
        end
    end
end