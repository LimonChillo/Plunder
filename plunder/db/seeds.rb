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
u4 = User.create!({:email => "c@b.cc", :password => "11111111", :password_confirmation => "11111111" })


m = u1.articles.create(name: 'Milch')
b = u1.articles.create(name: 'Butter')
e = u2.articles.create(name: 'Eier')
f = u3.articles.create(name: 'Fleisch')
s = u3.articles.create(name: 'Saft')




u1.favorites << e
u1.favorites << f

u2.favorites << b
u2.favorites << m
u2.favorites << s

u3.favorites << b

u4.favorites << s
u4.favorites << e
u4.favorites << f

Match.update_all(:like => true)