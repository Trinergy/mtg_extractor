require_relative "./../test_helper"

#file type does not matter since OCR usage is determined by Scanner class, use when filetype check involves special formats

class TestConverter < MiniTest::Test
  def setup
    @pdf_file = "./docs/files/Filogix Mortgage Summary.pdf"
    @ocr_file = "./docs/files/MortgageSummary.jpg"
  end

  def test_pdf_write_txt
    Converter.convert(@pdf_file, false, OUTPUT)
    assert_includes(Dir["#{OUTPUT}/*.txt"], "#{OUTPUT}/Filogix Mortgage Summary.txt")
  end

  def test_ocr_write_txt
    Converter.convert(@ocr_file, true, OUTPUT)
    assert_includes(Dir["#{OUTPUT}/*.txt"], "#{OUTPUT}/MortgageSummary.txt")
  end
end