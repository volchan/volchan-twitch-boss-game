logger = Logger.new(STDOUT)

logger.info '> seeding...'
User.destroy_all
Bot.destroy_all

User.create!(
  username: 'volchan',
  email: 'contact@volchan.fr',
  password: 'Sy8sep4s!',
  time_zone: 'Paris',
  admin: true
)
logger.info '.'

bot_data = YAML.safe_load(File.read('db/seed_data/bots.yml'))
bot_data.each do |bot|
  user = User.create!(
    username: bot['channel'],
    email: "#{bot['channel']}@gmail.com",
    password: 'Sy8sep4s!',
    time_zone: 'Paris'
  )

  bot = Bot.create!(bot.merge(user: user))
  Boss.create!(
    bot: bot,
    name: 'No boss yet!',
    current_hp: 1,
    max_hp: 1,
    current_shield: 0,
    max_shield: 1
  )
  logger.info '.'
end

logger.info 'Done!'
