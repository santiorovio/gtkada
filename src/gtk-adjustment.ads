-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
-- Copyright (C) 1998 Emmanuel Briot and Joel Brobecker              --
--                                                                   --
-- This library is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU Library General Public       --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This library is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- Library General Public License for more details.                  --
--                                                                   --
-- You should have received a copy of the GNU Library General Public --
-- License along with this library; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
-----------------------------------------------------------------------

with Gtk.Data;

package Gtk.Adjustment is

   type Gtk_Adjustment is new Data.Gtk_Data with private;

   function Null_Adjustment return Gtk_Adjustment;

   procedure Gtk_New (Adjustment : out Gtk_Adjustment;
                      Value          : in Gfloat;
                      Lower          : in Gfloat;
                      Upper          : in Gfloat;
                      Step_Increment : in Gfloat;
                      Page_Increment : in Gfloat;
                      Page_Size      : in Gfloat);
   --  mapping: Gtk_New gtkadjustment.h gtk_adjustment_new

   function Get_Value (Adjustment : in Gtk_Adjustment'Class) return Gfloat;

   procedure Set_Value (Adjustment : in out Gtk_Adjustment'Class;
                        Value      : in     Gfloat);
   --  mapping: Set_Value gtkadjustment.h gtk_adjustment_set_value

   procedure Clamp_Page (Adjustment : in out Gtk_Adjustment'Class;
                         Lower      : in     Gfloat;
                         Upper      : in     Gfloat);
   --  mapping: Clamp_Page gtkadjustment.h gtk_adjustment_clamp_page

private

   type Gtk_Adjustment is new Data.Gtk_Data with null record;

   --  mapping: NOT_IMPLEMENTED gtkadjustment.h gtk_adjustment_get_type

end Gtk.Adjustment;
