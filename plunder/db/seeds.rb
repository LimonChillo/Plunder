# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u1 = User.create!({:email => "a@a.aa", :password => "11111111", :password_confirmation => "11111111" })
u2 = User.create!({:email => "b@b.bb", :password => "11111111", :password_confirmation => "11111111" })
u3 = User.create!({:email => "c@c.cc", :password => "11111111", :password_confirmation => "11111111" })
u4 = User.create!({:email => "d@d.dd", :password => "11111111", :password_confirmation => "11111111" })
u5 = User.create!({:email => "e@e.ee", :password => "11111111", :password_confirmation => "11111111" })

m = u1.articles.create(name: 'Monitor')
b = u1.articles.create(name: 'Lego')
e = u2.articles.create(name: 'Ente')
f = u3.articles.create(name: 'Hotwheels')
s = u3.articles.create(name: 'Nudeln')
t = u5.articles.create(name: 'Tisch')



u1.favorites << e
u1.favorites << f

u2.favorites << b
u2.favorites << m
u2.favorites << s

u3.favorites << b


u4.favorites << s
u4.favorites << e
u4.favorites << f


u1.favorites << s
u2.favorites << f
u3.favorites << m
u3.favorites << e
u4.favorites << m
u4.favorites << b

u5.favorites << m
u5.favorites << b

Exchange.create(:article_id_1 => 1, :article_id_2 => 3, :user_1 => 1, :user_2 => 2, :accept_1 => 3, :accept_2 => 3)
Exchange.create(:article_id_1 => 2, :article_id_2 => 3, :user_1 => 1, :user_2 => 2, :accept_1 => 3, :accept_2 => 3)

Exchange.create(:article_id_1 => 1, :article_id_2 => 4, :user_1 => 1, :user_2 => 3, :accept_1 => 3, :accept_2 => 3)
Exchange.create(:article_id_1 => 2, :article_id_2 => 4, :user_1 => 1, :user_2 => 3, :accept_1 => 3, :accept_2 => 3)
Exchange.create(:article_id_1 => 1, :article_id_2 => 5, :user_1 => 1, :user_2 => 3, :accept_1 => 3, :accept_2 => 3)

#xchange.create(:article_id_1 => 5, :article_id_2 => 3, :user_1 => 1, :user_2 => 3, :accept_1 => 3, :accept_2 => 3)
#Exchange.create(:article_id_1 => , :article_id_2 => , :user_1 => 1, :user_2 => 3, :accept_1 => 3, :accept_2 => 3)


Match.update_all(:like => true)