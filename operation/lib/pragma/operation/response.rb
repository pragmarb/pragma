# frozen_string_literal: true

module Pragma
  module Operation
    # Represents an HTTP response. Provides utilities to deal with status codes and such.
    class Response
      STATUSES = {
        100 => :continue,
        101 => :switching_protocols,
        102 => :processing,
        200 => :ok,
        201 => :created,
        202 => :accepted,
        203 => :non_authoritative_information,
        204 => :no_content,
        205 => :reset_content,
        206 => :partial_content,
        207 => :multi_status,
        208 => :already_reported,
        300 => :multiple_choices,
        301 => :moved_permanently,
        302 => :found,
        303 => :see_other,
        304 => :not_modified,
        305 => :use_proxy,
        307 => :temporary_redirect,
        400 => :bad_request,
        401 => :unauthorized,
        402 => :payment_required,
        403 => :forbidden,
        404 => :not_found,
        405 => :method_not_allowed,
        406 => :not_acceptable,
        407 => :proxy_authentication_required,
        408 => :request_timeout,
        409 => :conflict,
        410 => :gone,
        411 => :length_required,
        412 => :precondition_failed,
        413 => :request_entity_too_large,
        414 => :request_uri_too_large,
        415 => :unsupported_media_type,
        416 => :request_range_not_satisfiable,
        417 => :expectation_failed,
        418 => :im_a_teapot,
        422 => :unprocessable_entity,
        423 => :locked,
        424 => :failed_dependency,
        425 => :unordered_collection,
        426 => :upgrade_required,
        428 => :precondition_required,
        429 => :too_many_requests,
        431 => :request_header_fields_too_large,
        449 => :retry_with,
        500 => :internal_server_error,
        501 => :not_implemented,
        502 => :bad_gateway,
        503 => :service_unavailable,
        504 => :gateway_timeout,
        505 => :http_version_not_supported,
        506 => :variant_also_negotiates,
        507 => :insufficient_storage,
        509 => :bandwidth_limit_exceeded,
        510 => :not_extended,
        511 => :network_authentication_required
      }.freeze

      # @!attribute [rw] entity
      #   @return [Object] the entity/body of the response
      #
      # @!attribute [rw] headers
      #   @return [Hash] the headers of the response
      attr_accessor :entity, :headers

      # @!attribute [r] status
      #   @return [Integer|Symbol] the HTTP status code of the response
      attr_reader :status

      # Initializes the response.
      #
      # @param status [Integer|Symbol] the HTTP status code of the response
      # @param entity [Object] the entity/body of the response
      # @param headers [Hash] the headers of the response
      def initialize(status: 200, entity: nil, headers: {})
        self.status = status
        self.entity = entity
        self.headers = headers
      end

      # Returns whether the response has a successful HTTP status code, by checking whether the
      # status code is 1xx, 2xx or 3xx.
      #
      # @return [Boolean]
      def success?
        %w[1 2 3].include?(@status.to_s[0])
      end

      # Returns whether the response has a failed HTTP status code, by checking whether the status
      # code is 4xx or 5xx.
      #
      # @return [Boolean]
      def failure?
        !success?
      end

      # Sets the HTTP status code of the response.
      #
      # @param value [Symbol|Integer] the status code (e.g. +200+/+:ok+)
      #
      # @raise [ArgumentError] if an invalid status code is provided
      def status=(value)
        case value
        when Integer
          fail ArgumentError, "#{value} is not a valid status code" unless STATUSES[value]

          @status = value
        when Symbol, String
          unless STATUSES.invert[value.to_sym]
            fail ArgumentError, "#{value} is not a valid status phrase"
          end

          @status = STATUSES.invert[value.to_sym]
        else
          fail ArgumentError, "#status= expects an integer or a symbol, #{value} provided"
        end
      end

      # Applies a decorator to the response's entity.
      #
      # @param decorator [Class] the decorator to apply
      #
      # @return [Response] returns itself for chaining
      #
      # @example Applying a decorator
      #   response = Pragma::Operation::Response::Ok.new(entity: user).decorate_with(UserDecorator)
      def decorate_with(decorator)
        tap do
          self.entity = decorator.represent(entity)
        end
      end
    end
  end
end
