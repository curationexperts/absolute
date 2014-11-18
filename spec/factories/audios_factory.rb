FactoryGirl.define do
  factory :audio, class: Audio do
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

    factory :private_audio do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end
    factory :public_audio do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end

    factory :audio_with_files do
      transient do
        file_count 3
      end

      after(:create) do |work, evaluator|
        FactoryGirl.create_list(:generic_file, evaluator.file_count, batch: work, user: evaluator.user)
      end
    end
  end
end
