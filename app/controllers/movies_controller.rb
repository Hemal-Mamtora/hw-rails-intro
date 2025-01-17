class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings = Movie.all_ratings
      
      if params[:sort] != nil and params[:sort] != session[:sort]
        session[:sort] = params[:sort]
      end

      if params[:ratings] != nil and params[:ratings] != session[:ratings]
        session[:ratings] = params[:ratings]
      end
      
      if (session[:sort] != params[:sort] or session[:ratings] != params[:ratings])
        flash.keep
        redirect_to({:sort => session[:sort], :ratings => session[:ratings]})
      end
      
      @filter_ratings = session[:ratings] == nil ? @all_ratings : session[:ratings].keys
      @movies = Movie.with_ratings(@filter_ratings).order(session[:sort])
      
      @title_header = session[:sort] == 'title'? 'bg-warning': nil
      @release_date_header = session[:sort] == 'release_date'? 'bg-warning': nil
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
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end