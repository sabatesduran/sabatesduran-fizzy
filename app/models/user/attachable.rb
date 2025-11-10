module User::Attachable
  extend ActiveSupport::Concern

  included do
    include ActionText::Attachable

    def attachable_plain_text_representation(...)
      "@#{first_name_with_last_name_initial.downcase}"
    end
  end
end
