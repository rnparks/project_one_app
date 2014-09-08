require 'csv'


module FinancialParse

#parsing google income statement data
GOOGLE_INCOME_STATEMENT = {}

CSV.foreach("../public/google_income_statement.csv", :headers => true, :header_converters => :symbol, :converters => :all) do |row|
  GOOGLE_INCOME_STATEMENT[row.fields[0]] = Hash[row.headers[1..-1].zip(row.fields[1..-1])]
end

FinancialParse::GOOGLE_INCOME_STATEMENT.each_key do |key|
puts key
puts FinancialParse::GOOGLE_INCOME_STATEMENT[key][:"2011"]
puts FinancialParse::GOOGLE_INCOME_STATEMENT[key][:"2012"]
puts FinancialParse::GOOGLE_INCOME_STATEMENT[key][:"2013"]
end


end #end of module

