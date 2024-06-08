# frozen_string_literal: true

module AasmStateEventConcern
  extend ActiveSupport::Concern

  included do
    attr_accessor :state_event

    before_save :fire_event!, if: -> { state_event.present? }
  end

  def fire_event!
    aasm.fire(state_event)
  rescue AASM::InvalidTransition => e
    errors.add(:state, e.to_s)
  end
end
