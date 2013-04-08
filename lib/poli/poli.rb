require "yaml"
require 'nokogiri'
require 'httparty'
require 'date'

module Poli
  class POLi
    class << self
      
      def load_config(config_file = nil)
        unless config_file
          if defined? Rails
            config_file = "#{Rails.root}/config/poli.yml"
          else
            config_file = File.join(Dir.pwd, 'config/poli.yml')
            unless File.file?(config_file)
              config_file = File.join(Dir.pwd, 'poli.yml')
            end
          end
          raise "poli.yml not found, generate one with 'poli generate [path]'." unless File.file?(config_file)
        end

        @settings = YAML.load_file(config_file)
        @settings = (defined? Rails) ? @settings[Rails.env] : @settings["defaults"]
      end
      
      def settings
        @settings.dup
      end
      
      def get_financialInstitutions
        body = build_financialInstitutions_xml
        response = HTTParty.post @settings['get_financial_institutions'], :body => body, :headers => {'Content-type' => 'text/xml'}
        institutions = response.parsed_response["GetFinancialInstitutionsResponse"]
        banks = []
        if institutions and institutions["FinancialInstitutionList"] and institutions["FinancialInstitutionList"]["FinancialInstitution"]
          institutions["FinancialInstitutionList"]["FinancialInstitution"].each do |institute|
            banks << institute["FinancialInstitutionName"]
          end
        end
        banks
      end
      
      def initiate_transaction(amount, merchant_ref, ip)
        body = build_initiate_xml(amount, merchant_ref, ip)
        response = HTTParty.post @settings['initiate_transaction'], :body => body, :headers => {'Content-type' => 'text/xml'}
        poli_transfer = response.parsed_response["InitiateTransactionResponse"]
        poli_transfer["Transaction"] if poli_transfer
      end
      
      def get_transaction(token)
        body = build_transaction_xml(token)
        response = HTTParty.post @settings['get_transaction'], :body => body, :headers => {'Content-type' => 'text/xml'}
        poli_transaction = response.parsed_response["GetTransactionResponse"]
        return [poli_transaction["Errors"], poli_transaction["TransactionStatusCode"], poli_transaction["Transaction"]] if poli_transaction
      end
      
    private
      def build_financialInstitutions_xml
        doc = Nokogiri::XML('<GetFinancialInstitutionsRequest xmlns="http://schemas.datacontract.org/2004/07/Centricom.POLi.Services.MerchantAPI.Contracts" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"></GetFinancialInstitutionsRequest>')
        doc.root.add_child("<AuthenticationCode>#{@settings['authentication_code']}</AuthenticationCode>")
        doc.root.add_child("<MerchantCode>#{@settings['merchant_code']}</MerchantCode>")
        doc.to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION).strip
      end
      
      def build_initiate_xml(amount, merchant_ref, ip)
        doc = Nokogiri::XML('<InitiateTransactionRequest xmlns="http://schemas.datacontract.org/2004/07/Centricom.POLi.Services.MerchantAPI.Contracts" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"></InitiateTransactionRequest>')
        doc.root.add_child("<AuthenticationCode>#{@settings['authentication_code']}</AuthenticationCode>")

        transaction = doc.root.add_child('<Transaction xmlns:dco="http://schemas.datacontract.org/2004/07/Centricom.POLi.Services.MerchantAPI.DCO"></Transaction>')[0]
        transaction.add_child("<dco:CurrencyAmount>#{sprintf("%.2f", amount)}</dco:CurrencyAmount>")
        transaction.add_child("<dco:CurrencyCode>#{@settings['currency_code']}</dco:CurrencyCode>")
        transaction.add_child("<dco:MerchantCheckoutURL>#{@settings['checkout_url']}</dco:MerchantCheckoutURL>")
        transaction.add_child("<dco:MerchantCode>#{@settings['merchant_code']}</dco:MerchantCode>")

        transaction.add_child("<dco:MerchantData>from-poli</dco:MerchantData>")
        transaction.add_child("<dco:MerchantDateTime>#{DateTime.now.strftime("%Y-%m-%dT%H:%M:%S")}</dco:MerchantDateTime>")
        transaction.add_child("<dco:MerchantHomePageURL>#{@settings['homepage_url']}</dco:MerchantHomePageURL>")
        transaction.add_child("<dco:MerchantRef>#{merchant_ref}</dco:MerchantRef>")
        transaction.add_child("<dco:NotificationURL>#{@settings['notification_url']}</dco:NotificationURL>")
        transaction.add_child("<dco:SuccessfulURL>#{@settings['successful_url']}</dco:SuccessfulURL>")

        transaction.add_child("<dco:Timeout>#{@settings['timeout']}</dco:Timeout>")
        transaction.add_child("<dco:UnsuccessfulURL>#{@settings['unsuccessful_url']}</dco:UnsuccessfulURL>")
        transaction.add_child("<dco:UserIPAddress>#{ip}</dco:UserIPAddress>")

        doc.to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION).strip
      end
      
      def build_transaction_xml(token)
        doc = Nokogiri::XML('<GetTransactionRequest xmlns="http://schemas.datacontract.org/2004/07/Centricom.POLi.Services.MerchantAPI.Contracts" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"></GetTransactionRequest>')
        doc.root.add_child("<AuthenticationCode>#{@settings['authentication_code']}</AuthenticationCode>")
        doc.root.add_child("<MerchantCode>#{@settings['merchant_code']}</MerchantCode>")
        doc.root.add_child("<TransactionToken>#{token}</TransactionToken>")    
        doc.to_xml(:save_with => Nokogiri::XML::Node::SaveOptions::AS_XML | Nokogiri::XML::Node::SaveOptions::NO_DECLARATION).strip
      end
      
    end
  end
end