class Cards::Comments::ReactionsController < ApplicationController
  include CardScoped

  before_action :set_comment

  def index
  end

  def new
  end

  def create
    reaction = @comment.reactions.create!(params.expect(reaction: :content))

    broadcast_create(reaction)
    redirect_to card_comment_reactions_path(@card, @comment)
  end

  def destroy
    reaction = @comment.reactions.find(params[:id])
    reaction.destroy

    broadcast_remove(reaction)
  end

  private
    def set_comment
      @comment = @card.comments.find(params[:comment_id])
    end

    def broadcast_create(reaction)
      reaction.broadcast_append_to @card, target: [ @comment, :reactions ], partial: "cards/comments/reactions/reaction"
    end

    def broadcast_remove(reaction)
      reaction.broadcast_remove_to @card
    end
end
