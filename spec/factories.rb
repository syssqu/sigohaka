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

	factory :commute do
		# sequence(:user_id) {|n| "1"}
		
		sequence(:transport) {|n| "trans_#{n}"}
		sequence(:segment1) {|n| "segment1_#{n}"}
		sequence(:segment2) {|n| "segment2_#{n}"}
		sequence(:money) {|n| "#{n}"}
		user
	end

	factory :reason do
		
		sequence(:reason) {|n| "new"}
		sequence(:reason_text) {|n| "text_#{n}"}
		user
	end

	factory :housing_allowance do

    sequence(:reason) {|n| "new"}
    sequence(:reason_text) {|n| "reason_#{n}"}
    sequence(:housing_style) {|n| "ta"}
    sequence(:housing_style_text) {|n| "ta_text_#{n}"}
    sequence(:agree_date_s) {|n| "agrees_#{n}"}
    sequence(:agree_date_e) {|n| "agreee_#{n}"}
    sequence(:spouse) {|n| "spouse_#{n}"}
    sequence(:spouse_name) {|n| "spouse_name_#{n}"}
    sequence(:spouse_other) {|n| "spouse_other_#{n}"}
    sequence(:support) {|n| "support_#{n}"}
    sequence(:support_name1) {|n| "support_name1_#{n}"}
    sequence(:support_name2) {|n| "support_name2_#{n}"}
    user
  end
end