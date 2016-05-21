require_relative "cleaner"
require_relative "file_manager"
require_relative "extractor"

class OcrFile
  include Cleaner
  include FileManager
  include Extractor
  attr_reader :path, :ocr

  def initialize(path)
    @path = path
    @ocr = true
  end

  def convert
    Docsplit.extract_text(path, :ocr => ocr, :output => './docs/tmp')
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