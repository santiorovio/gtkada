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
--  GtkCssProvider is an object implementing the
--  Gtk.Style_Provider.Gtk_Style_Provider interface. It is able to parse <ulink
--  url="http://www.w3.org/TR/CSS2">CSS</ulink>-like input in order to style
--  widgets.
--
--  == Default files ==
--
--  An application can cause GTK+ to parse a specific CSS style sheet by
--  calling gtk_css_provider_load_from_file and adding the provider with
--  Gtk.Style_Context.Add_Provider or
--  Gtk.Style_Context.Add_Provider_For_Screen. In addition, certain files will
--  be read when GTK+ is initialized. First, the file
--  '<envar>$XDG_CONFIG_HOME</envar>/gtk-3.0/gtk.css' is loaded if it exists.
--  Then, GTK+ tries to load
--  '<envar>$HOME</envar>/.themes/<replaceable>theme-name</replaceable>/gtk-3.0/gtk.css',
--  falling back to
--  '<replaceable>datadir</replaceable>/share/themes/<replaceable>theme-name</replaceable>/gtk-3.0/gtk.css',
--  where <replaceable>theme-name</replaceable> is the name of the current
--  theme (see the Gtk.Settings.Gtk_Settings:gtk-theme-name setting) and
--  <replaceable>datadir</replaceable> is the prefix configured when GTK+ was
--  compiled, unless overridden by the <envar>GTK_DATA_PREFIX</envar>
--  environment variable.
--
--  == Style sheets ==
--
--  The basic structure of the style sheets understood by this provider is a
--  series of statements, which are either rule sets or '@-rules', separated by
--  whitespace.
--
--  A rule set consists of a selector and a declaration block, which is a
--  series of declarations enclosed in curly braces ({ and }). The declarations
--  are separated by semicolons (;). Multiple selectors can share the same
--  declaration block, by putting all the separators in front of the block,
--  separated by commas.
--
--  == A rule set with two selectors ==
--
--  <programlisting language="text"> GtkButton, GtkEntry { color: &num;ff00ea;
--  font: Comic Sans 12 } </programlisting>
--  == Selectors ==
--
--  Selectors work very similar to the way they do in CSS, with widget class
--  names taking the role of element names, and widget names taking the role of
--  IDs. When used in a selector, widget names must be prefixed with a '&num;'
--  character. The '*' character represents the so-called universal selector,
--  which matches any widget.
--
--  To express more complicated situations, selectors can be combined in
--  various ways:
--
--     * To require that a widget satisfies several conditions, combine
--  several selectors into one by concatenating them. E.g.
--  'GtkButton&num;button1' matches a GtkButton widget with the name button1.
--
--     * To only match a widget when it occurs inside some other widget, write
--  the two selectors after each other, separated by whitespace. E.g.
--  'GtkToolBar GtkButton' matches GtkButton widgets that occur inside a
--  GtkToolBar.
--
--     * In the previous example, the GtkButton is matched even if it occurs
--  deeply nested inside the toolbar. To restrict the match to direct children
--  of the parent widget, insert a '>' character between the two selectors.
--  E.g. 'GtkNotebook > GtkLabel' matches GtkLabel widgets that are direct
--  children of a GtkNotebook.
--
--  == Widget classes and names in selectors ==
--
--  <programlisting language="text"> /* Theme labels that are descendants of a
--  window */ GtkWindow GtkLabel { background-color: &num;898989 }
--  /* Theme notebooks, and anything that's within these */ GtkNotebook {
--  background-color: &num;a939f0 }
--
--  /* Theme combo boxes, and entries that are direct children of a notebook
--  */ GtkComboBox, GtkNotebook > GtkEntry { color: Fg_Color; background-color:
--  &num;1209a2 }
--
--  /* Theme any widget within a GtkBin */ GtkBin * { font: Sans 20 }
--
--  /* Theme a label named title-label */ GtkLabel&num;title-label { font:
--  Sans 15 }
--
--  /* Theme any widget named main-entry */ &num;main-entry {
--  background-color: &num;f0a810 } </programlisting>
--
--  Widgets may also define style classes, which can be used for matching.
--  When used in a selector, style classes must be prefixed with a '.'
--  character.
--
--  Refer to the documentation of individual widgets to learn which style
--  classes they define and see <xref linkend="gtkstylecontext-classes"/> for a
--  list of all style classes used by GTK+ widgets.
--
--  Note that there is some ambiguity in the selector syntax when it comes to
--  differentiation widget class names from regions. GTK+ currently treats a
--  string as a widget class name if it contains any uppercase characters
--  (which should work for more widgets with names like GtkLabel).
--
--  == Style classes in selectors ==
--
--  <programlisting language="text"> /* Theme all widgets defining the class
--  entry */ .entry { color: &num;39f1f9; }
--  /* Theme spinbuttons' entry */ GtkSpinButton.entry { color: &num;900185 }
--  </programlisting>
--
--  In complicated widgets like e.g. a GtkNotebook, it may be desirable to
--  style different parts of the widget differently. To make this possible,
--  container widgets may define regions, whose names may be used for matching
--  in selectors.
--
--  Some containers allow to further differentiate between regions by applying
--  so-called pseudo-classes to the region. For example, the tab region in
--  GtkNotebook allows to single out the first or last tab by using the
--  :first-child or :last-child pseudo-class. When used in selectors,
--  pseudo-classes must be prefixed with a ':' character.
--
--  Refer to the documentation of individual widgets to learn which regions
--  and pseudo-classes they define and see <xref
--  linkend="gtkstylecontext-classes"/> for a list of all regions used by GTK+
--  widgets.
--
--  == Regions in selectors ==
--
--  <programlisting language="text"> /* Theme any label within a notebook */
--  GtkNotebook GtkLabel { color: &num;f90192; }
--  /* Theme labels within notebook tabs */ GtkNotebook tab GtkLabel { color:
--  &num;703910; }
--
--  /* Theme labels in the any first notebook tab, both selectors are
--  equivalent */ GtkNotebook tab:nth-child(first) GtkLabel, GtkNotebook
--  tab:first-child GtkLabel { color: &num;89d012; } </programlisting>
--
--  Another use of pseudo-classes is to match widgets depending on their
--  state. This is conceptually similar to the :hover, :active or :focus
--  pseudo-classes in CSS. The available pseudo-classes for widget states are
--  :active, :prelight (or :hover), :insensitive, :selected, :focused and
--  :inconsistent.
--
--  == Styling specific widget states ==
--
--  <programlisting language="text"> /* Theme active (pressed) buttons */
--  GtkButton:active { background-color: &num;0274d9; }
--  /* Theme buttons with the mouse pointer on it, both are equivalent */
--  GtkButton:hover, GtkButton:prelight { background-color: &num;3085a9; }
--
--  /* Theme insensitive widgets, both are equivalent */ :insensitive,
--  *:insensitive { background-color: &num;320a91; }
--
--  /* Theme selection colors in entries */ GtkEntry:selected {
--  background-color: &num;56f9a0; }
--
--  /* Theme focused labels */ GtkLabel:focused { background-color:
--  &num;b4940f; }
--
--  /* Theme inconsistent checkbuttons */ GtkCheckButton:inconsistent {
--  background-color: &num;20395a; } </programlisting>
--
--  Widget state pseudoclasses may only apply to the last element in a
--  selector.
--
--  To determine the effective style for a widget, all the matching rule sets
--  are merged. As in CSS, rules apply by specificity, so the rules whose
--  selectors more closely match a widget path will take precedence over the
--  others.
--
--  == &commat; Rules ==
--
--  GTK+'s CSS supports the &commat;import rule, in order to load another CSS
--  style sheet in addition to the currently parsed one.
--
--  == Using the &commat;import rule ==
--
--  <programlisting language="text"> &commat;import url
--  ("path/to/common.css"); </programlisting>
--  <para id="css-binding-set"> In order to extend key bindings affecting
--  different widgets, GTK+ supports the &commat;binding-set rule to parse a
--  set of bind/unbind directives, see Gtk.Binding_Set.Gtk_Binding_Set for the
--  supported syntax. Note that the binding sets defined in this way must be
--  associated with rule sets by setting the gtk-key-bindings style property.
--  Customized key bindings are typically defined in a separate 'gtk-keys.css'
--  CSS file and GTK+ loads this file according to the current key theme, which
--  is defined by the Gtk.Settings.Gtk_Settings:gtk-key-theme-name setting.
--
--  == Using the &commat;binding rule ==
--
--  <programlisting language="text"> &commat;binding-set binding-set1 { bind
--  "<alt>Left" { "move-cursor" (visual-positions, -3, 0) }; unbind "End"; };
--  &commat;binding-set binding-set2 { bind "<alt>Right" { "move-cursor"
--  (visual-positions, 3, 0) }; bind "<alt>KP_space" { "delete-from-cursor"
--  (whitespace, 1) "insert-at-cursor" (" ") }; };
--
--  GtkEntry { gtk-key-bindings: binding-set1, binding-set2; }
--  </programlisting>
--
--  GTK+ also supports an additional &commat;define-color rule, in order to
--  define a color name which may be used instead of color numeric
--  representations. Also see the Gtk.Settings.Gtk_Settings:gtk-color-scheme
--  setting for a way to override the values of these named colors.
--
--  == Defining colors ==
--
--  <programlisting language="text"> &commat;define-color bg_color
--  &num;f9a039;
--  * { background-color: &commat;bg_color; } </programlisting>
--
--  == Symbolic colors ==
--
--  Besides being able to define color names, the CSS parser is also able to
--  read different color expressions, which can also be nested, providing a
--  rich language to define colors which are derived from a set of base colors.
--
--  == Using symbolic colors ==
--
--  <programlisting language="text"> &commat;define-color entry-color shade
--  (&commat;bg_color, 0.7);
--  GtkEntry { background-color: Entry-color; }
--
--  GtkEntry:focused { background-color: mix (&commat;entry-color, shade
--  (&num;fff, 0.5), 0.8); } </programlisting>
--
--  The various ways to express colors in GTK+ CSS are:
--
--  <thead>
--  Syntax
--
--  Explanation
--
--  Examples
--
--  </thead>
--  rgb(R, G, B)
--
--  An opaque color; R, G, B can be either integers between 0 and 255 or
--  percentages
--
--  <literallayout>rgb(128, 10, 54) rgb(20%, 30%, 0%)</literallayout>
--  rgba(R, G, B, A)
--
--  A translucent color; R, G, B are as in the previous row, A is a floating
--  point number between 0 and 1
--
--  <literallayout>rgba(255, 255, 0, 0.5)</literallayout>
--  &num;Xxyyzz
--
--  An opaque color; Xx, Yy, Zz are hexadecimal numbers specifying R, G, B
--  variants with between 1 and 4 hexadecimal digits per component are allowed
--
--  <literallayout>&num;ff12ab &num;f0c</literallayout>
--  &commat;name
--
--  Reference to a color that has been defined with &commat;define-color
--
--  &commat;bg_color
--
--  mix(Color1, Color2, F)
--
--  A linear combination of Color1 and Color2. F is a floating point number
--  between 0 and 1.
--
--  <literallayout>mix(&num;ff1e0a, &commat;bg_color, 0.8)</literallayout>
--  shade(Color, F)
--
--  A lighter or darker variant of Color. F is a floating point number.
--
--  shade(&commat;fg_color, 0.5)
--
--  lighter(Color)
--
--  A lighter variant of Color
--
--  darker(Color)
--
--  A darker variant of Color
--
--  == Gradients ==
--
--  Linear or radial Gradients can be used as background images.
--
--  A linear gradient along the line from (Start_X, Start_Y) to (End_X, End_Y)
--  is specified using the syntax <literallayout>-gtk-gradient (linear, Start_X
--  Start_Y, End_X End_Y, color-stop (Position, Color), ...)</literallayout>
--  where Start_X and End_X can be either a floating point number between 0 and
--  1 or one of the special values 'left', 'right' or 'center', Start_Y and
--  End_Y can be either a floating point number between 0 and 1 or one of the
--  special values 'top', 'bottom' or 'center', Position is a floating point
--  number between 0 and 1 and Color is a color expression (see above). The
--  color-stop can be repeated multiple times to add more than one color stop.
--  'from (Color)' and 'to (Color)' can be used as abbreviations for color
--  stops with position 0 and 1, respectively.
--
--  == A linear gradient ==
--
--  <inlinegraphic fileref="gradient1.png" format="PNG"/>
--  This gradient was specified with <literallayout>-gtk-gradient (linear,
--  left top, right bottom, from(&commat;yellow),
--  to(&commat;blue))</literallayout>
--
--  == Another linear gradient ==
--
--  <inlinegraphic fileref="gradient2.png" format="PNG"/>
--  This gradient was specified with <literallayout>-gtk-gradient (linear, 0
--  0, 0 1, color-stop(0, &commat;yellow), color-stop(0.2, &commat;blue),
--  color-stop(1, &num;0f0))</literallayout>
--
--  A radial gradient along the two circles defined by (Start_X, Start_Y,
--  Start_Radius) and (End_X, End_Y, End_Radius) is specified using the syntax
--  <literallayout>-gtk-gradient (radial, Start_X Start_Y, Start_Radius, End_X
--  End_Y, End_Radius, color-stop (Position, Color), ...)</literallayout> where
--  Start_Radius and End_Radius are floating point numbers and the other
--  parameters are as before.
--
--  == A radial gradient ==
--
--  <inlinegraphic fileref="gradient3.png" format="PNG"/>
--  This gradient was specified with <literallayout>-gtk-gradient (radial,
--  center center, 0, center center, 1, from(&commat;yellow),
--  to(&commat;green))</literallayout>
--
--  == Another radial gradient ==
--
--  <inlinegraphic fileref="gradient4.png" format="PNG"/>
--  This gradient was specified with <literallayout>-gtk-gradient (radial, 0.4
--  0.4, 0.1, 0.6 0.6, 0.7, color-stop (0, &num;f00), color-stop (0.1,
--  &num;a0f), color-stop (0.2, &commat;yellow), color-stop (1,
--  &commat;green))</literallayout>
--
--  == Text shadow ==
--
--  A shadow list can be applied to text or symbolic icons, using the CSS3
--  text-shadow syntax, as defined in <ulink
--  url="http://www.w3.org/TR/css3-text/text-shadow">the CSS3
--  specification</ulink>.
--
--  A text shadow is specified using the syntax <literallayout>text-shadow:
--  Horizontal_Offset Vertical_Offset [ Blur_Radius ] Color</literallayout> The
--  offset of the shadow is specified with the Horizontal_Offset and
--  Vertical_Offset parameters. The optional blur radius is parsed, but it is
--  currently not rendered by the GTK+ theming engine.
--
--  To set multiple shadows on an element, you can specify a comma-separated
--  list of shadow elements in the text-shadow property. Shadows are always
--  rendered front-back, i.e. the first shadow specified is on top of the
--  others. Shadows can thus overlay each other, but they can never overlay the
--  text itself, which is always rendered on top of the shadow layer.
--
--  == Box shadow ==
--
--  Themes can apply shadows on framed elements using the CSS3 box-shadow
--  syntax, as defined in <ulink
--  url="http://www.w3.org/TR/css3-background/the-box-shadow">the CSS3
--  specification</ulink>.
--
--  A box shadow is specified using the syntax <literallayout>box-shadow: [
--  Inset ] Horizontal_Offset Vertical_Offset [ Blur_Radius ] [ Spread ]
--  Color</literallayout> A positive offset will draw a shadow that is offset
--  to the right (down) of the box, a negative offset to the left (top). The
--  optional spread parameter defines an additional distance to expand the
--  shadow shape in all directions, by the specified radius. The optional blur
--  radius parameter is parsed, but it is currently not rendered by the GTK+
--  theming engine. The inset parameter defines whether the drop shadow should
--  be rendered inside or outside the box canvas. Only inset box-shadows are
--  currently supported by the GTK+ theming engine, non-inset elements are
--  currently ignored.
--
--  To set multiple box-shadows on an element, you can specify a
--  comma-separated list of shadow elements in the box-shadow property. Shadows
--  are always rendered front-back, i.e. the first shadow specified is on top
--  of the others, so they may overlap other boxes or other shadows.
--
--  == Border images ==
--
--  Images and gradients can also be used in slices for the purpose of
--  creating scalable borders. For more information, see the CSS3 documentation
--  for the border-image property, which can be found <ulink
--  url="http://www.w3.org/TR/css3-background/border-images">here</ulink>.
--
--  <inlinegraphic fileref="slices.png" format="PNG"/>
--  The parameters of the slicing process are controlled by four separate
--  properties. Note that you can use the
--  <literallayout>border-image</literallayout> shorthand property to set
--  values for the three properties at the same time.
--
--  <literallayout>border-image-source: url(Path) (or border-image-source:
--  -gtk-gradient(...))</literallayout>: Specifies the source of the border
--  image, and it can either be an URL or a gradient (see above).
--  <literallayout>border-image-slice: Top Right Bottom Left</literallayout>
--  The sizes specified by the Top, Right, Bottom and Left parameters are the
--  offsets, in pixels, from the relevant edge where the image should be "cut
--  off" to build the slices used for the rendering of the border.
--  <literallayout>border-image-width: Top Right Bottom Left</literallayout>
--  The sizes specified by the Top, Right, Bottom and Left parameters are
--  inward distances from the border box edge, used to specify the rendered
--  size of each slice determined by border-image-slice. If this property is
--  not specified, the values of border-width will be used as a fallback.
--  <literallayout>border-image-repeat: [stretch|repeat|round|space] ?
--  [stretch|repeat|round|space]</literallayout> Specifies how the image slices
--  should be rendered in the area outlined by border-width. The default
--  (stretch) is to resize the slice to fill in the whole allocated area. If
--  the value of this property is 'repeat', the image slice will be tiled to
--  fill the area. If the value of this property is 'round', the image slice
--  will be tiled to fill the area, and scaled to fit it exactly a whole number
--  of times. If the value of this property is 'space', the image slice will be
--  tiled to fill the area, and if it doesn't fit it exactly a whole number of
--  times, the extra space is distributed as padding around the slices. If two
--  options are specified, the first one affects the horizontal behaviour and
--  the second one the vertical behaviour. If only one option is specified, it
--  affects both.
--  == A border image ==
--
--  <inlinegraphic fileref="border1.png" format="PNG"/>
--  This border image was specified with <literallayout>url("gradient1.png")
--  10 10 10 10</literallayout>
--
--  == A repeating border image ==
--
--  <inlinegraphic fileref="border2.png" format="PNG"/>
--  This border image was specified with <literallayout>url("gradient1.png")
--  10 10 10 10 repeat</literallayout>
--
--  == A stretched border image ==
--
--  <inlinegraphic fileref="border3.png" format="PNG"/>
--  This border image was specified with <literallayout>url("gradient1.png")
--  10 10 10 10 stretch</literallayout>
--
--  Styles can specify transitions that will be used to create a gradual
--  change in the appearance when a widget state changes. The following syntax
--  is used to specify transitions: <literallayout>Duration [s|ms]
--  [linear|ease|ease-in|ease-out|ease-in-out] [loop]?</literallayout> The
--  Duration is the amount of time that the animation will take for a complete
--  cycle from start to end. If the loop option is given, the animation will be
--  repated until the state changes again. The option after the duration
--  determines the transition function from a small set of predefined
--  functions. <figure>
--
--  == Linear transition ==
--
--  <graphic fileref="linear.png" format="PNG"/> </figure> <figure>
--  == Ease transition ==
--
--  <graphic fileref="ease.png" format="PNG"/> </figure> <figure>
--  == Ease-in-out transition ==
--
--  <graphic fileref="ease-in-out.png" format="PNG"/> </figure> <figure>
--  == Ease-in transition ==
--
--  <graphic fileref="ease-in.png" format="PNG"/> </figure> <figure>
--  == Ease-out transition ==
--
--  <graphic fileref="ease-out.png" format="PNG"/> </figure>
--  == Supported properties ==
--
--  Properties are the part that differ the most to common CSS, not all
--  properties are supported (some are planned to be supported eventually, some
--  others are meaningless or don't map intuitively in a widget based
--  environment).
--
--  The currently supported properties are:
--
--  <thead>
--  Property name
--
--  Syntax
--
--  Maps to
--
--  Examples
--
--  </thead>
--  engine
--
--  engine-name
--
--  Gtk.Theming_Engine.Gtk_Theming_Engine
--
--  engine: clearlooks; engine: none; /* use the default (i.e. builtin)
--  engine) */
--
--  background-color <entry morerows="2">color (see above) <entry
--  morerows="7">Gdk.RGBA.Gdk_RGBA <entry
--  morerows="7"><literallayout>background-color: &num;fff; color: &amp;color1;
--  background-color: shade (&amp;color1, 0.5); color: mix (&amp;color1,
--  &num;f0f, 0.8);</literallayout>
--
--  color
--
--  border-top-color <entry morerows="4">transparent|color (see above)
--
--  border-right-color
--
--  border-bottom-color
--
--  border-left-color
--
--  border-color
--
--  [transparent|color]{1,4}
--
--  font-family
--
--  Family [, Family]*
--
--  gchararray
--
--  font-family: Sans, Arial;
--
--  font-style
--
--  [normal|oblique|italic]
--
--  PANGO_TYPE_STYLE
--
--  font-style: italic;
--
--  font-variant
--
--  [normal|small-caps]
--
--  PANGO_TYPE_VARIANT
--
--  font-variant: normal;
--
--  font-weight
--
--  [normal|bold|bolder|lighter|100|200|300|400|500|600|700|800|900]
--
--  PANGO_TYPE_WEIGHT
--
--  font-weight: bold;
--
--  font-size
--
--  Font size in point
--
--  Gint
--
--  font-size: 13;
--
--  font
--
--  Family [Style] [Size]
--
--  Pango.Font_Description.Pango_Font_Description
--
--  font: Sans 15;
--
--  margin-top
--
--  integer
--
--  Gint
--
--  margin-top: 0;
--
--  margin-left
--
--  integer
--
--  Gint
--
--  margin-left: 1;
--
--  margin-bottom
--
--  integer
--
--  Gint
--
--  margin-bottom: 2;
--
--  margin-right
--
--  integer
--
--  Gint
--
--  margin-right: 4;
--
--  margin <entry morerows="1"><literallayout>Width Vertical_Width
--  Horizontal_Width Top_Width Horizontal_Width Bottom_Width Top_Width
--  Right_Width Bottom_Width Left_Width</literallayout>
--
--  <entry morerows="1">Gtk.Style.Gtk_Border <entry
--  morerows="1"><literallayout>margin: 5; margin: 5 10; margin: 5 10 3;
--  margin: 5 10 3 5;</literallayout>
--  padding-top
--
--  integer
--
--  Gint
--
--  padding-top: 5;
--
--  padding-left
--
--  integer
--
--  Gint
--
--  padding-left: 5;
--
--  padding-bottom
--
--  integer
--
--  Gint
--
--  padding-bottom: 5;
--
--  padding-right
--
--  integer
--
--  Gint
--
--  padding-right: 5;
--
--  padding
--
--  background-image
--
--  <literallayout>gradient (see above) or url(Path)</literallayout>
--  cairo_pattern_t
--
--  <literallayout>-gtk-gradient (linear, left top, right top, from
--  (&num;fff), to (&num;000)); -gtk-gradient (linear, 0.0 0.5, 0.5 1.0, from
--  (&num;fff), color-stop (0.5, &num;f00), to (&num;000)); -gtk-gradient
--  (radial, center center, 0.2, center center, 0.8, color-stop (0.0,
--  &num;fff), color-stop (1.0, &num;000)); url
--  ('background.png');</literallayout>
--  border-top-width
--
--  integer
--
--  Gint
--
--  border-top-width: 5;
--
--  border-left-width
--
--  integer
--
--  Gint
--
--  border-left-width: 5;
--
--  border-bottom-width
--
--  integer
--
--  Gint
--
--  border-bottom-width: 5;
--
--  border-right-width
--
--  integer
--
--  Gint
--
--  border-right-width: 5;
--
--  border-width <entry morerows="1">Gtk.Style.Gtk_Border <entry
--  morerows="1"><literallayout>border-width: 1; border-width: 1 2;
--  border-width: 1 2 3; border-width: 1 2 3 5;</literallayout>
--
--  border-radius
--
--  integer
--
--  Gint
--
--  border-radius: 5;
--
--  border-style
--
--  [none|solid|inset|outset]
--
--  Gtk_Border_Style
--
--  border-style: solid;
--
--  border-image
--
--  <literallayout>border image (see above)</literallayout>
--  internal use only
--
--  <literallayout>border-image: url("/path/to/image.png") 3 4 3 4 stretch;
--  border-image: url("/path/to/image.png") 3 4 4 3 repeat
--  stretch;</literallayout>
--  text-shadow
--
--  shadow list (see above)
--
--  Gtk_Text_Shadow
--
--  <literallayout>text-shadow: 1 1 0 blue, -4 -4 red;</literallayout>
--  transition
--
--  transition (see above)
--
--  internal use only
--
--  <literallayout>transition: 150ms ease-in-out; transition: 1s linear
--  loop;</literallayout>
--  gtk-key-bindings
--
--  binding set name list
--
--  internal use only
--
--  <literallayout>gtk-bindings: binding1, binding2, ...;</literallayout>
--  GtkThemingEngines can register their own, engine-specific style properties
--  with the function gtk_theming_engine_register_property. These properties
--  can be set in CSS like other properties, using a name of the form
--  <literallayout>-<replaceable>namespace</replaceable>-<replaceable>name</replaceable></literallayout>,
--  where <replaceable>namespace</replaceable> is typically the name of the
--  theming engine, and <replaceable>name</replaceable> is the name of the
--  property. Style properties that have been registered by widgets using
--  gtk_widget_class_install_style_property can also be set in this way, using
--  the widget class name for <replaceable>namespace</replaceable>.
--
--  == Using engine-specific style properties ==
--
--    * {
--       engine: clearlooks;
--       border-radius: 4;
--       -GtkPaned-handle-size: 6;
--       -clearlooks-colorize-scrollbar: false;
--    }
--
--
--  </description>

