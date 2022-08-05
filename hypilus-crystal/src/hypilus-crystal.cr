require "./middleware/BooksHandler.cr"
require "./struct/book.cr"
require "kemal"

module Hypilus
  Books = [] of Book
end

before_all do |env|
  env.response.headers["X-Powered-By"] = "Kemal (Crystal)"
end

add_handler BooksHandler.new

Kemal.run 
