module SlackBot
  module Commands
    class Github < SlackRubyBot::Commands::Base
      @github_client = SlackBot::Utils::GithubClient.new

      command 'github' do |client, data, _match|
        command_input = parse_command(_match[:expression])
        if @github_client.authenticated?
          response = perform_command(command_input)
          client.web_client.chat_postMessage(channel: data.channel, text: response)
        else
          client.say(channel: data.channel, text: "Fail... you know that you need to be authenticated, don't you?")
        end
      end

      class << self
        def parse_command(input)
          input.split.reject(&:blank?) if input
        end

        def perform_command(command_input)
          return 'Need more than that chief' unless command_input
          command = command_input.first
          arguments = command_input[1..-1]
          case command
          when 'repos'
            @github_client.repositories
          when 'branch'
            @github_client
            'branch'
          when 'branches'
            repo_name = arguments.first
            @github_client.branches(repo_name)
          when 'prs'
            repo_name = arguments[0]
            state = arguments[1]
            @github_client.pull_requests(repo_name, state)
          when 'create_pr'
            return 'Failed... Command format: github create_pr [repo] [base_branch] [feature_branch]' if arguments.length != 3
            repo_name = arguments[0]
            base = arguments[1]
            branch = arguments[2]
            # Here you would make calls to your ticket/issue tracker and set the perfomated title and body
            title = "PR for #{branch}"
            body = "This PR does very nice things and here's the link to the issue it solves"
            @github_client.create_pr(repo_name, base, branch, title, body)
          when 'merge_pr'
            return 'Failed... Command format: github merge_pr [repo] [pull_request_id]' if arguments.length != 2
            repo_name = arguments[0]
            pr_number = arguments[1]
            @github_client.merge_pr(repo_name, pr_number)
          when 'close_pr'
            return 'Failed... Command format: github close_pr [repo] [pull_request_id]' if arguments.length != 2
            repo_name = arguments[0]
            pr_number = arguments[1]
            @github_client.close_pr(repo_name, pr_number)
          else
            "Yeah... you know... I didn't get what you want, sorry about that"
          end
        end
      end
    end
  end
end
