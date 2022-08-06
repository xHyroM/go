require "../hypilus-crystal.cr"

struct BookManager
    def self.get_book_name(name : String)
        Hypilus::Database.query_one? "SELECT name FROM books WHERE name = ?", name, as: String
    end

    def self.add_book(book : Book)
        Hypilus::Database.exec "INSERT INTO books (name, description, author, price) VALUES (?, ?, ?, ?)", book.name, book.description, book.author, book.price
    end

    def self.get_books()
        (Hypilus::Database.query_all "SELECT * FROM books", as: Book.tuple).to_json
    end
end