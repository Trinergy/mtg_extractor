#Mortgage Application Text Extractor
A library that converts PDF/Images to text which then extracts information from it. Can also work for any forms and uses [Tesseract](https://github.com/tesseract-ocr/tesseract) open-source Optical Character Recognition engine.

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

The application uses 5 essential tools: Scanner, Converter, FileManager, Cleaner, and Extractor.
(Delegator is optional, it will be considered when the delegation of tasks gets more complicated when Image processing gets implemented to provide more accurate reads with OCR)

###Scanner
`Scanner.scan` presents the properties of the file as a hash to make it easier for the application to delegate tasks.
```ruby
Scanner.scan("./docs/MortgageApplication.pdf")
# {:path=>"./docs/MortgageApplication.pdf", :ext=>"pdf", :ocr=>true}
```
OCR is used for images as well as PDF versions that the [pdf-reader](https://github.com/yob/pdf-reader) can not convert

###Converter
`Converter.convert` takes the PDF or image file (provided by the file hash) and converts it into a rough (still lots of whitespaces) text file and returns a boolean to notify if conversion was successful or not.
```ruby
file = {:path=>"./docs/MortgageApplication.pdf", :ext=>"pdf", :ocr=>true}
Converter.convert(file)
# true
```

###FileManager
The FileManager contains paths to file directories that are destinations for conversions, cleaning, and parsing. It is responsible for converting files' extensions and paths to its proper destination.
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
tmp_file = FileManager.change_to(file[:path], "tmp")
# "./docs/tmp/MortgageApplication.txt"
clean_path = FileManager.change_to(file[:path], "clean")
# "./docs/clean/MortgageApplication.txt"

Cleaner.clean(tmp_file, clean_path)
# true
```

###Extractor
`Extractor.extract` writes a parsed copy in a text file based on the fields array provided in the query.
```ruby
parsed_path = FileManager.change_to(file[:path], "parsed")
# "./docs/parsed/MortgageApplication.txt"

field_query = ["Address", "Name"]

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

For example: Residency Status can only have so many values.

The current extractor works by examining the file line by line for just the fields then saves the line number to an array. Then it checks if the field's line contains any content. If not, it checks the next line's content and gets it's line number and pushes it to its respective field's array. If the next line has another field (determined by presence of colon), it will treat it as a contentless field and automatically prints "N/A" for its content. It then stores all these fields in their respective sets in an array of arrays. Then these line numbers (of the clean copy) will get printed into a parsed copy text file.
