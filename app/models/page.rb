class Page < ActiveRecord::Base
  def self.load
    Rails.application.routes.draw do
      Page.all.each do |pg|
        match "/#{pg.slug}" => "pages#show", as: "#{pg.slug}", via: [:get, :post], defaults: { id: pg.id, slug: pg.slug, format: 'json' }
      end
    end
  end

  def self.reload
    Rails.application.routes_reloader.reload!
  end
end
