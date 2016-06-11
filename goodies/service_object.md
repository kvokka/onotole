## Service Object

The is a pretty standard pattern in `Ruby`, when you use standard classes for 
some purposes, and this pattern usually is called as Service Object.

There are 2 types of it: which will be instantiated, and witch will be like some
methods bag. In this article I'll talk about second type only. The easiest way to
implement it is to use standard `Ruby` class, like
```
class Foo
  def self.call
    puts 42
  end
end
```
but it can be instantiated. It is not right! So we should `include Singleton` 
module from `stdlib`, or do this work manually, mainly move #new method to 
private group or undefine it. 

The second way is to go upper and use `Module` as descendant, so code will be
like
```
module Foo
  def self.call
    puts 42
  end
end
```
Now we have no problems with instances, but we still have `Module` methods, which
are unused in this approach. So, we can dig dipper and inherit from Object
```
class << FOO ||= Object.new
  def call
    puts 42
  end
end
```
So we have no unused behavior and get cleaner code. Just new `Object` with pack
of singleton methods, and because it have class name, we use `||=` for preventing 
multiple assigns, which will boost our code. Perfect!

Of course the is some feature on this approach. If you change `FOO#call` method 
later, and then `require` again file with initial code of `FOO` it will not 
restore method to initial state. But it is weeery unusual.

You may call it `Foo`, of course, but you will avoid the convention in this 
case.
