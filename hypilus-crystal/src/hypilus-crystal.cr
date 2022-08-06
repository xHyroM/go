require "./middleware/BooksHandler.cr"
require "./struct/book.cr"
require "kemal"

module Hypilus
  Books = [] of Book
end

add_handler BooksHandler.new

Kemal.run 
