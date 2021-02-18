# frozen_string_literal: true

class DateFormatterResponse
  attr_accessor :value, :error

  def success?
    @error.nil?
  end
end
