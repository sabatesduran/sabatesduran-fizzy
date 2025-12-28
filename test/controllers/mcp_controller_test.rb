require "test_helper"

class McpControllerTest < ActionDispatch::IntegrationTest
  setup do
    @write_token = bearer_token_header(identity_access_tokens(:davids_api_token).token)
    @board = boards(:writebook)
    @card = cards(:layout)
  end

  test "lists tools" do
    post mcp_path,
      params: { id: "1", method: "tools/list", params: {} },
      headers: @write_token,
      as: :json

    assert_response :success
    tool_names = response.parsed_body.dig("result", "tools").map { |tool| tool["name"] }

    %w[ list_boards show_board create_card close_card create_comment ].each do |tool_name|
      assert_includes tool_names, tool_name
    end
  end

  test "lists boards for the authenticated account" do
    post mcp_path,
      params: { id: "2", method: "tools/call", params: { name: "list_boards", arguments: {} } },
      headers: @write_token,
      as: :json

    assert_response :success
    boards = response.parsed_body.dig("result", "data", "boards")

    assert_equal [ @board.id ], boards.map { |board| board["id"] }
  end

  test "creates a card" do
    assert_difference -> { Card.count }, +1 do
      post mcp_path,
        params: { id: "3", method: "tools/call", params: { name: "create_card", arguments: { board_id: @board.id, title: "New MCP Card", description: "Created through MCP" } } },
        headers: @write_token,
        as: :json
    end

    assert_response :created
    card_data = response.parsed_body.dig("result", "data", "card")

    assert_equal "New MCP Card", card_data["title"]
  end

  test "closes a card by number" do
    post mcp_path,
      params: { id: "4", method: "tools/call", params: { name: "close_card", arguments: { card_number: @card.number } } },
      headers: @write_token,
      as: :json

    assert_response :success
    assert_predicate @card.reload, :closed?
  end

  test "creates a comment on a card" do
    assert_difference -> { @card.comments.count }, +1 do
      post mcp_path,
        params: { id: "5", method: "tools/call", params: { name: "create_comment", arguments: { card_number: @card.number, body: "Hello from MCP" } } },
        headers: @write_token,
        as: :json
    end

    assert_response :created
    assert_equal "Hello from MCP", @card.reload.comments.last.body.to_plain_text
  end

  private
    def bearer_token_header(token)
      { "Authorization" => "Bearer #{token}" }
    end
end
