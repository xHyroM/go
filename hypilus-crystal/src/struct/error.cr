struct Error
    property status : Int32
    property message : String

    def initialize(@status : Int32, @message : String)
    end

    def out(env : HTTP::Server::Context)
        env.response.status_code = self.status
        self.to_json
    end

    def to_json(json : JSON::Builder)
        json.object do
            json.field "status", status
            json.field "message", message
        end
    end
end