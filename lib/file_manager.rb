class FileManager

  TMP_PATH = "./docs/tmp/"
  CLEAN_PATH = "./docs/clean/"
  PARSED_PATH = "./docs/parsed/"

  class << self
    def change_to(path, filter)
      if File.exist?(path)
        txt_file = get_txt_ext(path)
        case filter
        when "tmp"
          TMP_PATH + txt_file
        when "clean"
          CLEAN_PATH + txt_file
        when "parsed"
          PARSED_PATH + txt_file
        else
          raise "File path can not be changed because specified filter does not exist"
        end
      else
        raise "File path can not be changed because it does not exist"
      end
    end

    private
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