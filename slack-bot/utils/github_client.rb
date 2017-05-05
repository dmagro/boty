module SlackBot
  module Utils
  	class GithubClient

			def initialize
				@client = Octokit::Client.new(login: ENV['GITHUB_USERNAME'], password: ENV['GITHUB_PASSWORD'])
			end

			def authenticated?
				@client.user_authenticated?
			end

			def branches(repo_name)
				begin
					repo = "#{ENV['GITHUB_USERNAME']}/#{repo_name}"
					branches = @client.branches(repo)
					list_branches(repo, branches)
				rescue Octokit::NotFound
					"Can't find that repo..."
				end 
			end

			private
			def list_branches(repo, branches)
				list = branches.map do |b|
					short_sha = b[:commit][:sha][0..6]
					"Branch: #{b[:name]} Last Commit: <#{commit_url(repo, short_sha)}|#{short_sha}>"
				end
				list.join("\n")
			end

			def commit_url(repo, sha)
				"https://github.com/#{repo}/commit/#{sha}"
			end
		end
	end
end