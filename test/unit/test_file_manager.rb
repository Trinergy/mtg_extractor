require_relative "./../test_helper"

class TestFileManager < MiniTest::Test
  def setup
    @good_file = "./docs/files/MortgageSummary.jpg"
    @bad_file = "./docs/IAMSOBADIWILLFAIL"
  end

  def test_change_to_return_tmp_path
    @tmp_path = FileManager.change_to(@good_file, "tmp")
    assert_match("#{TMP_PATH}MortgageSummary.txt", @tmp_path)
  end

  def test_change_to_return_clean_path
    @clean_path = FileManager.change_to(@good_file, "clean")
    assert_match("#{CLEAN_PATH}MortgageSummary.txt", @clean_path)
  end

  def test_change_to_return_clean_path
    @parsed_path = FileManager.change_to(@good_file, "parsed")
    assert_match("#{PARSED_PATH}MortgageSummary.txt", @parsed_path)
  end

  def test_change_to_bad_path_raise_err
    @err = assert_raises(RuntimeError) { FileManager.change_to(@good_file, "LOLTHISISBAD") }
    assert_match("File path can not be changed because specified filter does not exist", @err.message)
  end

  def test_change_to_bad_file_raise_err
    @err = assert_raises(RuntimeError) { FileManager.change_to(@bad_file, "LOLTHISISALSOBAD") }
    assert_match("File path can not be changed because it does not exist", @err.message)
  end
end