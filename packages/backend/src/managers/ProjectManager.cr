require "../hypilus.cr"

struct ProjectManager
  def self.get_project_name(name : String)
    Hypilus::Database.query_one? "SELECT name FROM projects WHERE name = ?", name, as: String
  end

  def self.add_project(project : Project)
    Hypilus::Database.exec "INSERT INTO projects (name, description, author, github_repository_url) VALUES (?, ?, ?, ?)", project.name, project.description, project.author, project.github_repository_url
  end

  def self.get_projects
    (Hypilus::Database.query_all "SELECT * FROM projects", as: Project.tuple).to_json
  end
end
