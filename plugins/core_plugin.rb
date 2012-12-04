class Test < Plugin
    def initialize()
        @name = "myPluginTest"
    end

    def report
        super()
        puts "Extension plugin"
    end
end

# The plugin class MUST be registered with the
# Plugin Manager
plugin_manager.register(Test, true)


class NumberPlugin < Plugin
    def initialize(kwargs={})
        super({ name: "number" })
    end
end

plugin_manager.register(NumberPlugin, true)

class WordPlugin < Plugin
    def initialize(kwargs={})
        super({ name: "word" })
    end
end

plugin_manager.register(WordPlugin, true)
