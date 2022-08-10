require "multi_auth"
require "kemal"

module OAuth2Handler
  MultiAuth.config("github", ENV["GTIHUB_CLIENT_ID"], ENV["GITHUB_CLIENT_SECRET"])

  def self.multi_auth(env)
    redirect_uri = "#{Kemal.config.scheme}://#{env.request.host_with_port.as(String)}/oauth2/callback"
    MultiAuth.make("github", redirect_uri)
  end

  get "/oauth2/" do |env|
    env.redirect(multi_auth(env).authorize_uri)
  end

  get "/oauth2/callback" do |env|
    user = multi_auth(env).user(env.params.query)
    p user.email
    user
  end
end
