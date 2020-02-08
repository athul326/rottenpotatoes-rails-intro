class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G','PG','PG-13','R','NC-17']
    @selectedratings = @all_ratings
    if params[:sort].present? then
      @sort = params[:sort]
    elsif session[:sort].present? then
      @sort = session[:sort]
    else
      @sort = params[:sort]
    end
    if params[:ratings].present? then
      @rate = params[:ratings]
    elsif session[:ratings].present? then
      @rate = session[:ratings]
    else
      @rate = params[:ratings]
    end
    session[:sort] = @sort
    session[:ratings] = @rate
    
    
    @movies = Movie.order(@sort)
    if @rate.present? then
      @movies = Movie.where(:rating => @rate.keys).order(@sort)
      @selectedratings = @rate.keys
    end
    if @sort == "title" then
      @hilite_t = 'hilite'
    elsif @sort == 'release_date' then
      @hilite_rd = 'hilite'
    end
    
  end

  def new
    # default: render 'new' template
  end
  
  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
