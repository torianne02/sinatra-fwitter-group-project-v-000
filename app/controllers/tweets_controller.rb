class TweetsController < ApplicationController
  get '/tweets' do
    if logged_in?
      erb :'/tweets/tweets'
    else
      redirect '/login'
    end
  end

  get '/tweets/new' do
    if logged_in?
      erb :'/tweets/new'
    else
      redirect '/login'
    end
  end

  post '/tweets' do
    if params[:content].empty?
      redirect to '/tweets/new'
    else
      @tweet = Tweet.create(content: params[:content])
      @user = User.find(session[:user_id])
      @tweet.user_id = @user.id
      @tweet.save
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find(params[:id])

      erb :'/tweets/show'
    else
      redirect '/login'
    end
  end

  get '/tweets/:id/edit' do
    if logged_in?
      @tweet = Tweet.find(params[:id])
      if !session[:user_id] == @tweet.user_id
        redirect '/tweets'
      else
        erb :'/tweets/edit'
      end
    else
      redirect '/login'
    end
  end

  patch '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    if !params[:content].empty?
      @tweet.update(content: params[:content])
    else
      redirect "/tweets/#{@tweet.id}/edit"
    end
  end

  delete '/tweets/:id/delete' do
    @tweet = Tweet.find(params[:id])
    if session[:user_id] != @tweet.user_id
      redirect '/tweets'
    else
      @tweet.delete
      redirect '/tweets'
    end
  end
end