Plugin architecture
===================

The plugin framework consists of a _Plugin Registry_ class, _Plugin
Controller_ class (currently unused) and a _Plugin_ class.

The Plugin Registry stores plugin classes.  Plugin instances are requested
from the Plugin Register using the plugin's internal `name` variable.

The Plugin Registry's **plugin_instance** method accepts the plugin's name
and plugin's arguments in the form of dictionary.

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
is identified using the name `foo`.

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

A plugin must provide a minimum set of pre-defined methods to met the
applications requirements.  Specifically a plugin must;

  * `initialize` it's internal variables at instantiation,

  * `randomize` the data set when requested.

  * `to_txt` display the data set in text form.

After the plugin class definition a call to the Plug Registry object
must be made.  The Plugin Registry is made available in the form of the
 variable `plugin_manager`.

E.g.
`plugin_manager.register(NumberPlugin, true)`

