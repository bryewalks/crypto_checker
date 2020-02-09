require 'http'

module CryptoChecker
  class CryptoAPI
    class << self

      DEFAULT_API_ENDPOINT = "https://api.coingecko.com/api/v3"

      def check_price(coin, currency)
        url = generate_currency_url(coin, currency)
        results = call_api(url).first
        results.current_price
      end

      def supported_vs_currencies
        url = DEFAULT_API_ENDPOINT
        url += "/simple/supported_vs_currencies"
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
        url = DEFAULT_API_ENDPOINT
        url += "/coins/markets"
        url += "?vs_currency=#{currency}"
        url += symbol_or_id(coin)
      end
    end
  end
end

CryptoChecker::CryptoAPI.supported_vs_currencies