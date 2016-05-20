module Cleaner
  class Cleaner
    class << self
      def clean(tmp_file, clean_path)
        clean_file = clean_copy(clean_path)
        File.foreach(tmp_file) do |line|
          remove_blank_line(line)
          write_line(clean_file, line)
        end
        clean_file.close
        #check if new file is cleaned (returns empty file if unsuccessful)
        !File.zero?(clean_path)
      end

      private

      def write_line(clean_file, line)
        clean_file.puts line unless line.chomp.empty?
      end

      def remove_blank_line(line)
        line.gsub!(/^\s[\r\n]+/, "")
      end

      def clean_copy(clean_path)
        File.new(clean_path, "w+")
      end
    end
  end
end