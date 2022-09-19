# frozen_string_literal: true

RSpec.describe Maketable do
  let(:maketable) { Maketable::Maketable.new(test_file_calendar_pn, 2022) }
  let(:maketable_with_nil) { Maketable::Maketable.new(test_file_calendar_pn, nil) }

  it "described_class" do |_example|
    expect(described_class).to equal(Maketable)
  end

  it "has a version number" do
    expect(Maketable::VERSION).not_to be nil
  end

  it "make instance of Maketable::Maketable", xcmd: 0 do
    inst = maketable
    # puts inst
    expect(inst).to_not eq(nil)
  end

  it "analyze yaml file", yaml: true, xcmd: 1 do
    inst = maketable
    # expect(inst.analyze.size > 0).to be(true)
    # expect(inst.analyze.instance_of?(Hash)).to be(true)
    # expect(inst.analyze.keys).to be(nil)
    expect(!inst.analyze.keys.empty?).to be(true)
  end

  it "table show", xcmd: 21 do
    inst = maketable
    inst.analyze

    # inst.show_yaml
    expect do
      inst.show_yaml
      # puts("")
    end.to_not output("\n").to_stdout
  end

  it "table show in markdown format", xcmd: 22 do
    inst = maketable
    inst.analyze
    format = :markdown
    expect do
      inst.show(format)
    end.to output.to_stdout
  end

  it "make list of instance of Item", xcmd: 30 do
    start_month = 4
    expect(Maketable::Order.make_table_row_label(start_month).size).to eq(12)
  end

  context "with nil year" do
    it "fail to make instance of Maketable::Maketable", xcmd: 40 do
      expect { maketable_with_nil }.to raise_error(Maketable::InvalidYearError)
      #      expect { maketable_with_nil }.to raise_error("raise_error")
    end
  end
end
