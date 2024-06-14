# frozen_string_literal: true

module BulletinsHelper
  def bulletin_states_for_select
    Bulletin.aasm.states.map { |state| [t("bulletin.states.#{state}"), state] }
  end
end
