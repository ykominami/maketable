# frozen_string_literal: true

def check_hash_structure(obj, kind)
  valid = true
  obj.each do |k, v|
    # p v.class
    # p "=="
    ret = if kind == 4
            check_hash_structure_sub_four(v, k)
          else
            check_hash_structure_sub(v)
          end
    valid = ret if valid
  end
  valid
end

def check_hash_structure_sub(obj)
  # p obj.keys
  valid = true
  obj.each do |k, v|
    next unless k != v.size

    p "==#{k}"
    p v.class
    p v.size
    p v
    valid = false
  end
  valid
end

def check_hash_structure_sub_four(obj, key)
  valid = true
  size_list_hash = {
    1 => [12],
    2 => [6, 6],
    3 => [4, 4, 4],
    4 => [3, 3, 3, 3]
  }
  obj.each_with_index do |v, ind|
    next unless size_list_hash[key][ind] != v.size

    # p "size_list_hash[#{k}][#{ind}]=#{size_list_hash[k][ind]}"
    # p "v.size=#{v.size}"
    # p "==#{ind}"
    # p v.class
    # p v.size
    # p v
    valid = false
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
    obj = Maketable::Order.make_month_order_one(year, max)
    ret = check_hash_structure(obj, 4)
    expect(ret).to eq(true)
  end

  it "make month order 4", ycmd: 11 do
    year = 2022
    max = 12
    obj = Maketable::Order.make_month_order_four(year, max)
    ret = check_hash_structure(obj, 4)
    expect(ret).to eq(true)
  end

  it "make month order a", ycmd: 12 do
    year = 2022
    max = 12
    obj = Maketable::Order.make_month_order_a(year, max)
    # p obj
    ret = check_hash_structure(obj, 1)
    expect(ret).to eq(true)
  end

  it "regexp", ycmd: 100 do
    re_str = Regexp.escape("<<(.+)>>")
    re_label = Regexp.new(re_str)
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
