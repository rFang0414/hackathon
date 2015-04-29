class EventSourceController < ApplicationController

    def tester 
        response.headers["Content-Type"] = "text/event-stream"
        3.times do |n|
            response.stream.write "message: hellow world! \n\n"
            sleep 2
        end
    end
end
