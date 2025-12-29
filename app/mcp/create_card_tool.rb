class CreateCardTool < ApplicationTool
  def tool_description
    "Create a published card on a board"
  end

  def tool_schema
    {
      type: "object",
      properties: {
        board_id: { type: "string", description: "Board UUID" },
        title: { type: "string", description: "Card title" },
        description: { type: "string", description: "Optional rich text body" }
      },
      required: [ "board_id", "title" ]
    }
  end

  def call
    # card = Current.user.accessible_cards.find_by(number: arguments["card_number"])
    #
    # case
    # when card.nil?
    #   error "Card not found: ##{arguments["card_number"]}")
    # when card.closed?
    #   error "Card ##{card.number} is already closed")
    # end
    #
    # card.close(user: Current.user)
    # success "Closed card ##{card.number}: #{card.title}"
  end
end
