require "thor"

module CryptoChecker
  class CLI < Thor

    DEFAULT_CURRENCY = "usd"

    desc "price COIN CURRENCY", "checks price of cryptocurrence vs specified currency. Default currency of USD"
    def price(coin, currency = DEFAULT_CURRENCY)
      output = ""
      output += CryptoAPI.check_price(coin, currency).to_s
      if currency == "usd"
        output.insert(0, "$")
      else
        output.insert(-1, " #{currency}")
      end
      puts output
    end

    desc "supported", "Lists supported currencys to check crypto against."
    def supported
      results = CryptoAPI.supported_vs_currencies
      results.each do |currency|
        puts currency
      end
    end
  end
end