puts plugin_manager

class Test < Plugin
	def initialize()
		@name = "test"
	end
	
	def report
		super()
		puts "Extension plugin"
	end
end

plugin_manager.register("myPluginTest", Test, true)
