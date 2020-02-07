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
      if params[:sort] == 'title' then
        @movies = Movie.order('title ASC')
      elsif params[:sort] == 'release_date' then
        @movies = Movie.order('release_date')
      end
      session[:sort] = params[:sort]
    elsif session[:sort].present? then
      redirect_to movies_path(session)
    end
    
    if params[:rating].present? then
      @selectedratings = params[:ratings].keys
      @movies = Movie.where(rating: params[:ratings].keys)
      session[:rating] = params[:rating]
    elsif session[:rating].present? then
      redirect_to movies_path(session)
    else
      @movies = Movie.where(rating: all_ratings).order(params[:sort])
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
