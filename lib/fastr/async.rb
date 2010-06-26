module Fastr
  module Async
    def self.included(kls)
      kls.extend(ClassMethods)
    end
    
    module ClassMethods
      def async(*args)
        Array(args).each do |arg|
          alias_method "#{arg}_orig", arg
          
          define_method(arg) do
            Fiber.new do
              send("#{arg}_orig")
            end.resume
            [-1, {}, []].freeze
          end
        end
      end
    end
    
    def arender(*args)
      env['async.callback'].call render(*args)
    end
    
    def aredirect(*args)
      env['async.callback'].call redirect(*args)
    end
    
    def aresp(rack_resp)
      env['async.callback'].call rack_resp
    end
  end
end