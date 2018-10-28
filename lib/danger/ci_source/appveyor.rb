# https://www.appveyor.com/docs/environment-variables/
module Danger
  # ### CI Setup
  #
  class AppVeyor < CI
    def self.validates_as_ci?(env)
      env.key? "APPVEYOR"
    end

    def self.validates_as_pr?(env)
      return false unless env.key? "APPVEYOR_PULL_REQUEST_NUMBER"
      env["APPVEYOR_PULL_REQUEST_NUMBER"].to_i > 0
    end

    def initialize(env)
      self.repo_slug = env["APPVEYOR_REPO_NAME"]
      self.pull_request_id = env["APPVEYOR_PULL_REQUEST_NUMBER"]
      self.repo_url = GitRepo.new.origins # AppVeyor doesn't provide a repo url env variable for now
    end

    def supported_request_sources
      @supported_request_sources ||= [
        Danger::RequestSources::GitHub,
        Danger::RequestSources::BitbucketCloud,
        Danger::RequestSources::BitbucketServer,
        Danger::RequestSources::GitLab
      ]
    end
  end
end
