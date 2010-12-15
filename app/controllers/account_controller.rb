class AccountController < ApplicationController

  before_filter :build, :except=>'index'
  require 'account' #Explicit include of model because we use derived classes
  #so autoloader gets confused cos I didn't make each one its own file


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

  def index
    #list available accounts
    @accounts=PertainingCategory.available_categories.
      concat(DirectCategory.available_categories).
      concat(JiraAccount.available_issues).
      concat([
        EverythingAccount.new
      ])
  end
  
  private

  def build
    if params[:account]
      @account=RawAccount.new(account)
    elsif params[:everything]
      @account=EverythingAccount.new
    elsif params[:allpath]
      @account=PertainingCategory.new(params[:allpath])
    elsif params[:textpath]
      @account=DirectCategory.new(params[:textpath])
    elsif params[:project]
      @account=JiraAccount.new(params[:project],params[:issue])
    else
      raise "Invalid route"
    end
    @code=@account.code
    @label=@account.label
   #lossy encoding as partial names must be valid variable names
  end

end
