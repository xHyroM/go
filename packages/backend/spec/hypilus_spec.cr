require "./spec_helper.cr"

describe "hypilus http server" do
  it "GET /api/projects" do
    get "/api/projects"
    response.body.should be_truthy
  end

  it "POST /api/projects" do
    post "/api/projects", HTTP::Headers{"Content-Type" => "application/json"}, {"name": "hypilus", "description": "Simple API in crystal", "author": "xHyroM", "github_repository_url": "https://github.com/xHyroM/hypilus"}.to_json
    response.body.should eq "{\"name\":\"hypilus\",\"description\":\"Simple API in crystal\",\"author\":\"xHyroM\",\"github_repository_url\":\"https://github.com/xHyroM/hypilus\"}"
  end
end
