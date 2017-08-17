module ApplicationHelper
  def boss_image(boss)
    if boss.avatar.blank?
      'https://www.wallstreetotc.com/wp-content/uploads/2014/10/facebook-anonymous-app.jpg'
    else
      boss.avatar
    end
  end
end
