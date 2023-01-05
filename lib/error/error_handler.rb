module Error
    module ErrorHandler
        def self.included(clazz)
            clazz.class_eval do
                rescue_from ActiveRecord::RecordNotFound do |e|
                    respond(:record_not_found, 404, e.to_s)
                end
                
                # doesnt work, activeRecord::unprocessableentity isnt a thing, need to find out what it really is
                # rescue_from UnprocessableEntity do |e|
                #     respond(:unprocessable_entity, 422, e.to_s)
                # end

                rescue_from ActionController::BadRequest do |e|
                    respond(:bad_request, 400, e.to_s)
                end

                rescue_from ActionController::ParameterMissing do |e|
                    respond(:bad_request, 400, e.to_s)
                end

                rescue_from ActionController::UnpermittedParameters do |e|
                    respond(:bad_request, 400, e.to_s)
                end

                # rescue_from StandardError do |e|
                #     respond(:standard_error, 500, e.to_s)
                # end
            end
        end

        private

        def respond(_error, _status, _message)
            json = Helpers::Render.json(_error, _status, _message)
            render json: json, status: _status
        end
    end
end