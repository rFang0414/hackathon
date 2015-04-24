require 'resque/tasks'

#rake resque:work QUEUE = food
#rake environment resque:work QUEUE=food
task 'resque:setup' => :environment