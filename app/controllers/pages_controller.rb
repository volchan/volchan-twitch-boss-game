class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home show]

  def home; end
end
