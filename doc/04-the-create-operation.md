# The Create operation

Pragma provides a default implementation of the Create operation. Here's how it works:

1. it builds a new instance of the model;
2. it wraps the model in the Create contract;
3. it validates and authorizes the contract;
4. it saves the record;
5. it responds with 201 Created and the decorated record.

To create a Create operation (pun intended), inherit from `Pragma::Operation::Create`:

```ruby
module API
  module V1
    module Post
      module Operation
        module Create < Pragma::Operation::Create
        end
      end
    end
  end
end
```

To override the defaults of this operation, have a look at the [source code](https://github.com/pragmarb/pragma/blob/master/lib/pragma/operation/create.rb).
