# == Schema Information
#
# Table name: warrants
#
#  id                       :bigint           not null, primary key
#  link                     :string
#  stock                    :string
#  issuer                   :string
#  code                     :string
#  status                   :string
#  start_date               :date
#  end_date                 :date
#  conversion               :integer
#  current_warrent_price    :integer
#  basic_stock_price        :integer
#  current_stock_price      :integer
#  percent_need_to_increase :integer
#  percent_expired_profile  :integer
#  percent_premium          :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#
require "test_helper"

class WarrantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
