Plugin architecture
===================

The plugin framework consists of a _Plugin Registry_ class, _Plugin
Controller_ class (currently unused) and a _Plugin_ class.

* Plugin Registry stores plugin classes and manages instantiates their objects.

* Plugin Controller determines if a plugin is active. (currently unused)

* Plugins generate randomised data based on a given data set, present the
data in a digestable format.

The Plugin Registry's **plugin_instance** method accepts the plugin's name
and arguments in the form of dictionary.

* Create the foo plugin object with a character set of "abcd".
  `foo_plugin = plugin_manager.plugin_instance("foo",{charset: "abcd"})`

* Randomise a data set using the character set passed in by argument.
  `foo_plugin.randomise()` or `foo_plugin.randomize()`

* Display the randomised character set as text.
  `foo_plugin.to_txt()`



How to write a plugin
======================

The first step is to choose a name to identify the plugin.  In the following
example the plugin `myPluginfoo` inherits from `Plugin::Plugin` and
is identified using the name `foo`.  In the case of plugin name collision,
first loaded wins.

`class myPluginfoo < Plugin::Plugin
    def initialize(kwargs={})
        super({ name: "foo" }.merge(kwargs))
    end
end`

The plugin class inherits from the parent class `Plugin::Plugin`.
The plugin class is stored by the Plugin Registry object.  Once registered
with the Plugin Registry, the plugin object is created using its internal
variable `name`.  The name variable is treat as case insensitive by the
Registry.


Required methods
================

A plugin must provide a minimum set of pre-defined methods to meet the
applications requirements.  Specifically a plugin must;

  * `initialize` it's internal variables at instantiation,

  * `randomise` the data set when requested.  Warning: The `randomize`
  method call is an alias to `randomise`.  Do not use `randomize` to
  implement the method unless you know what you're doing.

  * `display` display the data set in a form applicable to the data type.

Call the Plug Registry object __register__ method after the plugin class'
definition.  The Plugin Registry object variable is available as `plugin_manager`.

E.g.  To register the NumberPlugin plugin class:
`plugin_manager.register(NumberPlugin, true)`

