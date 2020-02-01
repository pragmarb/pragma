# frozen_string_literal: true

module Pragma
  module Resource
    module Operation
      # Finds all records of the requested resource, authorizes them, paginates them and decorates
      # them.
      class Index < Pragma::Operation::Base
        step Macro::Classes()
        step :retrieve!, name: 'retrieve'
        step :scope!, name: 'scope'
        step Macro::Ordering()
        step Macro::Pagination()
        step Macro::Decorator(name: :collection)
        step :include!, name: 'include'
        step :respond!, name: 'respond'

        def retrieve!(options)
          options['model'] = options['model.class'].all
        end

        def include!(options)
          options['model'] = Pragma::Decorator::Association::Expander
                             .load_adaptor(options['model'])
                             .include_associations(options['params'][:expand] || [])
        end

        # TODO: Turn this into a macro.
        def scope!(options, model:, **)
          options['model'] = options['policy.default.scope.class'].new(
            options['policy.context'] || options['current_user'],
            model
          ).resolve
        end

        def respond!(options, **)
          options['result.response'] = Response::Ok.new(
            entity: options['result.decorator.collection']
          )
        end
      end
    end
  end
end
