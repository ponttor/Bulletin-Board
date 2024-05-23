# frozen_string_literal: true

class Bulletin < ApplicationRecord
  include BulletinStateMachine

  belongs_to :user
  belongs_to :category
  has_one_attached :image

  validates :title, presence: true, length: { minimum: 3 }
  validates :description, presence: true
  validates :image, attached: true, content_type: %i[png jpg jpeg], size: { less_than: 5.megabytes }

  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "created_at", "description", "id", "state", "title", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "image_attachment", "image_blob", "user"]
  end
end
