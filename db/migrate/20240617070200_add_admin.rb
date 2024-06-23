class AddAdmin < ActiveRecord::Migration[7.1]
  def change
    return unless Rails.env.production?

    user = User.find_by(email: 'vasiliqa13@gmail.com')
    user.update(admin: true) if user
  end
end
