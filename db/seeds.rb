# frozen_string_literal: true

5.times do
  Category.create(name: Faker::Emotion.noun)
end

3.times do
  User.create(name: Faker::Movies::BackToTheFuture.character, email: Faker::Internet.email)
end

b1 = Bulletin.create(user: User.first, category: Category.first, description: Faker::Movies::BackToTheFuture.quote, title: Faker::Ancient.hero)
b1.image.attach(io: Rails.root.join('db/images/bul1.jpeg').open, filename: 'bul1.jpeg')
b2 = Bulletin.create(user: User.first, category: Category.first, description: Faker::Movies::BackToTheFuture.quote, title: Faker::Ancient.hero)
b2.image.attach(io: Rails.root.join('db/images/bul2.jpeg').open, filename: 'bul2.jpeg')
b3 = Bulletin.create(user: User.first, category: Category.first, description: Faker::Movies::BackToTheFuture.quote, title: Faker::Ancient.hero)
b3.image.attach(io: Rails.root.join('db/images/bul3.jpeg').open, filename: 'bul3.jpeg')
b4 = Bulletin.create(user: User.first, category: Category.first, description: Faker::Movies::BackToTheFuture.quote, title: Faker::Ancient.hero)
b4.image.attach(io: Rails.root.join('db/images/bul4.jpeg').open, filename: 'bul4.jpeg')
