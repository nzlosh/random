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
# Plugin Manager, or it won't be available
plugin_manager.register(Test, true)
