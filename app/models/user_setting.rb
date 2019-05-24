class UserSetting < ActiveRecord::Base
  serialize :ages, Hash
end
