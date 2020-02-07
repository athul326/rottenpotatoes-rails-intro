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
    session.update(params)
    @all_ratings = ['G','PG','PG-13','R','NC-17']
    @selectedratings = @all_ratings
    if(params[:sort]==nil or params[:ratings]==nil) then
      flash.keep
      redirect_to movies_path({:sort=>session[:sort],:ratings=>session[:ratings]})
    end
    
    if session[:ratings]
      @selectedratings = session[:ratings].keys
      @movies = Movie.where(rating: session[:ratings].keys)
    else
      @movies = Movie.all
    end
    
    if session[:sort] == 'title'
      @movies = Movie.where(rating: session[:ratings].keys).order('title ASC')
      @hilite_t = 'hilite'
    end
    if session[:sort] == 'release_date'
      @movies = Movie.where(rating: session[:ratings].keys).order('release_date')
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
