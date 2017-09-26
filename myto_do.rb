require'sinatra'
class Tasks_to_do 
	attr_accessor :task,:done,:important,:urgent
		def initialize task
			@task = task
			@done =false
			@important = false
			@urgent = false
		end
	end

t1=Tasks_to_do.new"meeeting at 9:00am"
t2=Tasks_to_do.new"pay electricity bill"
t3=Tasks_to_do.new"go for shopping"
t4=Tasks_to_do.new"watch cricket match at 5:00pm"
t5=Tasks_to_do.new"go for movie at 9:00pm"

tasks = []
tasks<<t1
tasks<<t2
tasks<<t3
tasks<<t4
tasks<<t5

get'/'do
	data= {}
	data[:tasks]=tasks
	erb:mytodo_index,locals:data
end

post'/add'do
	task=params["task"]
	puts task
	if task.gsub(/\s+/, "").length!=0
		t=Tasks_to_do.new task
		tasks<<t		
	end
	return redirect '/'
end

post '/done'do
	task=params["task"]	
	tasks.each do|t|
		if t.task==task
			t.done=!t.done	
		end
	end
	return redirect'/'	
end

post '/priority'do
	task=params["task"]
	tasks.each do|t|
		if t.task==task
			checkbox_value1 = params["urgent"].nil? ? false : true
			checkbox_value2 = params["important"].nil? ? false : true
			if checkbox_value1
				t.urgent=true
			else
				t.urgent=false
			end

			if checkbox_value2
				t.important=true
			else
				t.important=false
			end
		end
	end
	return redirect'/'
end

post'/del_task'do
	task=params["task"]
	puts task		
	tasks.each do|t|
		if t.task==task
			puts"found"
			tasks.delete(t)	
			puts tasks 				
		end
	end
	return redirect'/'	
end