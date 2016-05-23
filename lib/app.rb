require "pdf-reader" #determine if version too old through #raw_content
#https://github.com/yob/pdf-reader
require "docsplit" #convert file to text with or w/o OCR
#http://documentcloud.github.io/docsplit/#usage
require "mimemagic" #determine mime type by file content
#https://github.com/minad/mimemagic

require_relative "file_delegator"
require_relative "file_manager"
require_relative "cleaner"
require_relative "extractor"

query = ["Name" , "Address"]

folder = FileDelegator.new(Dir["./docs/files/*"])
files = folder.assign_files

files.each do |file|
  file.convert
  file.clean
  file.extract(query)
end