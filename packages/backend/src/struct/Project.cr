require "yaml"
require "xml"

struct Project
  property name : String
  property description : String
  property author : String
  property github_repository_url : String
  class_property tuple = {name: String, description: String, author: String, github_repository_url: String}

  def initialize(@name : String, @description : String, @author : String, @github_repository_url : String)
  end

  def to_json(json : JSON::Builder)
    json.object do
      json.field "name", self.name
      json.field "description", self.description
      json.field "author", self.author
      json.field "github_repository_url", self.github_repository_url
    end
  end

  def to_yaml(yaml : YAML::Nodes::Builder)
    yaml.mapping do
      yaml.scalar "name"
      yaml.scalar self.name

      yaml.scalar "description"
      yaml.scalar self.description

      yaml.scalar "author"
      yaml.scalar self.author

      yaml.scalar "github_repository_url"
      yaml.scalar self.github_repository_url
    end
  end

  def to_xml(xml : XML::Builder)
    xml.element("name") { xml.text self.name }
    xml.element("description") { xml.description self.description }
    xml.element("author") { xml.author self.author }
    xml.element("github_repository_url") { xml.github_repository_url self.github_repository_url }
  end
end
