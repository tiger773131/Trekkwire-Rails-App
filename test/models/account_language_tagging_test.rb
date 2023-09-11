# == Schema Information
#
# Table name: account_language_taggings
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :bigint           not null
#  language_tag_id :bigint           not null
#
# Indexes
#
#  index_account_language_taggings_on_account_id       (account_id)
#  index_account_language_taggings_on_language_tag_id  (language_tag_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#  fk_rails_...  (language_tag_id => language_tags.id)
#
require "test_helper"

class AccountLanguageTaggingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
