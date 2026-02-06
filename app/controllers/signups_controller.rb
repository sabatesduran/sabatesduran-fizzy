class SignupsController < ApplicationController
  disallow_account_scope
  allow_unauthenticated_access
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_signup_path, alert: "Try again later." }
  before_action :redirect_authenticated_user
  before_action :enforce_tenant_limit

  layout "public"

  def new
    @signup = Signup.new
  end

  def create
    signup = Signup.new(signup_params)

    if password_login_enabled?
      if signup.valid?(:identity_creation)
        identity = Identity.find_or_create_by!(email_address: signup.email_address)
        identity.password = signup.password
        identity.password_confirmation = signup.password_confirmation
        identity.save!

        start_new_session_for identity
        redirect_to new_signup_completion_path
      else
        head :unprocessable_entity
      end
    else
      if signup.valid?(:identity_creation)
        redirect_to_session_magic_link signup.create_identity
      else
        head :unprocessable_entity
      end
    end
  end

  private
    def redirect_authenticated_user
      redirect_to new_signup_completion_path if authenticated?
    end

    def password_login_enabled?
      ActiveModel::Type::Boolean.new.cast(ENV.fetch("PASSWORD_LOGIN_ENABLED", false))
    end

    def enforce_tenant_limit
      redirect_to new_session_url unless Account.accepting_signups?
    end

    def signup_params
      params.expect(signup: %i[email_address password password_confirmation])
    end
end
