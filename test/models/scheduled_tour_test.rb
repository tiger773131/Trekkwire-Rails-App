# == Schema Information
#
# Table name: scheduled_tours
#
#  id              :bigint           not null, primary key
#  location        :string
#  scheduled_date  :date
#  scheduled_time  :time
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_user_id :bigint
#  tour_id         :bigint           not null
#
# Indexes
#
#  index_scheduled_tours_on_account_user_id  (account_user_id)
#  index_scheduled_tours_on_tour_id          (tour_id)
#
# Foreign Keys
#
#  fk_rails_...  (account_user_id => account_users.id)
#  fk_rails_...  (tour_id => tours.id)
#
require "test_helper"

class ScheduledTourTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
