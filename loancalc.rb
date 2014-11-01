require 'sinatra'
require 'haml'

SITE_TITLE = "Кредитный калькулятор"

get '/' do
	@errors={}
	haml :home
end

post '/' do
	@errors={}
	
	@errors[:rate] = 1 if params[:rate].nil? || params[:rate].empty?
	@errors[:sum] = 1 if params[:sum].nil? || params[:sum].empty?
	@errors[:period] = 1 if params[:period].nil? || params[:period].empty?


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
    	@rate = rate
    	@sum = sum
    	@period = period
    end

    attr_accessor :rate, :sum, :period

    def calculate
        r = self.rate.to_i.to_f
        s = self.sum.to_i.to_f / 12
        p = self.period.to_i
 
        r + (r * s / (1 - (1 + s) * (1 - p)))
    end
end