require 'octokit'

module SlackBot
  module Commands
    class Github < SlackRubyBot::Commands::Base
      github_client = Octokit::Client.new(login: ENV['GITHUB_USERNAME'], password: ENV['GITHUB_PASSWORD'])

      command 'github' do |client, data, _match|
        command_input = match['expression'].split.reject(&:blank?)
        if github_client
          perform_command(command_input)
          client.web_client.chat_postMessage(channel: data.channel, text: "git stuff")
        else
          client.say(channel: data.channel, text: "Fail... you know that you need to be authenticated, don't you?")
        end
      end

      class << self
        def perform_command(command_input)
          command = command_input.first
          arguments = command_input(1..-1)
          case object
          when 'branches'
            x = github_client.branches('dmagro/boty')
            binding.pry
          when 'tags'
            #get tags 
          else
            "Yeah... you know... I didn't get what you want, sorry about that"
          end
        end
      end
    end
  end
end