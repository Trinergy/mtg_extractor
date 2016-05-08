# class Delegator

#Can be used when task delegation gets too complicated at app level

#   class << self
#   #if image, process it
#   #imageprocessor will send to converter
#   #if pdf, send to converter
#   #converter handles ocr or not

#     def delegate(file)
#       case file[:ext]
#       when "pdf"
#         Converter.convert(file)
#       #list the img paths you accept (if you use image processing)
#       when "jpg", "png",
#         ImageProcessor.process(file)
#       else
#         raise "File can not be converted"
#       end 
#     end

#   end
# end