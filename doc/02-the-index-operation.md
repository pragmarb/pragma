# The Index operation

Pragma provides a default implementation of the Index operation. Here's how it works:

1. it finds all records of the model;
2. it wraps the query in the policy to only return viewable records;
3. it responds with 200 OK and a paginated list of decorated records.

To create an Index operation, inherit from `Pragma::Operation::Index`:

```ruby
module API
  module V1
    module Post
      module Operation
        module Index < Pragma::Operation::Index
        end
      end
    end
  end
end
```

## Overriding defaults

You can override the record retrieval logic by overriding `#find_records`:

```ruby
module API
  module V1
    module Post
      module Operation
        module Index < Pragma::Operation::Index
          private

          def find_records
            ::Post.all
          end
        end
      end
    end
  end
end
```

To override the decorator you can call the usual `#decorator`.
