require "../managers/BookManager.cr"
require "../struct/Error.cr"
require "../struct/Book.cr"
require "kemal"

class BooksHandler < Kemal::Handler
    def call(env : HTTP::Server::Context)
        unless env.request.path === "/api/books"
            return call_next(env)
        end

        env.response.headers["X-Powered-By"] = "Kemal (Crystal)"

        case env.request.method
        when "GET"
            env.response.print handle_get(env)
        when "POST"
            env.response.print handle_post(env)
        else
            Error.new(405, "Allowed methods: GET, POST")
        end
    end

    def handle_get(env : HTTP::Server::Context)
        type = env.params.query["type"]? || "json"

        case type
        when "json"
            env.response.content_type = "application/json"

            BookManager.get_books
        when "yaml"
            env.response.content_type = "text/plain" # Firefox doesnt support text/yaml :((

            BookManager.get_books
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
        exist = BookManager.get_book_name(book.name)
        
        if exist
            return Error.new(400, "Book already exist.").out(env)
        end
        
        env.response.content_type = "application/json"
        
        BookManager.add_book(book)
        book.to_json
    end
end