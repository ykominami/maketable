# frozen_string_literal: true

RSpec.describe Maketable do
  def test_file_pn
    @test_file_pn ||= Maketable::TEST_DATA_DIR + "test.yml"
  end

  def test_file_x_pn(fname)
    Maketable::TEST_DATA_DIR + fname
  end

  let(:maketable) { Maketable::Maketable.new(test_file_pn, 2022) }
  let(:maketable_a) { Maketable::Maketable.new(test_file_x_pn("test_a.yml"), 2022) }
  let(:maketable_b) { Maketable::Maketable.new(test_file_x_pn("test_b.yml"), 2022) }

  def maketable_with_nil
    Maketable::Maketable.new(test_file_pn, nil)
  end

  it "described_class" do |_example|
    expect(described_class).to equal(Maketable)
  end

  it "has a version number" do
    expect(Maketable::VERSION).not_to be nil
  end

  it "make instance of Maketable::Maketable" do
    inst = maketable
    expect(inst).to_not eq(nil)
  end

  it "analyze yaml file", yaml: true, xcmd: 1 do
    inst = maketable
    expect(inst.analyze).to_not eq(nil)
  end

  it "table output", xcmd: 21 do
    inst = maketable
    inst.analyze
    expect(inst.output).to_not eq(nil)
  end

  it "table output in markdown format", xcmd: 22 do
    inst = maketable
    inst.analyze
    format = :markdown
    expect(inst.output(format)).to_not eq(nil)
  end

  it "analyze yaml file_a", yaml: true, xcmd: 2 do
    inst = maketable_a
    expect(inst.analyze).to_not eq(nil)
  end

  it "make list of instance of Item", xcmd: 30 do
    start_month = 4
    expect(Maketable::Order.make_table_row_label(start_month).size).to eq(12)
  end

  it "table output by test_b.yml", xcmd: 40 do
    inst = maketable_b
    inst.analyze
    expect(inst.output).to_not eq(nil)
  end

  context "with nil year" do
    it "fail to make instance of Maketable::Maketable" do
      expect { maketable_with_nil }.to raise_error(Maketable::InvalidYearError)
      #      expect { maketable_with_nil }.to raise_error("raise_error")
    end
  end
end
