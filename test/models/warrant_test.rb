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
#  conversion               :float
#  current_warrant_price    :integer
#  basic_stock_price        :integer
#  current_stock_price      :integer
#  percent_need_to_increase :float
#  percent_expired_profit   :float
#  percent_premium          :float
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  tham_chieu               :integer
#
require "test_helper"

class WarrantTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
