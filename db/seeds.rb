50.times  do
	Client.create({
		name: Faker::Name.name,
        phone: Faker::PhoneNumber.cell_phone,
        last_purchase: Faker::Date.between(from: 30.days.ago, to: Date.today)
	})
end