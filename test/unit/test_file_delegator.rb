require_relative "./../test_helper"

class TestFileDelegator < MiniTest::Test
  def setup
    @file = FileDelegator.new(Dir["./test/docs/files/*"])
  end

  def test_instance_of
    assert_instance_of(FileDelegator, @file)
  end

  def test_bad_init_raise_err
    @err = assert_raises(RuntimeError) { FileDelegator.new(Dir["./test/docs/files/badpath/*"]) }
    assert_match("File/Folder does not exist", @err.message)
  end

  def test_assign_files_creates_objects
    files = @file.assign_files
    check = 0
    files.each do |file|
      if (file.instance_of?(OcrFile) || file.instance_of?(PdfFile))
        check+= 1
      end
    end
    assert_equal(3, check)
  end
end