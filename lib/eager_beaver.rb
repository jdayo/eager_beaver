module EagerBeaver
  def eager(method_name, directory, options = {})
    klass_prefix = ''
    singleton = false
    singleton = true if options[:singleton] == true
    unless Rails.application.config.cache_classes
      Rails.logger.error "Eager beaver has handled #{method_name.to_s}"
      define_singleton_method("#{method_name.to_s}_reload_dependencies".to_sym) do

        directories = if directory.is_a? Array
                        directory
                      else
                        [directory]
                      end

        directories.each do |d|
          d_components = d.split('#')
          p = d
          prefix = ""
          if d_components.size == 2
            prefix, p = d_components
          end

          ["#{p}/*.rb"].each do |path|
            Dir[Rails.root.to_s + path].each do |file|
              klass_name = File.basename(file, ".rb")
              Rails.logger.error("force reload load #{prefix}#{klass_name.camelize}")
              "#{prefix}#{klass_name.camelize}".constantize
            end
          end
        end
      end

      unless singleton
        define_method("#{method_name.to_s}_with_preload".to_sym) do |*args|
          Rails.logger.error "reload dependency on #{method_name.to_s}"
          self.class.send("#{method_name.to_s}_reload_dependencies".to_sym)
          send("#{method_name.to_s}_without_preload".to_sym, *args)
        end
      else
        define_singleton_method("#{method_name.to_s}_with_preload".to_sym) do |*args|
          Rails.logger.error "reload dependency on ::#{method_name.to_s}"
          send("#{method_name.to_s}_reload_dependencies".to_sym)
          send("#{method_name.to_s}_without_preload".to_sym, *args)
        end
      end

      if singleton
        self.class_eval("
          class << self
             alias_method_chain :#{method_name}, :preload
          end
      ")
      else
        alias_method_chain(method_name, :preload)
      end
    end
  end
end
