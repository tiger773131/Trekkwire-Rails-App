# == Schema Information
#
# Table name: tours
#
#  id          :bigint           not null, primary key
#  description :text
#  duration    :integer
#  price       :decimal(8, 2)
#  tagline     :string
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint           not null
#
# Indexes
#
#  index_tours_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
require "test_helper"

class TourTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
