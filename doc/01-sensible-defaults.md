# Sensible defaults

This gem works best if you follow the recommended structure (partially borrowed from
[Trailblazer](https://github.com/trailblazer/trailblazer)) for organizing resources:

```
└── api
    └── v1
        └── post
            ├── contract
            │   ├── create.rb
            │   └── update.rb
            ├── operation
            │   ├── create.rb
            │   ├── destroy.rb
            │   ├── index.rb
            │   └── update.rb
            └── policy.rb
            └── decorator.rb
```

Your modules and classes would, of course, follow the same structure: `API::V1::Post::Policy`,
`API::V1::Post::Operation::Create` and so on and so forth.

If you adhere to this structure, the gem will be able to locate all of your classes without explicit
configuration (i.e. no `#policy` or `#contract` calls etc.). This will save you a lot of time and is
highly recommended, especially when used in conjunction with the provided CRUD operations.

To leverage automatic discovery, include `Pragma::Operation::Defaults` in your operation:

```ruby
module API
  module V1
    module Post
      module Operation
        class Create < Pragma::Operation::Base
          include Pragma::Operation::Defaults

          def call
            # You can use `decorate`, `validate` and `authorize` without having to explicitly
            # specify the decorator, validator and policy classes.
            #
            # ...
          end
        end
      end
    end
  end
end
```
