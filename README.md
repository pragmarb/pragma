# Pragma

[![Build Status](https://img.shields.io/travis/pragmarb/pragma.svg?maxAge=3600&style=flat-square)](https://travis-ci.org/pragmarb/pragma)
[![Dependency Status](https://img.shields.io/gemnasium/pragmarb/pragma.svg?maxAge=3600&style=flat-square)](https://gemnasium.com/github.com/pragmarb/pragma)
[![Code Climate](https://img.shields.io/codeclimate/github/pragmarb/pragma.svg?maxAge=3600&style=flat-square)](https://codeclimate.com/github/pragmarb/pragma)
[![Coveralls](https://img.shields.io/coveralls/pragmarb/pragma.svg?maxAge=3600&style=flat-square)](https://coveralls.io/github/pragmarb/pragma)

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
            └── policy.rb
            └── decorator.rb
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
          #   - a policy that responds to #create?
          #   - a Create contract
          #   - a decorator
          #   - an Article model
        end
      end
    end
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pragmarb/pragma.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
