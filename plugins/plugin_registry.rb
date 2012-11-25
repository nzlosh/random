#!/usr/bin/ruby

#~ class PluginManager
#~ """
#~ The Plugin Manager maintains the registry of available
#~ plugins and the availability in the application.
#~ """
    #~ attr_accessor :registry

    #~ def activate(plugin_name)
        #~ if @registry.key?(plugin_name)
            #~ puts "ACTIVATE PLUGIN"
            #~ raise
        #~ else
            #~ puts "Unknown plugin named '#{plugin_name}'"
        #~ end
    #~ end
#~
    #~ def deactivate(plugin_name)
        #~ if @registry.key?(plugin_name)
            #~ puts "DEACTIVATE PLUGIN"
            #~ raise
        #~ else
            #~ puts "Unknown plugin named '#{plugin_name}'"
        #~ end
    #~ end
#~ end
#~
#~ class Plugin
    #~ attr_accessor :active
#~
    #~ def initialize(kwargs={})
        #~ @kwargs = { active => true }.merge(kwargs)
    #~ end
#~
    #~ def report
        #~ puts "Plugin base"
    #~ end
#~ end
#~
#~
#~ puts "Start plug-in app"
#~

#~
#~ plugin_manager.activate("myPluginTest")
#~ puts plugin_manager.list_plugins

class PluginRegister
    attr_accessor :registry

    def initialize()
        @registry = {}
    end

    def register(plugin=nil, active=true)
        # Expects the plugin CLASS, not the object.
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

    def list_plugins
        return @registry.keys
    end
end

class PluginController
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
        @name = kwargs[:name]
    end

    def randomise()
        raise "Unimplemented"
    end

    def available_presentation()
        puts methods()
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

class NumberPlugin < Plugin
    def initialize(kwargs={})
        super({ name: "number"})
    end
end

class WordPlugin < Plugin
    def initialize(kwargs={})
        super({ name: "word"})
    end
end

def loadPlugins(plugin_manager)
    # Purpose: Load plugins from disk and register them with the
    # plugin manager.
    # Arguments
    # @pm - Plugin Manager to register loaded plugins.
    puts "To do: Use configuration file to find plugin directory"
    puts "and the plugins to be loaded"
    @plugin_dir = "./"
    @plugins = ["core_plugin.rb"]

    @plugins.each { |p|
        puts "Read plugins #{p}"
        s=""
        File.open("#{@plugin_dir}/#{p}", "r").each { |line| s += line }
        # The plugin specification must insist that the plugin registers
        # itself with the plugin manager at evaluation time.
        eval(s)
    }
end

registry = PluginRegister.new

registry.register(WordPlugin, true)
loadPlugins(registry)

puts registry.list_plugins

pluggy_test = registry.registry["Test"]["plugin"].new
puts pluggy_test.name
