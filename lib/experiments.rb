class MyClass
  def method &block
    block.call
  end

  def method_missing name, *args
    puts name
  end
end

MyClass.new.method do
  puts x
end