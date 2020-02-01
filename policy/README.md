# Pragma::Policy

[![Build Status](https://travis-ci.org/pragmarb/pragma-policy.svg?branch=master)](https://travis-ci.org/pragmarb/pragma-policy)
[![Coverage Status](https://coveralls.io/repos/github/pragmarb/pragma-policy/badge.svg?branch=master)](https://coveralls.io/github/pragmarb/pragma-policy?branch=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/e51e8d7489eb72ab97ba/maintainability)](https://codeclimate.com/github/pragmarb/pragma-policy/maintainability)

Policies provide fine-grained access control for your API resources.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pragma-policy'
```

And then execute:

```console
$ bundle
```

Or install it yourself as:

```console
$ gem install pragma-policy
```

## Usage

To create a policy, simply inherit from `Pragma::Policy::Base`:

```ruby
module API
  module V1
    module Article
      class Policy < Pragma::Policy::Base
      end
    end
  end
end
```

By default, the policy does not return any objects when scoping and forbids all operations.

You can start customizing your policy by defining a scope and operation predicates:

```ruby
module API
  module V1
    module Article
      class Policy < Pragma::Policy::Base
        class Scope < Pragma::Policy::Base::Scope
          def resolve
            scope.where('published = ? OR author_id = ?', true, user.id)
          end
        end

        def show?
          record.published? || record.author_id == user.id
        end

        def update?
          record.author_id == user.id
        end

        def destroy?
          record.author_id == user.id
        end
      end
    end
  end
end
```

You are ready to use your policy!

### Retrieving records

To retrieve all the records accessible by a user, use the `.accessible_by` class method:

```ruby
posts = API::V1::Article::Policy::Scope.new(user, Article.all).resolve
```

### Authorizing operations

To authorize an operation, first instantiate the policy, then use the predicate methods:

```ruby
policy = API::V1::Article::Policy.new(user, post)
fail 'You cannot update this post!' unless policy.update?
```

Since raising when the operation is forbidden is so common, we provide bang methods a shorthand
syntax. `Pragma::Policy::NotAuthorizedError` is raised if the predicate method returns `false`:

```ruby
policy = API::V1::Article::Policy.new(user, post)
policy.update! # raises if the user cannot update the post
```

### Reusing Pundit policies

If you already use [Pundit](https://github.com/varvet/pundit), there's no need to copy-paste
policies for your API. You can use `Pragma::Policy::Pundit` to delegate to your existing policies
and scopes:

```ruby
module API
  module V1
    module Article
      class Policy < Pragma::Pundit::Policy
        # This is optional: the inferred default would be ArticlePolicy.
        self.pundit_klass = CustomArticlePolicy
      end
    end
  end
end
```

Note that you can still override specific methods if you want, and we'll keep delegating the rest
to Pundit:

```ruby
module API
  module V1
    module Article
      class Policy < Pragma::Pundit::Policy
        def create?
          # Your custom create policy here
        end
      end
    end
  end
end
```

### Passing additional context

If you want to pass additional context to the policy, just pass it instead of the user object.
Pragma::Policy never uses your context in any way, so you can pass whatever you want:

```ruby
policy = API::V1::Article::Policy.new(OpenStruct.new(ip: request.remote_ip, user: user), post)
policy.update!
```

In your policy, you can use `#context` as an alias for `#user` for convenience:

```ruby
module API
  module V1
    module Article
      class Policy < Pragma::Pundit::Policy
        def update?
          record.author_id == context.user.id || context.ip == '127.0.0.1'
        end
      end
    end
  end
end
```

If you are using [pragma-rails](https://github.com/pragmarb/pragma-rails), you may change the
context passed to the policy by defining a `#policy_context` method on your controller. This way you
are not forced to override `#current_user` or `#pragma_user`:

```ruby
module API
  module V1
    class PostsController < ApplicationController
      # ...

      private

      def policy_context
        OpenStruct.new(ip: request.remote_ip, user: current_user)
      end
    end
  end
end
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pragmarb/pragma-policy.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
