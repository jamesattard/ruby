#!/usr/bin/env ruby

class Employee

	attr_reader :salary, :type, :taxtotal

	def initialize( salary, type )
		@salary = salary
		@type = type
	end

	def computetaxbands
		case type		# current tax rates are the same for single and married persons
		when 1
			bandA = 2790
			bandB = 32010
			bandC = 150000
			rateA = 0.1
			rateB = 0.2
			rateC = 0.4
			rateD = 0.5
		end
		
		case salary
		when	0..bandA
			calctax( IncomeTaxBand.new( salary, rateA ) )
		when bandA+1..bandB
			calctax( IncomeTaxBand.new( salary, rateB ) )
		when bandB+1..bandC
			calctax( IncomeTaxBand.new( bandB, rateB ), IncomeTaxBand.new( salary - bandB, rateC ) )
		else
			calctax( IncomeTaxBand.new( bandB, rateB ), IncomeTaxBand.new( bandC, rateC ), IncomeTaxBand.new( salary - bandC, rateD )	 )
		end
		
	end

	def calctax( *taxbands ) #taxbands is an array of IncomeTaxBand objects
		@taxtotal = 0
		taxband_inst = taxbands
		taxbands.each { | taxband_inst | @taxtotal += taxband_inst.tax }
	end
	
end

class IncomeTaxBand
	
	attr_reader :tax
	
	def initialize( amount, pct )
		@tax = amount * pct
	end

end

class TaxViewer

	def inputvalid?(salary)
		if (salary.respond_to?(:match) && salary.match(/\d/))
			true
		else
			false
		end
	end 
	
	def annual(salary, tax)
		netannual = (salary - tax).round		
	end
	
	def monthly(salary, tax)
		netmonthly = ((salary - tax) / 12).round
	end
	
	def weekly(salary, tax)
		netweekly = ((salary - tax) / 52).round
	end

end

puts "UK Income tax calculator (2013-2014):\n\n"
loop do

	viewer = TaxViewer.new
	print "Please enter your gross annual Salary: £"
	salary = gets.chomp

	if viewer.inputvalid? salary

		emp = Employee.new(salary.to_i, 1)
		emp.computetaxbands

		printf "Total Tax: £%d\n", emp.taxtotal
		printf "Net Salary: £%d\n", viewer.annual(salary.to_i, emp.taxtotal)
		printf "Net Month: £%d\n", viewer.monthly(salary.to_i, emp.taxtotal)
		printf "Net Week: £%d\n", viewer.weekly(salary.to_i, emp.taxtotal)	
		break
	else
		print "\nPlease enter a valid number!\n\n"
	end

end



