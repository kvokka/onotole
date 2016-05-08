## Custom FormBuilder methods

In some moment you may catch yourself on understanding breaking DRY principles,
when you make you views. Some functionality can be easily moved to helpers, some
may be beautify by `Formtastic` or `SimpleForm`, but some stuff anyway will be 
undone, like adding some default classes to your forms or buttons or making
some own form methods. I'll implement in `Onotole` root for `FormBuilder` 
methods at `app/helpers/`, so now it is easy to extend. Here I post some chunk 
of code, like example:

```
class FormBuilderExtension < ActionView::Helpers::FormBuilder

  delegate :select_tag, to: :@template
  delegate :options_for_select, to: :@template


  def select_for_user field, select_options, user
    selected = user ? user.send(field) : ''
    options = options_for_select( select_options, selected: selected)
    select_tag field, options, include_blank: I18n.t("activerecord.attributes.user.#{field}")
  end
end
```

also, this [article](http://likeawritingdesk.com/posts/very-custom-form-builders-in-rails/) 
will be very useful for digging deeper
