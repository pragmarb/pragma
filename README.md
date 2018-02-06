# Pragma

[![Build Status](https://travis-ci.org/pragmarb/pragma.svg?branch=master)](https://travis-ci.org/pragmarb/pragma)
[![Dependency Status](https://gemnasium.com/badges/github.com/pragmarb/pragma.svg)](https://gemnasium.com/github.com/pragmarb/pragma)
[![Coverage Status](https://coveralls.io/repos/github/pragmarb/pragma/badge.svg?branch=master)](https://coveralls.io/github/pragmarb/pragma?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/e51e8d7489eb72ab97ba/maintainability)](https://codeclimate.com/github/pragmarb/pragma/maintainability)

Welcome to Pragma, an expressive, opinionated ecosystem for building beautiful RESTful APIs with 
Ruby.

You can think of this as a meta-gem that pulls in the following pieces:

- [Pragma::Operation](https://github.com/pragmarb/pragma-operation);
- [Pragma::Policy](https://github.com/pragmarb/pragma-policy);
- [Pragma::Decorator](https://github.com/pragmarb/pragma-decorator);
- [Pragma::Contract](https://github.com/pragmarb/pragma-contract).

Additionally, it also provides default CRUD operations that leverage all of the Pragma components
and will make creating new resources in your API a breeze.

Looking for a Rails integration? Check out [pragma-rails](https://github.com/pragmarb/pragma-rails)!

## Philosophy

Pragma was created with a very specific goal in mind: to make the development of JSON APIs a matter
of hours, not days. In other words, Pragma is for JSON APIs what Rails is for web applications.

Here are the ground rules:

1. **Pragma is opinionated.** With Pragma, you don't get to make a lot of choices and that's
   _exactly_ why people are using it: they want to focus on the business logic of their API rather
   than the useless details. We understand this approach will not work in some cases and that's
   alright. If you need more personalization, only use a subset of Pragma (see item 2) or something
   else.
2. **Pragma is modular.** Pragma is built as a set of gems (currently 6), plus some standalone
   tools. You can pick one or more modules and use them in your application as you see fit. Even
   though they are completely independent from each other, they nicely integrate and work best when
   used together, creating an ecosystem that will dramatically speed up your design and development
   process.
3. **Pragma is designed to be Rails-free.** Just as what happens with Trailblazer, our Rails 
   integration is decoupled from the rest of the ecosystem and all of the gems can be used without 
   Rails. This is just a byproduct of the project's design: Pragma is built with pure Ruby.
   [pragma-rails](https://github.com/pragmarb/pragma-rails) is the only available framework 
   integration at the moment, but more will come! 

### Why not Trailblazer?

[Trailblazer](https://github.com/trailblazer/trailblazer) and all of its companion projects are
awesome. They are so awesome that Pragma is built on top of them: even though we're not using
the Trailblazer gem itself yet, many of the Pragma gems are simply extensions of their Trailblazer
counterparts:

- decorators are [ROAR representers](https://github.com/apotonick/roar);
- contracts are [Reform forms](https://github.com/apotonick/reform);
- operations are [Trailblazer operations](https://github.com/trailblazer/trailblazer-operation).

Trailblazer and Pragma have different (but similar) places in the Ruby world: Trailblazer is an
architecture for building all kinds of web applications in an intelligent, rational way, while
Pragma is an architecture for building JSON APIs. We have shamelessly taken all of the flexibility
and awesomeness from the Trailblazer project and restricted it to a narrow field of work, providing
tools, helpers and integrations that could never be part of Trailblazer due to their specificity.

Thank you, guys!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pragma'
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install pragma
```

## Usage

### Project Structure

This gem works best if you follow the recommended structure for organizing resources:

```
└── api
    └── v1
        └── article
            ├── contract
            │   ├── create.rb
            │   └── update.rb
            ├── operation
            │   ├── create.rb
            │   ├── destroy.rb
            │   ├── index.rb
            │   └── update.rb
            └── decorator
            |   ├── collection.rb
            |   └── instance.rb
            └── policy.rb
```

Your modules and classes would, of course, follow the same structure: `API::V1::Article::Policy` and 
so on and so forth.

If you adhere to this structure, the gem will be able to locate all of your classes without any
explicit configuration. This will save you a lot of time and is highly recommended.

### Fantastic Five

Pragma comes with five built-in operations, often referred to as Fantastic Five (or "FF" for 
brevity). They are, of course, Index, Show, Create, Update and Destroy. 

These operations leverage the full power of the integrated Pragma ecosystem and require all four 
components to be properly installed and configured in your application. You may reconfigure them
to skip some of the steps, but it is highly recommended to use them as they come.

You can find these operations under [lib/pragma/operation](https://github.com/pragmarb/pragma/tree/master/lib/pragma/operation).
To use them, simply create your own operations and inherit from ours. For instance:

```ruby
module API
  module V1
    module Article
      module Operation
        class Create < Pragma::Operation::Create
          # This assumes that you have the following:
          #   1) an Article model
          #   2) a Policy (responding to #create?)
          #   3) a Create contract
          #   4) an Instance decorator
        end
      end
    end
  end
end
```

## Macros

The FF are implemented through their own set of macros, which take care of stuff like authorizing,
paginating, filtering etc.

If you want, you can use these macros in your own operations.

### Classes

**Used in:** Index, Show, Create, Update, Destroy

The `Classes` macro is responsible of tying together all the Pragma components: put it into an
operation and it will determine the class names of the related policy, model, decorators and 
contract. You can override any of these classes when defining the operation or at runtime if you
wish.

Example usage:

```ruby
module API
  module V1
    module Article
      module Operation
        class Create < Pragma::Operation::Base
          # Let the macro figure out class names.
          step Pragma::Macro::Classes()
          step :execute!
          
          # But override the contract.
          self['contract.default.class'] = Contract::CustomCreate
          
          def execute!(options)
            # `options` contains the following:
            #    
            #    `model.class`
            #    `policy.default.class`
            #    `policy.default.scope.class`
            #    `decorator.instance.class`
            #    `decorator.collection.class`
            #    `contract.default.class` 
            #    
            # These will be `nil` if the expected classes do not exist.
          end
        end
      end
    end
  end
end
```

### Model

**Used in:** Index, Show, Create, Update, Destroy

The `Model` macro provides support for performing different operations with models. It can either
build a new instance of the model, if you are creating a new record, for instance, or it can find
an existing record by ID.

Example of building a new record:

```ruby
module API
  module V1
    module Article
      module Operation
        class Create < Pragma::Operation::Base
          # This step can be done by Classes if you want.
          self['model.class'] = ::Article
           
          step Pragma::Macro::Model(:build)
          step :save!
          
          def save!(options)
            # Here you'd usually validate and assign parameters before saving.
  
            # ...
  
            options['model'].save!
          end
        end
      end
    end
  end
end
```

As we mentioned, `Model` can also be used to find a record by ID:

```ruby
module API
  module V1
    module Article
      module Operation
        class Show < Pragma::Operation::Base
          # This step can be done by Classes if you want.
          self['model.class'] = ::Article
           
          step Pragma::Macro::Model(:find_by), fail_fast: true
          step :respond!
          
          def respond!(options)
            options['result.response'] = Response::Ok.new(
              entity: options['model']
            )
          end
        end
      end
    end
  end
end
```

In the example above, if the record is not found, the macro will respond with `404 Not Found` and a
descriptive error message for you. If you want to override the error handling logic, you can remove 
the `fail_fast` option and instead implement your own `failure` step.

### Policy

**Used in:** Index, Show, Create, Update, Destroy

The `Policy` macro ensures that the current user can perform an operation on a given record.

Here's a usage example:

```ruby
module API
  module V1
    module Article
      module Operation
        class Show < Pragma::Operation::Base
          # This step can be done by Classes if you want.
          self['policy.default.class'] = Policy
          
          step :model!
          step Pragma::Macro::Policy(), fail_fast: true
          # You can also specify a custom method to call on the policy:
          # step Pragma::Macro::Policy(action: :custom_method), fail_fast: true
          step :respond!
          
          def model!(params:, **)
            options['model'] = ::Article.find(params[:id])
          end
        end
      end
    end
  end
end
```

If the user is not authorized to perform the operation (i.e. if the policy's `#show?` method returns
`false`), the macro will respond with `403 Forbidden` and a descriptive error message. If you want 
to override the error handling logic, you can remove the `fail_fast` option and instead implement 
your own `failure` step.

### Filtering

**Used in:** Index

The `Filtering` macro provides a simple interface to define basic filters for your API. You simply
include the macro and configure which filters you want to expose to the users.

```ruby
module API
  module V1
    module Article
      module Operation
        class Index < Pragma::Operation::Base
          step :model!
          step Pragma::Macro::Filtering()
          step :respond!

          self['filtering.filters'] = [
            Pragma::Filter::Equals.new(param: :by_category, column: :category_id),
            Pragma::Filter::Ilike.new(param: :by_title, column: :title)
          ]
          
          def model!(params:, **)
            options['model'] = ::Article.all
          end
        end
      end
    end
  end
end
```

With the example above, you are exposing the `by_category` filter and the `by_title` filters. The 
following filters are available for ActiveRecord currently:

- `Equals`: performs an equality (`=`) comparison.
- `Like`: performs a `LIKE` comparison.
- `Ilike`: performs an `ILIKE` comparison.

Support for more clauses as well as more ORMs will come soon.

### Ordering

**Used in:** Index

As the name suggests, the `Ordering` macro allows you to easily implement default and user-defined
ordering.

Here's an example:

```ruby
module API
  module V1
    module Article
      module Operation
        class Index < Pragma::Operation::Base
          # This step can be done by Classes if you want.
          self['model.class'] = ::Article

          self['ordering.default_column'] = :published_at
          self['ordering.default_direction'] = :desc
          self['ordering.columns'] = %i[title published_at updated_at]

          step :model!

          # This will override `model` with the ordered relation.
          step Pragma::Macro::Ordering(), fail_fast: true

          step :respond!

          def model!(options)
            options['model'] = options['model.class'].all
          end
          
          def respond!(options)
            options['result.response'] = Response::Ok.new(
              entity: options['model']
            )
          end
        end
      end
    end
  end
end
```

If the user provides an invalid order column or direction, the macro will respond with `422 Unprocessable Entity`
and a descriptive error message. If you wish to implement your own error handling logic, you can
remove the `fail_fast` option and implement your own `failure` step.

The macro accepts the following options, which can be defined on the operation or at runtime:

- `ordering.columns`: an array of columns the user can order by.
- `ordering.default_column`: the default column to order by (default: `created_at`).
- `ordering.default_direction`: the default direction to order by (default: `desc`).
- `ordering.column_param`: the name of the parameter which will contain the order column.
- `ordering.direction_param`: the name of the parameter which will contain the order direction.

### Pagination

**Used in:** Index

The `Pagination` macro is responsible for paginating collections of records through 
[will_paginate](https://github.com/mislav/will_paginate). It also allows your users to set the 
number of records per page.

```ruby
module API
  module V1
    module Article
      module Operation
        class Index < Pragma::Operation::Base
          # This step can be done by Classes if you want.
          self['model.class'] = ::Article

          step :model!

          # This will override `model` with the paginated relation.
          step Pragma::Macro::Pagination(), fail_fast: true

          step :respond!

          def model!(options)
            options['model'] = options['model.class'].all
          end
          
          def respond!(options)
            options['result.response'] = Response::Ok.new(
              entity: options['model']
            )
          end
        end
      end
    end
  end
end
```

In the example above, if the page or per-page number fail validation, the macro will respond with
`422 Unprocessable Entity` and a descriptive error message. If you wish to implement your own error 
handling logic, you can remove the `fail_fast` option and implement your own `failure` step.

The macro accepts the following options, which can be defined on the operation or at runtime:

- `pagination.page_param`: the parameter that will contain the page number.
- `pagination.per_page_param`: the parameter that will contain the number of items to include in each page.
- `pagination.default_per_page`: the default number of items per page.
- `pagination.max_per_page`: the max number of items per page.

This macro is best used in conjunction with the [Collection](https://github.com/pragmarb/pragma-decorator#collection) 
and [Pagination](https://github.com/pragmarb/pragma-decorator#pagination) modules of 
[Pragma::Decorator](https://github.com/pragmarb/pragma-decorator), which will expose all the 
pagination metadata.

### Decorator

**Used in:** Index, Show, Create, Update

The `Decorator` macro uses one of your decorators to decorate the model. If you are using 
[expansion](https://github.com/pragmarb/pragma-decorator#associations), it will also make sure that
the expansion parameter is valid.

Example usage:

```ruby
module API
  module V1
    module Article
      module Operation
        class Show < Pragma::Operation::Base
          # This step can be done by Classes if you want.
          self['decorator.instance.class'] = Decorator::Instance
          
          step :model!
          step Pragma::Macro::Decorator(), fail_fast: true
          step :respond!
          
          def model!(params:, **)
            options['model'] = ::Article.find(params[:id])
          end
          
          def respond!(options)
            # Pragma does this for you in the default operations.
            options['result.response'] = Response::Ok.new(
              entity: options['result.decorator.instance']
            )
          end
        end
      end
    end
  end
end
```

The macro accepts the following options, which can be defined on the operation or at runtime:

- `expand.enabled`: whether associations can be expanded.
- `expand.limit`: how many associations can be expanded at once.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pragmarb/pragma.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