pragma Warnings (Off, "*is already use-visible*");
with Glib;               use Glib;
with Glib.Error;         use Glib.Error;
with Glib.Object;        use Glib.Object;
with Glib.Types;         use Glib.Types;
with Glib.Values;        use Glib.Values;
with Gtk.Enums;          use Gtk.Enums;
with Gtk.Icon_Factory;   use Gtk.Icon_Factory;
with Gtk.Style_Provider; use Gtk.Style_Provider;
with Gtk.Widget;         use Gtk.Widget;

package Gtk.Css_Provider is

   type Gtk_Css_Provider_Record is new GObject_Record with null record;
   type Gtk_Css_Provider is access all Gtk_Css_Provider_Record'Class;

   ------------------
   -- Constructors --
   ------------------

   procedure Gtk_New (Self : out Gtk_Css_Provider);
   --  Returns a newly created Gtk.Css_Provider.Gtk_Css_Provider.

   procedure Initialize
      (Self : not null access Gtk_Css_Provider_Record'Class);
   --  Returns a newly created Gtk.Css_Provider.Gtk_Css_Provider.

   function Get_Type return Glib.GType;
   pragma Import (C, Get_Type, "gtk_css_provider_get_type");

   -------------
   -- Methods --
   -------------

   function Load_From_Data
      (Self   : not null access Gtk_Css_Provider_Record;
       Data   : UTF8_String;
       Length : Gint := -1) return Boolean;
   --  Loads Data into Css_Provider, making it clear any previously loaded
   --  information.
   --  "data": CSS data loaded in memory
   --  "length": the length of Data in bytes, or -1 for NUL terminated
   --  strings. If Length is not -1, the code will assume it is not NUL
   --  terminated and will potentially do a copy.

   function Load_From_Path
      (Self  : not null access Gtk_Css_Provider_Record;
       Path  : UTF8_String;
       Error : access Glib.Error.GError) return Boolean;
   --  Loads the data contained in Path into Css_Provider, making it clear any
   --  previously loaded information.
   --  "path": the path of a filename to load, in the GLib filename encoding

   function To_String
      (Self : not null access Gtk_Css_Provider_Record) return UTF8_String;
   --  Convertes the Provider into a string representation in CSS format.
   --  Using Gtk.Css_Provider.Load_From_Data with the return value from this
   --  function on a new provider created with Gtk.Css_Provider.Gtk_New will
   --  basicallu create a duplicate of this Provider.

   ---------------------------------------------
   -- Inherited subprograms (from interfaces) --
   ---------------------------------------------

   function Get_Icon_Factory
      (Self : not null access Gtk_Css_Provider_Record;
       Path : Gtk.Widget.Gtk_Widget_Path)
       return Gtk.Icon_Factory.Gtk_Icon_Factory;

   procedure Get_Style_Property
      (Self  : not null access Gtk_Css_Provider_Record;
       Path  : Gtk.Widget.Gtk_Widget_Path;
       State : Gtk.Enums.Gtk_State_Flags;
       Pspec : in out Glib.Param_Spec;
       Value : out Glib.Values.GValue;
       Found : out Boolean);

   ----------------
   -- Interfaces --
   ----------------
   --  This class implements several interfaces. See Glib.Types
   --
   --  - "StyleProvider"

   package Implements_Gtk_Style_Provider is new Glib.Types.Implements
     (Gtk.Style_Provider.Gtk_Style_Provider, Gtk_Css_Provider_Record, Gtk_Css_Provider);
   function "+"
     (Widget : access Gtk_Css_Provider_Record'Class)
   return Gtk.Style_Provider.Gtk_Style_Provider
   renames Implements_Gtk_Style_Provider.To_Interface;
   function "-"
     (Interf : Gtk.Style_Provider.Gtk_Style_Provider)
   return Gtk_Css_Provider
   renames Implements_Gtk_Style_Provider.To_Object;

   ---------------
   -- Functions --
   ---------------

   function Get_Default return Gtk_Css_Provider;
   --  Returns the provider containing the style settings used as a fallback
   --  for all widgets.
   --  This memory is owned by GTK+, and you must not free it.

   function Get_Named
      (Name    : UTF8_String;
       Variant : UTF8_String := "") return Gtk_Css_Provider;
   --  Loads a theme from the usual theme paths
   --  This memory is owned by GTK+, and you must not free it.
   --  "name": A theme name
   --  "variant": variant to load, for example, "dark", or null for the
   --  default

   -------------
   -- Signals --
   -------------
   --  The following new signals are defined for this widget:
   --
   --  "parsing-error"
   --     procedure Handler
   --       (Self    : access Gtk_Css_Provider_Record'Class;
   --        Section : Gtk.Css_Section.Gtk_Css_Section;
   --        Error   : GLib.Error);
   --    --  "section": section the error happened in
   --    --  "error": The parsing error
   --  Signals that a parsing error occured. the Path, Line and Position
   --  describe the actual location of the error as accurately as possible.
   --
   --  Parsing errors are never fatal, so the parsing will resume after the
   --  error. Errors may however cause parts of the given data or even all of
   --  it to not be parsed at all. So it is a useful idea to check that the
   --  parsing succeeds by connecting to this signal.
   --
   --  Note that this signal may be emitted at any time as the css provider
   --  may opt to defer parsing parts or all of the input to a later time than
   --  when a loading function was called.

   Signal_Parsing_Error : constant Glib.Signal_Name := "parsing-error";

end Gtk.Css_Provider;
