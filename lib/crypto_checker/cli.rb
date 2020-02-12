require "thor"
require "crypto_checker/crypto_api"

module CryptoChecker
  class CLI < Thor

    DEFAULT_CURRENCY = "usd"
    DEFAULT_CRYPTOCURRENCY = "btc"

    desc "price [COIN CURRENCY]", "Checks price of cryptocurrency vs specified currency. Default currency of USD."
    map "-p" => "price"
    def price(coin = DEFAULT_CRYPTOCURRENCY, currency = DEFAULT_CURRENCY)
      price = CryptoAPI.check_price(coin, currency)
      puts format_currency(price, currency)
    end

    desc "cost [AMOUNT COIN CURRENCY]", "Calculates the cost of specified amount of cryptocurrency. Default currency of USD."
    map "-c" => "cost"
    def cost(amount, coin, currency = DEFAULT_CURRENCY)
      price = CryptoAPI.calculate_cost(amount.to_i, coin, currency)
      puts format_currency(price, currency)
    end

    desc "supported", "Lists supported currencies to check cryptocurrency against."
    map "-s" => "supported"
    def supported
      results = CryptoAPI.supported_vs_currencies
      results.each do |currency|
        puts currency
      end
    end

    desc "top [AMOUNT]", "Lists top 10 cryptocurrencies or specified amount"
    map "-t" => "top"
    def top(amount = 10)
      results = CryptoAPI.top_coins(amount)
      results.each_with_index do |coin, index|
        puts "#{index + 1}: #{coin.name}"
      end
    end

    desc "symbol [COIN]", "Finds symbol for given coin."
    map "-sym" => "symbol"
    def symbol(coin)
      puts CryptoAPI.find_symbol(coin) || "No Results"
    end

    no_tasks do
      def format_currency(amount, currency)
        amount = amount.to_s
        if currency == "usd"
          amount = '%.2f' % amount
          amount.insert(0, "$")
        else
          amount.insert(-1, " #{currency.upcase}")
        end
      end
    end
  end
end