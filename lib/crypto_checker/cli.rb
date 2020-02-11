require "thor"
require "crypto_checker/crypto_api"

module CryptoChecker
  class CLI < Thor

    DEFAULT_CURRENCY = "usd"

    desc "price [COIN CURRENCY]", "Checks price of cryptocurrency vs specified currency. Default currency of USD."
    def price(coin, currency = DEFAULT_CURRENCY)
      price = CryptoAPI.check_price(coin, currency).to_s
      if currency == "usd"
        price.insert(0, "$")
      else
        price.insert(-1, " #{currency.upcase}")
      end
      puts price
    end

    desc "cost [AMOUNT COIN CURRENCY]", "Finds the cost of specified amount of cryptocurrency. Default currency of USD."
    def cost(amount, coin, currency = DEFAULT_CURRENCY)
      cost = CryptoAPI.calculate_cost(amount.to_i, coin, currency).to_s
      if currency == "usd"
        cost = '%.2f' % cost
        cost.insert(0, "$")
      else
        cost.insert(-1, " #{currency.upcase}")
      end
      puts cost
    end

    desc "supported", "Lists supported currencies to check cryptocurrency against."
    def supported
      results = CryptoAPI.supported_vs_currencies
      results.each do |currency|
        puts currency
      end
    end

    desc "top [AMOUNT]", "List top 10 cryptocurrencies or specified amount"
    def top(amount = 10)
      results = CryptoAPI.top_coins(amount)
      results.each_with_index do |coin, index|
        puts "#{index + 1}: #{coin.name}"
      end
    end
  end
end