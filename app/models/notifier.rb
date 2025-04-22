class Notifier
  attr_reader :source

  class << self
    def for(source)
      case source
        when Event
          "Notifier::Events::#{source.action.classify}".safe_constantize&.new(source)
        when ::Mention
          Notifier::Mention.new(source)
      end
    end
  end

  def notify
    if should_notify?
      recipients.map do |recipient|
        Notification.create! user: recipient, source: source, resource: resource, creator: creator
      end
    end
  end

  private
    def initialize(source)
      @source = source
    end

    def should_notify?
      true
    end

    def resource
      source
    end
end
