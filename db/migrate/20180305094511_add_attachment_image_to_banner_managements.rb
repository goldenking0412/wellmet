class AddAttachmentImageToBannerManagements < ActiveRecord::Migration
  def self.up
    change_table :banner_managements do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :banner_managements, :image
  end
end
