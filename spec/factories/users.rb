FactoryBot.define do
    factory :user do
        # username{'capy' }
        # email{'capy@aa.io'}
        # age{ 5 }
        # political_affiliation{'hufflepuff' }
        # password{'password'}
        username{ Faker::Movies::HarryPotter.character }
        email{ Faker::Internet.email }
        age{ 5 }
        political_affiliation{ Faker::Movies::HarryPotter.house }
        password{'password'}
    end
end