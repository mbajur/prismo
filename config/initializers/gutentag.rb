# module Gutentag
#   module TagDecorator
#     def to_param
#       name
#     end
#   end
# end

# Rails.application.config.to_prepare do
#   Gutentag::Tag.prepend(Gutentag::TagDecorator)
# end

Rails.application.config.to_prepare do
  Gutentag::Tag.class_eval do
    include SearchCop

    search_scope :search do
      attributes :name
    end

    def to_param
      name
    end
  end
end
