-----------------------------------------------------------------------
--               GtkAda - Ada95 binding for Gtk+/Gnome               --
--                                                                   --
--                   Copyright (C) 2001 ACT-Europe                   --
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

with Interfaces.C.Strings;
with Unchecked_Conversion;
with Unchecked_Deallocation;

with Glib.Type_Conversion_Hooks;
with Gtkada.Types; use Gtkada.Types;

package body Glib.GObjects is

   procedure Free_User_Data (Data : in System.Address);
   --  Free the user data Data. This function should not be called directly

   -------------------------
   -- Conversion_Function --
   -------------------------

   function Conversion_Function
     (Obj : System.Address; Stub : GObject_Record'Class) return GObject
   is
      function Get_Type (Obj : System.Address) return GType;
      pragma Import (C, Get_Type, "ada_gobject_get_type");

      Name  : constant String := Type_Name (Get_Type (Obj));
      Hooks : Glib.Type_Conversion_Hooks.Hook_List_Access;

      use type Glib.Type_Conversion_Hooks.Hook_List_Access;

   begin
      Hooks := Glib.Type_Conversion_Hooks.Conversion_Hooks;

      while Hooks /= null loop
         declare
            R : GObject := Hooks.Func (Name);
         begin
            if R /= null then
               return R;
            end if;
         end;

         Hooks := Hooks.Next;
      end loop;

      return new GObject_Record'Class' (Stub);
   end Conversion_Function;

   --------------------
   -- Free_User_Data --
   --------------------

   procedure Free_User_Data (Data : in System.Address) is
      function Convert is new Unchecked_Conversion (System.Address, GObject);
      procedure Free is new Unchecked_Deallocation
        (GObject_Record'Class, GObject);
      Obj : GObject := Convert (Data);
   begin
      Free (Obj);
   end Free_User_Data;

   ----------------
   -- Get_Object --
   ----------------

   function Get_Object (Object : access GObject_Record'Class)
                        return System.Address is
   begin
      return Object.Ptr;
   end Get_Object;

   --------------
   -- Get_Type --
   --------------

   function Get_Type (Object : access GObject_Record) return GType is
      function Internal (Object : System.Address) return GType;
      pragma Import (C, Internal, "ada_gobject_get_type");

   begin
      return Internal (Get_Object (Object));
   end Get_Type;

   -------------------
   -- Get_User_Data --
   -------------------

   function Get_User_Data
     (Obj  : in System.Address;
      Stub : in GObject_Record'Class) return GObject
   is
      function Internal
        (Object : in System.Address;
         Quark  : in Glib.GQuark) return GObject;
      pragma Import (C, Internal, "g_object_get_qdata");

      use type System.Address;

      R : GObject;
   begin
      if Obj = System.Null_Address then
         return null;
      end if;

      if GtkAda_String_Quark = Glib.Unknown_Quark then
         GtkAda_String_Quark := Glib.Quark_From_String (GtkAda_String);
      end if;

      R := Internal (Obj, GtkAda_String_Quark);

      if R = null then
         R := Conversion_Function (Obj, Stub);
         --  This function will either simply return what we expect (Stub), or
         --  try to create the exact Ada type corresponding to the C type.
         Set_Object (R, Obj);
         Initialize_User_Data (R);
      end if;

      return R;
   end Get_User_Data;

   --------------------------
   -- Initialize_User_Data --
   --------------------------

   procedure Initialize_User_Data (Obj : access GObject_Record'Class) is
      function Internal
        (Object : in System.Address;
         Quark  : in Glib.GQuark) return GObject;
      pragma Import (C, Internal, "g_object_get_qdata");

      procedure Set_User_Data
        (Obj     : System.Address;
         Quark   : Glib.GQuark;
         Data    : System.Address;
         Destroy : System.Address);
      pragma Import (C, Set_User_Data, "g_object_set_qdata_full");

   begin
      if GtkAda_String_Quark = Glib.Unknown_Quark then
         GtkAda_String_Quark := Glib.Quark_From_String (GtkAda_String);
      end if;

      if Internal (Get_Object (Obj), GtkAda_String_Quark) = null then
         Set_User_Data (Get_Object (Obj), GtkAda_String_Quark,
                        Obj.all'Address, Free_User_Data'Address);
      end if;
   end Initialize_User_Data;

   ----------------
   -- Is_Created --
   ----------------

   function Is_Created (Object : in GObject_Record'Class) return Boolean is
      use type System.Address;
   begin
      return Object.Ptr /= System.Null_Address;
   end Is_Created;

   ----------------
   -- Set_Object --
   ----------------

   procedure Set_Object
     (Object : access GObject_Record'Class;
      Value  : in     System.Address) is
   begin
      Object.Ptr := Value;
   end Set_Object;

   --------------------
   -- Unchecked_Cast --
   --------------------

   function Unchecked_Cast
     (Obj  : access GObject_Record'Class;
      Stub : GObject_Record'Class) return GObject
   is
      Object : GObject := GObject (Obj);
      Result : GObject := new GObject_Record'Class' (Stub);

      procedure Set_User_Data
        (Obj     : System.Address;
         Quark   : Glib.GQuark;
         Data    : GObject;
         Destroy : System.Address);
      pragma Import (C, Set_User_Data, "g_object_set_qdata_full");

      procedure Free is new Unchecked_Deallocation
        (GObject_Record'Class, GObject);

   begin
      Result.Ptr := Obj.Ptr;
      Set_User_Data
        (Obj.Ptr, GtkAda_String_Quark, Result, Free_User_Data'Address);
      Free (Object);
      return Result;
   end Unchecked_Cast;

   -----------------------------
   -- Initialize_Class_Record --
   -----------------------------

   procedure Initialize_Class_Record
     (Object       : access GObject_Record'Class;
      Signals      : Gtkada.Types.Chars_Ptr_Array;
      Class_Record : in out GObject_Class;
      Type_Name    : String;
      Parameters   : Signal_Parameter_Types := Null_Parameter_Types)
   is
      function Internal
        (Object         : System.Address;
         NSignals       : Gint;
         Signals        : System.Address;
         Parameters     : System.Address;
         Max_Parameters : Gint;
         Class_Record   : GObject_Class;
         Type_Name      : String) return GObject_Class;
      pragma Import (C, Internal, "ada_initialize_class_record");

      Default_Params : Signal_Parameter_Types (1 .. Signals'Length, 1 .. 0) :=
        (others => (others => GType_None));
      Pa  : System.Address := Default_Params'Address;
      Num : Gint := 0;

   begin
      if Parameters /= Null_Parameter_Types then
         pragma Assert (Parameters'Length (1) = Signals'Length);
         Pa := Parameters'Address;
         Num := Parameters'Length (2);
      end if;

      Class_Record :=
        Internal
          (Get_Object (Object),
           Signals'Length,
           Signals'Address,
           Pa,
           Num,
           Class_Record,
           Type_Name & ASCII.NUL);
   end Initialize_Class_Record;

   --------------
   -- List_Ids --
   --------------

   function List_Ids (Typ : Glib.GType) return Handler_Id_Array is
      type Flat_Id_Array is array (Guint) of Handler_Id;
      type Flat_Id_Array_Access is access Flat_Id_Array;
      type Guint_Access is access all Guint;
      function Internal (Typ : GType; N_Ids : Guint_Access)
         return Flat_Id_Array_Access;
      pragma Import (C, Internal, "g_signal_list_ids");
      N_Ids : aliased Guint;
      Result : Flat_Id_Array_Access := Internal (Typ, N_Ids'Access);
   begin
      if N_Ids = 0 then
         return (1 .. 0 => 0);
      else
         declare
            Res : Handler_Id_Array (0 .. N_Ids - 1) :=
              Handler_Id_Array (Result (0 .. N_Ids - 1));
         begin
            return Res;
         end;
      end if;
   end List_Ids;

   -----------------
   -- Signal_Name --
   -----------------

   function Signal_Name (Q : Signal_Query) return String is
      function Internal (Q : Signal_Query)
         return Interfaces.C.Strings.chars_ptr;
      pragma Import (C, Internal, "ada_gsignal_query_signal_name");
   begin
      return Interfaces.C.Strings.Value (Internal (Q));
   end Signal_Name;

   ------------
   -- Params --
   ------------

   function Params (Q : Signal_Query) return GType_Array is
      type Flat_GType_Array is array (Guint) of GType;
      type Flat_GType_Array_Access is access Flat_GType_Array;
      type Guint_Access is access all Guint;
      function Internal (Q : Signal_Query; N_Ids : Guint_Access)
         return Flat_GType_Array_Access;
      pragma Import (C, Internal, "ada_gsignal_query_params");
      N_Ids : aliased Guint;
      Result : Flat_GType_Array_Access := Internal (Q, N_Ids'Access);
   begin
      if N_Ids = 0 then
         return (1 .. 0 => GType_Invalid);
      else
         declare
            Res : GType_Array (0 .. N_Ids - 1) :=
              GType_Array (Result (0 .. N_Ids - 1));
         begin
            return Res;
         end;
      end if;
   end Params;

   ------------
   -- Lookup --
   ------------

   function Lookup (Object : GType; Signal : String) return Glib.Handler_Id
   is
      function Internal (Signal : String; Object : GType) return Handler_Id;
      pragma Import (C, Internal, "g_signal_lookup");
   begin
      return Internal (Signal & ASCII.Nul, Object);
   end Lookup;

   ------------
   -- Notify --
   ------------

   procedure Notify
     (Object : access Glib.GObjects.GObject_Record;
      Property_Name : String)
   is
      procedure Internal (Object : System.Address; Name : String);
      pragma Import (C, Internal, "g_object_notify");
   begin
      Internal (Glib.GObjects.Get_Object (Object), Property_Name & ASCII.Nul);
   end Notify;

end Glib.GObjects;
