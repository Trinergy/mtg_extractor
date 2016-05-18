require_relative "./../test_helper"

class TestCleaner < MiniTest::Test
  #can not rely on the fact that directories will be made on file write, need to modify the function to create file before write
  def setup
    FileUtils.mkdir(OUTPUT)
    @good_file = "./test/docs/tmp/MortgageSummary.txt"
    @clean_path = "#{OUTPUT}/MortgageSummary.txt"
    @bad_file = "./test/docs/tmp/LOLFAILMORE"
  end

  def test_clean_write_file
    Cleaner.clean(@good_file, @clean_path)
    assert_includes(Dir["#{OUTPUT}/*.txt"], @clean_path)
  end

  def test_clean_file_no_whitespace
    
  end
end