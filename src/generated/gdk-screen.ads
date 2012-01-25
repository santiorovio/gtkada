------------------------------------------------------------------------------
--                                                                          --
--      Copyright (C) 1998-2000 E. Briot, J. Brobecker and A. Charlet       --
--                     Copyright (C) 2000-2012, AdaCore                     --
--                                                                          --
-- This library is free software;  you can redistribute it and/or modify it --
-- under terms of the  GNU General Public License  as published by the Free --
-- Software  Foundation;  either version 3,  or (at your  option) any later --
-- version. This library is distributed in the hope that it will be useful, --
-- but WITHOUT ANY WARRANTY;  without even the implied warranty of MERCHAN- --
-- TABILITY or FITNESS FOR A PARTICULAR PURPOSE.                            --
--                                                                          --
-- As a special exception under Section 7 of GPL version 3, you are granted --
-- additional permissions described in the GCC Runtime Library Exception,   --
-- version 3.1, as published by the Free Software Foundation.               --
--                                                                          --
-- You should have received a copy of the GNU General Public License and    --
-- a copy of the GCC Runtime Library Exception along with this program;     --
-- see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see    --
-- <http://www.gnu.org/licenses/>.                                          --
--                                                                          --
------------------------------------------------------------------------------

pragma Ada_05;
--  <description>
--  Gdk.Screen.Gdk_Screen objects are the GDK representation of the screen on
--  which windows can be displayed and on which the pointer moves. X originally
--  identified screens with physical screens, but nowadays it is more common to
--  have a single Gdk.Screen.Gdk_Screen which combines several physical
--  monitors (see Gdk.Screen.Get_N_Monitors).
--
--  GdkScreen is used throughout GDK and GTK+ to specify which screen the top
--  level windows are to be displayed on. it is also used to query the screen
--  specification and default settings such as the default visual
--  (gdk_screen_get_system_visual), the dimensions of the physical monitors
--  (gdk_screen_get_monitor_geometry), etc.
--
--  </description>
--  <group>Gdk, the low-level API</group>

pragma Warnings (Off, "*is already use-visible*");
with Cairo;           use Cairo;
with Gdk.Display;     use Gdk.Display;
with Gdk.Rectangle;   use Gdk.Rectangle;
with Gdk.Types;       use Gdk.Types;
with Gdk.Visual;      use Gdk.Visual;
with Gdk.Window;      use Gdk.Window;
with Glib;            use Glib;
with Glib.Object;     use Glib.Object;
with Glib.Properties; use Glib.Properties;

