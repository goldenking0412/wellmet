[
  {
    name: 'Art & Design',
    color: '#f47e00',
    image: '1artanddesign.png'

  },
  {
    name: 'Events',
    color: '#fabc3d',
    image: '2events.png'
  },
  {
    name: 'Food',
    color: '#ec2f44',
    image: '3food.png'
  },
  {
    name: 'Games',
    color: '#2996e9',
    image: '4games.png'
  },
  {
    name: 'Health & Wellness',
    color: '#64c25a',
    image: '5healthandwellness.png'
  },
  {
    name: 'Media',
    color: '#afe327',
    image: '6media.png'
  },
  {
    name: 'Movies & TV',
    color: '#25b7d3',
    image: '7moviesandtv.png'
  },
  {
    name: 'Music',
    color: '#00e1c3',
    image: '8music.png'
  },
  {
    name: 'Pets',
    color: '#d630b0',
    image: '9pets.png'
  },
  {
    name: 'Sports',
    color: '#fa3d75',
    image: '10sports.png'
  },
  {
    name: 'Science & Technology',
    color: '#4864b5',
    image: '11sciencetech.png'
  },
  {
    name: 'Travel',
    color: '#a271d9',
    image: '12travel.png'
  }
].each do |c|
  Category.create(c)
end
