module StripeMailerHelper
  def subscription_date_display(subscription, user)
    unix_time = subscription.created.to_s
    unix_to_date_time(unix_time, user).strftime('%d/%m/%y %H:%M %Z')
  end

  def card_address_display(card)
    "#{card.address_line1}, #{card.address_city},
      #{card.address_zip}, #{card.address_country}"
  end

  private

  def unix_to_date_time(unix_time, user)
    DateTime.strptime(unix_time, '%s').in_time_zone(user.time_zone)
  end
end
