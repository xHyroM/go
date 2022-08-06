require "./spec_helper.cr"

describe "hypilus http server" do
  it "GET /api/books" do
    get "/api/books"
    response.body.should be_truthy
  end

  it "POST /api/books" do
    post "/api/books", HTTP::Headers{"Content-Type" => "application/json"}, {"name": "test", "description": "test", "author": "ad", "price": 30.05}.to_json
    response.body.should eq "{\"name\":\"test\",\"description\":\"test\",\"author\":\"ad\",\"price\":30.05}"
  end
end
