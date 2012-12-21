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
with Ada.Unchecked_Conversion;
with Glib.Type_Conversion_Hooks; use Glib.Type_Conversion_Hooks;
with Interfaces.C.Strings;       use Interfaces.C.Strings;

package body Gtk.Text_Tag_Table is

   procedure C_Gtk_Text_Tag_Table_Foreach
      (Table : System.Address;
       Func  : System.Address;
       Data  : System.Address);
   pragma Import (C, C_Gtk_Text_Tag_Table_Foreach, "gtk_text_tag_table_foreach");
   --  Calls Func on each tag in Table, with user data Data. Note that the
   --  table may not be modified while iterating over it (you can't add/remove
   --  tags).
   --  "func": a function to call on each tag
   --  "data": user data

   function To_Gtk_Text_Tag_Table_Foreach is new Ada.Unchecked_Conversion
     (System.Address, Gtk_Text_Tag_Table_Foreach);

   function To_Address is new Ada.Unchecked_Conversion
     (Gtk_Text_Tag_Table_Foreach, System.Address);

   procedure Internal_Gtk_Text_Tag_Table_Foreach
      (Tag  : System.Address;
       Data : System.Address);
   pragma Convention (C, Internal_Gtk_Text_Tag_Table_Foreach);

   -----------------------------------------
   -- Internal_Gtk_Text_Tag_Table_Foreach --
   -----------------------------------------

   procedure Internal_Gtk_Text_Tag_Table_Foreach
      (Tag  : System.Address;
       Data : System.Address)
   is
      Func              : constant Gtk_Text_Tag_Table_Foreach := To_Gtk_Text_Tag_Table_Foreach (Data);
      Stub_Gtk_Text_Tag : Gtk.Text_Tag.Gtk_Text_Tag_Record;
   begin
      Func (Gtk.Text_Tag.Gtk_Text_Tag (Get_User_Data (Tag, Stub_Gtk_Text_Tag)));
   end Internal_Gtk_Text_Tag_Table_Foreach;

   package Type_Conversion_Gtk_Text_Tag_Table is new Glib.Type_Conversion_Hooks.Hook_Registrator
     (Get_Type'Access, Gtk_Text_Tag_Table_Record);
   pragma Unreferenced (Type_Conversion_Gtk_Text_Tag_Table);

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New (Table : out Gtk_Text_Tag_Table) is
   begin
      Table := new Gtk_Text_Tag_Table_Record;
      Gtk.Text_Tag_Table.Initialize (Table);
   end Gtk_New;

   ----------------------------
   -- Gtk_Text_Tag_Table_New --
   ----------------------------

   function Gtk_Text_Tag_Table_New return Gtk_Text_Tag_Table is
      Table : constant Gtk_Text_Tag_Table := new Gtk_Text_Tag_Table_Record;
   begin
      Gtk.Text_Tag_Table.Initialize (Table);
      return Table;
   end Gtk_Text_Tag_Table_New;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize
      (Table : not null access Gtk_Text_Tag_Table_Record'Class)
   is
      function Internal return System.Address;
      pragma Import (C, Internal, "gtk_text_tag_table_new");
   begin
      Set_Object (Table, Internal);
   end Initialize;

   ---------
   -- Add --
   ---------

   procedure Add
      (Table : not null access Gtk_Text_Tag_Table_Record;
       Tag   : not null access Gtk.Text_Tag.Gtk_Text_Tag_Record'Class)
   is
      procedure Internal (Table : System.Address; Tag : System.Address);
      pragma Import (C, Internal, "gtk_text_tag_table_add");
   begin
      Internal (Get_Object (Table), Get_Object (Tag));
   end Add;

   -------------
   -- Foreach --
   -------------

   procedure Foreach
      (Table : not null access Gtk_Text_Tag_Table_Record;
       Func  : Gtk_Text_Tag_Table_Foreach)
   is
   begin
      if Func = null then
         C_Gtk_Text_Tag_Table_Foreach (Get_Object (Table), System.Null_Address, System.Null_Address);
      else
         C_Gtk_Text_Tag_Table_Foreach (Get_Object (Table), Internal_Gtk_Text_Tag_Table_Foreach'Address, To_Address (Func));
      end if;
   end Foreach;

   package body Foreach_User_Data is

      package Users is new Glib.Object.User_Data_Closure
        (User_Data_Type, Destroy);

      function To_Gtk_Text_Tag_Table_Foreach is new Ada.Unchecked_Conversion
        (System.Address, Gtk_Text_Tag_Table_Foreach);

      function To_Address is new Ada.Unchecked_Conversion
        (Gtk_Text_Tag_Table_Foreach, System.Address);

      procedure Internal_Cb (Tag : System.Address; Data : System.Address);
      pragma Convention (C, Internal_Cb);

      -------------
      -- Foreach --
      -------------

      procedure Foreach
         (Table : not null access Gtk.Text_Tag_Table.Gtk_Text_Tag_Table_Record'Class;
          Func  : Gtk_Text_Tag_Table_Foreach;
          Data  : User_Data_Type)
      is
      begin
         if Func = null then
            C_Gtk_Text_Tag_Table_Foreach (Get_Object (Table), System.Null_Address, System.Null_Address);
         else
            C_Gtk_Text_Tag_Table_Foreach (Get_Object (Table), Internal_Cb'Address, Users.Build (To_Address (Func), Data));
         end if;
      end Foreach;

      -----------------
      -- Internal_Cb --
      -----------------

      procedure Internal_Cb (Tag : System.Address; Data : System.Address) is
         D                 : constant Users.Internal_Data_Access := Users.Convert (Data);
         Stub_Gtk_Text_Tag : Gtk.Text_Tag.Gtk_Text_Tag_Record;
      begin
         To_Gtk_Text_Tag_Table_Foreach (D.Func) (Gtk.Text_Tag.Gtk_Text_Tag (Get_User_Data (Tag, Stub_Gtk_Text_Tag)), D.Data.all);
      end Internal_Cb;

   end Foreach_User_Data;

   --------------
   -- Get_Size --
   --------------

   function Get_Size
      (Table : not null access Gtk_Text_Tag_Table_Record) return Gint
   is
      function Internal (Table : System.Address) return Gint;
      pragma Import (C, Internal, "gtk_text_tag_table_get_size");
   begin
      return Internal (Get_Object (Table));
   end Get_Size;

   ------------
   -- Lookup --
   ------------

   function Lookup
      (Table : not null access Gtk_Text_Tag_Table_Record;
       Name  : UTF8_String) return Gtk.Text_Tag.Gtk_Text_Tag
   is
      function Internal
         (Table : System.Address;
          Name  : Interfaces.C.Strings.chars_ptr) return System.Address;
      pragma Import (C, Internal, "gtk_text_tag_table_lookup");
      Tmp_Name          : Interfaces.C.Strings.chars_ptr := New_String (Name);
      Stub_Gtk_Text_Tag : Gtk.Text_Tag.Gtk_Text_Tag_Record;
      Tmp_Return        : System.Address;
   begin
      Tmp_Return := Internal (Get_Object (Table), Tmp_Name);
      Free (Tmp_Name);
      return Gtk.Text_Tag.Gtk_Text_Tag (Get_User_Data (Tmp_Return, Stub_Gtk_Text_Tag));
   end Lookup;

   ------------
   -- Remove --
   ------------

   procedure Remove
      (Table : not null access Gtk_Text_Tag_Table_Record;
       Tag   : not null access Gtk.Text_Tag.Gtk_Text_Tag_Record'Class)
   is
      procedure Internal (Table : System.Address; Tag : System.Address);
      pragma Import (C, Internal, "gtk_text_tag_table_remove");
   begin
      Internal (Get_Object (Table), Get_Object (Tag));
   end Remove;

   ------------------
   -- On_Tag_Added --
   ------------------

   procedure On_Tag_Added
      (Self : not null access Gtk_Text_Tag_Table_Record;
       Call : not null access procedure
         (Self : access Gtk_Text_Tag_Table_Record'Class;
          Tag  : not null access Gtk.Text_Tag.Gtk_Text_Tag_Record'Class))
   is
      pragma Unreferenced (Self, Call);
   begin
      null;
   end On_Tag_Added;

   ------------------
   -- On_Tag_Added --
   ------------------

   procedure On_Tag_Added
      (Self : not null access Gtk_Text_Tag_Table_Record;
       Call : not null access procedure
         (Self : access Glib.Object.GObject_Record'Class;
          Tag  : not null access Gtk.Text_Tag.Gtk_Text_Tag_Record'Class);
       Slot : not null access Glib.Object.GObject_Record'Class)
   is
      pragma Unreferenced (Self, Call, Slot);
   begin
      null;
   end On_Tag_Added;

   --------------------
   -- On_Tag_Changed --
   --------------------

   procedure On_Tag_Changed
      (Self : not null access Gtk_Text_Tag_Table_Record;
       Call : not null access procedure
         (Self         : access Gtk_Text_Tag_Table_Record'Class;
          Tag          : not null access Gtk.Text_Tag.Gtk_Text_Tag_Record'Class;
          Size_Changed : Boolean))
   is
      pragma Unreferenced (Self, Call);
   begin
      null;
   end On_Tag_Changed;

   --------------------
   -- On_Tag_Changed --
   --------------------

   procedure On_Tag_Changed
      (Self : not null access Gtk_Text_Tag_Table_Record;
       Call : not null access procedure
         (Self         : access Glib.Object.GObject_Record'Class;
          Tag          : not null access Gtk.Text_Tag.Gtk_Text_Tag_Record'Class;
          Size_Changed : Boolean);
       Slot : not null access Glib.Object.GObject_Record'Class)
   is
      pragma Unreferenced (Self, Call, Slot);
   begin
      null;
   end On_Tag_Changed;

   --------------------
   -- On_Tag_Removed --
   --------------------

   procedure On_Tag_Removed
      (Self : not null access Gtk_Text_Tag_Table_Record;
       Call : not null access procedure
         (Self : access Gtk_Text_Tag_Table_Record'Class;
          Tag  : not null access Gtk.Text_Tag.Gtk_Text_Tag_Record'Class))
   is
      pragma Unreferenced (Self, Call);
   begin
      null;
   end On_Tag_Removed;

   --------------------
   -- On_Tag_Removed --
   --------------------

   procedure On_Tag_Removed
      (Self : not null access Gtk_Text_Tag_Table_Record;
       Call : not null access procedure
         (Self : access Glib.Object.GObject_Record'Class;
          Tag  : not null access Gtk.Text_Tag.Gtk_Text_Tag_Record'Class);
       Slot : not null access Glib.Object.GObject_Record'Class)
   is
      pragma Unreferenced (Self, Call, Slot);
   begin
      null;
   end On_Tag_Removed;

end Gtk.Text_Tag_Table;
