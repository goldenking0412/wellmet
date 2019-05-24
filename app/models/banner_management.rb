class BannerManagement < ActiveRecord::Base
  has_attached_file :image,
    :storage => :cloudinary,
    :styles => { medium: '300x300>', thumb: '100x100>', landscape: '1800x1200#'},
    :cloudinary_url_options => {
        :default => {
            :secure => true
        },
        :styles => {
            :avatar => {
                :quality => 75,
                :transformation => [ { :angle => 20 } ]
            }
        }
     },
    :overwrite => true,
    :cloudinary_resource_type => :image,
    :path => ':id/:style/:filename',
    :cloudinary_credentials => '#{Rails.root}/config/cloudinary.yml'
  validates_attachment :image, presence: true
  validates_uniqueness_of :position
  do_not_validate_attachment_file_type :image
  validates_inclusion_of :heading_position, :in => %w(top-left top-center top-right left center right bottom-left bottom-center bottom-right),
  :message => "%{value} is not a valid size"
end
