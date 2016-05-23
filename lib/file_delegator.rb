require_relative "ocr_file"
require_relative "pdf_file"

class FileDelegator
  attr_reader :paths

  def initialize(paths)
    raise "File/Folder does not exist" unless !paths.empty?
    @paths = paths
  end

  def assign_files
    paths.collect do |path|
      if use_ocr?(path)
        create_ocr_file(path)
      else
        create_pdf_file(path)
      end
    end
  end

  private

  def create_ocr_file(path)
    OcrFile.new(path)
  end

  def create_pdf_file(path)
    PdfFile.new(path)
  end

  def get_ext(file)
    #delete period b/c mimemagic returns subtype w/o it
    ext = File.extname(file).delete(".")
    if ext.empty?
      ext = MimeMagic.by_magic(File.open(file)).subtype
    end
    ext
  end

  def use_ocr?(file)
    ext = get_ext(file)
    if ext == "pdf"
      File.open(file) do |io|
        !pdf_ver_ok?(io)
      end
    else
      true
    end
  end

  #PDF Reader raw content returns only 1 line if the version is not compatible for direct text conversion
  def pdf_ver_ok?(file)
    reader = PDF::Reader.new(file)
    (reader.page(1).raw_content.lines.count != 1) ? true : false
  end
end