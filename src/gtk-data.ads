-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
--                     Copyright (C) 1998-1999                       --
--        Emmanuel Briot, Joel Brobecker and Arnaud Charlet          --
--                                                                   --
-- This library is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This library is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this library; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-- As a special exception, if other files instantiate generics from  --
-- this unit, or you link this unit with other files to produce an   --
-- executable, this  unit  does not  by itself cause  the resulting  --
-- executable to be covered by the GNU General Public License. This  --
-- exception does not however invalidate any other reasons why the   --
-- executable file  might be covered by the  GNU Public License.     --
-----------------------------------------------------------------------

--  <description>
--
--  Abstract class for objects containing data
--  This object is currently not very useful since it only provides
--  a single "disconnect" signal.
--
--  This is the "Model" in the Model/View/Controller framework.
--  </description>
--  <c_version>1.2.6</c_version>

with Gtk.Object;

package Gtk.Data is

   type Gtk_Data_Record is new Object.Gtk_Object_Record with private;
   type Gtk_Data is access all Gtk_Data_Record'Class;

   function Get_Type return Gtk.Gtk_Type;
   --  Returns the internal value associated with a Gtk_Data internally.

   ----------------------------
   -- Support for GATE/DGATE --
   ----------------------------

   procedure Generate (N      : in Node_Ptr;
                       File   : in File_Type)
     renames Gtk.Object.Generate;
   --  Gate internal function

   procedure Generate (Data : in out Gtk.Object.Gtk_Object; N : in Node_Ptr)
     renames Gtk.Object.Generate;
   --  Dgate internal function

   -------------
   -- Signals --
   -------------

   --  <signals>
   --  The following new signals are defined for this widget:
   --
   --  - "disconnect"
   --    procedure Handler (Data : access Gtk_Data_Record'Class);
   --
   --    Emitted just before DATA is destroyed.
   --  </signals>

private
   type Gtk_Data_Record is new Object.Gtk_Object_Record with null record;
   pragma Import (C, Get_Type, "gtk_data_get_type");
end Gtk.Data;
