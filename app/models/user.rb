class User < ActiveRecord::Base
  scope :inspectors, -> { where(role: 'inspector') }
  scope :requesters, -> { where(role: 'requester') }
end
