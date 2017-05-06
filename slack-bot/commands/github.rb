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
          when 'pr'
            @github_client
            'prs'
          when 'prs'
            repo_name = arguments.first
            state = arguments.second
            @github_client.pull_requests(repo_name, state)
          else
            "Yeah... you know... I didn't get what you want, sorry about that"
          end
        end
      end
    end
  end
end
