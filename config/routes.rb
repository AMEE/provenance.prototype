ActionController::Routing::Routes.draw do |map|
  map.connect 'everything/graph',:controller=>'account',:action=>'graph',:account=>'everything'
  map.connect 'everything/report',:controller=>'account',:action=>'report',:account=>'everything'
  map.connect ':account/report',:controller=>'account',:action=>'report'
  map.connect ':account/graph',:controller=>'account',:action=>'graph'
  map.root :controller=>'account',:project=>'SC',:issue=>'47',:action=>'graph'
end
