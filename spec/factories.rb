FactoryGirl.define do 
	factory :user do
		sequence(:family_name) { |n| "Person #{n}" }
		sequence(:first_name) { |n| "Person #{n}" }
		sequence(:kana_family_name) { |n| "Person #{n}" }
		sequence(:kana_first_name) { |n| "Person #{n}" }
		sequence(:email) { |n| "person_#{n}@example.com"}
		sequence(:gender) {|n| "man"}
		sequence(:section_id) {"1"}
    sequence(:role) {"admin"}
		password	"foobarfoo"
		password_confirmation	"foobarfoo"

		factory :admin do
			admin true
		end
	end

	factory :transportation_express do
    sequence(:destination) { |n| "where #{n}" }
    sequence(:koutu_date) { |n| "2014-06-01" }
    sequence(:route) { |n| "route #{n}" }
    sequence(:transport) { |n| "transport #{n}" }
    sequence(:money) { |n| "#{n}" }
    sequence(:note) { |n| "note #{n}" }
    sequence(:sum) { |n| "#{n}" }
    sequence(:year) { |n| "1234" }
    sequence(:month) { |n| "56" }
    sequence(:user_id) {|n| "1"}
    user
	end

	factory :business_report do
		sequence(:naiyou) { |n| "naiyou #{n}" }
		sequence(:jisseki) { |n| "jisseki #{n}" }
		sequence(:tool) { |n| "tool #{n} "}
		sequence(:self_purpose) { |n| "self_purpose #{n}" }
		sequence(:self_value) { |n| "self_value #{n}" }
		sequence(:self_reason) { |n| "self_reason #{n}" }
		sequence(:user_situation) { |n| "user_situation #{n}" }
		sequence(:request) { |n| "request #{n}" }
		sequence(:develop_purpose) { |n| "develop_purpose #{n}" }
		sequence(:develop_jisseki) { |n| "develop_jisseki #{n}" }
		sequence(:note) { |n| "note #{n}" }
		sequence(:reflection) { |n| "reflection #{n}" }
		sequence(:user_id) { |n| "1"}
	end

	factory :section do
    sequence(code: "1", name: "システム事業部1課")
    sequence(code: "2", name: "システム事業部2課")
    sequence(code: "3", name: "システム事業部3課")
	end
end