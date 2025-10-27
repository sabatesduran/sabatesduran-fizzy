class DeleteAiModels < ActiveRecord::Migration[8.2]
  def change
    drop_table :conversation_messages
    drop_table :conversations
    drop_table :ai_quotas
  end
end
