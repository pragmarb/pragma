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
configuration (i.e. no `#policy` or `#contract` calls etc.).

This will save you a lot of time and is highly recommended, especially when used in conjunction with
the provided CRUD operations. If no policy or contract are specified, then the provided operations
will simply skip the authorization/validation step.
