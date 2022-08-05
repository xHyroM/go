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

get "/api/list" do
  books.to_json
end

post "/api/book" do |env|
  name = env.params.json["name"].as(String)
  description = env.params.json["description"].as(String)
  author = env.params.json["author"].as(String)
  price = env.params.json["price"].as(Float64)

  book = Book.new(name, description, author, price)
  if books.includes?(book)
    env.response.status_code = 400
    {"error": "Bad Request", "message": "Book already exist."}.to_json
  else
    books.push(book)
    book.to_json
  end
end

Kemal.run 
