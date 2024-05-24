# frozen_string_literal: true

class BulletinPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    author? || published? || admin?
  end

  def new?
    user
  end

  def create?
    user
  end

  def edit?
    author?
  end

  def update?
    author?
  end

  def archive?
    author?
  end

  def moderate?
    author?
  end

  private

  def author?
    record.user == user
  end

  def admin?
    user&.admin?
  end

  def published?
    record.published?
  end
end
