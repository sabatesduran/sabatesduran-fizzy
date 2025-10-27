require "test_helper"

class Ai::ResponseCostTest < ActiveSupport::TestCase
  test "price calculations" do
    response_cost = Ai::Cost.new(
      model_id: "gpt-4",
      input_tokens: 198,
      output_tokens: 2
    )

    # We've got 198 input tokens, so that's
    # 198 * 3000 = 594000
    assert_equal 594000, response_cost.input_cost_in_microcents

    # We've got 2 output tokens, so that's
    # 2 * 6000 = 12000
    assert_equal 12000, response_cost.output_cost_in_microcents

    # So the total is 594000 + 12000 micro-cents
    assert_equal 606000, response_cost.in_microcents
  end
end
