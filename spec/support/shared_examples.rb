shared_examples "requires sign in" do
  it "redirects the user to the sign in page" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to login_path
  end
end

shared_examples "tokenable" do
  it "generates a random token for each newly created user" do
    expect(object.token).to be_present
  end
end

