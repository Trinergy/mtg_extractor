require_relative "./../test_helper"

class TestCleaner < MiniTest::Test
  def setup
    FileUtils.mkdir(OUTPUT)
    @good_file = "./test/docs/tmp/MortgageSummary.txt"
    @clean_path = "#{OUTPUT}/MortgageSummary.txt"
  end

  def test_clean_write_file
    Cleaner.clean(@good_file, @clean_path)
    assert_includes(Dir["#{OUTPUT}/*.txt"], @clean_path)
  end

  def test_clean_good_file_no_whitespace
    #test 2nd line b/c some converted files still have txt on first line but whitespaces onwards.
    #used gets instead of read so the whole file doesn't get loaded into memory aka slurping
    Cleaner.clean(@good_file, @clean_path)
    @file = File.open(@clean_path)
    2.times{@file.gets}
    @file.close
    assert_match("Sep?14?2015 09:25:57 PM EST Smith, John ALTM-55", $_)
  end

  def test_clean_good_file_return_succ_true
    @success = Cleaner.clean(@good_file, @clean_path)
    assert(@success)
  end
end