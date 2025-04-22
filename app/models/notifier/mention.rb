class Notifier::Mention < Notifier
  private
    def resource
      source.container
    end

    def recipients
      [ source.mentionee ]
    end

    def creator
      source.mentioner
    end
end
