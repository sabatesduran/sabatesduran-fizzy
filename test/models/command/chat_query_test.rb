require "test_helper"

class Command::ChatQueryTest < ActionDispatch::IntegrationTest
  include CommandTestHelper

  setup do
    Current.session = sessions(:david)
  end

  test "sandbox list of cards" do
    user = users(:david)
    url = cards_url
    context = Command::Parser::Context.new(user, url: url)
    puts Command::ChatQuery.new(user: user, context: context, query: "summarize cards about performance").execute
    puts Command::ChatQuery.new(user: user, context: context, query: "tag with #performance").execute
    puts Command::ChatQuery.new(user: user, context: context, query: "cards assigned to jorge").execute
    puts Command::ChatQuery.new(user: user, context: context, query: "performance cards assigned to jorge").execute
    puts Command::ChatQuery.new(user: user, context: context, query: "close performance cards assigned to jorge and tag them with #performance").execute
  end

  test "sandbox single card" do
    user = users(:david)
    url = card_url(cards(:logo))
    context = Command::Parser::Context.new(user, url: url)
    puts Command::ChatQuery.new(user: user, context: context, query: "summarize cards about performance").execute
    puts Command::ChatQuery.new(user: user, context: context, query: "tag with performance and close").execute
    puts Command::ChatQuery.new(user: user, context: context, query: "summarize this card").execute
    puts Command::ChatQuery.new(user: user, context: context, query: "tag with #performance").execute
    puts Command::ChatQuery.new(user: user, context: context, query: "cards assigned to jorge").execute
    puts Command::ChatQuery.new(user: user, context: context, query: "performance cards assigned to jorge").execute
    puts Command::ChatQuery.new(user: user, context: context, query: "close performance cards assigned to jorge and tag them with #performance").execute
  end
end
