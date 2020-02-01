# Pragma::Operation

[![Build Status](https://travis-ci.org/pragmarb/pragma-operation.svg?branch=master)](https://travis-ci.org/pragmarb/pragma-operation)
[![Coverage Status](https://coveralls.io/repos/github/pragmarb/pragma-operation/badge.svg?branch=master)](https://coveralls.io/github/pragmarb/pragma-operation?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/e51e8d7489eb72ab97ba/maintainability)](https://codeclimate.com/github/pragmarb/pragma-operation/maintainability)

Operations encapsulate the business logic of your JSON API.

They are built on top of the [Trailblazer::Operation](https://github.com/trailblazer/trailblazer-operation) gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pragma-operation'
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install pragma-operation
```

## Usage

Let's build your first operation!

```ruby
module API
  module V1
    module Article
      class Show < Pragma::Operation::Base
        step :find!
        failure :handle_not_found!, fail_fast: true
        step :authorize!
        failure :handle_unauthorized!
        step :respond!

        def find!(params:, **options)
          options['model'] = ::Article.find_by(id: params[:id])
        end

        def handle_not_found!(options)
          options['result.response'] = Pragma::Operation::Response::NotFound.new
          false
        end

        def authorize!(options)
          options['result.authorization'] = options['model'].published? || 
            options['model'].author == options['current_user']
        end

        def handle_unauthorized!(options)
          options['result.response'] = Pragma::Operation::Response::Forbidden.new(
            entity: Error.new(
              error_type: :forbidden,
              error_message: 'You can only access an article if published or authored by you.'
            )
          )
        end
  
        def respond!(options)
          options['result.response'] = Pragma::Operation::Response::Ok.new(
            entity: options['model'].as_json
          )
        end
      end
    end
  end
end
```

Yes, I know. This does not make any sense yet. Before continuing, I encourage you to read (and
understand!) the documentation of [Trailblazer::Operation](http://trailblazer.to/gems/operation/2.0/index.html).
Pragma::Operation is simply an extension of its TRB counterpart. For the rest of this guide, we will
assume you have a good understanding of TRB concepts like flow control and macros.

### Response basics

The only requirement for a Pragma operation is that it sets a `result.response` key in the options
hash by the end of its execution. This is a `Pragma::Operation::Response` object that will be used
by [pragma-rails](https://github.com/pragmarb/pragma-rails) or another integration to respond with
the proper HTTP information.

Responses have, just as you'd expect, a status, headers and body. You can manipulate them by using
the `status`, `headers` and `entity` parameters of the initializer:

```ruby
response = Pragma::Operation::Response.new(
  status: 201,
  headers: {
    'X-Api-Custom' => 'Value'
  },
  entity: my_model
)
```

You can also set these properties through their accessors after instantiating the response:

```ruby
# You can set the status as a symbol:
response.status = :created

# You can set it as an HTTP status code:
response.status = 201

# You can manipulate headers:
response.headers['X-Api-Custom'] = 'Value'

# You can manipulate the entity:
response.entity = my_model

# The entity can be any object responding to #to_json:
response.entity = {
  foo: :bar
}
```

### Decorating entities

The response class also has support for Pragma [decorators](https://github.com/pragmarb/pragma-decorator).

If you use decorators, you can set a decorator as the entity or you can use the `#decorate_with`
convenience method to decorate the existing entity:

```ruby
response.entity = ArticleDecorator.new(article)

# This is equivalent to the above:
response.entity = article
response.decorate_with(ArticleDecorator) # returns the response itself for chaining
```

### Errors

Pragma::Operation ships with an `Error` data structure that's simply the recommended way to present
your errors. You can build your custom error by creating a new instance of it and specify a 
machine-readable error type and a human-readable error message:

```ruby
error = Pragma::Operation::Error.new(
  error_type: :invalid_date,
  error_message: 'You have specified an invalid date in your request.'
)

error.as_json # => {:error_type=>:invalid_date, :error_message=>"You have specified an invalid date in your request.", :meta=>{}}
error.to_json # => {"error_type":"invalid_date","error_message":"You have specified an invalid date in your request.","meta":{}} 
```

Do you see that `meta` property in the JSON representation of the error? You can use it to include
additional metadata about the error. This is especially useful, for instance, with validation errors
as you can include the exact fields and validation messages (which is exactly what Pragma does by
default, by the way):

```ruby
error = Pragma::Operation::Error.new(
  error_type: :invalid_date,
  error_message: 'You have specified an invalid date in your request.',
  meta: {
    expected_format: 'YYYY-MM-DD'
  }
)

error.as_json # => {:error_type=>:invalid_date, :error_message=>"You have specified an invalid date in your request.", :meta=>{:expected_format=>"YYYY-MM-DD"}}
error.to_json # => {"error_type":"invalid_date","error_message":"You have specified an invalid date in your request.","meta":{"expected_format":"YYYY-MM-DD"}}
```

If you don't want to go with this format, you are free to implement your own error class, but it is
not recommended, as the [built-in macros](https://github.com/pragmarb/pragma/tree/master/lib/pragma/operation/macro) 
will use `Pragma::Operation::Error`.

### Built-in responses

Last but not least, as you have seen in the example operation, Pragma provides some 
[built-in responses](https://github.com/pragmarb/pragma-operation/tree/master/lib/pragma/operation/response) 
for common status codes and bodies. Some of these only have a status code while others (the error
responses) also have a default entity attached to them. For instance, you can use `Pragma::Operation::Response::Forbidden`
without specifying your own error type and message:

```ruby
response = Pragma::Operation::Response::Forbidden.new

response.status # => 403
response.entity.to_json # => {"error_type":"forbidden","error_message":"You are not authorized to access the requested resource.","meta":{}}
```

The built-in responses are not meant to be comprehensive and you will most likely have to implement
your own. If you write some that you think could be useful, feel free to open a PR!

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pragmarb/pragma-operation.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
