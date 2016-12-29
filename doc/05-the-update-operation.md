# The Update operation

Pragma provides a default implementation of the Update operation. Here's how it works:

1. it finds an instance of the model by ID;
2. it wraps the model in the Update contract;
3. it validates and authorizes the contract;
4. it saves the record;
5. it responds with 200 OK and the decorated record.

To create an Update operation, inherit from `Pragma::Operation::Update`:

```ruby
module API
  module V1
    module Post
      module Operation
        module Update < Pragma::Operation::Update
        end
      end
    end
  end
end
```

To override the defaults of this operation, have a look at the [source code](https://github.com/pragmarb/pragma/blob/master/lib/pragma/operation/update.rb).
