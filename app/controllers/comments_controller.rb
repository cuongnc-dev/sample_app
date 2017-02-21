class CommentsController < ApplicationController
  def create
  	session[:return_to] ||= request.referer
  	@comment = Comment.new(content: params[:comment][:content], user_id: current_user.id, micropost_id: params[:comment][:micropost_id])
    if @comment.save
      flash[:success] = "Comment successful!"
      redirect_to session.delete(:return_to)
    else
	    @current_micropost = current_user.microposts.find_by(id: params[:comment][:micropost_id])
	    @comment = Comment.new

	    @comments = @current_micropost.comments.paginate(page: params[:page])
	    render 'microposts/show'
    end
  end

  def update
  	@comment = Comment.find(params[:id])
  	session[:return_to] ||= request.referer
  	if @comment.update_attributes(content: params[:comment][:content])
  		flash[:success]	= "Edit successful!"
  		redirect_to session.delete(:return_to)
  	else
  		flash[:danger]  = "Edit failed!"
  		redirect_to session.delete(:return_to)
  	end
  end

  def destroy
  	@comment = Comment.find(params[:id])
  	@comment.destroy
    flash[:success] = "Comment deleted!"
    session[:return_to] ||= request.referer
    redirect_to session.delete(:return_to)
  end
end
