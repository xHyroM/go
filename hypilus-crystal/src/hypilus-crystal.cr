require "kemal"

struct Book
  property name : String
  property description : String
  property author : String
  property price : Float64

  def initialize(@name : String, @description : String, @author : String, @price : Float64)
  end

  def to_json(json : JSON::Builder)
    json.object do
      json.field "name", self.name
      json.field "description", self.description
      json.field "author", self.author
      json.field "price", self.price
    end
  end
end

books = [] of Book

before_get do |env|
  env.response.content_type = "application/json"
end

get "/api/books" do
  books.to_json
end

post "/api/books" do |env|
  name = env.params.json["name"]?
  description = env.params.json["description"]?
  author = env.params.json["author"]?
  price = env.params.json["price"]?

  if name.nil? || description.nil? || author.nil? || price.nil?
    next {"error": "Bad Request", "message": "Missing body"}.to_json
  end

  book = Book.new(name.as(String), description.as(String), author.as(String), price.as(Float64))
  if books.includes?(book)
    env.response.status_code = 400
    {"error": "Bad Request", "message": "Book already exist."}.to_json
  else
    books.push(book)
    book.to_json
  end
end

Kemal.run 
