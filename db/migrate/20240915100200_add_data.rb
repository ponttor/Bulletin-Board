class AddData < ActiveRecord::Migration[7.1]
  def change
    return unless Rails.env.production?

    Category.create([{ name: 'essential' }, { name: 'advanced' }, { name: 'master' }])

    categories = Category.all
    users = User.all
    states = Bulletin.aasm.states.map(&:name)

    99.times do |i|
      bulletin = Bulletin.new(
        title: "bul #{i}",
        description: "Description #{i}",
        user: users.sample,
        category: categories.sample,
        state: states.sample
      )

      bulletin.image.attach(io: Rails.root.join('db/images/bul1.jpeg').open, filename: 'bul1.jpeg')

      bulletin.save!
    end
  end
end
