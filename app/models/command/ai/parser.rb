class Command::Ai::Parser
  include Rails.application.routes.url_helpers

  attr_reader :context

  delegate :user, to: :context

  def initialize(context)
    @context = context
  end

  def parse(query)
    query_json = resolve_named_params_to_ids command_translator.as_normalized_json(query)
    build_chat_response_with query, query_json
  end

  private
    def command_translator
      Command::Ai::Translator.new(context)
    end

    def resolve_named_params_to_ids(query_json)
      query_json.tap do |query_json|
        if query_context = query_json["context"].presence
          query_context["assignee_ids"] = query_context["assignee_ids"]&.filter_map { |name| assignee_from(name)&.id }
          query_context["creator_id"] = assignee_from(query_context["creator_id"])&.id if query_context["creator_id"]
          query_context["collection_ids"] = query_context["collection_ids"]&.filter_map { |name| Collection.where("lower(name) = ?", name.downcase).first&.id }
          query_context["tag_ids"] = query_context["tag_ids"]&.filter_map { |name| ::Tag.find_by_title(name)&.id }
          query_context.compact!
        end
      end
    end

    def assignee_from(string)
      string_without_at = string.delete_prefix("@")
      User.all.find { |user| user.mentionable_handles.include?(string_without_at) }
    end

    def build_chat_response_with(query, query_json)
      query_context = context_from_query(query_json)
      resolved_context = query_context || context

      commands = Array.wrap(commands_from_query(query_json, resolved_context))

      if query_context
        commands.unshift Command::VisitUrl.new(user: user, url: query_context.url, context: resolved_context)
      end

      Command::Composite.new(title: query, commands: commands, user: user, line: query, context: resolved_context)
    end

    def context_from_query(query_json)
      if context_properties = query_json["context"].presence
        url = cards_path(**context_properties)
        Command::Parser::Context.new(user, url: url)
      end
    end

    def commands_from_query(query_json, context)
      parser = Command::Parser.new(context)
      if command_lines = query_json["commands"].presence
        command_lines.collect { parser.parse(it) }
      end
    end
end
