# frozen_string_literal: true

RSpec.describe Maketable::LimitedMarkDown do
  let(:taskc_markdown_yaml) { test_file_x_pn("taskc_markdown.yaml") }
  let(:taskc_trac_wiki_yaml) { test_file_x_pn("taskc_trac_wiki.yaml") }

  it "make table in trac wiki format from yaml file", yaml: true, ycmd: 1 do
    yaml_file = taskc_markdown_yaml
    puts "yaml_file=#{yaml_file}"
    # input_file=
    lmd, hs = Maketable::LimitedMarkDown.create_md_from_setting_yaml_file(yaml_file)
    str = lmd.md2table(hs["columns_count"], hs["headers"], hs["table_format"].to_sym, hs["fields"])
    # puts(str)
    lmd.output_file(str)

    expect(str).to_not eq(nil)
  end

  it "make table in trac wiki format from yaml file", yaml: true, ycmd: 2 do
    yaml_file = taskc_trac_wiki_yaml
    puts "yaml_file=#{yaml_file}"
    # input_file=
    lmd, hs = Maketable::LimitedMarkDown.create_md_from_setting_yaml_file(yaml_file)
    str = lmd.md2table(hs["columns_count"], hs["headers"], hs["table_format"].to_sym, hs["fields"])
    # puts(str)
    lmd.output_file(str)

    expect(str).to_not eq(nil)
  end
end
