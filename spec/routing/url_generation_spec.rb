describe "generating routes" do
    
  it "generates correct URL for settings page" do
    forks_path.should == '/forks'
  end

  it "generates correct URLs for forks" do
    fork = FactoryGirl.build(:fork, owner: 'Floppy', repo_name: 'such-travis')
    fork_path(fork).should == '/forks/Floppy/such-travis'
  end

end