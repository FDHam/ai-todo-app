FactoryBot.define do
  factory :todo do
    title { "Buy groceries" }
    description { "Need to buy milk, bread, and eggs from the store" }
    completed { false }

    trait :completed do
      completed { true }
    end

    trait :without_description do
      description { nil }
    end

    trait :long_title do
      title { "A" * 100 }
    end

    trait :long_description do
      description { "A" * 500 }
    end

    factory :completed_todo, traits: [ :completed ]
    factory :todo_without_description, traits: [ :without_description ]
  end
end
