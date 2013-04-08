require 'poli'

describe Poli::POLi do
  
  it "load config should initialize POLi" do
    Poli::POLi.load_config
    Poli::POLi.settings.empty?.should be_false
  end
  
  context "POLI API" do    
    before(:all) { Poli::POLi.load_config }
  
    it "get_financialInstitutions" do
      Poli::POLi.get_financialInstitutions.size.should be > 0
    end
    
    it "initiate and get transaction" do
      transaction = Poli::POLi.initiate_transaction(1.00, "Test Ref", "119.225.58.230")
      transaction.should_not be_nil
      
      transaction2 = Poli::POLi.get_transaction(transaction["TransactionToken"])
      transaction2.last.should_not be_nil
    end
  
  end
  
  context "Test generator" do
    
    it "poli version test" do
      Poli::Runner.start(["-v"])
    end
    
    it "poli version test" do
      Poli::Runner.start(["generate"])
    end
    
  end

end