class JokesController < ApplicationController
  load_and_authorize_resource
  before_action :find_joke, only: [:show, :edit, :update, :destroy, :like, :dislike]

  def index
    @jokes = Joke.all
  end

  def new
    @joke = Joke.new
  end

  def create
    @joke = Joke.new(joke_params)

    if @joke.save
      redirect_to @joke, notice: 'Joke was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def show; end

  def update
    if @joke.update(joke_params)
      redirect_to @joke, notice: 'Joke was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @joke.destroy
    redirect_to jokes_path, notice: 'Joke was successfully destroyed.'
  end

  def like
    vote_handler = VoteHandler.new(@joke, current_user)
    @res = vote_handler.like
    @next_joke = vote_handler.next_joke if @res
  end

  def dislike
    vote_handler = VoteHandler.new(@joke, current_user)
    @res = vote_handler.dislike
    @next_joke = vote_handler.next_joke if @res
  end

  private

  def joke_params
    params.require(:joke).permit(:content)
  end

  def find_joke
    @joke = Joke.find(params[:id])
  end
end
