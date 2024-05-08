import gi
gi.require_version("GLib", "2.0")
assert("__init__" in gi.__file__)
from gi.repository import GLib
assert(31 == GLib.Date.get_days_in_month(GLib.DateMonth.JANUARY, 2000))

