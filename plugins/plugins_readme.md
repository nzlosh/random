Plugin architecture
===================

The plugin framework is quite simple.  It consists of a Plugin Registry
class, Plugin ACL class and the Plugin class itself.

The Plugin Registry stores plugin classes in a dictionary.  The key
is the plugin's internal name.  The value is the plugins class.

To make use of a plugin, it is enough to call the Plugin Registry's 
`plugin_instance` method with the plugin's name and it's arguments.

`
# Create the foo plugin object with a character set of "abcd".
foo_plugin = plugin_manager.register.plugin_instance("foo",{charset: "abcd"})

# Randomise a data set using the character set passed in by argument.
foo_plugin.random()

# Display the randomised character set as text.
foo_plugin.to_txt()
`


How to write a plugin
======================

The first step is to chose a name for the plugin which will be used to
identify it during the life time of the application.  In the following
example the plugin name is `foo`.

The plugin class must inherit from the parent class `Plugin::Plugin`.
The plugin class is given to Plugin Registry object.  From this point
onwards the Plugin Registry knows of the plugin class by the plugin's
internal variable `name`.  The name variable is treat as case insensitive
by the Registry.

`
class myPluginfoo < Plugin::Plugin
    def initialize(kwargs={})
        super({ name: "foo" }.merge(kwargs))
    end
end
`

To do .. explain the minimum set of methods that must be implemented.


Lastly, register the plugin class with the Plugin Registry is made possible
with the use of the global variable `plugin_manager`.

`
plugin_manager.register(NumberPlugin, true)
`

