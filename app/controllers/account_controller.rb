class AccountController < ApplicationController

  before_filter :build



  def graph
    case @code
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
      @label=" information in account #{params[:account]}"
      rawcode="-x params[:account]"
    elsif params[:everything]
      @label="all information available"
      rawcode="-b"
    elsif params[:allpath]
      jpath=params[:allpath].join('/')
      @label="all information pertaining to AMEE category #{jpath}"
      rawcode="--database sesame-sparql -b --category-subgraph /#{jpath}"
    elsif params[:textpath]
      jpath=params[:textpath].join('/')
      @label="all information pertaining to AMEE category #{jpath}"
      rawcode="-x --category /#{jpath}"
    elsif params[:project]
      @label=" information in jira ticket #{params[:project]}-#{params[:issue]}"
      rawcode=code "-x -i #{params[:project]}-#{params[:issue]}"
    else
      raise "Invalid route"
    end
    @code=CGI.escape(rawcode).gsub('+','_').gsub('%','__').gsub('-','_')
   #lossy encoding as partial names must be valid variable names
  end

end
