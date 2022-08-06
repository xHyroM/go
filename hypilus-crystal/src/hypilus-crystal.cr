require "./middleware/BooksHandler.cr"
require "./struct/book.cr"
require "kemal"
require "sqlite3"

module Hypilus
  Database = DB.open "sqlite3://./storage/data.db"
  Database.exec "create table if not exists books (name text, description text, author text, price float)"
end

add_handler BooksHandler.new

Kemal.run 
