require 'rubygems'
class Md
  attr_accessor :markdown_text, :html_text, :markdown_file_path, :html_file_path, :success

  def initialize(options={})
    @success = false
    @markdown_text = ''
    @markdown_file_path = options[:markdown_file_path]
    return false unless File.exist? @markdown_file_path
  end

  def run
    set_html_file_path
    get_markdown_text
    get_html_text
    create_html_file
  end

  def set_html_file_path
    base_file_name = File.basename(@markdown_file_path, ".mkd")
    base_file_path = File.dirname(@markdown_file_path)
    @html_file_path = File.join(base_file_path, "#{base_file_name}.html")
  end

  def get_markdown_text
    rio(@markdown_file_path) > @markdown_text
  end

  def get_html_text
    md = RDiscount.new(@markdown_text)
    @html_text = md.to_html
  end

  def create_html_file
    rio(@html_file_path) < @html_text
    @success = true
  end

  def success?
    @success
  end

end
