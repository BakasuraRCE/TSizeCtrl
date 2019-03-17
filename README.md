# TSizeCtrl
Non-visual Delphi component to enable runtime moving and resizing of controls.

# Author: Angus Johnson
http://angusj.com/delphi/

http://angusj.com/delphi/sizectrl.html

# Tested on:
Delphi 3, 4, 5, 6, 7, 10.1 Berlin, 10.2 Tokyo

# Version:
7.2 - 3 September 2006

## BASIC USAGE:
1. Add a TSizeCtrl component (SizeCtrl1) to your form.
2. Set SizeCtrl1 properties (button colors etc) as desired.
3. Assign event methods (start, during & end size/move events) as desired.
4. In the form's OnCreate method, SizeCtrl1.RegisterControl() all possible targets.
5. In an assigned menuitem method, toggle the SizeCtrl1.Enabled property.
6. Once enabled:
     * Click or Tab to select targets.
     * Hold the Shift key down to select multiple targets.
     * Resize targets by click & dragging a target's resize buttons or by holding the Shift key down while use the arrow keys.
     * Move controls by click & dragging a target or by using the arrow keys.

## MISCELLANEOUS NOTES:
Capturing the WM_SETCURSOR messages of Listview headers requires hooking the header's message handler too. I don't think this minor improvement in cursor management justifies the considerable extra programming effort.
