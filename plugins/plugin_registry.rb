#!/usr/bin/ruby

class PluginRegister
    attr_accessor :registry

    def initialize()
        @registry = {}
    end

    def register(plugin=nil, active=true)
        if plugin
            @registry.merge({"#{plugin.name}": })
        end
    end

    def unregister(plugin_name)
        if @registry.key?(plugin_name)
            @registry.delete(:"#{plugin_name}")
        end
    end

    def activate(plugin_name)
    end

    def deactivate(plugin_name)
    end
end

class PluginController
    attr_accessor :plugin, :active

    def initialize(plugin=nil, active=true)
        if plugin:
            @plugin = plugin
            @active = active
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

def loadPlugins()
# Function to load plugins from the plugin directory.
end

w = WordPlugin.new

puts w.name
w.available_presentation()
puts w.to_enum
