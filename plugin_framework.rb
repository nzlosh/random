module Plugin
    class Register
        def initialize()
            @registry = {}
        end

        def register(plugin=nil, active=true)
            # Expects the plugin CLASS, not the object.
            raise if plugin == nil
            puts "Registered plugin '#{plugin.name}'.  Active: #{active}"
            if plugin
                @registry[plugin.name] = { "plugin" => plugin, "active" => active }
            end
        end

        def unregister(plugin_name)
            if @registry.key?(plugin_name)
                @registry.delete(plugin_name)
            end
        end

        def activate(plugin_name)
            if @registry.key?(plugin_name)
                puts "#{plugin_name} plugin activated"
                @registry[plugin_name]["active"] = true
            else
                puts "Unknown plugin named '#{plugin_name}'"
            end
        end

        def deactivate(plugin_name)
            if @registry.key?(plugin_name)
                puts "#{plugin_name} plugin deactivated"
                @registry[plugin_name]["active"] = false
            else
                puts "Unknown plugin named '#{plugin_name}'"
            end
        end

        def plugin_instance(plugin_name=nil, kwargs={})
            if @registry.key?(plugin_name)
                return @registry[plugin_name]["plugin"].new(kwargs)
            end
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
    end

end

def load_plugin(plugin_manager)
    # Purpose: Load Plugins from disk and evaluate the code.
    # Arguments
    # @plugin_manager - Plugin Manager to register loaded plugins.
    ### To do: Use configuration file to find plugin directory
    ### and the plugins to be loaded.
    @plugin_dir = "/home/che/workspace/random/plugins"
    @plugins = ["core_plugin.rb"]

    @plugins.each { |p|
        puts "Read plugins #{@plugin_dir}/#{p}"
        s=""
        File.open("#{@plugin_dir}/#{p}", "r").each { |line| s += line }
        # The plugin specification requires that the plugin registers
        # itself with the plugin manager at evaluation time.
        eval(s)
    }
end
