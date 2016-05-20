class Converter
  class << self
    def convert(path, ocr)
      success = Docsplit.extract_text(path, :ocr => ocr, :output => './docs/tmp')
      success != [] ? true : false
    end
  end
end