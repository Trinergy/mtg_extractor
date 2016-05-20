module Extractor
  class Extractor

    class << self

      def extract(clean_file, parsed_path, str)
        if File.exist?(clean_file) && !File.zero?(clean_file)
          all_lineno = get_lineno(clean_file, str)
          write_parsed_copy(clean_file, parsed_path, all_lineno)
          !File.zero?(parsed_path)
        else
          raise "#{clean_file} could not be extracted because it is either empty or does not exist"
        end
      end

      private

      def write_parsed_copy(clean_file, parsed_path, all_lineno)
        parsed_file = parsed_copy(parsed_path)
        all_lineno.each do |field|
          field.each do |lineno|
            if lineno == "N/A"
              parsed_file.puts lineno
            else
              file = File.open(clean_file)
              lineno.times{file.gets}
              parsed_file.puts $_
              file.close
            end
          end
        end
        parsed_file.close
      end

      def get_lineno(clean_file, str)
        target_field = get_regex(str)

        field_lineno = get_field(clean_file, target_field)
        all_lineno = get_field_content(clean_file, field_lineno)

        all_lineno
      end

      def get_field(clean_file, target_field)
        field_lineno = []
        File.foreach(clean_file).with_index do |line,lineno|
          if target_field.match(line)
            field_lineno.push([lineno + 1])
          end
        end
        field_lineno
      end

      def get_field_content(clean_file, field_lineno)
        field_lineno.each do |field|
          field.each do |lineno|
            if use_next_line?(clean_file, lineno)
              file = File.open(clean_file)
              next_line = lineno + 1
              next_line.times{file.gets}
              if !$_.include?(":")
                field.push(next_line)
              else
                field.push("N/A")
              end
              file.close
            end
          end
        end
      end

      def use_next_line?(clean_file, lineno)
        if lineno != "N/A"
          file = File.open(clean_file)
          lineno.times{file.gets}
          partition = $_.partition(":")
          next_line = partition[2].length == 1 ? true : false
          file.close

          next_line
        end
      end

      def get_regex(str)
        Regexp.new(str, true)
      end

      def parsed_copy(parsed_path)
        File.new(parsed_path, "a")
      end
    end
  end
end