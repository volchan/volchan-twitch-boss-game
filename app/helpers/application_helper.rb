module ApplicationHelper
  def boss_image(boss)
    if boss.avatar.blank?
      'https://static-cdn.jtvnw.net/jtv_user_pictures/xarth/404_user_300x300.png'
    else
      boss.avatar
    end
  end
end
