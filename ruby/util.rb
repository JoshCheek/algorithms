module Util
  def self.with_file_arg(filename, arg_position = 0, &block)
    if filename == $0
      file_path = ARGV[arg_position]
      File.open(file_path) do |f|
        yield(f)
      end
    end
  end
end
