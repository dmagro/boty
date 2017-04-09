require 'sinatra/base'

module SlackBot
  class Web < Sinatra::Base
    get '/' do
      'Stuff...'
    end
  end
end