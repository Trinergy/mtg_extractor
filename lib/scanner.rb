class Scanner

  #check by extension, if not provided, check by mime content then convert to non "." format

  class << self

    def scan(file)
      scan_file = {
        path: file,
        ext: get_ext(file),
        ocr: use_ocr?(file)
        }
    end

    def get_ext(file)
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
end