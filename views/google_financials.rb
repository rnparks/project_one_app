require 'csv'

module FinancialParse

#parsing google income statement data
GOOGLE_INCOME_STATEMENT = {}

CSV.foreach("public/google_income_statement.csv", :headers => true, :header_converters => :symbol, :converters => :all) do |row|
  GOOGLE_INCOME_STATEMENT[row.fields[0]] = Hash[row.headers[1..-1].zip(row.fields[1..-1])]
end

#parsing google balance sheet data
GOOGLE_BALANCE_SHEET = {}

CSV.foreach("public/google_balance_sheet.csv", :headers => true, :header_converters => :symbol, :converters => :all) do |row|
  GOOGLE_BALANCE_SHEET[row.fields[0]] = Hash[row.headers[1..-1].zip(row.fields[1..-1])]
end

#parsing google cash flow dada
GOOGLE_CASH_FLOW_STATEMENT = {}
CSV.foreach("public/google_cash_flow_statement.csv", :headers => true, :header_converters => :symbol, :converters => :all) do |row|
  GOOGLE_CASH_FLOW_STATEMENT[row.fields[0]] = Hash[row.headers[1..-1].zip(row.fields[1..-1])]
end








end #end of module

