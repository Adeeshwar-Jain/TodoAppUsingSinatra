#****************************Code without Data Mapper***********************
# require'sinatra'
# class Tasks_to_do 
# 	attr_accessor :task,:done,:important,:urgent
# 		def initialize task
# 			@task = task
# 			@done =false
# 			@important = false
# 			@urgent = false
# 		end
# 	end

# t1=Tasks_to_do.new"meeeting at 9:00am"
# t2=Tasks_to_do.new"pay electricity bill"
# t3=Tasks_to_do.new"go for shopping"
# t4=Tasks_to_do.new"watch cricket match at 5:00pm"
# t5=Tasks_to_do.new"go for movie at 9:00pm"

# tasks = []
# tasks<<t1
# tasks<<t2
# tasks<<t3
# tasks<<t4
# tasks<<t5

# get'/'do
# 	data= {}
# 	data[:tasks]=tasks
# 	erb:mytodo_index,locals:data
# end

# post'/add'do
# 	task=params["task"]
# 	puts task
# 	if task.gsub(/\s+/, "").length!=0
# 		t=Tasks_to_do.new task
# 		tasks<<t		
# 	end
# 	return redirect '/'
# end

# post '/done'do
# 	task=params["task"]	
# 	tasks.each do|t|
# 		if t.task==task
# 			t.done=!t.done	
# 		end
# 	end
# 	return redirect'/'	
# end

# post '/priority'do
# 	task=params["task"]
# 	tasks.each do|t|
# 		if t.task==task
# 			checkbox_value1 = params["urgent"].nil? ? false : true
# 			checkbox_value2 = params["important"].nil? ? false : true
# 			if checkbox_value1
# 				t.urgent=true
# 			else
# 				t.urgent=false
# 			end

# 			if checkbox_value2
# 				t.important=true
# 			else
# 				t.important=false
# 			end
# 		end
# 	end
# 	return redirect'/'
# end

# post'/del_task'do
# 	task=params["task"]
# 	puts task		
# 	tasks.each do|t|
# 		if t.task==task
# 			puts"found"
# 			tasks.delete(t)	
# 			puts tasks 				
# 		end
# 	end
# 	return redirect'/'	
# end


#****************************Code with Data Mapper***********************
require 'sinatra'
require 'data_mapper'
DataMapper.setup(:default, 'sqlite:///'+Dir.pwd+'/project.db')

class Tasks_to_do
	include DataMapper::Resource 
	property :id, Serial
	property:task, String, :required => true 
	property:done, Boolean,:default  => false
	property:urgent, Boolean,:default  => false
	property:important, Boolean,:default  => false
end

DataMapper.finalize 

DataMapper.auto_upgrade!

if Tasks_to_do.all.length==0
	Tasks_to_do.create(:task=>'meeeting at 9:00am')
	Tasks_to_do.create(:task=>'pay electricity bill')
	Tasks_to_do.create(:task=>'go for shopping')
	Tasks_to_do.create(:task=>'watch cricket match at 5:00pm')
	Tasks_to_do.create(:task=>'go for movie at 9:00pm')
end


get'/'do
	data= {}
	data[:tasks]=Tasks_to_do.all
	erb:mytodo_index,locals:data
end

post'/add'do
	task=params["task"]
	puts task
	if task.gsub(/\s+/, "").length!=0
		Tasks_to_do.create(:task=> task)		
	end
	return redirect '/'
end

post '/done'do
	id=params["id"].to_i
	puts id	
	task=Tasks_to_do.get(id)
		task.done=!task.done
		task.save	
	return redirect'/'	
end

post '/priority'do
	id=params["id"].to_i	
	task=Tasks_to_do.get(id)	
			checkbox_value1 = params["urgent"].nil? ? false : true
			checkbox_value2 = params["important"].nil? ? false : true
			puts checkbox_value1,checkbox_value2
			if checkbox_value1
				task.urgent=true
			else
				task.urgent=false
			end

			if checkbox_value2
				task.important=true
			else
				task.important=false
			end	
			task.save	
	return redirect'/'
end

post'/del_task'do
	id=params["id"].to_i	
	task=Tasks_to_do.get(id)	
		task.destroy
		return redirect'/'	
end