FactoryGirl.define do
  factory :case_generic_work, class: CaseGenericWork do
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
      work.owner = evaluator.user.user_key
    }

    factory :private_case_generic_work do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end
    factory :public_case_generic_work do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
    factory :case_generic_work_with_files do
      transient do
        file_count 3
      end

      after(:create) do |work, evaluator|
        FactoryGirl.create_list(:generic_file, evaluator.file_count, batch: work, user: evaluator.user)
      end
    end
  end
end
