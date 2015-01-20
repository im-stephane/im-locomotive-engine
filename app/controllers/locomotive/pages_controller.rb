module Locomotive
  class PagesController < BaseController

    localized

    before_filter :back_to_default_site_locale, only: %w(new create)

    before_filter :load_page, only: [:show, :edit, :update, :sort, :destroy]

    layout 'locomotive/layouts/preview', only: [:edit]

    respond_to :json, only: [:show, :create, :update, :sort, :get_path]

    def index
      authorize Page
      @pages = current_site.all_pages_in_once
      respond_with(@pages)
    end

    def show
      authorize @page
      respond_with @page
    end

    def new
      authorize Page
      @page = current_site.pages.build
      respond_with @page
    end

    def create
      authorize Page
      @page = current_site.pages.create(page_params)
      respond_with @page, location: -> { edit_page_path(current_site, @page) }
    end

    def edit
      authorize @page
      respond_with @page
    end

    def update
      authorize @page
      @page.update_attributes(page_params)
      respond_with @page, location: edit_page_path(current_site, @page)
    end

    def destroy
      authorize @page
      @page.destroy
      respond_with @page, location: pages_path(current_site)
    end

    def sort
      authorize @page, :update?
      @page.sort_children!(params.require(:children))
      respond_with @page, location: edit_page_path(current_site, @page)
    end

    def get_path
      page = current_site.pages.build(parent: current_site.pages.find(params[:parent_id]), slug: params[:slug].permalink).tap do |p|
        p.valid?; p.send(:build_fullpath)
      end
      render json: {
        url:                public_page_url(page, locale: current_content_locale),
        slug:               page.slug,
        templatized_parent: page.templatized_from_parent?
      }
    end

    private

    def load_page
      @page = current_site.pages.find(params[:id])
    end

    def page_params
      params.require(:page).permit(:title, :slug, :published, :parent, :parent_id, :raw_template)
    end

  end
end
