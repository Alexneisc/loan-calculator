require 'sinatra'
require 'haml'

SITE_TITLE = "Кредитный калькулятор"

get '/' do
	@errors={}
	haml :home
end

post '/' do
	@errors={}
	
	@errors[:rate] = true if params[:rate].empty?
	@errors[:sum] = true if  params[:sum].empty?
	@errors[:period] = true if  params[:period].empty?


	if @errors.empty?
		credit = Calculator.new(params[:rate], params[:sum], params[:period])
		@amount = credit.calculate.round(2)
	else
		@errors[:msg] = 'Все поля должны быть заполнены'
	end
	haml :home
end

class Calculator
	def initialize(rate, sum, period)
		@rate = rate.to_f
		@sum = sum.to_f
		@period = period.to_i
	end

	attr_accessor :rate, :sum, :period

	def calculate
		sum * ( rate / 100 / ( 1 - ( 1 + rate / 100 ) ** -period ) )
	end
end