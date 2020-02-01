# frozen_string_literal: true

RSpec.describe Pragma::Decorator::Association do
  subject { decorator }

  before do
    class OpenStructWithPk < OpenStruct
      def self.primary_key
        :id
      end
    end
  end

  let(:decorator) { decorator_klass.new(invoice) }

  let(:decorator_klass) do
    Class.new(Pragma::Decorator::Base) do
      include Pragma::Decorator::Association
    end.tap do |klass|
      klass.send(:belongs_to, :customer, decorator: customer_decorator_klass)
    end
  end

  let(:customer_decorator_klass) do
    Class.new(Pragma::Decorator::Base) do
      include Pragma::Decorator::Association

      property :id
      property :full_name
    end.tap do |klass|
      klass.send(:belongs_to, :company, decorator: company_decorator_klass)
    end
  end

  let(:company_decorator_klass) do
    Class.new(Pragma::Decorator::Base) do
      property :id
      property :name, if: ->(user_options:, **) { user_options[:current_user].id == 1 }
    end
  end

  let(:invoice) do
    OpenStructWithPk.new(id: 'invoice_id', customer: customer)
  end

  let(:customer) do
    OpenStructWithPk.new(id: 'customer_id', full_name: 'John Doe', company: company)
  end

  let(:company) do
    OpenStructWithPk.new(id: 'company_id', name: 'ACME')
  end

  let(:result) do
    JSON.parse(subject.to_json(user_options: {
                                 expand: expand,
                                 current_user: current_user
                               }))
  end

  let(:expand) { [] }
  let(:current_user) { OpenStructWithPk.new(id: 1) }

  context 'when the association is not expanded' do
    it "renders the associated object's ID" do
      expect(result).to include(
        'customer' => customer.id
      )
    end
  end

  context 'when the association is expanded' do
    let(:expand) { ['customer'] }

    it 'renders the associated object' do
      expect(result).to include(
        'customer' => a_hash_including(
          'id' => customer.id,
          'full_name' => customer.full_name,
          'company' => company.id
        )
      )
    end
  end

  context 'when nested associations are expanded' do
    let(:expand) { ['customer', 'customer.company'] }

    it 'renders the associated objects' do
      expect(result).to include(
        'customer' => a_hash_including(
          'id' => customer.id,
          'full_name' => customer.full_name,
          'company' => a_hash_including(
            'id' => company.id,
            'name' => company.name
          )
        )
      )
    end
  end

  context 'when render_nil is false' do
    before do
      decorator_klass.send(:belongs_to, :customer,
                           decorator: customer_decorator_klass,
                           render_nil: false)
    end

    let(:customer) { nil }

    it 'does not render nil associations' do
      expect(result).not_to have_key('customer')
    end
  end

  context 'when render_nil is true' do
    before do
      decorator_klass.send(:belongs_to, :customer,
                           decorator: customer_decorator_klass,
                           render_nil: true)
    end

    it 'renders nil associations' do
      expect(result).to have_key('customer')
    end
  end

  context 'when exec_context is decorator' do
    before do
      decorator_klass.class_eval do
        def customer
          OpenStructWithPk.new(id: 'customer_on_decorator')
        end
      end

      decorator_klass.send(:belongs_to, :customer,
                           decorator: customer_decorator_klass,
                           exec_context: :decorator)
    end

    it 'calls the getter on the decorator' do
      expect(result).to include('customer' => 'customer_on_decorator')
    end
  end

  context 'when decorator is a callable' do
    before do
      decorator_klass.send(:belongs_to, :customer,
                           decorator: ->(_associated_object) { customer_decorator_klass })
    end

    let(:expand) { ['customer'] }

    it 'computes the decorator from the callable' do
      expect(result).to include(
        'customer' => a_hash_including(
          'id' => customer.id,
          'full_name' => customer.full_name,
          'company' => company.id
        )
      )
    end
  end

  context 'when :as option is provided' do
    before do
      decorator_klass.send(:belongs_to, :user,
                           decorator: customer_decorator_klass,
                           as: :customer)
    end

    let(:invoice) { OpenStructWithPk.new(user: customer) }

    it "renders the associated object's ID" do
      expect(result).to include('customer' => customer.id)
    end

    context 'when expanding' do
      let(:expand) { ['customer', 'customer.company'] }

      it 'expands properly' do
        expect(result).to include(
          'customer' => a_hash_including(
            'id' => customer.id,
            'full_name' => customer.full_name,
            'company' => a_hash_including(
              'id' => company.id,
              'name' => company.name
            )
          )
        )
      end
    end
  end

  describe '#validate_expansion' do
    subject { -> { decorator.validate_expansion(expand) } }

    context 'when nested associations are expanded without the parents being expanded' do
      let(:expand) { ['customer.company'] }

      it 'raises an UnexpandedAssociationParent error' do
        expect(subject).to raise_error(Pragma::Decorator::Association::UnexpandedAssociationParent)
      end
    end

    context 'when a non-existing associations is expanded' do
      let(:expand) { ['dummy'] }

      it 'raises an AssociationNotFound error' do
        expect(subject).to raise_error(Pragma::Decorator::Association::AssociationNotFound)
      end
    end
  end
end
