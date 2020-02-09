require 'http'

module CryptoChecker
  class CryptoAPI
    class << self

      DEFAULT_API_ENDPOINT = "https://api.coingecko.com/api/v3"
      DEFAULT_CURRENCY = "usd"

      def check_price(coin, currency = DEFAULT_CURRENCY)
        uri = generate_currency_uri(coin, currency)
        results = call_api(uri).first
        results.current_price
      end

      private

      def call_api(uri)
        response = HTTP.get(uri)
        JSON.parse(response, object_class: OpenStruct)
      end

      def symbol_or_id(coin)
        coin.length == 3 ? "&symbols=#{coin}" : "&ids=#{coin}"
      end

      def generate_currency_uri(coin, currency)
        url = DEFAULT_API_ENDPOINT
        url += "/coins/markets"
        url += "?vs_currency=#{currency}"
        url += symbol_or_id(coin)
        URI(url)
      end
    end
  end
end

p CryptoChecker::CryptoAPI.check_price("eth")