# frozen_string_literal: true

module BulletinStateMachine
  extend ActiveSupport::Concern

  included do
    include AASM
    include AasmStateEventConcern

    aasm column: 'state' do
      state :draft, initial: true
      state :under_moderation, :published, :rejected, :archived

      event :moderate do
        transitions from: %i[draft rejected], to: :under_moderation
      end

      event :publish do
        transitions from: :under_moderation, to: :published
      end

      event :reject do
        transitions from: :under_moderation, to: :rejected
      end

      event :archive do
        transitions from: %i[published draft under_moderation rejected], to: :archived
      end
    end
  end
end
