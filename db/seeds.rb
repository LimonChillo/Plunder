# u1 = User.new({:email => "a@a.aa", :password => "11111111", :password_confirmation => "11111111", :name => "Susanne", :location => "Salzburg"})
# u2 = User.new({:email => "b@b.bb", :password => "11111111", :password_confirmation => "11111111", :name => "Lisa", :location => "Kufstein" })
# u3 = User.new({:email => "c@c.cc", :password => "11111111", :password_confirmation => "11111111", :name => "Klaus", :location => "Hallein" })
# u4 = User.new({:email => "d@d.dd", :password => "11111111", :password_confirmation => "11111111", :name => "Dieter", :location => "Innsbruck" })
# u5 = User.new({:email => "e@e.ee", :password => "11111111", :password_confirmation => "11111111", :name => "Manuel", :location => "Puch" })

# u1.skip_confirmation!
# u2.skip_confirmation!
# u3.skip_confirmation!
# u4.skip_confirmation!
# u5.skip_confirmation!

# u1.save!
# u2.save!
# u3.save!
# u4.save!
# u5.save!

# m = u1.articles.create(name: 'Monitor')
# b = u1.articles.create(name: 'Lego', shippable: true)
# e = u2.articles.create(name: 'Ente', shippable: true)
# f = u3.articles.create(name: 'Hotwheels')
# s = u3.articles.create(name: 'Nudeln')
# t = u5.articles.create(name: 'Tisch')



# u1.favorites << e
# u1.favorites << f

# u2.favorites << b
# u2.favorites << m
# u2.favorites << s

# u3.favorites << b

# u4.favorites << s
# u4.favorites << e
# u4.favorites << f


# u1.favorites << s
# u2.favorites << f
# u3.favorites << m
# u3.favorites << e
# u4.favorites << m
# u4.favorites << b

# u5.favorites << m
# u5.favorites << b

# Exchange.create(:article_id_1 => 1, :article_id_2 => 3, :user_1 => 1, :user_2 => 2, :user_1_accept => "unset", :user_2_accept => "unset")
# Exchange.create(:article_id_1 => 2, :article_id_2 => 3, :user_1 => 1, :user_2 => 2, :user_1_accept => "unset", :user_2_accept => "unset")

# Exchange.create(:article_id_1 => 4, :article_id_2 => 3, :user_1 => 3, :user_2 => 2, :user_1_accept => "unset", :user_2_accept => "unset")
# Exchange.create(:article_id_1 => 5, :article_id_2 => 3, :user_1 => 3, :user_2 => 2, :user_1_accept => "unset", :user_2_accept => "unset")

# Exchange.create(:article_id_1 => 1, :article_id_2 => 4, :user_1 => 1, :user_2 => 3, :user_1_accept => "unset", :user_2_accept => "unset")
# Exchange.create(:article_id_1 => 2, :article_id_2 => 4, :user_1 => 1, :user_2 => 3, :user_1_accept => "unset", :user_2_accept => "unset")
# Exchange.create(:article_id_1 => 1, :article_id_2 => 5, :user_1 => 1, :user_2 => 3, :user_1_accept => "unset", :user_2_accept => "unset")
# Exchange.create(:article_id_1 => 2, :article_id_2 => 5, :user_1 => 1, :user_2 => 3, :user_1_accept => "unset", :user_2_accept => "unset")


# Match.update_all(:like => true)