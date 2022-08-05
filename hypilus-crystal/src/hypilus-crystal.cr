require "./struct/book.cr"
require "./struct/error.cr"
require "kemal"

books = [] of Book

before_all do |env|
  env.response.headers["X-Powered-By"] = "Kemal (Crystal)"
end

get "/api/books" do |env|
  type = env.params.query["type"]? || "json"

  case type
  when "json"
    env.response.content_type = "application/json"
    books.to_json
  when "yaml"
    env.response.content_type = "text/plain" # Firefox doesnt support text/yaml :((
    books.to_yaml
  else
    Error.new(400, "Invalid formatting type, supported: json, yaml").out(env)
  end
end

post "/api/books" do |env|
  name = env.params.json["name"]?
  description = env.params.json["description"]?
  author = env.params.json["author"]?
  price = env.params.json["price"]?

  if name.nil? || description.nil? || author.nil? || price.nil?
    next Error.new(400, "Missing body.").out(env)
  end

  book = Book.new(name.as(String), description.as(String), author.as(String), price.as(Float64))
  exist = false
  books.each { |book|
    if book.name === name
      exist = true
      break
    end
  }

  if exist
    next Error.new(400, "Book already exist.").out(env)
  end

  env.response.content_type = "application/json"

  books.push(book)
  book.to_json
end

Kemal.run 
