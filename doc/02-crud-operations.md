# CRUD operations

Pragma ships with a default set of CRUD operations which should work for most standard API
resources. You can use them as they are, modify them or simply roll your own.

## The Index operation

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
        class Index < Pragma::Operation::Index
        end
      end
    end
  end
end
```

To override the defaults of this operation, have a look at the [source code](https://github.com/pragmarb/pragma/blob/master/lib/pragma/operation/index.rb).

## The Create operation

Pragma provides a default implementation of the Create operation. Here's how it works:

1. it builds a new instance of the model;
2. it wraps the model in the Create contract;
3. it validates and authorizes the contract;
4. it saves the record;
5. it responds with 201 Created and the decorated record.

To create a Create operation (pun intended), inherit from `Pragma::Operation::Create`:

```ruby
module API
  module V1
    module Post
      module Operation
        class Create < Pragma::Operation::Create
        end
      end
    end
  end
end
```

To override the defaults of this operation, have a look at the [source code](https://github.com/pragmarb/pragma/blob/master/lib/pragma/operation/create.rb).

## The Update operation

Pragma provides a default implementation of the Update operation. Here's how it works:

1. it finds an instance of the model by ID;
2. it wraps the model in the Update contract;
3. it validates and authorizes the contract;
4. it saves the record;
5. it responds with 200 OK and the decorated record.

To create an Update operation, inherit from `Pragma::Operation::Update`:

```ruby
module API
  module V1
    module Post
      module Operation
        class Update < Pragma::Operation::Update
        end
      end
    end
  end
end
```

To override the defaults of this operation, have a look at the [source code](https://github.com/pragmarb/pragma/blob/master/lib/pragma/operation/update.rb).

## The Destroy operation

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
        class Destroy < Pragma::Operation::Destroy
        end
      end
    end
  end
end
```

To override the defaults of this operation, have a look at the [source code](https://github.com/pragmarb/pragma/blob/master/lib/pragma/operation/destroy.rb).
