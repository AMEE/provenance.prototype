class AccountController < ApplicationController

  before_filter :build



  def graph
    case @account
    when false
    else
      @basex=8
      @basey=4
    end
  end

  def report
  end
  
  private

  def build
    if params[:account]
      @account=params[:account]
    else
      @account="#{params[:project]}-#{params[:issue]}"
    end
  end

end
