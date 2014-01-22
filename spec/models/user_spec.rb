require 'spec_helper'

describe User do

    before { @user = User.new(name: "Lincoln Fitzsimons", 
                              email: "example@test.com",
                              password: "passtest",
                              password_confirmation: "passtest") }

    subject { @user }

    it { should respond_to(:name) }
    it { should respond_to(:email) }
    it { should respond_to(:password_digest) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }
    it { should respond_to(:authenticate) }
    it { should be_valid }
    
    # name tests
    describe "when name is not present" do 
        before { @user.name = " " }
        it { should_not be_valid }
    end
    describe "when name is too short" do
        before { @user.name = "aa" }
        it { should_not be_valid }
    end
    describe "when name is too long" do
        before { @user.name = "a" * 101 }
        it { should_not be_valid }
    end
    
    # email tests
    describe "when email is not present" do
        before { @user.email = " " }
        it { should_not be_valid }
    end
    describe "when email is not a valid format" do
        before { @user.email = "lincoln.fitzsimons" }
        it { should_not be_valid }
    end
    describe "when email already taken" do
        before do
            duplicate_user = @user.dup
            duplicate_user.email = @user.email.upcase
            duplicate_user.save
        end

        it { should_not be_valid}
    end

    # password tests
    describe "when password too short" do
        before do 
            @user.password = "12345" 
            @user.password_confirmation = "12345"
        end
        it { should_not be_valid }
    end
    describe "when password and confirmation are different" do
        before { @user.password_confirmation = "wrong" }
        it { should_not be_valid }
    end
    describe "return value of authenticate method" do
        before { @user.save }
        let(:found_user) { User.find_by(email: @user.email) }

        describe "with valid password" do
            it { should eq found_user.authenticate(@user.password) }
        end
        describe "with invalid password" do
            let(:user_for_invalid_password) { found_user.authenticate("invalid") }
            
            it { should_not eq user_for_invalid_password }
            specify { expect(user_for_invalid_password).to be_false }
        end
    end
end
