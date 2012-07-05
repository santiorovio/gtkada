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

--  <description>
--  A Gtk.Toggle_Action.Gtk_Toggle_Action corresponds roughly to a
--  Gtk.Check_Menu_Item.Gtk_Check_Menu_Item. It has an "active" state
--  specifying whether the action has been checked or not.
--
--  </description>

pragma Warnings (Off, "*is already use-visible*");
with Glib;            use Glib;
with Glib.Properties; use Glib.Properties;
with Glib.Types;      use Glib.Types;
with Gtk.Action;      use Gtk.Action;
with Gtk.Buildable;   use Gtk.Buildable;

package Gtk.Toggle_Action is

   type Gtk_Toggle_Action_Record is new Gtk_Action_Record with null record;
   type Gtk_Toggle_Action is access all Gtk_Toggle_Action_Record'Class;

   ------------------
   -- Constructors --
   ------------------

   procedure Gtk_New
      (Action   : out Gtk_Toggle_Action;
       Name     : UTF8_String;
       Label    : UTF8_String := "";
       Tooltip  : UTF8_String := "";
       Stock_Id : UTF8_String := "");
   procedure Initialize
      (Action   : not null access Gtk_Toggle_Action_Record'Class;
       Name     : UTF8_String;
       Label    : UTF8_String := "";
       Tooltip  : UTF8_String := "";
       Stock_Id : UTF8_String := "");
   --  Creates a new Gtk.Toggle_Action.Gtk_Toggle_Action object. To add the
   --  action to a Gtk.Action_Group.Gtk_Action_Group and set the accelerator
   --  for the action, call Gtk.Action_Group.Add_Action_With_Accel.
   --  Since: gtk+ 2.4
   --  "name": A unique name for the action
   --  "label": The label displayed in menu items and on buttons, or null
   --  "tooltip": A tooltip for the action, or null
   --  "stock_id": The stock icon to display in widgets representing the
   --  action, or null

   function Get_Type return Glib.GType;
   pragma Import (C, Get_Type, "gtk_toggle_action_get_type");

   -------------
   -- Methods --
   -------------

   function Get_Active
      (Action : not null access Gtk_Toggle_Action_Record) return Boolean;
   procedure Set_Active
      (Action    : not null access Gtk_Toggle_Action_Record;
       Is_Active : Boolean);
   --  Sets the checked state on the toggle action.
   --  Since: gtk+ 2.4
   --  "is_active": whether the action should be checked or not

   function Get_Draw_As_Radio
      (Action : not null access Gtk_Toggle_Action_Record) return Boolean;
   procedure Set_Draw_As_Radio
      (Action        : not null access Gtk_Toggle_Action_Record;
       Draw_As_Radio : Boolean);
   --  Sets whether the action should have proxies like a radio action.
   --  Since: gtk+ 2.4
   --  "draw_as_radio": whether the action should have proxies like a radio
   --  action

   procedure Toggled (Action : not null access Gtk_Toggle_Action_Record);
   --  Emits the "toggled" signal on the toggle action.
   --  Since: gtk+ 2.4

   ---------------------------------------------
   -- Inherited subprograms (from interfaces) --
   ---------------------------------------------
   --  Methods inherited from the Buildable interface are not duplicated here
   --  since they are meant to be used by tools, mostly. If you need to call
   --  them, use an explicit cast through the "-" operator below.

   ----------------
   -- Interfaces --
   ----------------
   --  This class implements several interfaces. See Glib.Types
   --
   --  - "Buildable"

   package Implements_Gtk_Buildable is new Glib.Types.Implements
     (Gtk.Buildable.Gtk_Buildable, Gtk_Toggle_Action_Record, Gtk_Toggle_Action);
   function "+"
     (Widget : access Gtk_Toggle_Action_Record'Class)
   return Gtk.Buildable.Gtk_Buildable
   renames Implements_Gtk_Buildable.To_Interface;
   function "-"
     (Interf : Gtk.Buildable.Gtk_Buildable)
   return Gtk_Toggle_Action
   renames Implements_Gtk_Buildable.To_Object;

   ----------------
   -- Properties --
   ----------------
   --  The following properties are defined for this widget. See
   --  Glib.Properties for more information on properties)
   --
   --  Name: Active_Property
   --  Type: Boolean
   --  Flags: read-write
   --  Whether the toggle action should be active.
   --
   --  Name: Draw_As_Radio_Property
   --  Type: Boolean
   --  Flags: read-write
   --  Whether the proxies for this action look like radio action proxies.
   --
   --  This is an appearance property and thus only applies if
   --  Gtk.Activatable.Gtk_Activatable:use-action-appearance is True.

   Active_Property : constant Glib.Properties.Property_Boolean;
   Draw_As_Radio_Property : constant Glib.Properties.Property_Boolean;

   -------------
   -- Signals --
   -------------
   --  The following new signals are defined for this widget:
   --
   --  "toggled"
   --     procedure Handler (Self : access Gtk_Toggle_Action_Record'Class);
   --  Should be connected if you wish to perform an action whenever the
   --  Gtk.Toggle_Action.Gtk_Toggle_Action state is changed.

   Signal_Toggled : constant Glib.Signal_Name := "toggled";

private
   Active_Property : constant Glib.Properties.Property_Boolean :=
     Glib.Properties.Build ("active");
   Draw_As_Radio_Property : constant Glib.Properties.Property_Boolean :=
     Glib.Properties.Build ("draw-as-radio");
end Gtk.Toggle_Action;