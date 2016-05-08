class FileManager

  TMP_PATH = "./docs/tmp/"
  CLEAN_PATH = "./docs/clean/"
  PARSED_PATH = "./docs/parsed/"

  class << self

    def tmp_path(path)
      TMP_PATH + get_txt_ext(path)
    end

    def parsed_path(path)
      PARSED_PATH + File.basename(path)
    end

    def clean_path(path)
      CLEAN_PATH + File.basename(path)
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