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

helpers do
  def lorem
    "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n"
  end

  def example_output
    out = []
    out << "#Header 1\n"
    out << "##Header 2\n"
    out << lorem
    out << "###Header 3\n"
    out << "  * #{lorem.split(' ')[0]}\n"
    out << "  * #{lorem.split(' ')[1]}\n"
    out << "  * #{lorem.split(' ')[2]}\n"
    out << "  * #{lorem.split(' ')[3]}\n"
    out << "\n"
    out << "####Header 4\n"
    out << "  1. #{lorem.split(' ')[3]}\n"
    out << "  2. #{lorem.split(' ')[2]}\n"
    out << "  3. #{lorem.split(' ')[1]}\n"
    out << "  4. #{lorem.split(' ')[0]}\n"
    out
  end
end

get '/' do
  @output = example_output
  haml :index
end

get '/history' do
  haml :history
end

post '/' do
  #there's probably a better way, but just send a param for the response wanted.
  params[:response_type].nil? ? reponse_type = 'text' : response_type = params[:response_type]

  u = UploadedMarkdownFileHandler.new(params)
  u.convert!

  if u.success?
    case response_type
    when 'text'
      "#{u.converted_file_data}" #return html for curl conversion
    when 'md'
      @output = u.markdown_file_data
      haml :index
    else
      redirect "#{u.converted_file_path}"
    end
  else
    "naw"
  end
end
