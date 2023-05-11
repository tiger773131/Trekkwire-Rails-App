# == Schema Information
#
# Table name: operating_locations
#
#  id         :bigint           not null, primary key
#  address    :string
#  latitude   :decimal(10, 6)
#  longitude  :decimal(10, 6)
#  position   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  account_id :bigint           not null
#
# Indexes
#
#  index_operating_locations_on_account_id  (account_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id)
#
require "test_helper"

class OperatingLocationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
