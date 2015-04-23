require 'resque/tasks'

rake resque:work QUEUE = food
task 'resque:setup' => :environment