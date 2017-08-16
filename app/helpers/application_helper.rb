module ApplicationHelper
  def boss_image(boss)
    if boss.avatar.nil?
      "background-image: linear-gradient(rgba(0,0,0, 0), rgba(0,0,0, 0.2)), url('https://www.wallstreetotc.com/wp-content/uploads/2014/10/facebook-anonymous-app.jpg');"
    else
      "background-image: linear-gradient(rgba(0,0,0, 0), rgba(0,0,0, 0.2)), url('#{boss.avatar}');"
    end
  end
end
