module Converter
  class Converter
    class << self
      def convert(path, ocr, output = './docs/tmp')
        Docsplit.extract_text(path, :ocr => ocr, :output => output)
      end
    end
  end
end