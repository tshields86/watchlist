class Stock < ActiveRecord::Base

  has_many :user_stocks
  has_many :users, through: :user_stocks

  def self.find_by_ticker(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  def self.new_from_lookup(ticker_symbol)
    looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
    return nil unless looked_up_stock.name

    new_stock = new(ticker: looked_up_stock.symbol, name: looked_up_stock.name)
    new_stock.last_price = new_stock.price
    new_stock
  end

  def price
    last_trade = StockQuote::Stock.quote(ticker).last_trade_price_only
    return "#{last_trade}" if last_trade

    opening_price = StockQuote::Stock.quote(ticker).open
    return "#{opening_price} (Opening)" if opening_price
    'Unavailable'
  end

  def change
    percent_change = StockQuote::Stock.quote(ticker).change_percent_change
    return "#{percent_change}" if percent_change
  end

end
