require_relative "./../test_helper"

#file type does not matter since OCR usage is determined by Scanner class, use when filetype check involves special formats

class TestConverter < MiniTest::Test
  def setup
    @pdf_file = Scanner.scan("./docs/Filogix Mortgage Summary.pdf")
    @bad_file = {:path=>"./docs/IAMSOBADIWILLFAIL", :ext=>"pdf", :ocr=>false}
    # @img_file = Scanner.scan("./docs/MortgageSummary.jpg")
    # @old_pdf_file = Scanner.scan("./docs/MortgageApplication.pdf")
  end

  def test_pdf_write_txt
    Converter.convert(@pdf_file, OUTPUT)
    assert_includes(Dir["#{OUTPUT}/*.txt"], "#{OUTPUT}/Filogix Mortgage Summary.txt")
  end

  def test_return_success_true
    @success = Converter.convert(@pdf_file, OUTPUT)
    assert(@success)
  end

  def test_return_success_false
    @success = Converter.convert(@bad_file, OUTPUT)
    refute(@success)
  end

  # def test_img_write_txt
  #   Converter.convert(@img_file, OUTPUT)
  #   assert_includes(Dir["#{OUTPUT}/*.txt"], "#{OUTPUT}/MortgageSummary.txt")
  # end

  # def test_old_pdf_write_txt
  #   Converter.convert(@old_pdf_file, OUTPUT)
  #   assert_includes(Dir["#{OUTPUT}/*.txt"], "#{OUTPUT}/MortgageApplication.txt")
  # end
end