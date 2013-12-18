describe "generating routes" do
    
  it "generates correct URL for settings page" do
    repos_path.should == '/repos'
  end

  it "generates correct URLs for forks" do
    fork = FactoryGirl.build(:fork, user: 'Floppy', repo_name: 'such-travis')
    repo_path(fork).should == '/repos/Floppy/such-travis'
  end

end