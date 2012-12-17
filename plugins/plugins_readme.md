Plugin architecture
===================

The plugin framework consists of a _Plugin Registry_ class, _Plugin
Controller_ class and a _Plugin_ class.

The Plugin Registry stores plugin classes.  Plugin instances are requested
from the Plugin Register using the plugin's internal `name` variable.

The Plugin Registry's **plugin_instance** method accepts the plugin's name
and plugin arguments in the form of dictionary.

* Create the foo plugin object with a character set of "abcd".
  `foo_plugin = plugin_manager.plugin_instance("foo",{charset: "abcd"})`

* Randomise a data set using the character set passed in by argument.
  `foo_plugin.randomise()` or `foo_plugin.randomize()`

* Display the randomised character set as text.
  `foo_plugin.to_txt()`



How to write a plugin
======================

The first step is to choose a name for the plugin.  The name is used to
identify the plguin during the application's life time.  In the following
example the plugin `myPluginfoo` in herits from `Plugin::Plugin` and
is identified using the name `foo`.

`class myPluginfoo < Plugin::Plugin
    def initialize(kwargs={})
        super({ name: "foo" }.merge(kwargs))
    end
end`

The plugin class inherits from the parent class `Plugin::Plugin`.
The plugin class is given to Plugin Registry object.  From this point
onwards the Plugin Registry knows of the plugin class by the plugin's
internal variable `name`.  The name variable is treat as case insensitive
by the Registry.


Required methods
================

`randomize` - generate a set of random

Lastly, register the plugin class with the Plugin Registry is made possible
with the use of the global variable `plugin_manager`.

`plugin_manager.register(NumberPlugin, true)`

