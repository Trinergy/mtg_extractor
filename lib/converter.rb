class Converter
  class << self
    def convert(file, output)
      success = Docsplit.extract_text(Dir[file[:path]], :ocr => file[:ocr], :output => output)
      success != [] ? true : false
    end
  end
end