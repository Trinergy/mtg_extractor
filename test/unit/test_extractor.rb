require_relative "./../test_helper"

class TestExtractor < MiniTest::Test
  def setup
    FileUtils.mkdir(OUTPUT)
    @query_1 = "Address"
    @good_file = "./test/docs/clean/MortgageSummary.txt"
    @bad_file = "./test/docs/clean/LOLOLOLOLOL"
    @parsed_path = "#{OUTPUT}/MortgageSummary.txt"
  end

  def test_extractor_write_file
    Extractor.extract(@good_file, @parsed_path, @query_1)
    assert_includes(Dir["#{OUTPUT}/*.txt"], @parsed_path)
  end

  def test_extractor_parsed_query
    Extractor.extract(@good_file, @parsed_path, @query_1)
    @file = File.read(@parsed_path)
    assert_match("Property Address: 1234 Elm Street Vancouver, BC V5Y 0E8\nAddress:\nN/A\n", @file)
  end

  def test_extractor_good_file_return_succ_true
    @success = Extractor.extract(@good_file, @parsed_path, @query_1)
    assert(@success)
  end

  def test_extractor_bad_file_raise_err
    @err = assert_raises(RuntimeError) { Extractor.extract(@bad_file, @parsed_path, @query_1) }
    assert_match("#{@bad_file} could not be extracted because it is either empty or does not exist", @err.message)
  end
end