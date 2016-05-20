require "pdf-reader" #determine if version too old through #raw_content
#https://github.com/yob/pdf-reader
require "docsplit" #convert file to text with or w/o OCR
#http://documentcloud.github.io/docsplit/#usage
require "mimemagic" #determine mime type by file content
#https://github.com/minad/mimemagic
require_relative "scanner"
require_relative "delegator"
require_relative "converter"
require_relative "cleaner"
require_relative "file_manager"
require_relative "extractor"

file = Scanner.scan("./docs/MortgageSummary.jpg")

Converter.convert(file, './docs/tmp')

tmp_file = FileManager.change_to(file[:path], "tmp")
clean_path = FileManager.change_to(file[:path], "clean")

Cleaner.clean(tmp_file, clean_path)

parsed_path = FileManager.change_to(file[:path], "parsed")
field_query = ["Address", "Name"]
if field_query.kind_of?(Array)
  field_query.each do |query|
    Extractor.extract(clean_path, parsed_path, query)
  end
else
  Extractor.extract(clean_path, parsed_path, field_query)
end




