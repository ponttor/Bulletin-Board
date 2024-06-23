# frozen_string_literal: true

class Bulletin < ApplicationRecord
  include BulletinStateMachine

  belongs_to :user
  belongs_to :category
  has_one_attached :image

  validates :title, presence: true, length: { minimum: 3 }
  validates :description, presence: true
  validates :image, attached: true, content_type: %i[png jpg jpeg], size: { less_than: 5.megabytes }

  def self.ransackable_attributes(_auth_object = nil)
    %w[category_id state title]
  end
end
