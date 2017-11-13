# frozen_string_literal: true

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
class Profile < ActiveRecord::Base
  belongs_to :user
end
