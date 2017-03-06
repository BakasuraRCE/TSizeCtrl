unit main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, SizeControl, ExtCtrls, ComCtrls, StdCtrls, Menus, CommCtrl;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    EnableSizeControl1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    cbSizeMove: TCheckBox;
    Label2: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Edit1: TEdit;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Panel2: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    ComboBox1: TComboBox;
    Panel1: TPanel;
    ListView1: TListView;
    StatusBar1: TStatusBar;
    Label4: TLabel;
    TabSheet2: TTabSheet;
    CheckBox1: TCheckBox;
    Label5: TLabel;
    Button1: TButton;
    PopupMenu2: TPopupMenu;
    MenuItem1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure EnableSizeControl1Click(Sender: TObject);
    procedure cbSizeMoveClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
  private
    SizeCtrl: TSizeCtrl;
    procedure SizeCtrlDuring(Sender: TObject; dx, dy: integer; State: TSCState);
    procedure SizeCtrlEnd(Sender: TObject; State: TSCState);
    procedure SizeCtrlTargetChange(Sender: TObject);
    procedure SizeCtrlMouseDown(Sender: TObject;
      Target: TControl; TargetPt: TPoint; var handled: boolean);
    procedure SizeCtrlSetCursor(Sender: TObject;
      Target: TControl; TargetPt: TPoint; var handled: boolean);
    procedure SizeCtrlKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  GRIDSIZE: integer = 10; //try changing this too.

implementation

{$R *.dfm}

//RegComponents: A simple recursive procedure which registers with SizeCtrl1
//all the visible controls contained by aParent except 'tagged' controls ...
procedure RegComponents(aParent: TWinControl; SizeCtrl: TSizeCtrl);
var
  i: integer;
begin
  for i := 0 to aParent.ControlCount -1 do
  begin
    //In this demo, Tag <> 0 prevents a control becoming a SizeCtrl target ...
    if aParent.Controls[i].Tag = 0 then
      SizeCtrl.RegisterControl(aParent.Controls[i]);
    if aParent.Controls[i] is TWinControl then
      RegComponents(TWinControl(aParent.Controls[i]), SizeCtrl);
  end;
end;
//------------------------------------------------------------------------------

procedure UnregComponents(aParent: TWinControl; SizeCtrl: TSizeCtrl);
var
  i: integer;
begin
  for i := 0 to aParent.ControlCount -1 do
  begin
    SizeCtrl.UnRegisterControl(aParent.Controls[i]);
    if aParent.Controls[i] is TWinControl then
      UnregComponents(TWinControl(aParent.Controls[i]), SizeCtrl);
  end;
end;
//------------------------------------------------------------------------------

procedure TForm1.FormCreate(Sender: TObject);
begin
  //All of this would normally be done in the IDE's Object Inspector
  //if SizeCtrl was installed into the IDE.
  SizeCtrl := TSizeCtrl.Create(self);
  SizeCtrl.OnTargetChange := SizeCtrlTargetChange;
  SizeCtrl.OnDuringSizeMove := SizeCtrlDuring;
  SizeCtrl.OnEndSizeMove := SizeCtrlEnd;
  SizeCtrl.GridSize := GRIDSIZE;
  SizeCtrl.PopupMenu := PopupMenu2;
  //to override behaviour of Pagecontrols so new pages can be selected ...
  SizeCtrl.OnMouseDown := SizeCtrlMouseDown;
  SizeCtrl.OnSetCursor := SizeCtrlSetCursor;
  SizeCtrl.OnKeyDown := SizeCtrlKeyDown;

  RegComponents(self, SizeCtrl);
  SizeCtrl.Enabled := true;

  //ALSO, TRY OUT EACH OF THESE OPTIONS ...
  SizeCtrl.BtnColor := $CC;
  //SizeCtrl.MultiTargetResize := false;
  //SizeCtrl.MoveOnly := true;
end;
//------------------------------------------------------------------------------

