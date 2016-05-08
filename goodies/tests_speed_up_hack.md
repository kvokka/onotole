## Make RSpec faster

There are 2 tricky methods to speed up your tests in Onotole. It made up to 25%
boost. At first you need to disable logging in tests (usually you do not read 
it). [see](http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/)

```
Rails.logger.level = 4
```

And the second one is to differ garbage collection, by adding `garbage.rb` file 

```
class DeferredGarbageCollection
  DEFERRED_GC_THRESHOLD = (ENV['DEFER_GC'] || 15.0).to_f

  @last_gc_run = Time.now

  def self.start
    GC.disable
  end

  def self.reconsider
    if Time.now - @last_gc_run >= DEFERRED_GC_THRESHOLD
      GC.enable
      GC.start
      GC.disable
      @last_gc_run = Time.now
    end
  end
end
```

And make it running with this snippet of code
```
unless ENV['DEFER_GC'] == '0' || ENV['DEFER_GC'] == 'false'
  require 'support/deferred_garbage_collection'
  RSpec.configure do |config|
    config.before(:all) { DeferredGarbageCollection.start }
    config.after(:all)  { DeferredGarbageCollection.reconsider }
  end
end
```
