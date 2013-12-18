describe "routes" do
    
  it "routes /repos to index action" do
    get('/repos').should route_to :controller => 'repos', :action => 'index'
  end

  {
    "Floppy/such-travis"  => true,
    "Floppy/such-travis2" => true,
    "Flo_ppy/such_travis" => true,
    "Floppy/such/travis"  => false,
    "Floppysuch-travis"   => false,
    "Floppy.dot/whatever" => false,
    "/such-travis"        => false,
    "Floppy/"             => false,
    "what/the*fuck"       => false,
  }.each_pair do |repo_path, routable|
    
    if routable

      it "routes /repos/#{repo_path} to show action" do
        get("/repos/#{repo_path}").should route_to :controller => 'repos', :action => 'show', :id => repo_path
      end

    else

      it "/repos/#{repo_path} should not route" do
        get("/repos/#{repo_path}").should_not be_routable
      end

    end
  end

end