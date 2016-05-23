require_relative "cleaner"
require_relative "file_manager"
require_relative "extractor"
require_relative "converter"

class PdfFile
  include Converter
  include Cleaner
  include FileManager
  include Extractor
  attr_reader :path, :ocr

  def initialize(path)
    @path = path
    @ocr = false
  end

  def convert
    Converter.convert(path, ocr)
  end

  def clean
    tmp_path = get_tmp
    clean_path = get_clean
    Cleaner.clean(tmp_path, clean_path)
    File.delete(tmp_path)
  end

  def extract(query)
    clean_path = get_clean
    parsed_path = get_parsed
    query.each do |q|
      Extractor.extract(clean_path, parsed_path, q)
    end
  end

  private

  def get_tmp
    FileManager.change_to(path, "tmp")
  end

  def get_clean
    FileManager.change_to(path, "clean")
  end

  def get_parsed
    FileManager.change_to(path, "parsed")
  end
end