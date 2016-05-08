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

if !file.empty?
  conv_succ = Converter.convert(file)
else
  raise "File could not be converted"
end

if conv_succ
  tmp_file = FileManager.tmp_path(file[:path])
  clean_path = FileManager.clean_path(tmp_file)
  clean_succ = Cleaner.clean(tmp_file, clean_path)
else
  raise "File could not be cleaned"
end

if clean_succ
  parsed_path = FileManager.parsed_path(clean_path)
  field_query = ["Payment", "Name"]
  if field_query.kind_of?(Array)
    field_query.each do |query|
      Extractor.extract(clean_path, parsed_path, query)
    end
  else
    Extractor.extract(clean_path, parsed_path, field_query)
  end
else
  raise "File could not be extracted"
end

#work on extractor, initialize it with specific queries?
#take an array of queries and do it accordingly?

# p file.get_ext

# p file.use_ocr?
##Testing the pdf-reader methods
  # File.open("./docs/Filogix Mortgage Summary.pdf", "rb") do |io|
  #   reader = PDF::Reader.new(io)
  #   puts reader.info
  #   # puts reader.text

  #   puts "new section"
  #   puts reader.page(1).raw_content

  #   puts "text"

  #   puts reader.page(1).text

  #   # reader.pages.each do |page|
  #   #   # puts page.fonts
  #   #   puts page.text
  #   #   # puts page.objects.inspect
  #   # end
  # end

# test_pdf =  Dir['./docs/Filogix Test App.pdf']

# Docsplit.extract_text(test_pdf, :ocr => false, :output => './text')


# TESTING FOR IF NEED OCR
# File.open("./docs/MortgageApplication.pdf", "rb") do |io|
#   reader = PDF::Reader.new(io)
#   puts "testing image pdf %%%%%%%%%%%"
#   puts reader.page(1).raw_content.lines.count
# end

# File.open("./docs/Filogix Test App.pdf", "rb") do |io|
#   reader = PDF::Reader.new(io)
#   puts "testing image pdf %%%%%%%%%%%"
#   puts reader.page(1).raw_content.lines.count
# end

# first use PDF::READER to figure out if the file requires OCR
# it generates encoding through raw_content, so if can only get one line of encoding (page(1).raw_content -> if 1 line of encoding), it means version is not compatible with parsing w/o OCR

#break down into pieces


#a function that determines if OCR is necessary for PDF files
#non-pdf files (media-type:images) automatically use OCR
#from the files' encodings in the sample pack, anything that


#just check file extension?

#check for folder filepaths (multiples files)
def use_ocr?(filepath)
  File.open(filepath) do |io|
    !pdf_ver_ok?(io)
  end
end

def pdf_ver_ok?(file)
  reader = PDF::Reader.new(file)
  (reader.page(1).raw_content.lines.count != 1) ? true : false
end

#check file type by extname (might be faster, but better to only have 1 way of checking without returning varied ext names or subtypes based on libraries)(can modify gems' code or write own code if time allows)

# def check_file_ext(file)
#   ext = File.extname(file)
#   if ext.empty?
#     p ext
#     p "no ext"
#     ext = MimeMagic.by_magic(File.open(file)).subtype
#   end
#   ext
# end

def convert_to_text(file)
  #check mime_type by content (more accurate than file extension)
  extension = MimeMagic.by_magic(File.open(file)).subtype
  if extension != "pdf"
    Docsplit.extract_text(Dir[file], :ocr => true, :output => './tmp')
  else
    ocr = use_ocr?(file)
    Docsplit.extract_text(Dir[file], :ocr => ocr, :output => './tmp')
  end
end

#regex true 2nd param means it's case insensitive
def get_txt_ext(file)
  ext = File.extname(file)
  replace = Regexp.new(ext, true)
  file.gsub(replace, ".txt")
end


# File.readlines("./text/Filogix Test App.txt").each do |line|
#   puts line
# end


#look up ruby IO, fileno
#need to figure out a way to print blocks of text with $ symbol for keywords such as payment or fees. Then also check if there is ocntent after :, just print that line, and if no content (/n) then print the next line (if you get rid of whitespace).

def parse_txt(text_file, str)
  target = Regexp.new(str, true)

  label_line_num = parse_for_labels(text_file, target)
  all_line_nums = get_label_content(text_file, label_line_num)

  all_line_nums
