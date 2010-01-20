class UploadedMarkdownFileHandler
  attr_accessor :markdown_file_path, :markdown_file_data, :success, :converted_file_path, :return_method_type, :public_dir

  STORAGE_PATH = 'public/af'

  def initialize(options={})
    @success = false
    return unless options[:markdown_file]

    @return_method_type = options[:return_method_type] || :text

    uploaded_markdown_file = options[:markdown_file]
    file_name = uploaded_markdown_file[:filename]
    get_file_path(file_name)
    @markdown_file_data = uploaded_markdown_file[:tempfile].read
  end

  def get_file_path(file_name)
    dir_num = next_directory
    new_directory_path = File.join(STORAGE_PATH, dir_num)
    Dir.mkdir(new_directory_path)

    return unless File.directory? new_directory_path

    @public_dir = File.join('ar', dir_num)

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
      html_file = File.basename(m.html_file_path)
      @converted_file_path = File.join(@public_dir, html_file)
    end
  end

  def return_method
    case @return_method_type
    when :text
    end
  end

  def next_directory
    (Dir.entries(STORAGE_PATH).count - 1).to_s
  end

  def success?
    @success
  end

end
