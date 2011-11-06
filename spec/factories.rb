Factory.sequence(:article) do |n|
  "article_#{n}"
end

Factory.sequence(:name) do |n|
  "name_#{n}"
end

[:article_title, :user_name, :body].each do |sym|
  Factory.sequence(sym)  do |n|
    "#{sym.to_s}_#{n}"
  end
end


# Sample(1) シンプル
#
# Factory.define :article do |f|
#   f.title 'タイトル'
#   f.user  'uchiyama'
#   f.body  '"こんにちは'
# end

# Sample(2) シーケンスを使う
#
# Factory.define :article do |f|
#   f.title Factory.next(:article_title)
#   f.user  'uchiyama'
#   f.body  '"こんにちは'
# end

# Sample(3) 名前を遅延評価
#
Factory.define :article do |f|
 f.title { Factory.next(:article_title) } 
 f.user  'uchiyama'
 f.body  '"こんにちは'
end

# Sample(4) 関連を記述
#

Factory.define :attach do |f|
  f.filename "foo.png"
end


Factory.define :article_with_attaches, :class => Article do |f|
  f.title     { Factory.next(:article_title) } 
  f.user      'uchiyama'
  f.body      'こんにちは'
  f.attaches  [ Factory(:attach), Factory(:attach) ]
end

Factory.define :comment do |f|
  f.user  { Factory.next(:user_name) }
  f.body  "それはすごい"
end

# Sample(5) そのままコメント追加→×
#
# Factory.define :article_with_comments, :class => Article do |f|
#   f.title     { Factory.next(:article_title) } 
#   f.user      { Factory.next(:user_name) }
#   f.body      'こんにちは'
#   f.comments  [ Factory(:comment), Factory(:comment) ]
# end

# Sample(6) 遅延評価→×
#
# Factory.define :article_with_comments, :class => Article do |f|
#   f.title     { Factory.next(:article_title) } 
#   f.user      { Factory.next(:user_name) }
#   f.body      'こんにちは'
#   f.comments  {[ Factory(:comment), Factory(:comment) ]}
# end

# Sample(7) article生成後にcomment生成
#
Factory.define :article_with_comments, :class => Article do |f|
  f.title     { Factory.next(:article_title) } 
  f.user      { Factory.next(:user_name) }
  f.body      'こんにちは'
  f.after_create do |article| 
    comments = [ 
      Factory(:comment, :article_id => article.id),
      Factory(:comment, :article_id => article.id)
    ]
  end
end
