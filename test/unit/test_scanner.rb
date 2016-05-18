require_relative "./../test_helper"

class TestScanner < MiniTest::Test
  def setup
    @pdf_file = Scanner.scan("./docs/Filogix Mortgage Summary.pdf")
    @img_file = Scanner.scan("./docs/MortgageSummary.jpg")
    @old_pdf_file = Scanner.scan("./docs/MortgageApplication.pdf")
    @bad_file = "./docs/IAMSOBADIWILLFAIL"
  end

  def test_return_path
    assert_match("./docs/Filogix Mortgage Summary.pdf", @pdf_file[:path])
  end

  def test_return_ext
    assert_match("pdf", @pdf_file[:ext])
  end

  def test_pdf_return_ocr_false
    refute(@pdf_file[:ocr])
  end

  def test_img_return_ocr_true
    assert(@img_file[:ocr])
  end

  def test_old_pdf_return_ocr_true
    assert(@old_pdf_file[:ocr])
  end

  def test_bad_file_raise_error
    @err = assert_raises(RuntimeError) { Scanner.scan(@bad_file) }
    assert_match("Can not scan because file does not exist", @err.message)
  end
end