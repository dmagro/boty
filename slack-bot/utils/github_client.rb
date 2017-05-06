module SlackBot
  module Utils
  	class GithubClient

			def initialize
				@client = Octokit::Client.new(login: ENV['GITHUB_USERNAME'], password: ENV['GITHUB_PASSWORD'])
			end

			def authenticated?
				@client.user_authenticated?
			end

			def repositories
				repos = @client.repositories(ENV['GITHUB_USERNAME'])
				list_repositories(repos)
			end

			def branches(repo_name)
				repo = repo(repo_name)
				branches = @client.branches(repo)
				list_branches(repo, branches)
			rescue Octokit::NotFound, Octokit::InvalidRepository
				"Can't find that repo..."
			end

			def pull_requests(repo_name, state)
				prs_state = state != 'close' ? 'open' : state
				repo = repo(repo_name)
				pull_requests = @client.pull_requests(repo, state: prs_state)
				list_pull_requests(repo, pull_requests)
			rescue Octokit::NotFound, Octokit::InvalidRepository
				"Can't find that repo..."
			end

			private
			def list_repositories(repositories)
				list = repositories.map do |r| 
					language = r[:language].nil? ? '' : " | Language: #{r[:language]}"
					"<#{r[:html_url]}|#{r[:name]}>#{language} | Forks: #{r[:forks]} | Watchers: #{r[:watchers]}"
				end
				list.join("\n")
			end

			def list_branches(repo, branches)
				list = branches.map do |b|
					short_sha = b[:commit][:sha][0..6]
					"#{b[:name]} Last Commit: <#{commit_url(repo, short_sha)}|#{short_sha}>"
				end
				list.join("\n")
			end

			def list_pull_requests(repo, pull_requests)
				pull_requests.map{ |pr| pull_request_text(repo, pr) }.join("\n")
			end

			def pull_request_text(repo, pr)
				"<#{pr[:html_url]}|#{pr[:title]}> #{pr[:user][:login]} (#{pr[:state]})" +
				"\n\t Labels: #{issue_labels(repo, pr[:number])}"+
				"\n\t Description: \n\t #{pr[:body][0..80].split("\n").join("\n\t\t")}" + 
				"\n\t Last Commit: #{commit_text(pr_commits(repo, pr[:number]).last)}"
			end

			def pr_commits(repo, issue_number)
				@client.pull_request_commits(repo, issue_number)
			end

			def commit_text(commit)
				auhtor_name = commit[:commit][:author][:name]
				author_url = commit[:committer][:html_url]
				"<#{commit[:html_url]}|#{commit[:sha][0..6]}> - <#{author_url}|#{auhtor_name}> "
			end

			def commit_url(repo, sha)
				"https://github.com/#{repo}/commit/#{sha}"
			end

			def issue_labels(repo, issue_number)
				@client.labels_for_issue(repo, issue_number).map { |l| l[:name] }.join(' ')
			end

			def repo(repo_name)
				"#{ENV['GITHUB_USERNAME']}/#{repo_name}"
			end
		end
	end
end