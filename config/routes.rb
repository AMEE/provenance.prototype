ActionController::Routing::Routes.draw do |map|
  map.connect ':project/:issue/graph',:controller=>'account',:action=>'graph'
  map.connect ':project/:issue/report',:controller=>'account',:action=>'report'
  map.root :controller=>'account',:project=>'ST',:issue=>'50',:action=>'graph'
end
