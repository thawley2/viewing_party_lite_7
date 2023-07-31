class MovieFacade
  def initialize(id)
    @id = id
  end

  def movie
    @_movie ||= Movie.new(format_movie_data)
  end

  def reviews
    @_reviews ||= reviews_data.map do |review|
      Review.new(review)
    end
  end

  def cast
    @_cast ||= cast_data.map do |cast_member|
      CastMember.new(cast_member)
    end
  end

  def self.get_movie_poster(id)
    facade = create_facade(id)
    facade.movie.poster
  end

  def movie_poster 
    movie.poster
  end

  def self.get_movie_title(id)
    facade = create_facade(id)
    facade.movie.title
  end

  def self.create_facade(id)
    MovieFacade.new(id)
  end

  def movie_id
    movie.id
  end

  def movie_title
    movie.title
  end

  def movie_vote_average
    movie.vote_average
  end

  def movie_runtime
    movie.runtime
  end

  def movie_genres
    movie.genres
  end

  def movie_summary
    movie.summary
  end

  private
    def service
      @_service ||= MovieDataService.new
    end

    def movie_data
      @_movie_data ||= service.find_movie(@id)
    end

    def format_movie_data
      movie = movie_data

      data = {
        id: movie[:id],
        title: movie[:title],
        vote_average: movie[:vote_average],
        runtime: movie[:runtime],
        genres: get_genres(movie[:genres]),
        summary: movie[:overview],
        poster: create_url(movie[:poster_path])
      }
    end

    def reviews_data
      @_reviews_data ||= service.find_reviews(@id)[:results]
    end

    def cast_data
      @_cast_data ||= service.find_cast(@id)[:cast][0..9]
    end

    def get_genres(genres)
      genres.map {|genre| genre[:name]}
    end

    def create_url(path)
      'https://image.tmdb.org/t/p/original' + path
    end
end