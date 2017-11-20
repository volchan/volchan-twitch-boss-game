class StripeApi
  attr_reader :user, :errors

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
    add_error(e)
  rescue Stripe::InvalidRequestError => e
    add_error(e)
  end

  def check_subscription
    customer = find_customer
    return false if customer.deleted?
    return false if customer.subscriptions.data.empty?
    customer.subscriptions.data.first.status == 'active'
  end

  def find_customer
    Stripe::Customer.retrieve(@user.stripe_id)
  end

  private

  def create_customer(params)
    user_params = user_params(params)
    customer = Stripe::Customer.create(
      email: user_params[:email],
      source: params[:stripeToken],
      description: customer_description(user_params)
    )
    @user.update(stripe_id: customer.id)
    customer
  end

  def user_params(params)
    params.require(:user).permit(:email, :first_name, :last_name, :full_address)
  end

  def customer_description(params)
    "#{customer_full_name(params)}, #{params[:full_address]}"
  end

  def customer_full_name(params)
    "#{params[:first_name].capitalize} #{params[:last_name].upcase}"
  end

  def add_error(e)
    @errors << e.message
    false
  end
end
