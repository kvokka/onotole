### Mailcatcher on load error

I got in love in `Mailcather` project, but there is one dizzy feature in it- if 
in your controller must be sent some mail and `Mailcatcher` daemon is not running
you will have an error (and it is oblivious). The is a sample code

```
  def create
    @review = Review.new(review_params)
    if @review.save
      flash.now[:notice] = "All ok!"
      Mailer.review_for_admin(@review).deliver  # <- Here it is
      respond_to do |format|
        format.js { render partial: "reviews/create" }
      end
    else
      flash.now[:alert] = @review.errors.full_messages.join(", ")
      respond_to do |format|
        format.js { render partial: "pages/flash" }
      end
    end
  end
```

Actually, you test mail services not very often, and, it will be good enough, if 
there will not be unneeded error and mail will be sent in 
`action_mailer.delivery_method = :test` or `action_mailer.delivery_method = :file`
mode. I preferred the second method. And there is the code, which it implements 
in `delelodment.rb`

``` 
Rails.application.configure do
  ...
  if system ('lsof -i :1025 | grep mailcatch > /dev/null')
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = { address: "localhost", port: 1025 }
  else
    config.action_mailer.delivery_method = :file
  end
end
```

This code will run only once, when `rails server` starts, so, it will not slow 
down your system. I hope it was useful!

[Kvoka](https://github.com/kvokka/)

PS: You may need to install `lsof` utility, if you have no it.
`sudo apt-get install lsof` will help in this case.

