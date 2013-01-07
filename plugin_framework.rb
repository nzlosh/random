class BadClassException < RuntimeError
end

module Plugin
    class Register
        def initialize()
            @registry = {}
        end

        def register(plugin=nil, active=true)
            # Expects the plugin CLASS, not the object.
            raise BadClassException if not plugin < Plugin
            # The object instance is required to initialise the plugin's
            # name and use it for registry's hash key.
            @p = plugin.new
            $log.debug("Registered plugin '#{@p.name}'.  Active: #{active}")

            if @registry.key?(@p.name)
                $log.warn("Plugin '#{@p.name}' skipped because it's already registered!")
            else
                @registry[@p.name] = { "plugin" => plugin, "active" => active }
            end
        end

        def unregister(plugin_name)
            if @registry.key?(:plugin_name)
                @registry.delete(plugin_name)
            end
        end

        def activate(plugin_name)
            if @registry.key?(:plugin_name)
                puts "#{plugin_name} plugin activated"
                @registry[plugin_name]["active"] = true
            else
                $log.warn("Unknown plugin named '#{plugin_name}'")
            end
        end

        def deactivate(plugin_name)
            if @registry.key?(plugin_name)
                puts "#{plugin_name} plugin deactivated"
                @registry[plugin_name]["active"] = false
            else
                $log.warn("Unknown plugin named '#{plugin_name}'")
            end
        end

        def plugin_instance(plugin_name=nil, kwargs={})
            if @registry.key?(plugin_name.downcase)
                return @registry[plugin_name.downcase]["plugin"].new(kwargs)
            end
            return nil
        end

        def list_plugins()
            # to do: implement active/inactive control logic
            return @registry.keys
        end
    end

    class Controller
        attr_accessor :plugin, :active

        def initialize(plugin=nil, active=true)
            if plugin
                @plugin = plugin
                @active = active
            end
        end
    end

    class Plugin
        attr_accessor :name

        def initialize(kwargs={})
            kwargs = { name: "base" }.merge(kwargs)
            @name = kwargs[:name].downcase
        end

        def randomise()
            raise "Unimplemented"
        end

        def to_txt()
            raise "Unimplemented"
        end

        def to_html()
            raise "Unimplemented"
        end

        def to_yaml()
            raise "Unimplemented"
        end

        def to_xml()
            raise "Unimplemented"
        end

        def to_json()
            raise "Unimplemented"
        end

        alias :randomize :randomise
    end

end

def load_plugin(pm)
    # Purpose: Load Plugins from disk and evaluate the code.
    # Arguments
    # @plugin_manager - Plugin Manager to register loaded plugins.
    ### To do: Use configuration file to find plugin directory
    ### and the plugins to be loaded.
    @plugin_dir = $config[:plugin_dir]
    @plugins = $config[:plugins]

    # By making plugin_manager's scope local to the load_plugin function,
    # it's scope is extended to the files loaded by require.
    @plugin_manager = pm

    @plugins.each { |p|
        begin
            # The plugin specification requires that the plugin registers
            # itself with the plugin manager at evaluation time.
            require "#{@plugin_dir}/#{p}" if File.exists?("#{@plugin_dir}/#{p}")
        rescue => e
            puts "#{@plugin_dir}/#{p}: #{e}"
            e.backtrace.each { |l| puts l }
        end
    }
end
