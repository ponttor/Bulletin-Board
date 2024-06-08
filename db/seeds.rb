# frozen_string_literal: true

Category.create([{ name: 'Black' }, { name: 'White' }, { name: 'Red' }])
User.create([{ name: 'Bin', email: 'bin@bin.ru' }, { name: 'Min', email: 'min@bin.ru' }])

categories = Category.all
users = User.all
states = Bulletin.aasm.states.map(&:name)

200.times do |i|
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
