require 'sinatra'
require 'sprockets'

module AssetHelpers
  def asset_path(source)
    "/assets/" + settings.sprockets.find_asset(source).digest_path
  end
end

class App < Sinatra::Base
  set :root, File.expand_path('../', __FILE__)
  set :sprockets, Sprockets::Environment.new(root)
  set :precompile, [ /\w+\.(?!js|css).+/, /(application|vendor).(css|js)$/ ]
  set :assets_prefix, 'assets'
  set :assets_path, File.join(root, 'public', assets_prefix)
  set :views, Proc.new { File.join(root, "app/views") }

  configure do
    ["assets", "vendor"].each do |path|
      sprockets.append_path(File.join(root, path, 'stylesheets'))
      sprockets.append_path(File.join(root, path, 'javascripts'))
      sprockets.append_path(File.join(root, path, 'images'))
    end

    sprockets.context_class.instance_eval do
      include AssetHelpers
    end
  end

  helpers do
    include AssetHelpers
  end

  get '/' do
    haml :index
  end

end
