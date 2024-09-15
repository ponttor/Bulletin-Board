class AddNewAdmin < ActiveRecord::Migration[7.1]
  def change
    return unless Rails.env.production?

    user = User.find_by(email: 'ruzinovrun@gmail.com')
    user.update(admin: true) if user
  end
end
