# frozen_string_literal: true

def capture(stream)
  begin
    stream = stream.to_s
    eval "$#{stream} = StringIO.new"
    yield
    result = eval("$#{stream}").string
  ensure
    eval "$#{stream} = #{stream.upcase}"
  end
  result
end

RSpec.describe "M" do
  it "DateTime List", ycmd: 1 do
    year = 2022
    month = 4
    max = 12
    expect(Maketable::Util.make_datetime_list(year, month, max).size).to eq(12)
  end

  it "DateTime Hash", ycmd: 2 do
    year = 2022
    month = 4
    max = 12
    expect(Maketable::Util.make_datetime_hash(year, month, max).size).to eq(12)
  end

  it "make month order", ycmd: 3 do
    year = 2022
    start_month = 4
    max = 12
    obj = Maketable::Order.make_month_order(year, start_month, max)
    p obj
    expect(obj).to eq(nil)
  end

  it "make month order 1", ycmd: 10 do
    year = 2022
    max = 12
    obj = Maketable::Order.make_month_order_1(year, max)
    p obj
    expect(obj).to eq(nil)
  end

  it "make month order 4", ycmd: 11 do
    year = 2022
    max = 12
    obj = Maketable::Order.make_month_order_4(year, max)
    p obj
    expect(obj).to eq(nil)
  end

  it "make month order a", ycmd: 12 do
    year = 2022
    max = 12
    obj = Maketable::Order.make_month_order_a(year, max)
    p obj
    expect(obj).to eq(nil)
  end

  it "regexp" , ycmd: 100 do
#    re_label = Regexp.new("(.+)\[<(.+)>\]")

    #re_str = Regexp.escape("(.+)<<(.+)>>")
    re_str = Regexp.escape("<<(.+)>>")
    #p re_str
    re_label = Regexp.new(re_str)

    #re_label = Regexp.new("[<(.+)>]")
    #re_label = Regexp.new("<(.+)>")
    #re_label = Regexp.new("(\[<)(.+)(>\])")
    #re_label = Regexp.new("(.+)")
    str = "開発者会議2022 <<開会>>"
    result = re_label.match(str)
    if result
      p "[0] #{Regexp.last_match[0]}"
      p "[1] #{Regexp.last_match[1]}"
      p "[2] #{Regexp.last_match[2]}"
      p "[3] #{Regexp.last_match[3]}"
    end
    expect(result).to eq(nil)

  end
end
