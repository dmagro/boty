module SlackBot
  module Commands
    class Reddit < SlackRubyBot::Commands::Base
      command 'list' do |client, data, _match|
        client.say(channel: data.channel, text: 'Fuck Off!!!')
      end
    end
  end
end