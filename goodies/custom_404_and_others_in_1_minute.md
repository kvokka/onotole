## Public errors customization (404,422,500...)

Today I got a task to customize errors, and found 
[one useful article](https://wearestac.com/blog/dynamic-error-pages-in-rails),
but with `Onotole` it is much easyer. You need a very little part of code.
In default pack you actually have `Hight voltage` gem, witch will make all work.
Add in your `config/application.rb` this line:
```
module MyAwesome
  class Application < Rails::Application
    ...
    config.exceptions_app = self.routes
  end
end
```
And now `Hight voltage` is in play! Make in `app/views/pages/404.html.erb` (or 
any other template) and here it is.
