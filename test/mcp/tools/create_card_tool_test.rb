require "test_helper"

class CreateCardToolTest < ActiveSupport::TestCase
  test "create" do
    tool = CreateCardTool.new
    assert_equal({name: "create_card", description: "Create a published card on a board", inputSchema: {type: "object", properties: {board_id: {type: "string", description: "Board UUID"}, title: {type: "string", description: "Card title"}, description: {type: "string", description: "Optional rich text body"}}, required: ["board_id", "title"]}}, tool.tool_bundle)
  end
end
