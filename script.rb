module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    k = 0
    while k < to_a.length
      yield to_a[k]
      k += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    k = 0
    while k < to_a.length
      yield(to_a[k], k)
      k += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    final = []
    num = [Hash, Range].member?(self.class) ? to_a.flatten : self
    k = 0
    count do
      final << num[k] if yield(num[k])
      k += 1
    end
    final
  end

  def my_all?(block = nil)
    my_each do |re|
      if block_given?
        return false unless yield re
      elsif block.instance_of?(Regexp)
        return false unless block =~ re
      elsif block.instance_of?(Class)
        return false unless [re.class, re.class.superclass].include?(block)
      elsif !block.nil?
        return false unless re == block
      else
        return false unless re
      end
    end
    true
  end

  def my_any?(block = nil)
    arr = to_a
    return false if (arr - [nil, false]) == []

    my_each do |re|
      if block_given?
        return true if yield re
      elsif block.instance_of?(Regexp)
        return true if block =~ re
      elsif block.instance_of?(Class)
        return true if [re.class, re.class.superclass].include?(block)
      elsif !block.nil?
        my_boolean = false
        arr.each do |i|
          my_boolean = true if i == block
        end
        return my_boolean
      else
        return true unless re
      end
    end
    return true if block.nil? && !block_given?

    false
  end
end
