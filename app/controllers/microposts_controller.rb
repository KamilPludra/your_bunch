# encoding: utf-8

class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Wiadomość utworzona!"
      redirect_to root_url


     # respond_to do |format|
      #  format.html { redirect_to @user }
       # format.js
      #end


    else
      @feed_items = []
      render 'strony_statyczne/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

  def correct_user
    @micropost = current_user.microposts.find_by_id(params[:id])
    redirect_to root_url if @micropost.nil?
  end
end