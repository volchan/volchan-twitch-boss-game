class StripeApi
  def initialize(user)
    @user = user
    @errors = []
  end

  def find_or_create_custormer(params)
    return find_customer unless @user.stripe_id.nil?
    return create_customer(params) if @user.stripe_id.nil?
  end

  def create_subscription(customer)
    Stripe::Subscription.create(
      customer: customer.id,
      items: [
        { plan: 'basic-monthly' }
      ]
    )
  rescue Stripe::CardError => e
    @errors << e.message
    false
  end

  def check_subscription
    customer = find_customer
    return false if customer.subscriptions.data.empty?
    customer.subscriptions.data.first.status == 'active'
  end

  private

  def find_customer
    Stripe::Customer.retrieve(@user.stripe_id)
  end

  def create_customer(params)
    user_params = permit_user_params(params)
    customer = Stripe::Customer.create(
      email: user_params[:email],
      source: params[:stripeToken]
    )
    @user.update(stripe_id: customer.id)
    customer
  end

  def permit_user_params(params)
    params.require(:user).permit(:email)
  end

  def user_full_name(params)
    "#{params[:first_name].capitalize} #{params[:last_name].upcase}"
  end
end