procedure TForm1.FormDestroy(Sender: TObject);
begin
  //it's important to disable SizeCtrl before destroying the form
  //because any SizeCtrl registered controls need to be 'unhooked' ...
  SizeCtrl.Enabled := false;
end;
//------------------------------------------------------------------------------

procedure TForm1.Exit1Click(Sender: TObject);
begin
  close;
end;
//------------------------------------------------------------------------------

procedure TForm1.EnableSizeControl1Click(Sender: TObject);
begin
  cbSizeMove.Checked := not cbSizeMove.Checked;
end;
//------------------------------------------------------------------------------

procedure TForm1.cbSizeMoveClick(Sender: TObject);
begin
  SizeCtrl.Enabled := cbSizeMove.Checked;
  EnableSizeControl1.Checked := cbSizeMove.Checked;

  //Now, just in case the visible controls have changed (ie a new Tabsheet was
  //made visible) while SizeCtrl was disabled ...
  if cbSizeMove.Checked then
  begin
    //make sure the right controls on the PageControl are registered ...
    UnRegComponents(PageControl1, SizeCtrl);
    RegComponents(PageControl1, SizeCtrl);
  end;
  ActiveControl := nil;
  invalidate; //fixup grid painting on the form
end;
//------------------------------------------------------------------------------

procedure TForm1.FormResize(Sender: TObject);
begin
  //if SizeCtrl has targets selected, and they are moved or resized
  //independently of SizeCtrl, then SizeCtrl must be 'updated' ...
  SizeCtrl.Update;
end;

//------------------------------------------------------------------------------
// Pretty much everything below demonstrates optional features .
//------------------------------------------------------------------------------


//Button1Click() demonstrates that OnClick events of SizeCtrl 'registered'
//controls are disabled when SizeCtrl is enabled.

//(nb: This doesn't work in Delphi 3 so OnClick events would have to be
//blocked manually to prevent Alt+Key shortcuts responding).
procedure TForm1.Button1Click(Sender: TObject);
begin
  ShowMessage('Button1 pressed.');
end;
//------------------------------------------------------------------------------

//Paints a grid on the form (if GRIDSIZE > 1) ...
procedure TForm1.FormPaint(Sender: TObject);
var
  i,j: integer;
begin
  if (GRIDSIZE > 1) and SizeCtrl.Enabled then
    for i := 0 to width div GRIDSIZE do
      for j := 0 to height div GRIDSIZE do
        canvas.Pixels[i*GRIDSIZE, j*GRIDSIZE] := clGray;
end;

//------------------------------------------------------------------------------
// Give some basic feedback as to Size/Move changes ...
// (nb: While this demo only displays one target's properties, there may be
// any number of targets.)
//------------------------------------------------------------------------------

//1. Whenever a target changes ...
procedure TForm1.SizeCtrlTargetChange(Sender: TObject);
begin
  if SizeCtrl.TargetCount = 0 then
    StatusBar1.SimpleText := ''
  else with SizeCtrl.Targets[0] do StatusBar1.SimpleText :=
    format('  %s -  left:%d  top:%d, width:%d  height:%d',
      [Name,left,top,width,height]);
end;
//------------------------------------------------------------------------------

//2. During target resizing or moving ...
procedure TForm1.SizeCtrlDuring(Sender: TObject; dx,dy: integer; State: TSCState);
begin
  with SizeCtrl.Targets[0] do
    if State = scsMoving then
      StatusBar1.SimpleText := format('  %s -  left:%d  top:%d, width:%d  height:%d',
        [Name, left+dx, top+dy, width, height])
    else {State = scsSizing}
      StatusBar1.SimpleText := format('  %s -  left:%d  top:%d, width:%d  height:%d',
        [Name,left, top, width+dx, height+dy]);
end;
//------------------------------------------------------------------------------

//3. Once target resizing or moving has finished ...
procedure TForm1.SizeCtrlEnd(Sender: TObject; State: TSCState);
begin
  with SizeCtrl do
    if TargetCount = 0 then StatusBar1.SimpleText := ''
    else with Targets[0] do StatusBar1.SimpleText :=
      format('  %s -  left:%d  top:%d, width:%d  height:%d',
        [Name,left,top,width,height]);
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

