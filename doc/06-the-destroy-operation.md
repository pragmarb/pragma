# The Destroy operation

Pragma provides a default implementation of the Destroy operation. Here's how it works:

1. it finds an instance of the model by ID;
2. it authorizes the record;
3. it destroys the record;
4. it responds with 204 No Content.

To create a Destroy operation, inherit from `Pragma::Operation::Destroy`:

```ruby
module API
  module V1
    module Post
      module Operation
        module Destroy < Pragma::Operation::Destroy
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
        module Destroy < Pragma::Operation::Destroy
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

To override the policy you can call the usual `#policy`.
