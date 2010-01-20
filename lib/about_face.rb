class UploadedMarkdownFileHandler
  attr_accessor :markdown_file_path, :markdown_file_data, :success, :converted_file_path

  STORAGE_PATH = 'public/af'

  def initialize(options={})
    @success = false
    uploaded_markdown_file = options[:markdown_file]
    file_name = uploaded_markdown_file[:filename]
    get_file_path(file_name)
    @markdown_file_data = uploaded_markdown_file[:tempfile].read
  end

  def get_file_path(file_name)
    new_directory_path = File.join(STORAGE_PATH, next_directory)
    Dir.mkdir(new_directory_path)

    return unless File.directory? new_directory_path

    @markdown_file_path = File.join(new_directory_path, file_name)
  end

  def convert!
    save_markdown_file
    convert_markdown_file
  end

  def save_markdown_file
    rio(@markdown_file_path) < @markdown_file_data
  end

  def convert_markdown_file
    m = Md.new(:markdown_file_path => @markdown_file_path)
    m.run
    if m.success?
      @success = true
      @converted_file_path = m.html_file_path
    end
  end

  def next_directory
    (Dir.entries(STORAGE_PATH).count - 1).to_s
  end

  def success?
    @success
  end

end
