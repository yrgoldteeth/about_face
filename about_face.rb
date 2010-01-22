require 'rubygems'
require 'ruby-debug'
require 'sinatra'
require 'sinatra/ratpack'
require 'haml'
require 'rio'
require 'rdiscount'
require 'lib/uploaded_markdown_file_handler'
require 'lib/md'


set :root, File.dirname(__FILE__)

get '/' do
  haml :index
end

get '/history' do
  haml :history
end

post '/' do
  #there's probably a better way, but just send a param for the response wanted.
  params[:response_type].nil? ? reponse_type = 'html' : response_type = params[:response_type]

  u = UploadedMarkdownFileHandler.new(params)
  u.convert!

  if u.success?
    @markdown_file_data = u.markdown_file_data
    case response_type
    when 'html'
      "#{u.converted_file_data}"
    else
      haml :data
    end
  else
    "naw"
  end
end
