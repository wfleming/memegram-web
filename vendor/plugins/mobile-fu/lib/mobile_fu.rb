module ActionController
  module MobileFu
    # These are various strings that can be found in mobile devices.  Please feel free
    # to add on to this list.
    MOBILE_USER_AGENTS =  'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
                          'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
                          'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
                          'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
                          'webos|amoi|novarra|cdm|alcatel|pocket|ipad|iphone|mobileexplorer|' +
                          'mobile'
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      
      # Add this to one of your controllers to use MobileFu.  
      #
      #    class ApplicationController < ActionController::Base 
      #      has_mobile_fu
      #    end
      #
      # You can also force mobile mode by passing in 'true'
      #
      #    class ApplicationController < ActionController::Base 
      #      has_mobile_fu(true)
      #    end
        
      def has_mobile_fu(test_mode = false)
        include ActionController::MobileFu::InstanceMethods

        if test_mode 
          before_filter :force_mobile_format
        else
          before_filter :set_mobile_format
        end

        helper_method :is_mobile_device?
        helper_method :in_mobile_view?
        helper_method :is_device?
      end
      
      def is_mobile_device?
        @@is_mobile_device
      end

      def in_mobile_view?
        @@in_mobile_view
      end

      def is_device?(type)
        @@is_device
      end
      
      def exclude_mobile_for(action_names)
        @exclude_mobile_for ||= []
        action_names = [action_names] if !action_names.is_a?(Array)
        action_names = action_names.map(&:to_sym)
        @exclude_mobile_for += action_names
      end
      
      def exclude_mobile_for?(action_name)
        logger.debug("exclude_mobile_for?: exclusions -> #{@exclude_mobile_for.inspect}, current action is #{action_name}")
        @exclude_mobile_for ||= []
        @exclude_mobile_for.include?(action_name.to_sym)
      end
    end
    
    module InstanceMethods
      
      # Forces the request format to be :mobile
      
      def force_mobile_format
        if !request.xhr?
          request.format = :mobile if :html == request.format
          session[:mobile_view] = true if session[:mobile_view].nil?
        end
      end
      
      # Determines the request format based on whether the device is mobile or if
      # the user has opted to use either the 'Standard' view or 'Mobile' view.
      
      def set_mobile_format
        logger.debug("set_mobile_format: is_mobile_device? -> #{is_mobile_device?.inspect}")
        if is_mobile_device? && !request.xhr?
          # modifying to support other content types & to pay attention to specific view exclusions
          logger.debug("set_mobile_format: request.format -> #{request.format.inspect}")
          if (:html == request.format || 'text/html' == request.format) && !self.class.exclude_mobile_for?(action_name)
            logger.debug("set_mobile_format: SETTING THE FORMAT")
            request.format = (session[:mobile_view] == false ? :html : :mobile)
            logger.debug("set_mobile_format: (AFTER SET) request.format -> #{request.format.inspect}")
          end
          session[:mobile_view] = true if session[:mobile_view].nil?
        end
      end
      
      # Returns either true or false depending on whether or not the format of the
      # request is either :mobile or not.
      
      def in_mobile_view?
        request.format.to_sym == :mobile
      end
      
      # Returns either true or false depending on whether or not the user agent of
      # the device making the request is matched to a device in our regex.
      
      def is_mobile_device?
        logger.debug("is_mobile_device? -> #{request.user_agent}")
        request.user_agent.to_s.downcase =~ Regexp.new(ActionController::MobileFu::MOBILE_USER_AGENTS)
      end

      # Can check for a specific user agent
      # e.g., is_device?('iphone') or is_device?('mobileexplorer')
      
      def is_device?(type)
        request.user_agent.to_s.downcase.include?(type.to_s.downcase)
      end
    end
    
  end
  
end

ActionController::Base.send(:include, ActionController::MobileFu)