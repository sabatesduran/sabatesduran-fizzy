class ApplicationTool < ActionMcp::BaseTool
  EMPTY_SCHEMA = { "type": "object", "properties": {}, "required": [], "additionalProperties": false }

  def tool_name
    self.class.name.remove("Tool").underscore
  end

  def tool_description
    ""
  end

  def tool_schema
    EMPTY_SCHEMA
  end

  def tool_bundle
    { name: tool_name, description: tool_description, inputSchema: tool_schema }
  end
end