package Gdk.Screen is

   type Gdk_Screen_Record is new GObject_Record with null record;
   type Gdk_Screen is access all Gdk_Screen_Record'Class;

   ------------------
   -- Constructors --
   ------------------

   function Get_Type return Glib.GType;
   pragma Import (C, Get_Type, "gdk_screen_get_type");

   -------------
   -- Methods --
   -------------

   function Get_Active_Window
      (Screen : not null access Gdk_Screen_Record)
       return Gdk.Window.Gdk_Window;
   --  Returns the screen's currently active window.
   --  On X11, this is done by inspecting the _NET_ACTIVE_WINDOW property on
   --  the root window, as described in the <ulink
   --  url="http://www.freedesktop.org/Standards/wm-spec">Extended Window
   --  Manager Hints</ulink>. If there is no currently currently active window,
   --  or the window manager does not support the _NET_ACTIVE_WINDOW hint, this
   --  function returns null.
   --  On other platforms, this function may return null, depending on whether
   --  it is implementable on that platform.
   --  The returned window should be unrefed using g_object_unref when no
   --  longer needed.
   --  Since: gtk+ 2.10

   function Get_Display
      (Screen : not null access Gdk_Screen_Record)
       return Gdk.Display.Gdk_Display;
   --  Gets the display to which the Screen belongs.
   --  Since: gtk+ 2.2

   function Get_Font_Options
      (Screen : not null access Gdk_Screen_Record)
       return Cairo.Cairo_Font_Options;
   procedure Set_Font_Options
      (Screen  : not null access Gdk_Screen_Record;
       Options : in out Cairo.Cairo_Font_Options);
   --  Sets the default font options for the screen. These options will be set
   --  on any Pango.Context.Pango_Context's newly created with
   --  gdk_pango_context_get_for_screen. Changing the default set of font
   --  options does not affect contexts that have already been created.
   --  Since: gtk+ 2.10
   --  "options": a Cairo.Cairo_Font_Options, or null to unset any previously
   --  set default font options.

   function Get_Height
      (Screen : not null access Gdk_Screen_Record) return Gint;
   --  Gets the height of Screen in pixels
   --  Since: gtk+ 2.2

   function Get_Height_Mm
      (Screen : not null access Gdk_Screen_Record) return Gint;
   --  Returns the height of Screen in millimeters. Note that on some X
   --  servers this value will not be correct.
   --  Since: gtk+ 2.2

   function Get_Monitor_At_Point
      (Screen : not null access Gdk_Screen_Record;
       X      : Gint;
       Y      : Gint) return Gint;
   --  Returns the monitor number in which the point (X,Y) is located.
   --  a monitor close to (X,Y) if the point is not in any monitor.
   --  Since: gtk+ 2.2
   --  "x": the x coordinate in the virtual screen.
   --  "y": the y coordinate in the virtual screen.

   function Get_Monitor_At_Window
      (Screen : not null access Gdk_Screen_Record;
       Window : Gdk.Window.Gdk_Window) return Gint;
   --  Returns the number of the monitor in which the largest area of the
   --  bounding rectangle of Window resides.
   --  or if Window does not intersect any monitors, a monitor, close to
   --  Window.
   --  Since: gtk+ 2.2
   --  "window": a Gdk.Window.Gdk_Window

   procedure Get_Monitor_Geometry
      (Screen      : not null access Gdk_Screen_Record;
       Monitor_Num : Gint;
       Dest        : out Gdk.Rectangle.Gdk_Rectangle);
   --  Retrieves the Gdk_Rectangle representing the size and position of the
   --  individual monitor within the entire screen area.
   --  Note that the size of the entire screen area can be retrieved via
   --  Gdk.Screen.Get_Width and Gdk.Screen.Get_Height.
   --  Since: gtk+ 2.2
   --  "monitor_num": the monitor number, between 0 and
   --  gdk_screen_get_n_monitors (screen)
   --  "dest": a Gdk_Rectangle to be filled with the monitor geometry

   function Get_Monitor_Height_Mm
      (Screen      : not null access Gdk_Screen_Record;
       Monitor_Num : Gint) return Gint;
   --  Gets the height in millimeters of the specified monitor.
   --  Since: gtk+ 2.14
   --  "monitor_num": number of the monitor, between 0 and
   --  gdk_screen_get_n_monitors (screen)

   function Get_Monitor_Plug_Name
      (Screen      : not null access Gdk_Screen_Record;
       Monitor_Num : Gint) return UTF8_String;
   --  Returns the output name of the specified monitor. Usually something
   --  like VGA, DVI, or TV, not the actual product name of the display device.
   --  or null if the name cannot be determined
   --  Since: gtk+ 2.14
   --  "monitor_num": number of the monitor, between 0 and
   --  gdk_screen_get_n_monitors (screen)

   function Get_Monitor_Width_Mm
      (Screen      : not null access Gdk_Screen_Record;
       Monitor_Num : Gint) return Gint;
   --  Gets the width in millimeters of the specified monitor, if available.
   --  Since: gtk+ 2.14
   --  "monitor_num": number of the monitor, between 0 and
   --  gdk_screen_get_n_monitors (screen)

   function Get_N_Monitors
      (Screen : not null access Gdk_Screen_Record) return Gint;
   --  Returns the number of monitors which Screen consists of.
   --  Since: gtk+ 2.2

   function Get_Number
      (Screen : not null access Gdk_Screen_Record) return Gint;
   --  Gets the index of Screen among the screens in the display to which it
   --  belongs. (See Gdk.Screen.Get_Display)
   --  Since: gtk+ 2.2

   function Get_Primary_Monitor
      (Screen : not null access Gdk_Screen_Record) return Gint;
   --  Gets the primary monitor for Screen. The primary monitor is considered
   --  the monitor where the 'main desktop' lives. While normal application
   --  windows typically allow the window manager to place the windows,
   --  specialized desktop applications such as panels should place themselves
   --  on the primary monitor.
   --  If no primary monitor is configured by the user, the return value will
   --  be 0, defaulting to the first monitor.
   --  Since: gtk+ 2.20

   function Get_Resolution
      (Screen : not null access Gdk_Screen_Record) return Gdouble;
   procedure Set_Resolution
      (Screen : not null access Gdk_Screen_Record;
       Dpi    : Gdouble);
   --  Since: gtk+ 2.10
   --  "dpi": the resolution in "dots per inch". (Physical inches aren't
   --  actually involved; the terminology is conventional.) Sets the resolution
   --  for font handling on the screen. This is a scale factor between points
   --  specified in a Pango_Font_Description and cairo units. The default value
   --  is 96, meaning that a 10 point font will be 13 units high. (10 * 96. /
   --  72. = 13.3).

   function Get_Rgba_Visual
      (Screen : not null access Gdk_Screen_Record)
       return Gdk.Visual.Gdk_Visual;
   --  Gets a visual to use for creating windows with an alpha channel. The
   --  windowing system on which GTK+ is running may not support this
   --  capability, in which case null will be returned. Even if a non-null
   --  value is returned, its possible that the window's alpha channel won't be
   --  honored when displaying the window on the screen: in particular, for X
   --  an appropriate windowing manager and compositing manager must be running
   --  to provide appropriate display.
   --  This functionality is not implemented in the Windows backend.
   --  For setting an overall opacity for a top-level window, see
   --  gdk_window_set_opacity.
   --  alpha channel or null if the capability is not available.
   --  Since: gtk+ 2.8

   function Get_Root_Window
      (Screen : not null access Gdk_Screen_Record)
       return Gdk.Window.Gdk_Window;
   --  Gets the root window of Screen.
   --  Since: gtk+ 2.2

   function Get_System_Visual
      (Screen : not null access Gdk_Screen_Record)
       return Gdk.Visual.Gdk_Visual;
   --  Get the system's default visual for Screen. This is the visual for the
   --  root window of the display. The return value should not be freed.
   --  Since: gtk+ 2.2

   function Get_Toplevel_Windows
      (Screen : not null access Gdk_Screen_Record)
       return Gdk.Window.Gdk_Window_List.GList;
   --  Obtains a list of all toplevel windows known to GDK on the screen
   --  Screen. A toplevel window is a child of the root window (see
   --  gdk_get_default_root_window).
   --  The returned list should be freed with g_list_free, but its elements
   --  need not be freed.
   --  list of toplevel windows, free with g_list_free
   --  Since: gtk+ 2.2

   function Get_Width
      (Screen : not null access Gdk_Screen_Record) return Gint;
   --  Gets the width of Screen in pixels
   --  Since: gtk+ 2.2

   function Get_Width_Mm
      (Screen : not null access Gdk_Screen_Record) return Gint;
   --  Gets the width of Screen in millimeters. Note that on some X servers
   --  this value will not be correct.
   --  Since: gtk+ 2.2

   function Get_Window_Stack
      (Screen : not null access Gdk_Screen_Record)
       return Gdk.Window.Gdk_Window_List.GList;
   --  Returns a GList of Gdk.Window.Gdk_Window<!-- -->s representing the
   --  current window stack.
   --  On X11, this is done by inspecting the _NET_CLIENT_LIST_STACKING
   --  property on the root window, as described in the <ulink
   --  url="http://www.freedesktop.org/Standards/wm-spec">Extended Window
   --  Manager Hints</ulink>. If the window manager does not support the
   --  _NET_CLIENT_LIST_STACKING hint, this function returns null.
   --  On other platforms, this function may return null, depending on whether
   --  it is implementable on that platform.
   --  The returned list is newly allocated and owns references to the windows
   --  it contains, so it should be freed using g_list_free and its windows
   --  unrefed using g_object_unref when no longer needed.
   --  a list of Gdk.Window.Gdk_Window<!-- -->s for the current window stack,
   --  or null.
   --  Since: gtk+ 2.10

   function Is_Composited
      (Screen : not null access Gdk_Screen_Record) return Boolean;
   --  Returns whether windows with an RGBA visual can reasonably be expected
   --  to have their alpha channel drawn correctly on the screen.
   --  On X11 this function returns whether a compositing manager is
   --  compositing Screen.
   --  expected to have their alpha channels drawn correctly on the screen.
   --  Since: gtk+ 2.10

   function List_Visuals
      (Screen : not null access Gdk_Screen_Record)
       return Gdk.Window.Gdk_Window_List.GList;
   --  Lists the available visuals for the specified Screen. A visual
   --  describes a hardware image data format. For example, a visual might
   --  support 24-bit color, or 8-bit color, and might expect pixels to be in a
   --  certain format.
   --  Call g_list_free on the return value when you're finished with it.
   --  a list of visuals; the list must be freed, but not its contents
   --  Since: gtk+ 2.2

   function Make_Display_Name
      (Screen : not null access Gdk_Screen_Record) return UTF8_String;
   --  Determines the name to pass to gdk_display_open to get a
   --  Gdk.Display.Gdk_Display with this screen as the default screen.
   --  Since: gtk+ 2.2

   ----------------------
   -- GtkAda additions --
   ----------------------

   -------------
   -- Display --
   -------------
   --  These subprograms should really be in gdk-display.ads to match what is
   --  done for gtk+ itself, but that would create dependency circularities.
   --  Ada 2005 has support for these, but we want GtkAda to build with Ada95
   --  compilers.

   function Get_Screen
     (Display    : access Gdk.Display.Gdk_Display_Record'Class;
      Screen_Num : Glib.Gint)
   return Gdk_Screen;
   --  Returns a screen object for one of the screens of the display.

   function Get_Default_Screen
     (Display : access Gdk.Display.Gdk_Display_Record'Class) return Gdk_Screen;
   --  Get the default Gdk_Screen for display.

   procedure Get_Pointer
     (Display : access Gdk.Display.Gdk_Display_Record'Class;
      Screen  : out Gdk_Screen;
      X       : out Glib.Gint;
      Y       : out Glib.Gint;
      Mask    : out Gdk.Types.Gdk_Modifier_Type);
   --  Gets the current location of the pointer and the current modifier
   --  mask for a given display.
   --  (X, Y) are coordinates relative to the root window on the display

   procedure Warp_Pointer
     (Display : access Gdk.Display.Gdk_Display_Record'Class;
      Screen  : access Gdk_Screen_Record;
      X       : Glib.Gint;
      Y       : Glib.Gint);
   --  Warps the pointer of display to the point x,y on the screen screen,
   --  unless the pointer is confined to a window by a grab, in which case it
   --  will be moved as far as allowed by the grab. Warping the pointer creates
   --  events as if the user had moved the mouse instantaneously to the
   --  destination.
   --
   --  Note that the pointer should normally be under the control of the user.
   --  This function was added to cover some rare use cases like keyboard
   --  navigation support for the color picker in the GtkColorSelectionDialog.

   ---------------
   -- Functions --
   ---------------

   function Get_Default return Gdk_Screen;
   --  Gets the default screen for the default display. (See
   --  gdk_display_get_default ()).
   --  Since: gtk+ 2.2

   function Height return Gint;
   --  Returns the height of the default screen in pixels.

   function Height_Mm return Gint;
   --  Returns the height of the default screen in millimeters. Note that on
   --  many X servers this value will not be correct.
   --  though it is not always correct.

   function Width return Gint;
   --  Returns the width of the default screen in pixels.

   function Width_Mm return Gint;
   --  Returns the width of the default screen in millimeters. Note that on
   --  many X servers this value will not be correct.
   --  though it is not always correct.

   ----------------
   -- Properties --
   ----------------
   --  The following properties are defined for this widget. See
   --  Glib.Properties for more information on properties)
   --
   --  Name: Resolution_Property
   --  Type: Gdouble
   --  Flags: read-write

   Resolution_Property : constant Glib.Properties.Property_Double;

   -------------
   -- Signals --
   -------------
   --  The following new signals are defined for this widget:
   --
   --  "composited-changed"
   --     procedure Handler (Self : access Gdk_Screen_Record'Class);
   --  The ::composited-changed signal is emitted when the composited status
   --  of the screen changes
   --
   --  "monitors-changed"
   --     procedure Handler (Self : access Gdk_Screen_Record'Class);
   --  The ::monitors-changed signal is emitted when the number, size or
   --  position of the monitors attached to the screen change.
   --  Only for X11 and OS X for now. A future implementation for Win32 may be
   --  a possibility.
   --
   --  "size-changed"
   --     procedure Handler (Self : access Gdk_Screen_Record'Class);
   --  The ::size-changed signal is emitted when the pixel width or height of
   --  a screen changes.

   Signal_Composited_Changed : constant Glib.Signal_Name := "composited-changed";
   Signal_Monitors_Changed : constant Glib.Signal_Name := "monitors-changed";
   Signal_Size_Changed : constant Glib.Signal_Name := "size-changed";

private
   Resolution_Property : constant Glib.Properties.Property_Double :=
     Glib.Properties.Build ("resolution");
end Gdk.Screen;