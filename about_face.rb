require 'rubygems'
require 'sinatra'
require 'rio'
require 'rdiscount'
require 'lib/uploaded_markdown_file_handler'
require 'lib/md'

set :root, File.dirname(__FILE__)

post '/' do
  u = UploadedMarkdownFileHandler.new(params)
  u.convert!
  if u.success?
    "#{u.converted_file_path}"
  else
    "naw"
  end
end
