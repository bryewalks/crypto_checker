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
        url = generate_currency_url(coin, currency)
        results = call_api(url).first
        amount * results.current_price
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

# p CryptoChecker::CryptoAPI.calculate_cost(10, "bitcoin", "usd")