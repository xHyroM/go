require "../hypilus-crystal.cr"
require "../struct/error.cr"
require "../struct/book.cr"
require "kemal"

class BooksHandler < Kemal::Handler
    only ["/api/books"]

    def call(env : HTTP::Server::Context)
        case env.request.method
        when "GET"
            env.response.print handle_get(env)
        when "POST"
            env.response.print handle_post(env)
        else
            call_next(env)
        end
    end

    def handle_get(env : HTTP::Server::Context)
        type = env.params.query["type"]? || "json"

        case type
        when "json"
          env.response.content_type = "application/json"
          Hypilus::Books.to_json
        when "yaml"
          env.response.content_type = "text/plain" # Firefox doesnt support text/yaml :((
          Hypilus::Books.to_yaml
        else
          Error.new(400, "Invalid formatting type, supported: json, yaml").out(env)
        end
    end

    def handle_post(env : HTTP::Server::Context)
        name = env.params.json["name"]?
        description = env.params.json["description"]?
        author = env.params.json["author"]?
        price = env.params.json["price"]?
        
        if name.nil? || description.nil? || author.nil? || price.nil?
            return Error.new(400, "Missing body.").out(env)
        end
        
        book = Book.new(name.as(String), description.as(String), author.as(String), price.as(Float64))
        exist = false
        Hypilus::Books.each { |book|
            if book.name === name
            exist = true
            break
            end
        }
        
        if exist
            return Error.new(400, "Book already exist.").out(env)
        end
        
        env.response.content_type = "application/json"
        
        Hypilus::Books.push(book)
        book.to_json
    end
end