//The TPageControl.IndexOfTabAt() method is not available in older Delphi
//compilers. Therefore, I've included the following function
//so this demo works all the way back to Delphi 3 ...

function My_IndexOfTabAt(PageControl: TPageControl; X, Y: Integer): Integer;
var
  HitTest: TTCHitTestInfo;
begin
  Result := -1;
  if PtInRect(PageControl.ClientRect, Point(X, Y)) then
    with HitTest do
    begin
      pt.X := X;
      pt.Y := Y;
{$WARNINGS OFF}
      Result := SendMessage(PageControl.Handle, TCM_HITTEST, 0, LPARAM(@HitTest));
{$WARNINGS ON}
    end;
end;

//------------------------------------------------------------------------------

procedure TForm1.SizeCtrlMouseDown(Sender: TObject;
  Target: TControl; TargetPt: TPoint; var handled: boolean);
var
  i: integer;
begin
  //When clicking the PageControl, it's kind of nice to be able to change pages.
  //So, let's see if a new page needs to be displayed ...
  if (Target is TPageControl) then
    with TPageControl(Target) do
    begin

      //We need the PageIndex of the tab being clicked. The following line
      //is fine in Delphi 7 but isn't available with older compilers ...
      //    with TargetPt do i := PageControl1.IndexOfTabAt(X, Y);
      //Therefore, this is my workaround which works back to Delphi 3 ...
      with TargetPt do i := My_IndexOfTabAt(TPageControl(Target), X, Y);

      if (i >= 0) and ( ActivePage.PageIndex <> i) then
      begin
        //since further mouse handling stuff is not required ...
        handled := true;
        //Unregister from SizeCtrl all controls on the current page ...
        UnregComponents(PageControl1, SizeCtrl);
        //select the new page ...
        ActivePage := Pages[i];
        //finally, register controls on the new page...
        RegComponents(PageControl1, SizeCtrl);
      end;
    end;
end;
//------------------------------------------------------------------------------

procedure TForm1.SizeCtrlSetCursor(Sender: TObject;
  Target: TControl; TargetPt: TPoint; var handled: boolean);
var
  i: integer;
begin
  //when clicking the PageControl, it's kind of nice to show an appropriate
  //cursor if we're clicking a new tab ...
  if (Target is TPageControl) then
    with TPageControl(Target) do
    begin
      with TargetPt do i := My_IndexOfTabAt(TPageControl(Target), X, Y);
      if (i >= 0) and (ActivePage.PageIndex <> i) then
      begin
        //OK, we'll manage things from here ...
        handled := true;
        //assign the cursor directly ...
        windows.SetCursor(screen.Cursors[crDefault]);
      end;
    end;
end;
//------------------------------------------------------------------------------

var
  popupMousePos: TPoint; //A workaround for older versions of Delphi (see below)

procedure TForm1.PopupMenu2Popup(Sender: TObject);
begin
  GetCursorPos(popupMousePos);
end;
//------------------------------------------------------------------------------

procedure TForm1.MenuItem1Click(Sender: TObject);
var
  ctrl: TControl;
begin
  //The following line doesn't compile with older versions of Delphi ...
  //    ctrl := SizeCtrl.TargetCtrlFromPt(PopupMenu2.PopupPoint);
  //because the TPopupMenu.PopupPoint method isn't defined.
  //Therefore, this demo uses a slightly more cumbersome route ...
  ctrl := SizeCtrl.TargetCtrlFromPt(popupMousePos);
  if not assigned(ctrl) then
    ShowMessage('oops!!!') else //should never happen!
    ShowMessage('You just clicked - '+ ctrl.Name);
end;
//------------------------------------------------------------------------------

procedure TForm1.SizeCtrlKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key > VK_HELP then beep;
end;
//------------------------------------------------------------------------------

end.
