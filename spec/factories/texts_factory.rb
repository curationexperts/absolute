FactoryGirl.define do
  factory :text do
    transient do
      user { FactoryGirl.create(:user) }
    end

    sequence(:title) {|n| ["Title #{n}"] }
    rights { [Sufia.config.cc_licenses.first.dup] }
    date_uploaded { Date.today }
    date_modified { Date.today }
    visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_AUTHENTICATED

    before(:create) { |work, evaluator|
      work.apply_depositor_metadata(evaluator.user.user_key)
    }

    factory :private_text do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end

    factory :public_text do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
  end
end
