RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end

  config.current_user_method(&:current_user)


  config.model Page do
    edit do
     configure :body, :ck_editor
    end
  end

  config.model Logincm do
    edit do
     configure :content, :ck_editor
    end
  end

  config.model BannerManagement do
    edit do
     configure :heading, :ck_editor
    end
    edit do
     configure :subtitle1, :ck_editor
    end
    edit do
     configure :subtitle2, :ck_editor
    end
    edit do
      configure :heading_position , :enum do
        enum do
          ["top-left","top-center","top-right","left","center","right","bottom-left","bottom-center","bottom-right"]
        end
      end
    end
  end

  config.model 'Ckeditor::Asset' do
    visible false
  end

  config.model 'Ckeditor::AttachmentFile' do
    visible false
  end

  config.model 'Ckeditor::Picture' do
    visible false
  end


  # == Cancan ==
  config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
