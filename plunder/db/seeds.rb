# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u1 = User.create!({:email => "a@a.aa", :password => "11111111", :password_confirmation => "11111111" })
u2 = User.create!({:email => "b@b.bb", :password => "11111111", :password_confirmation => "11111111" })

m = u1.articles.create(name: 'Milch')
b = u2.articles.create(name: 'Butter')


 u1.favorites << m
 u1.favorites << b

 u2.favorites << b