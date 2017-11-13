# == Schema Information
#
# Table name: profiles
#
#  id         :integer          not null, primary key
#  first_name :string           default("")
#  last_name  :string           default("")
#  phone      :string           default("")
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Profile, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
