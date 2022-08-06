require "./routes/ProjectsHandler.cr"
require "./middleware/main.cr"
require "./struct/Error.cr"
require "sqlite3"
require "kemal"

module Hypilus
  Database = DB.open "sqlite3://./storage/data.db"
  Database.exec "create table if not exists projects (name text, description text, author text, github_repository_url text)"
end

add_handler MainMiddleware::Handler.new
add_handler ProjectsHandler.new

error 404 do |env|
  Error.new(404).out(env)
end

error 500 do |env|
  Error.new(500).out(env)
end

Kemal.run
