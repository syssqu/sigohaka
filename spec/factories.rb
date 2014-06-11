FactoryGirl.define do 
	factory :user do
		sequence(:family_name) { |n| "Person #{n}" }
		sequence(:first_name) { |n| "Person #{n}" }
		sequence(:kana_family_name) { |n| "Person #{n}" }
		sequence(:kana_first_name) { |n| "Person #{n}" }
		sequence(:email) { |n| "person_#{n}@example.com"}
		sequence(:gender) {|n| "man"}
		sequence(:section_id) {"1"}
		password	"foobarfoo"
		password_confirmation	"foobarfoo"

		factory :admin do
			admin true
		end
	end

	factory :transportation_express do
		destination "a"
		user

	end
end