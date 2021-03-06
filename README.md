#Mortgage Application Text Extractor
A library that converts PDF/Images to text and then extracts text from it. Can also work for any forms. It uses [Tesseract](https://github.com/tesseract-ocr/tesseract) open-source Optical Character Recognition engine.

##Setting Up

The [Docsplit](https://documentcloud.github.io/docsplit/) gem has a few dependencies so please make sure to install them before running the application.

`$ brew install graphicsmagick`

`$ brew install poppler`

`$ brew install ghostscript`

`$ brew install tesseract`

`$ bundle install`

##Usage

`$ ruby lib/app.rb`

##Documentation

The application uses 5 essential tools: FileDelegator, Converter, FileManager, Cleaner, and Extractor.

The 2 classes: OcrFile and PdfFile use the libraries above to process files.

###FileDelegator
`FileDelegator` is a factory that takes a file or folder path and creates OcrFile or PdfFile objects according to the file's extension or mimetype.
```ruby
FileDelegator.new(Dir["./docs/files/MortgageAp*"])
FileDelegator.assign_files
# [#<OcrFile:0x007f93aa0fc860 @path="./docs/files/MortgageApplication-page-001.jpg", @ocr=true>, #<OcrFile:0x007f93aa0fc428 @path="./docs/files/MortgageApplication-page-002.jpg", @ocr=true>, #<OcrFile:0x007f93a894b9f0 @path="./docs/files/MortgageApplication.pdf", @ocr=true>]
```
OCR is used for images as well as PDF versions that the [pdf-reader](https://github.com/yob/pdf-reader) can not convert

###Converter
`Converter.convert` takes three arguments: filepath, boolean(use_ocr?), and output path. The PDF or image file gets converted it into a rough (whitespace included) text file to a specified output folder.
```ruby
pdf_file = "./docs/files/Filogix Mortgage Summary.pdf"
output = 'test/output'
Converter.convert(pdf_file, false, output)
```

###FileManager
The FileManager is a module that contains paths to file directories that are destinations for conversions, cleaning, and parsing. It is responsible for converting files' extensions and paths to its proper destinations.
```ruby
TMP_PATH = "./docs/tmp/"
CLEAN_PATH = "./docs/clean/"
PARSED_PATH = "./docs/parsed/"

FileManager.change_to("./docs/MortgageApplication.pdf", "tmp")

# "./docs/tmp/MortgageApplication.txt"
```
###Cleaner
`Cleaner.clean` takes a text file and rewrites it into the clean files directory with whitespaces and line breaks removed. Returns boolean value based on clean success.
```ruby
tmp_file = FileManager.change_to("./docs/MortgageApplication.pdf", "tmp")
# "./docs/tmp/MortgageApplication.txt"
clean_path = FileManager.change_to("./docs/MortgageApplication.pdf", "clean")
# "./docs/clean/MortgageApplication.txt"

Cleaner.clean(tmp_file, clean_path)
# true
```

###Extractor
`Extractor.extract` writes a parsed copy in a text file based on the fields array provided in the query.
```ruby
parsed_path = FileManager.change_to("./docs/MortgageApplication.pdf", "parsed")
# "./docs/parsed/MortgageApplication.txt"

query = ["Address", "Name"]

field_query.each do |query|
  Extractor.extract(clean_path, parsed_path, query)
end

# File Output for "./docs/parsed/MortgageApplication.txt":
# Address: 1234 Elm Street Vancouver. BC V5Y 0E8
# Property Address; 1234 Elm Street Vancouver, BC V5Y 0E8
# Name: Mr. John Smith
# Lender:<Not Assigned) Product Name: ?Loan Type: Mortgage
```
###Notes
The extractor is not 100% accurate and can be improved with machine learning. It is possible to feed it expected templates and formats of information so it knows what keywords to look for in regards to certain fields.

For example: Residency Status can only have so many kinds values
              Bank statements are expected to have X many lines

The current extractor works by examining the file line by line for just the fields then saves the line number to an array. Then it checks if the field's line contains any content. If not, it checks the next line's content and gets it's line number and pushes it to its respective field's array. If the next line has another field (determined by presence of colon), it will treat it as a contentless field and automatically prints "N/A" for its content. It then stores all these fields in their respective sets in an array of arrays. Then these line numbers (of the clean copy) will get printed into a parsed copy text file.
