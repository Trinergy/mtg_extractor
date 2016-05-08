class Converter

  class << self

    def convert(file)
      success = Docsplit.extract_text(Dir[file[:path]], :ocr => file[:ocr], :output => './docs/tmp')

      success != [] ? true : false
    end

  end
end