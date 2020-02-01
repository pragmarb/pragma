# frozen_string_literal: true

RSpec.describe Pragma::Decorator::Pagination do
  subject { decorator }

  let(:decorator) { collection_decorator_klass.new(collection) }

  let(:collection_decorator_klass) do
    Class.new(Pragma::Decorator::Base) do
      include Pragma::Decorator::Pagination
    end
  end

  let(:result) { JSON.parse(subject.to_json) }

  context 'with the will_paginate interface' do
    before do
      module WillPaginate; end
    end

    let(:collection) do
      OpenStruct.new(
        current_page: 2,
        next_page: 3,
        per_page: 30,
        previous_page: 1,
        total_entries: 90,
        total_pages: 3
      )
    end

    it 'renders the pagination information' do
      expect(result).to eq(
        'current_page' => 2,
        'next_page' => 3,
        'per_page' => 30,
        'previous_page' => 1,
        'total_entries' => 90,
        'total_pages' => 3
      )
    end
  end

  context 'with the Kaminari interface' do
    before do
      module Kaminari; end
    end

    let(:collection) do
      OpenStruct.new(
        current_page: 2,
        next_page: 3,
        limit_value: 30,
        prev_page: 1,
        total_count: 90,
        total_pages: 3
      )
    end

    it 'renders the pagination information' do
      expect(result).to eq(
        'current_page' => 2,
        'next_page' => 3,
        'per_page' => 30,
        'previous_page' => 1,
        'total_entries' => 90,
        'total_pages' => 3
      )
    end
  end
end
