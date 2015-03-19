class SpreadController < ApplicationController
    def get_job
        @job = Job.find_by(id: params[:id].to_i)
    end

    def my_resume

    end
end
