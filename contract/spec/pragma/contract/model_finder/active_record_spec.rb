# frozen_string_literal: true

RSpec.describe Pragma::Contract::ModelFinder::ActiveRecord do
  subject { form_klass.new(model) }

  let(:form_klass) do
    Class.new(Pragma::Contract::Base) do
      property :user, type: User
    end
  end

  let(:model) { OpenStruct.new }

  before do
    module ActiveRecord
      class Base < OpenStruct
      end
    end

    class User < ActiveRecord::Base
      def self.find_by(id:)
        User.new(id: 1) if id == 1
      end
    end
  end

  it 'is instantiated correctly' do
    expect { subject }.not_to raise_error
  end

  it 'finds models correctly' do
    subject.validate(user: 1)
    expect(subject.user.id).to eq(1)
  end

  context 'with the :by option' do
    let(:form_klass) do
      Class.new(Pragma::Contract::Base) do
        property :user, type: User, by: :email
      end
    end

    before do
      class User < ActiveRecord::Base
        def self.find_by(email:)
          User.new(email: 'jdoe@example.com') if email == 'jdoe@example.com'
        end
      end
    end

    it 'finds models correctly' do
      subject.validate(user: 'jdoe@example.com')
      expect(subject.user.email).to eq('jdoe@example.com')
    end
  end
end
