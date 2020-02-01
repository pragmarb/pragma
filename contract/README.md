# Pragma::Contract

[![Build Status](https://travis-ci.org/pragmarb/pragma-contract.svg?branch=master)](https://travis-ci.org/pragmarb/pragma-contract)
[![Coverage Status](https://coveralls.io/repos/github/pragmarb/pragma-contract/badge.svg?branch=master)](https://coveralls.io/github/pragmarb/pragma-contract?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/e51e8d7489eb72ab97ba/maintainability)](https://codeclimate.com/github/pragmarb/pragma-contract/maintainability)

Contracts are form objects on steroids for your JSON API.

They are built on top of [Reform](https://github.com/apotonick/reform).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pragma-contract'
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install pragma-contract
```

## Usage

To create a contract, simply inherit from `Pragma::Contract::Base`:

```ruby
module API
  module V1
    module Article
      module Contract
        class Base < Pragma::Contract::Base
          property :title
          property :body
        end
      end
    end
  end
end
```

Since Pragma::Contract is built on top of [Reform](https://github.com/apotonick/reform), you should
consult [its documentation](http://trailblazer.to/gems/reform/) for the basic usage of contracts;
the rest of this section only covers the features provided specifically by Pragma::Contract.

### Coercion

Pragma::Contract supports Reform coercion through the [dry-types](https://github.com/dry-rb/dry-types)
gem.

You can access types with the `Pragma::Contract::Types` module.

```ruby
module API
  module V1
    module Article
      module Contract
        class Base < Pragma::Contract::Base
          property :title, type: Pragma::Contract::Types::Coercible::String
          property :body, type: Pragma::Contract::Types::Coercible::String
          property :published_at, type: Pragma::Contract::Types::Form::Date
        end
      end
    end
  end
end
```

Helpers are also provided as a shorthand syntax:

```ruby
module API
  module V1
    module Article
      module Contract
        class Base < Pragma::Contract::Base
          property :title, type: coercible(:string)
          property :body, type: coercible(:string)
          property :published_at, type: form(:date)
        end
      end
    end
  end
end
```

### Model finders

This is a common pattern in API contracts:

```ruby
module API
  module V1
    module Invoice
      module Contract
        class Base < Pragma::Contract::Base
          property :customer

          def customer=(val)
            super ::Customer.find_by(id: val)
          end
        end
      end
    end
  end
end
```

Pragma::Contract provides a shorthand syntax:

```ruby
module API
  module V1
    module Invoice
      module Contract
        class Base < Pragma::Contract::Base
          property :customer, type: Customer
        end
      end
    end
  end
end
```

You can also specify a custom column to find by!

```ruby
module API
  module V1
    module Invoice
      module Contract
        class Base < Pragma::Contract::Base
          property :customer, type: Customer, by: :email
        end
      end
    end
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pragmarb/pragma-contract.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
