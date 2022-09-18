# frozen_string_literal: true

RSpec.describe Maketable::LimitedMarkDown do
  it "make table in trac wiki format from yaml file", yaml: true, xcmd: 2 do
    yaml_file = test_file_x_pn("task_no_test_data_markdown.yaml")
    # input_file=
    lmd, hs = Maketable::LimitedMarkDown.create_md_from_setting_yaml_file(yaml_file)
    str = lmd.md2table(hs["columns_count"], hs["headers"], hs["table_format"].to_sym, hs["fields"])
    # puts(str)
    lmd.output_file(str)

    expect(str).to_not eq(nil)
  end
  #   it "" do
  #     lmd , hs = Maketable::LimitedMarkDown.create_md_from_setting_yaml_file(yaml_file)
  #     str = lmd.md2table(hs["columns_count"], hs["headers"], hs["table_format"], hs["fields"])
  #   end
end
