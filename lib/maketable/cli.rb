# frozen_string_literal: true

module Maketable
  # コマンドラインクラス
  class Cli
    def self.test_file_base_pn
      if ENV["TEST_DATA_DIR"]
        Pathname.new(ENV["TEST_DATA_DIR"])
      else
        Maketable::TEST_DATA_DIR
      end
    end

    def self.test_file_pn
      @test_file_pn = test_file_base_pn.join("test.yml")
    end

    def self.test_file_x_pn(fname)
      @test_file_pn = test_file_base_pn.join(fname)
    end

    def self.load_setting_yaml_file(yaml_file)
      yaml_file_pn = Pathname.new(yaml_file)
      yaml_file_parent_pn = yaml_file_pn.parent
      obj = YAML.load_file(yaml_file_pn)
      input_file_pn = Pathname.new(obj["input_file"])
      output_file_pn = Pathname.new(obj["output_file"])

      obj["input_file"] = yaml_file_parent_pn.join(input_file_pn) unless input_file_pn.exist?
      obj["output_file"] = yaml_file_parent_pn.join(output_file_pn) unless output_file_pn.exist?
      if obj["output_md_file"]
        output_md_file_pn = Pathname.new(obj["output_md_file"])
        obj["output_md_file"] = yaml_file_parent_pn.join(output_md_file_pn) unless output_md_file_pn.exist?
      end
      obj["fields"].map do |hash|
        hash["re"] = Regexp.new("^#{hash["name"]}:([^|]*)$")
      end
      obj
    end
  end
end
