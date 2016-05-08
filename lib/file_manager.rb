class FileManager

  TMP_PATH = "./docs/tmp/"
  CLEAN_PATH = "./docs/clean/"
  PARSED_PATH = "./docs/parsed/"

  class << self

    def change_to(path, filter)
      txt_file = get_txt_ext(path)
      case filter
      when "tmp"
        TMP_PATH + txt_file
      when "clean"
        CLEAN_PATH + txt_file
      when "parsed"
        PARSED_PATH + txt_file
      else
        raise "File path can not be changed"
      end
    end

    def get_txt_ext(file)
      ext = File.extname(file)

      if ext.empty?
        File.basename(file) + ".txt"
      else
        replace = Regexp.new(ext, true)
        File.basename(file).gsub(replace, ".txt")
      end
    end

  end

end