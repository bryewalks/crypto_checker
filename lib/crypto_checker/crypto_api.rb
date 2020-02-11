require 'http'

module CryptoChecker
  class CryptoAPI
    class << self

      BASE_URL = "https://api.coingecko.com/api/v3"

      def check_price(coin, currency)
        url = generate_currency_url(coin, currency)
        results = call_api(url).first
        results.current_price
      end

      def supported_vs_currencies
        url = BASE_URL
        url += "/simple/supported_vs_currencies"
        call_api(url)
      end

      def calculate_cost(amount, coin, currency)
        price = check_price(coin, currency)
        amount * price
      end

      def top_coins(amount)
        url = BASE_URL
        url += "/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=#{amount}"
        call_api(url)
      end

      private

      def call_api(url)
        response = HTTP.get(url)
        JSON.parse(response, object_class: OpenStruct)
      end

      def symbol_or_id(coin)
        coin.length == 3 ? "&symbols=#{coin}" : "&ids=#{coin}"
      end

      def generate_currency_url(coin, currency)
        url = BASE_URL
        url += "/coins/markets"
        url += "?vs_currency=#{currency}"
        url += symbol_or_id(coin)
      end
    end
  end
end