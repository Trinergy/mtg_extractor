here = File.dirname(__FILE__)
require "minitest/autorun"
require "docsplit"
require "pdf-reader"
require "mimemagic"
require "fileutils"
require File.join(here, '..', 'lib', 'scanner')
require File.join(here, '..', 'lib', 'converter')
require File.join(here, '..', 'lib', 'cleaner')
require File.join(here, '..', 'lib', 'file_manager')
require File.join(here, '..', 'lib', 'extractor')
# require File.join(here, '..', 'lib', 'delegator')

class Minitest::Test

  OUTPUT = 'test/output'

  def clear_output
    FileUtils.rm_r(OUTPUT) if File.exists?(OUTPUT)
  end

  def teardown
    clear_output
  end

end