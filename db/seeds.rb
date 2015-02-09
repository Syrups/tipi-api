# Some sample data
#
# Run rake db:seed to seed in DB

leo = Api::User.create(username: 'Léo')

story = leo.stories.create(title: 'Costa Rica journey')

glenn = Api::User.create(username: 'Glenn')

leo.subscribers << glenn
story.receivers << glenn

story.pages << Api::Page.create(position: 1)
story.pages << Api::Page.create(position: 2)
story.pages << Api::Page.create(position: 3)

