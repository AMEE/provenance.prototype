ActionController::Routing::Routes.draw do |map|
  map.connect 'everything/graph',:controller=>'account',:action=>'graph',:everything=>true
  map.connect 'everything/report',:controller=>'account',:action=>'report',:everything=>true
  map.connect ':account/report',:controller=>'account',:action=>'report'
  map.connect ':account/graph',:controller=>'account',:action=>'graph'
  map.connect 'category/*allpath/graph', :controller=>'account',:action=>'graph'
  map.connect 'category/*allpath/report', :controller=>'account',:action=>'report'
  map.connect 'textual/*textpath/graph', :controller=>'account',:action=>'graph'
  map.connect 'textual/*textpath/report', :controller=>'account',:action=>'report'
  map.connect 'issue/:project/:issue/graph', :controller=>'account',:action=>'graph'
  map.connect 'issue/:project/:issue/report', :controller=>'account',:action=>'report'
  map.root :controller=>'account',:action=>'index'
end