end

def parse_for_labels(text_file, target)
  label_line_num = []
  File.foreach(text_file).with_index do |line, line_num|
    if target.match(line)
      label_line_num.push([line_num + 1])
    end
  end
  label_line_num
end

def get_label_content(text_file, label_line_num)
  label_line_num.each do |label|
    label.each do |line_num|
      if check_label(text_file, line_num)
        file = File.open(text_file)
        next_line = line_num + 1
        next_line.times{file.gets}
        if !$_.include?(":")
          label.push(next_line)
        else
          label.push("N/A")
        end
        file.close
      end
    end
  end
end

def check_label(text_file, line_num)
  if line_num != "N/A"
    file = File.open(text_file)
    line_num.times{file.gets}
    partition = $_.partition(":")
    next_line = partition[2].length == 1 ? true : false
    file.close

    next_line
  end
end

def create_parsed_copy(text_file, wanted_line_num)
  parsed_file = File.new(parsed_filepath(text_file), "w")
  wanted_line_num.each do |label|
    label.each do |line_num|
      if line_num == "N/A"
        parsed_file.puts line_num
      else
        file = File.open(text_file)
        line_num.times{file.gets}
        parsed_file.puts $_
        file.close
      end
    end
  end
  parsed_file.close
end

def parsed_filepath(text_file)
  "./parsed/" + File.basename(text_file)
end

# file = File.open "./text/Filogix Test App.txt"
# 10.times{file.gets}
# p $_
# file.close

# x = Regexp.new("cat", true)
# p x.match("caT")


# parse_txt("./text/MortgageApplication.txt", "name")

def create_text_copy(tmp_file)
  text_file = File.new(text_filepath(tmp_file), "w")
  File.foreach(tmp_file) do |line|
    remove_blanks(line)
    text_file.puts line unless line.chomp.empty?
  end
  text_file.close
end

def text_filepath(filepath)
  "./text/" + File.basename(filepath)
end

def remove_blanks(line)
  line.gsub!(/^\s[\r\n]+/, "")
end


# p convert_to_text("./docs/Filogix Test App.pdf")
# create_text_copy("./tmp/Filogix Test App.txt")

# x = parse_txt("./text/Filogix Test App.txt", "name")

# p x

# create_parsed_copy("./text/Filogix Test App.txt", x)

#does not slurp, uses IO instead of read
#http://stackoverflow.com/questions/25189262/why-is-slurping-a-file-bad
# File.foreach("./text/MortgageApplication.txt").with_index do |line, line_num|
#   p line.delete!(" \n")
# end

# x = " \n"

# x.gsub!(/^\s[\r\n]+/, "")

# p x.empty?

# p x

# p "converting pdf that needs ocr"
# convert_to_text("./docs/MortgageApplication.pdf")
# create_text_copy("./tmp/MortgageApplication.txt")

# p "converting pdf that doesn't needs ocr"
# convert_to_text("./docs/Filogix Test App.pdf")
# create_text_copy("./tmp/Filogix Test App.txt")

# p "converting pdf without file extension specified"
# convert_to_text("./docs/Filogix Mortgage SummaryNoExt")
# create_text_copy("./tmp/Filogix Mortgage SummaryNoExt.txt")


# p "converting jpg"
# convert_to_text("./docs/MortgageSummary.jpg")
# create_text_copy("./tmp/MortgageSummary.txt")

# p "converting jpg file without extension specified"
# convert_to_text("./docs/MortgageSummaryNoExt")
# create_text_copy("./tmp/MortgageSummaryNoExt.txt")

#04/24/2016
#create method to convert filepaths to appropriate desination so create_clean_copy does not need to massage the data beforehand. 

#04/05/2016
#can convert any file that is non pdf into text, can accurately determine file type based on content and not extension

#NEXT: pass in array of strings that will be used to parse text files. Figure out ways to make search efficient, take the parsed bits and write to new file with the filename + parsed. and maybe add into content the filepath along with the array of strings it parsed for. 
#Look at nokogiri gem? After parsing is complete, delete the previous file used for parsing. (reference file may take too much space)
#is it possible to be selective with OCR?
#if no blank after colon, take that content, if blank, take the next line

#machine learning? have a separate file that stores all keywords that might potentially use multi-line $signs ?