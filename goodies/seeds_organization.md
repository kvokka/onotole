In some projects I've got a lot of data, which need to be loaded in db and Rails
provide simple tool for it: `seeds.rb`. But it can come ugly and hard 
supportable it few days and you may do simple 1000 strings of code, which will
become unsupportable in a moment. Easiest way to prevent it: split seeds.
I provide simple way, you add in `seeds.rb` this snippet of code

```
seed_files_list = Dir[File.join(Rails.root, "db", "seeds", "*.rb")]
seed_files_list.sort.each_with_index do |seed, i|
  load seed
  puts "Progress #{i + 1}/#{seed_files_list.length}. Seed #{seed.split('/').last.sub(/.rb$/, '')} loaded"
end
```

So now you will autoload all files from seeds folder and get pretty notify.
Easiest way to organize line it to name files with priority number like:

> `001_admin_user.rb`
> `080_products.rb`
> `500_comments.rb`
