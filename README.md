# TSizeCtrl
Non-visual Delphi component to enable runtime moving and resizing of controls.

## Original author: Angus Johnson
http://angusj.com/delphi/

http://angusj.com/delphi/sizectrl.html

## Tested on:
Delphi 3, 4, 5, 6, 7, 10.1 Berlin, 10.2 Tokyo

## Version:
This is a fork since the last version of the author (7.2 - 3 September 2006)

## TSizeCtrl Component Screenshots:

### Sizing:
![sizectrl_1](https://user-images.githubusercontent.com/26231582/54495198-9c5db200-48d9-11e9-80a5-c484ee7b0749.png) ![sizectrl_2](https://user-images.githubusercontent.com/26231582/54495202-abdcfb00-48d9-11e9-96cb-4b3d33730ccd.png)

### Moving:
![sizectrl_3](https://user-images.githubusercontent.com/26231582/54495211-c1522500-48d9-11e9-843a-3ec0083aeae6.png) ![sizectrl_4](https://user-images.githubusercontent.com/26231582/54495210-c0b98e80-48d9-11e9-8147-b01c402814e2.png)

### Aligned Controls have disabled "grab button" handles along fixed borders:
![sizectrl_7](https://user-images.githubusercontent.com/26231582/54495216-d2029b00-48d9-11e9-8772-bb429591bddc.png)

### Multiple controls can be moved or resized together:
![sizectrl_5](https://user-images.githubusercontent.com/26231582/54495219-dcbd3000-48d9-11e9-99e7-ed1cf485636a.png) ![sizectrl_6](https://user-images.githubusercontent.com/26231582/54495218-dc249980-48d9-11e9-9726-fd9162f51098.png)

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
