# frozen_string_literal: true

require './app/filter'
require 'byebug'
class PeopleController
  def initialize(params)
    @params = params
  end

  def normalize
    Filter.new(params).result if params.any?
  end

  private

  attr_reader :params
end
