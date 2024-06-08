# frozen_string_literal: true

class ProfilePolicy < ApplicationPolicy
  def show?
    user
  end
end
