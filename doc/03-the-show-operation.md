# The Show operation

Pragma provides a default implementation of the Show operation. Here's how it works:

1. it finds a record by ID;
2. it authorizes the record;
3. it responds with 200 OK and the decorated record.

To create a Show operation, inherit from `Pragma::Operation::Show`:

```ruby
module API
  module V1
    module Post
      module Operation
        module Show < Pragma::Operation::Show
        end
      end
    end
  end
end
```

To override the defaults of this operation, have a look at the [source code](https://github.com/pragmarb/pragma/blob/master/lib/pragma/operation/show.rb).
