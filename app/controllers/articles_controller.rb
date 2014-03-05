class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.xml
  layout 'boxed'

  before_filter :select_article,:only => [:show,:edit,:update,:destroy]
  before_filter :"current_user!",:only=>[:new,:create,:edit,:update]
  
  def index
    @articles = Article.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    
    @article = Article.new
    fail User::PermissionDenied unless @article.can_be_created?(current_user)
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    fail User::PermissionDenied unless @article.can_be_updated?(current_user)
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = Article.new(params[:article])
    fail User::PermissionDenied unless @article.can_be_created?(current_user)
    @article.user = current_user
    respond_to do |format|
      if @article.save
        created_message(@article)
        format.html { redirect_to(@article) }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    
    fail User::PermissionDenied unless @article.can_be_updated?(current_user)
    respond_to do |format|
      if @article.update_attributes(params[:article])
        updated_message(@article)
        format.html { redirect_to(@article) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    fail User::PermissionDenied unless @article.can_be_deleted?(current_user)
    deleted_message(@article)
    @article.destroy
    respond_to do |format|
      format.html { redirect_to(articles_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def select_article
    @article = Article.find(params[:id])
  end
  
end
