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

## Overriding defaults

You can override the record retrieval logic by overriding the `#find_record` method:

```ruby
module API
  module V1
    module Post
      module Operation
        module Update < Pragma::Operation::Update
          private

          def find_record
            ::Post.find(params[:id])
          end
        end
      end
    end
  end
end
```

To override the policy, contract and decorator you can call the usual `#policy`, `#contract` and
`#decorator`.
