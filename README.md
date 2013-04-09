# Poli

API to integrate POLi payment gateway -- http://www.polipayments.com

## Installation

Add this line to your application's Gemfile:

    gem 'poli'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install poli

## Usage

### Use in irb
1. check poli version in terminal:

    > poli -v

2. generate poli configuration file, and change it to use your poli information, e.g. merchant code and authentication code:

    > poli generate
   
3. go into irb, and type:

```ruby
    > require 'poli'
    > Poli::POLi.load_config # by default will use poli.yml in current folder or ./config folder
    > financialInstitutions = Poli::POLi.get_financialInstitutions
    > puts financialInstitutions
```

### Use with rails app
1. put configuration file to yourApp/config/ folder, or generate poli one under your app folder:

   > poli generate

2. put the following code into your initialize file, could be "config/initializers/all_init.rb":

   > Poli::POLi.load_config


### Sample of the configuration file

		defaults: &DEFAULTS
		  currency_code: "AUD"
		  timeout: 900

		  homepage_url: http://localhost:3000
		  notification_url: http://localhost:3000/poli/notification
		  checkout_url: http://localhost:3000/profile/poli/checkout
		  successful_url: http://localhost:3000/profile/poli/successful
		  unsuccessful_url: http://localhost:3000/profile/poli/unsuccessful
  
		  initiate_transaction: https://merchantapi.apac.paywithpoli.com/MerchantAPIService.svc/Xml/transaction/initiate
		  get_transaction: https://merchantapi.apac.paywithpoli.com/MerchantAPIService.svc/Xml/transaction/query
		  get_financial_institutions: https://merchantapi.apac.paywithpoli.com/MerchantAPIService.svc/Xml/banks
  
		  merchant_code: 1111111
		  authentication_code: 222222222

		development:
		  <<: *DEFAULTS
		  merchant_code: 1111111
		  authentication_code: 222222222

		test:
		  <<: *DEFAULTS
		  merchant_code: 1111111
		  authentication_code: 222222222
  
		production:
		  <<: *DEFAULTS
		  merchant_code: 1111111
		  authentication_code: 222222222

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
