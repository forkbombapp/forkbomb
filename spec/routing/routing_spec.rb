describe "routes" do
    
  it "routes /fork to index action" do
    get('/forks').should route_to :controller => 'forks', :action => 'index'
  end

  {
    "Floppy/such-travis"  => true,
    "Floppy/such.travis"  => true,
    "Floppy/such-travis2" => true,
    "Flo_ppy/such_travis" => true,
    "Floppy/such/travis"  => false,
    "Floppysuch-travis"   => false,
    "Floppy.dot/whatever" => false,
    "/such-travis"        => false,
    "Floppy/"             => false,
    "what/the*fuck"       => false,
  }.each_pair do |fork_path, routable|
    
    if routable

      it "routes /forks/#{fork_path} to show action" do
        get("/forks/#{fork_path}").should route_to :controller => 'forks', :action => 'show', :id => fork_path
      end

    else

      it "/forks/#{fork_path} should not route" do
        get("/forks/#{fork_path}").should_not be_routable
      end

    end
  end

  it "routes /forks/Floppy/such-travis/badge.png to badge action" do
    get("/forks/Floppy/such-travis/badge.png").should route_to :controller => 'forks', :action => 'badge', :fork_id => "Floppy/such-travis", :format => 'png'
  end


end