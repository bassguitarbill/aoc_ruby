class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    gsub(/([a-z])(\d+\/)/,'\1_\2').
    tr("-", "_").
    downcase
  end
end

module AdventOfCodeRuby
  module Input
    def load_file(file_name: "input.txt")
      File.read(File.join(lib_folder, self.class.name.underscore.gsub(/\/[a-z_]*$/, "/#{file_name}")))
    end

    def lib_folder
      File.join(File.dirname(__FILE__), '../../lib')
    end
  end
end
