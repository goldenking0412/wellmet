class AddHeadingPositionToBannerManagements < ActiveRecord::Migration
  def change
    add_column :banner_managements, :heading_position, :string, default: 'top-center'
  end
end
