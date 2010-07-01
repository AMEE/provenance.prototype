class AccountController < ApplicationController

  before_filter :build



  def graph
    case @issuekey
    when "ST-50"
      @basex=8
      @basey=4
    when "SC-47"
      @basex=8
      @basey=4
    end
  end

  def report
  end
  
  private

  def build
    @issuekey="#{params[:project]}-#{params[:issue]}"
  end

end
