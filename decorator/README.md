# Pragma::Decorator

[![Build Status](https://travis-ci.org/pragmarb/pragma-decorator.svg?branch=master)](https://travis-ci.org/pragmarb/pragma-decorator)
[![Coverage Status](https://coveralls.io/repos/github/pragmarb/pragma-decorator/badge.svg?branch=master)](https://coveralls.io/github/pragmarb/pragma-decorator?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/e51e8d7489eb72ab97ba/maintainability)](https://codeclimate.com/github/pragmarb/pragma-decorator/maintainability)

Decorators are a way to easily convert your API resources to JSON with minimum hassle.

They are built on top of [ROAR](https://github.com/apotonick/roar). We provide some useful helpers
for rendering collections, expanding associations and much more.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pragma-decorator'
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install pragma-decorator
```

## Usage

Creating a decorator is as simple as inheriting from `Pragma::Decorator::Base`:

```ruby
module API
  module V1
    module User
      module Decorator
        class Instance < Pragma::Decorator::Base
          property :id
          property :email
          property :full_name
        end
      end
    end
  end
end
```

Just instantiate the decorator by passing it an object to decorate, then call `#to_hash` or
`#to_json`:

```ruby
decorator = API::V1::User::Decorator::Instance.new(user)
decorator.to_json
```

This will produce the following JSON:

```json
{
  "id": 1,
  "email": "jdoe@example.com",
  "full_name": "John Doe"
}
```

Since Pragma::Decorator is built on top of [ROAR](https://github.com/apotonick/roar) (which, in
turn, is built on top of [Representable](https://github.com/apotonick/representable)), you should
consult their documentation for the basic usage of decorators; the rest of this section only covers
the features provided specifically by Pragma::Decorator.

### Object Types

It is recommended that decorators expose the type of the decorated object. You can achieve this
with the `Type` mixin:

```ruby
module API
  module V1
    module User
      module Decorator
        class Instance < Pragma::Decorator::Base
          include Pragma::Decorator::Type
        end
      end
    end
  end
end
```

This would result in the following representation:

```json
{
  "type": "user",
  "...": "..."
}
```

You can also set a custom type name (just make sure to use it consistently!):

```ruby
module API
  module V1
    module User
      module Decorator
        class Instance < Pragma::Decorator::Base
          def type
            :custom_type
          end
        end
      end
    end
  end
end
```

`Array` and `ActiveRecord::Relation` are already overridden as `list` to avoid exposing internal
details. If you want to specify your own global overrides, you can do it by adding entries to the
`Pragma::Decorator::Type.overrides` hash:

```ruby
Pragma::Decorator::Type.overrides['Article'] = 'post'
```

### Timestamps

[UNIX time](https://en.wikipedia.org/wiki/Unix_time) is your safest bet when rendering/parsing
timestamps in your API, as it doesn't require a timezone indicator (the timezone is always UTC).

You can use the `Timestamp` mixin for converting `Time` instances to UNIX times:

```ruby
module API
  module V1
    module User
      module Decorator
        class Instance < Pragma::Decorator::Base
          include Pragma::Decorator::Timestamp

          timestamp :created_at
        end
      end
    end
  end
end
```

This will render a user like this:

```json
{
  "type": "user",
  "created_at": 1480287994
}
```

The `#timestamp` method supports all the options supported by `#property`.

### Associations

`Pragma::Decorator::Association` allows you to define associations in your decorator (currently,
only `belongs_to`/`has_one` associations are supported):

```ruby
module API
  module V1
    module Invoice
      module Decorator
        class Instance < Pragma::Decorator::Base
          include Pragma::Decorator::Association

          belongs_to :customer, decorator: API::V1::Customer::Decorator::Instance
        end
      end
    end
  end
end
```

Rendering an invoice will now create the following representation:

```json
{
  "customer": 19
}
```

You can pass `expand[]=customer` as a request parameter and have the `customer` property expanded
into a full object!

```json
{
  "customer": {
    "id": 19,
    "...": "..."
  }
}
```

This also works for nested associations. For instance, if the customer decorator had a `company`
association, you could pass `expand[]=customer&expand[]=customer.company` to get the company
expanded too.

Note that you will have to pass the associations to expand as a user option when rendering:

```ruby
decorator = API::V1::Invoice::Decorator::Instance.new(invoice)
decorator.to_json(user_options: {
  expand: ['customer', 'customer.company', 'customer.company.contact']
})
```

Needless to say, this is done automatically for you when you use all components together through
the [pragma](https://github.com/pragmarb/pragma) gem! :)

Associations support all the options supported by `#property`. Additionally, `decorator` can be a
callable object, which is useful for polymorphic associations:

```ruby
module API
  module V1
    module Discount
      module Decorator
        class Instance < Pragma::Decorator::Base
          include Pragma::Decorator::Association

          belongs_to :discountable, decorator: -> (discountable) {
            "API::V1::#{discountable.class}::Decorator::Instance".constantize
          }
        end
      end
    end
  end
end
```

### Collection

`Pragma::Decorator::Collection` wraps collections in a `data` property so that you can include
metadata about them:

```ruby
module API
  module V1
    module Invoice
      module Decorator
        class Collection < Pragma::Decorator::Base
          include Pragma::Decorator::Collection
          decorate_with Instance # this is optional, the default is 'Instance'

          property :total_cents, exec_context: :decorator

          def total_cents
            represented.sum(:total_cents)
          end
        end
      end
    end
  end
end
```

You can now do this:

```ruby
API::V1::Invoice::Decorator::Collection.new(Invoice.all).to_json
```

Which will produce the following JSON:

```json
{
  "data": [{
    "id": 1,
    "total_cents": 1500,
  }, {
    "id": 2,
    "total_cents": 3000,
  }],
  "total_cents": 4500
}
```

This is very useful, for instance, when you have a paginated collection, but want to include data
about the entire collection (not just the current page) in the response.

### Pagination

Speaking of pagination, you can use `Pragma::Decorator::Pagination` in combination with
`Collection` to include pagination data in your response:

```ruby
module API
  module V1
    module Invoice
      module Decorator
        class Collection < Pragma::Decorator::Base
          include Pragma::Decorator::Collection
          include Pragma::Decorator::Pagination

          decorate_with Instance
        end
      end
    end
  end
end
```

Now, you can run this code:

```ruby
API::V1::Invoice::Decorator::Collection.new(Invoice.all).to_json
```

Which will produce the following JSON:

```json
{
  "data": [{
    "id": 1,
    "...": "...",
  }, {
    "id": 2,
    "...": "...",
  }],
  "total_entries": 2,
  "per_page": 30,
  "total_pages": 1,
  "previous_page": null,
  "current_page": 1,
  "next_page": null
}
```

It works with both [will_paginate](https://github.com/mislav/will_paginate) and
[Kaminari](https://github.com/kaminari/kaminari)!

### Restricting property visibility

If you want to show or hide certain properties programmatically, you can do it with the `if` option:

```ruby
module API
  module V1
    module User
      module Decorator
        class Instance < Pragma::Decorator::Base
          property :id
          property :first_name
          property :last_name
          property :email, if: -> (user_options:, decorated:, **) {
            # Only show the email to admins or to the same user.
            user_options[:current_user].admin? || user_options[:current_user] == decorated
          }
        end
      end
    end
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pragmarb/pragma-decorator.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
