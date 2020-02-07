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
    @movies = Movie.all
    @all_ratings = ['G','PG','PG-13','R','NC-17']
    @selectedratings = @all_ratings
    hash = Hash.new
    
    
    if (!params[:ratings].present? && session[:ratings].present?) || (!params[:sort].present? && session[:sort].present?)
      if session[:ratings].present?
        hash = {:ratings => session[:ratings]}
      end
      if session[:sort].present?
        hash = {:sort => session[:sort]}
      end
      flash.keep
      redirect_to movies_path(params.merge(hash))
    end
    
    if params[:ratings]
      @selectedratings = params[:ratings].keys
      @movies = Movie.where(rating: params[:ratings].keys)
    end
    
    if params[:sort] == 'title'
      @movies = Movie.order('title ASC')
      @hilite_t = 'hilite'
    end
    if params[:sort] == 'release_date'
      @movies = Movie.order('release_date')
      @hilite_rd = 'hilite'
    end
    
    session[:ratings] = params[:ratings]
    session[:sort] = params[:sort]
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
