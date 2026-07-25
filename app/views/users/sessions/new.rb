module Views
  module Users
    module Sessions
      class New < Views::Base
        def initialize(resource:, resource_name:, devise_mapping:)
          @resource = resource
          @resource_name = resource_name
          @devise_mapping = devise_mapping
        end

        def view_template

        end
      end
    end
  end
end
