# frozen_string_literal: true

5.times { Category.create(name: Faker::Emotion.noun) }

5.times { User.create(name: Faker::Movies::BackToTheFuture.character, email: Faker::Internet.email) }

categories = Category.all
users = User.all
states = Bulletin.aasm.states.map(&:name)

200.times do
  bulletin = Bulletin.new(
    title: Faker::Beer.name,
    description: Faker::Lorem.paragraph_by_chars,
    user: users.sample,
    category: categories.sample,
    state: states.sample
  )

  bulletin.image.attach(io: Rails.root.join('db/images/bul1.jpeg').open, filename: 'bul1.jpeg')

  bulletin.save!
end
