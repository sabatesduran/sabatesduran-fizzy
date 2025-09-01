class Notification::Bundle::DeliverJob < ApplicationJob
  queue_as :backend

  def perform(bundle)
    bundle.deliver
  end
end
