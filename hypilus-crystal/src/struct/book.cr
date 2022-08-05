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