require 'lib/base'

class App < Base

  get '/' do
    haml :index
  end

end
