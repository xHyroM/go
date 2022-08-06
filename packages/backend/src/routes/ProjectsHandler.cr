require "../managers/ProjectManager.cr"
require "../struct/Project.cr"
require "../struct/Error.cr"
require "kemal"

class ProjectsHandler < Kemal::Handler
  def call(env : HTTP::Server::Context)
    unless env.request.path === "/api/projects"
      return call_next(env)
    end

    env.response.headers["X-Powered-By"] = "Kemal (Crystal)"

    case env.request.method
    when "GET"
      env.response.print handle_get(env)
    when "POST"
      env.response.print handle_post(env)
    else
      Error.new(405, "Allowed methods: GET, POST")
    end
  end

  def handle_get(env : HTTP::Server::Context)
    type = env.params.query["type"]? || "json"

    case type
    when "json"
      env.response.content_type = "application/json"

      ProjectManager.get_projects
    when "yaml"
      env.response.content_type = "text/plain" # Firefox doesnt support text/yaml :((

      ProjectManager.get_projects
    else
      Error.new(400, "Invalid formatting type, supported: json, yaml").out(env)
    end
  end

  def handle_post(env : HTTP::Server::Context)
    name = env.params.json["name"]?
    description = env.params.json["description"]?
    author = env.params.json["author"]?
    github_repository_url = env.params.json["github_repository_url"]?

    if name.nil? || description.nil? || author.nil? || github_repository_url.nil?
      return Error.new(400, "Missing body, required name, description, author, github_repository_url").out(env)
    end

    project = Project.new(name.as(String), description.as(String), author.as(String), github_repository_url.as(String))
    exist = ProjectManager.get_project_name(project.name)

    if exist
      return Error.new(400, "Project already exists").out(env)
    end

    env.response.content_type = "application/json"

    ProjectManager.add_project(project)
    project.to_json
  end
end
