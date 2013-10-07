class MoviesController < ApplicationController

    def show
        id = params[:id] # retrieve movie ID from URI route
        @movie = Movie.find(id) # look up movie by unique ID
        # will render app/views/movies/show.<extension> by default
    end

    def index
        @all_ratings = Movie.all_ratings
        already_visited = false

        if params[:sort_param]
            @sort = params[:sort_param]

        elsif session[:sort_param]
            @sort = session[:sort_param]
            already_visited = true
        end

        if params[:ratings]
            @ratings = params[:ratings]

        elsif session[:ratings]
            @ratings = session[:ratings]
            already_visited = true

        else
            @all_ratings.each do |rating|
                if @ratings
                    @ratings[rating] = 0
                else
                    @ratings = {}
                    @ratings[rating] = 1
                end
            end
            already_visited = true
        end
	
        if already_visited
            redirect_to movies_path(:sort_param => @sort, :ratings => @ratings)
        end

        Movie.find(:all, :order => @sort ? @sort : :id).each do |movie|
            if @ratings.keys.include? movie[:rating]
                if @movies
                    @movies << movie
                else
                    @movies = []
                    @movies << movie
                end
            end
        end

        session[:sort_param] = @sort
        session[:ratings] = @ratings

    end

    def new
        # default: render 'new' template
    end

    def create
        @movie = Movie.create!(params[:movie])
        flash[:notice] = "#{@movie.title} was successfully created."
        redirect_to movies_path
    end

    def edit
        @movie = Movie.find params[:id]
    end

    def update
        @movie = Movie.find params[:id]
        @movie.update_attributes!(params[:movie])
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
