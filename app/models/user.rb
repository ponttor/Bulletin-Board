# frozen_string_literal: true

class User < ApplicationRecord
  def self.find_or_create_from_auth(auth)
    user = User.find_or_create_by(email: auth['info']['email'])

    user.name = auth['info']['name']
    user.email = auth['info']['email']

    user.save
    user
  end
end
