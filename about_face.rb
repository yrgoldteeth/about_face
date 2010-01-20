require 'rubygems'
require 'sinatra'
require 'rio'
require 'rdiscount'
require 'lib/md'
require 'lib/about_face'

post '/' do
  u = UploadedMarkdownFileHandler.new(:markdown_file => params[:markdown_file])
  u.convert!
  if u.success?
    "#{u.converted_file_path}"
  else
    "naw"
  end
end
