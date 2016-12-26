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

## Overriding defaults

You can override the record retrieval logic by overriding `#find_record`:

```ruby
module API
  module V1
    module Post
      module Operation
        module Show < Pragma::Operation::Show
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

To override the decorator you can call the usual `#instance_decorator`.
