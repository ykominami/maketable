# frozen_string_literal: true

RSpec.describe Maketable::LimitedMarkDown do
  def test_file_base_pn
    if ENV["TEST_DATA_DIR"]
      Pathname.new(ENV["TEST_DATA_DIR"])
    else
      Maketable::TEST_DATA_DIR
    end
  end

  def test_file_pn
    @test_file_pn = test_file_base_pn.join("test.yml")
  end

  def test_file_x_pn(fname)
    @test_file_pn = test_file_base_pn.join(fname)
  end

  def maketable_with_nil
    Maketable::Md2table.new(test_file_pn, nil)
  end

  it "described_class" do |_example|
    expect(described_class).to equal(Maketable::LimitedMarkDown)
  end

  it "has a version number" do
    expect(Maketable::VERSION).not_to be nil
  end

  it "make instance of Maketable::LimitedMarkDown" , xcmd: 1 do
    inst = md2table_task_no_test_data
    expect(inst).to_not eq(nil)
  end

  it "make table in trac wiki format from yaml file", yaml: true, xcmd: 2 do
    yaml_file = test_file_x_pn("task_no_test_data.yaml")
    lmd , hs = Maketable::LimitedMarkDown.create_from_yaml_file(yaml_file)
    str = lmd.md2table(hs["columns_count"], hs["headers"], hs["table_format"].to_sym, hs["fields"])
    #puts(str)
    lmd.output(str)

    expect(str).to_not eq(nil)
  end

  it "make table in markdonw format from yaml file", yaml: true, xcmd: 3 do
    yaml_file = test_file_x_pn("task_no_test_data_markdown.yaml")
    lmd , hs = Maketable::LimitedMarkDown.create_from_yaml_file(yaml_file)
    pp hs
    str = lmd.md2table(hs["columns_count"], hs["headers"], hs["table_format"].to_sym, hs["fields"])
    #puts(str)
    lmd.output(str)

    expect(str).to_not eq(nil)
  end
end
