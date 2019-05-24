class CategoriesController < ApplicationController
  load_and_authorize_resource
  # GET /categories.json
  def index
    @categories = Category.where(deactivate: false)
  end
end
