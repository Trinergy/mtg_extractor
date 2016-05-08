class Cleaner

  class << self

    def clean(tmp_file, clean_path)
      clean_file = clean_copy(clean_path)

      File.foreach(tmp_file) do |line|
        remove_blank_line(line)
        write_line(clean_file, line)
      end
      clean_file.close
      clean_succ?(clean_path)
    end

    def write_line(clean_file, line)
      clean_file.puts line unless line.chomp.empty?
    end

    def remove_blank_line(line)
      line.gsub!(/^\s[\r\n]+/, "")
    end

    def clean_copy(clean_path)
      File.new(clean_path, "w")
    end

    def clean_succ?(clean_path)
      !File.zero?(clean_path)
    end
  end
end