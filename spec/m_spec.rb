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

def check_hash_structure(obj, kind)
  valid = true
  obj.each do |k,v|
    #p v.class
    #p "=="
    if kind == 4
      ret = check_hash_structure_sub_4(v, k)
    else
      ret = check_hash_structure_sub(v)
    end
    valid = ret if valid
  end
  valid
end

def check_hash_structure_sub(obj)
  #p obj.keys
  valid = true
  obj.each do |k,v|
    if k != v.size
      p "==#{k}"
      p v.class
      p v.size
      p v
      valid = false
    end
  end
  valid
end

def check_hash_structure_sub_4(obj, k)
  #p obj.keys
  valid = true
  size_list_hash = {
    1 => [12],
    2 => [6, 6],
    3 => [4, 4, 4],
    4 => [3, 3, 3, 3]
  }
  obj.each_with_index do |v, ind|
    #p "#######=== k=#{k} ind=#{ind}"
    if size_list_hash[k][ind] != v.size
      p "size_list_hash[#{k}][#{ind}]=#{size_list_hash[k][ind]}"
      p "v.size=#{v.size}"
      p "==#{ind}"
      p v.class
      p v.size
      p v
      valid = false
    end
  end
  valid
end

RSpec.describe "M" do
  it "Date List", ycmd: 1 do
    year = 2022
    month = 4
    max = 12
    expect(Maketable::Util.make_date_list(year, month, max).size).to eq(12)
  end

  it "DateTime Hash", ycmd: 2 do
    year = 2022
    month = 4
    max = 12
    expect(Maketable::Util.make_date_hash(year, month, max).size).to eq(12)
  end

  it "make month order", ycmd: 3 do
    year = 2022
    start_month = 4
    max = 12
    obj = Maketable::Order.make_month_order(year, start_month, max)
    ret = check_hash_structure(obj, 1)
    expect(ret).to eq(true)
  end

  it "make month order 1", ycmd: 10 do
    year = 2022
    max = 12
    obj = Maketable::Order.make_month_order_1(year, max)
    ret = check_hash_structure(obj, 4)
    expect(ret).to eq(true)
  end

  it "make month order 4", ycmd: 11 do
    year = 2022
    max = 12
    obj = Maketable::Order.make_month_order_4(year, max)
    ret = check_hash_structure(obj, 4)
    expect(ret).to eq(true)
  end

  it "make month order a", ycmd: 12 do
    year = 2022
    max = 12
    obj = Maketable::Order.make_month_order_a(year, max)
    #p obj
    ret = check_hash_structure(obj, 1)
    expect(ret).to eq(true)
  end

  it "regexp" , ycmd: 100 do
    re_str = Regexp.escape("<<(.+)>>")
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
