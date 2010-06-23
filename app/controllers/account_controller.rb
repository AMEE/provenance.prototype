class AccountController < ApplicationController

  before_filter :build



  def graph
  end

  def report
  end
  
  private

  def build
    @issuekey="#{params[:project]}-#{params[:issue]}"
  end

end
