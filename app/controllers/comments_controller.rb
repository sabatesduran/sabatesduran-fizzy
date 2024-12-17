class CommentsController < ApplicationController
  include BubbleScoped, BucketScoped
  before_action :set_comment, only: [ :show, :edit, :update, :destroy ]

  def create
    @bubble.capture new_comment
    redirect_to @bubble
  end

  def show
  end

  def edit
  end

  def update
    @comment.update! comment_params
    render :show
  end

  def destroy
    @comment.destroy
    redirect_to @bubble
  end

  private
    def comment_params
      params.require(:comment).permit(:body)
    end

    def new_comment
      Comment.new(comment_params)
    end

    def set_comment
      @comment = Comment.joins(:message)
                        .where(messages: { bubble_id: @bubble.id })
                        .find(params[:id])
    end
end
