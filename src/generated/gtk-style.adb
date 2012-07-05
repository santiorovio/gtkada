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

pragma Style_Checks (Off);
pragma Warnings (Off, "*is already use-visible*");
with Glib.Type_Conversion_Hooks; use Glib.Type_Conversion_Hooks;
with Interfaces.C.Strings;       use Interfaces.C.Strings;

package body Gtk.Style is

   package Type_Conversion_Gtk_Style is new Glib.Type_Conversion_Hooks.Hook_Registrator
     (Get_Type'Access, Gtk_Style_Record);
   pragma Unreferenced (Type_Conversion_Gtk_Style);

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New (Style : out Gtk_Style) is
   begin
      Style := new Gtk_Style_Record;
      Gtk.Style.Initialize (Style);
   end Gtk_New;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize (Style : not null access Gtk_Style_Record'Class) is
      function Internal return System.Address;
      pragma Import (C, Internal, "gtk_style_new");
   begin
      Set_Object (Style, Internal);
   end Initialize;

   ------------------------------
   -- Apply_Default_Background --
   ------------------------------

   procedure Apply_Default_Background
      (Style      : not null access Gtk_Style_Record;
       Cr         : Cairo.Cairo_Context;
       Window     : Gdk.Window.Gdk_Window;
       State_Type : Gtk.Enums.Gtk_State_Type;
       X          : Gint;
       Y          : Gint;
       Width      : Gint;
       Height     : Gint)
   is
      procedure Internal
         (Style      : System.Address;
          Cr         : Cairo.Cairo_Context;
          Window     : Gdk.Window.Gdk_Window;
          State_Type : Gtk.Enums.Gtk_State_Type;
          X          : Gint;
          Y          : Gint;
          Width      : Gint;
          Height     : Gint);
      pragma Import (C, Internal, "gtk_style_apply_default_background");
   begin
      Internal (Get_Object (Style), Cr, Window, State_Type, X, Y, Width, Height);
   end Apply_Default_Background;

   ------------
   -- Attach --
   ------------

   function Attach
      (Style  : not null access Gtk_Style_Record;
       Window : Gdk.Window.Gdk_Window) return Gtk_Style
   is
      function Internal
         (Style  : System.Address;
          Window : Gdk.Window.Gdk_Window) return System.Address;
      pragma Import (C, Internal, "gtk_style_attach");
      Stub_Gtk_Style : Gtk_Style_Record;
   begin
      return Gtk.Style.Gtk_Style (Get_User_Data (Internal (Get_Object (Style), Window), Stub_Gtk_Style));
   end Attach;

   ----------
   -- Copy --
   ----------

   function Copy (Style : not null access Gtk_Style_Record) return Gtk_Style is
      function Internal (Style : System.Address) return System.Address;
      pragma Import (C, Internal, "gtk_style_copy");
      Stub_Gtk_Style : Gtk_Style_Record;
   begin
      return Gtk.Style.Gtk_Style (Get_User_Data (Internal (Get_Object (Style)), Stub_Gtk_Style));
   end Copy;

   ------------
   -- Detach --
   ------------

   procedure Detach (Style : not null access Gtk_Style_Record) is
      procedure Internal (Style : System.Address);
      pragma Import (C, Internal, "gtk_style_detach");
   begin
      Internal (Get_Object (Style));
   end Detach;

   ------------------------
   -- Get_Style_Property --
   ------------------------

   procedure Get_Style_Property
      (Style         : not null access Gtk_Style_Record;
       Widget_Type   : GType;
       Property_Name : UTF8_String;
       Value         : in out Glib.Values.GValue)
   is
      procedure Internal
         (Style         : System.Address;
          Widget_Type   : GType;
          Property_Name : Interfaces.C.Strings.chars_ptr;
          Value         : in out Glib.Values.GValue);
      pragma Import (C, Internal, "gtk_style_get_style_property");
      Tmp_Property_Name : Interfaces.C.Strings.chars_ptr := New_String (Property_Name);
   begin
      Internal (Get_Object (Style), Widget_Type, Tmp_Property_Name, Value);
      Free (Tmp_Property_Name);
   end Get_Style_Property;

   -----------------
   -- Has_Context --
   -----------------

   function Has_Context
      (Style : not null access Gtk_Style_Record) return Boolean
   is
      function Internal (Style : System.Address) return Integer;
      pragma Import (C, Internal, "gtk_style_has_context");
   begin
      return Boolean'Val (Internal (Get_Object (Style)));
   end Has_Context;

   ------------------
   -- Lookup_Color --
   ------------------

   procedure Lookup_Color
      (Style      : not null access Gtk_Style_Record;
       Color_Name : UTF8_String;
       Color      : out Gdk.Color.Gdk_Color;
       Found      : out Boolean)
   is
      function Internal
         (Style      : System.Address;
          Color_Name : Interfaces.C.Strings.chars_ptr;
          Acc_Color  : access Gdk.Color.Gdk_Color) return Integer;
      pragma Import (C, Internal, "gtk_style_lookup_color");
      Acc_Color      : aliased Gdk.Color.Gdk_Color;
      Tmp_Color_Name : Interfaces.C.Strings.chars_ptr := New_String (Color_Name);
      Tmp_Return     : Integer;
   begin
      Tmp_Return := Internal (Get_Object (Style), Tmp_Color_Name, Acc_Color'Access);
      Color := Acc_Color;
      Free (Tmp_Color_Name);
      Found := Boolean'Val (Tmp_Return);
   end Lookup_Color;

   --------------------
   -- Set_Background --
   --------------------

   procedure Set_Background
      (Style      : not null access Gtk_Style_Record;
       Window     : Gdk.Window.Gdk_Window;
       State_Type : Gtk.Enums.Gtk_State_Type)
   is
      procedure Internal
         (Style      : System.Address;
          Window     : Gdk.Window.Gdk_Window;
          State_Type : Gtk.Enums.Gtk_State_Type);
      pragma Import (C, Internal, "gtk_style_set_background");
   begin
      Internal (Get_Object (Style), Window, State_Type);
   end Set_Background;

end Gtk.Style;