module Rack
  class Saml
    require 'rack/saml/misc/onelogin_setting'

    class OneloginResponse < AbstractResponse
      include OneloginSetting
      #extend Forwardable

      def initialize(request, config, metadata)
        super(request, config, metadata)
        @response = OneLogin::RubySaml::Response.new(@request.params['SAMLResponse'], settings: saml_settings)
      end

      def is_valid?
        begin
          if @response.is_valid?
            return true
          else
            raise ValidationError.new( @response.errors.inspect )
          end
        rescue OneLogin::RubySaml::ValidationError => e
          raise ValidationError.new(e.message)
        end
      end

      def attributes
        @response.attributes
      end

      #def_delegator :@response, :is_valid?, :attributes
    end
  end
end
