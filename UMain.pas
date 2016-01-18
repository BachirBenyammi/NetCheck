unit UMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, DateUtils,
  ExtCtrls, StdCtrls, WinSock, WinINet, Registry, ComCtrls, ShellApi, Menus, Buttons,
  ActnList, ImgList;

Const
  WM_MYMESSAGE=WM_USER+100;

type
  TMainForm = class(TForm)
    TimerCheck: TTimer;
    Timer: TTimer;
    ImgConnect: TImage;
    ImgDisconnect: TImage;
    Tree: TTreeView;
    Popup: TPopupMenu;
    ActionList: TActionList;
    ActOpt: TAction;
    ActAuto: TAction;
    ActDisconnect: TAction;
    ActManual: TAction;
    ActClose: TAction;
    ActAbout: TAction;
    ActSHowHide: TAction;
    Page: TPageControl;
    TabCon: TTabSheet;
    TabSea: TTabSheet;
    GroupBox1: TGroupBox;
    BtnConnect: TBitBtn;
    BtnManual: TBitBtn;
    GBNow: TGroupBox;
    LabNowDay: TLabel;
    LabDays: TLabel;
    Label5: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    LabNowTime: TLabel;
    Label7: TLabel;
    LabEnable: TLabel;
    GBMonth: TGroupBox;
    Label9: TLabel;
    LabMonthCost: TLabel;
    DTPMonth: TDateTimePicker;
    GBDay: TGroupBox;
    Label6: TLabel;
    Label8: TLabel;
    LabDayCount: TLabel;
    LabDayTime: TLabel;
    LabDayCost: TLabel;
    Label13: TLabel;
    DTPDate: TDateTimePicker;
    List: TListView;
    Menu: TMainMenu;
    MFile: TMenuItem;
    MClose: TMenuItem;
    MTools: TMenuItem;
    Options1: TMenuItem;
    SMAuto: TMenuItem;
    SMDisconnect: TMenuItem;
    SMManual: TMenuItem;
    ML1: TMenuItem;
    MHide: TMenuItem;
    Searsh1: TMenuItem;
    TabOpt: TTabSheet;
    TabAbout: TTabSheet;
    ActConnection: TAction;
    ActSearsh: TAction;
    Connection1: TMenuItem;
    About1: TMenuItem;
    ActClear: TAction;
    PMClose: TMenuItem;
    GBOpt: TGroupBox;
    CBActive: TCheckBox;
    CBStart: TCheckBox;
    EditCost: TEdit;
    CBKind: TComboBox;
    Label17: TLabel;
    Label16: TLabel;
    BtnClear: TBitBtn;
    BtnOk: TBitBtn;
    GroupBox2: TGroupBox;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    ImageList1: TImageList;
    BtnDisconnect: TBitBtn;
    Label2: TLabel;
    LabState: TLabel;
    Label10: TLabel;
    LabStart: TLabel;
    Label3: TLabel;
    LabTime: TLabel;
    Label1: TLabel;
    LabFinish: TLabel;
    Label18: TLabel;
    LabPrice: TLabel;
    Label4: TLabel;
    LabCost: TLabel;
    Label14: TLabel;
    LabHost: TLabel;
    Label15: TLabel;
    LabIp: TLabel;
    MConnection: TMenuItem;
    MView: TMenuItem;
    PMTools: TMenuItem;
    PMConnection: TMenuItem;
    PSMAuto: TMenuItem;
    PSMDisconnect: TMenuItem;
    PSMManual: TMenuItem;
    PMView1: TMenuItem;
    Connection3: TMenuItem;
    Searsh3: TMenuItem;
    Options3: TMenuItem;
    About3: TMenuItem;
    PMShow: TMenuItem;
    PML1: TMenuItem;
    Label23: TLabel;
    procedure TimerCheckTimer(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DTPDateKeyPress(Sender: TObject; var Key: Char);
    procedure DTPMonthKeyPress(Sender: TObject; var Key: Char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActOptExecute(Sender: TObject);
    procedure ActAutoExecute(Sender: TObject);
    procedure ActDisconnectExecute(Sender: TObject);
    procedure ActManualExecute(Sender: TObject);
    procedure ActAboutExecute(Sender: TObject);
    procedure ActSHowHideExecute(Sender: TObject);
    procedure ActCloseExecute(Sender: TObject);
    procedure ActConnectionExecute(Sender: TObject);
    procedure ActSearshExecute(Sender: TObject);
    procedure ActClearExecute(Sender: TObject);
    procedure EditCostKeyPress(Sender: TObject; var Key: Char);
    procedure BtnOkClick(Sender: TObject);
    procedure PMCloseClick(Sender: TObject);
    procedure DTPMonthChange(Sender: TObject);
    procedure DTPDateChange(Sender: TObject);
    procedure PageChange(Sender: TObject);
    procedure Label20Click(Sender: TObject);
    procedure Label23Click(Sender: TObject);
Private
    Procedure Shearch;
    Procedure SaveUpDate( Const Value:Boolean);
    Procedure SaveStart;
    Procedure ReadWriteReg( Const Value:Boolean);
    Procedure AddToSysTray(Msg:String;Icon:TIcon);
    Procedure WMHotkey(Var msg:TWMHotkey);message WM_HOTKEY;
    procedure TrayMessage(var Msg:TMessage);message WM_MYMESSAGE;
    procedure WMEndSession(var Msg:TWMEndSession);message WM_ENDSESSION;
  end;

var
  MainForm: TMainForm;
  IconData : TNotifyIconData;
  Prix : Real = 1/60;
  Node : TTreeNode;
  Nodes : TTreeNodes;
  AutoHide : Boolean = True;
  OnLine : Boolean = False;
  FoundYear, FoundMonth, FoundDay : boolean;
  CurrentHost, CurrentIp, FilePath : String;

implementation

{$R *.DFM}

Function GetCount(Str:String;P:Real):String;
var
  h,m,s,w:word;
begin
   Decodetime(StrToTime(Str),h,m,s,w);
   Result:=Format('%f',[(H*3600+M*60+S)*p])
end;

Procedure TMainForm.ReadWriteReg( Const Value : Boolean);
var
  Reg : TRegistry;
 procedure AddRemoveStartUp( Const Value : Boolean);
 begin
   Reg := TRegistry.Create;
   Try
     Reg.RootKey := HKEY_LOCAL_MACHINE;
     if Reg.OpenKey('Software\Microsoft\Windows\CurrentVersion\Run', True) Then
       If Value Then
         Reg.WriteString(Application.Title,Application.ExeName)
       else Reg.DeleteValue(Application.Title)
   finally
     Reg.CloseKey;
     Reg.Free
   end
 end;
begin
  Reg:=TRegistry.Create;
  With Reg Do
    Try
      RootKey:=HKEY_LOCAL_MACHINE;
      If OpenKey('Software\BenBacApp\' + Application.Title+'\Options',True)Then
        If Value then
          Begin
            If(ValueExists('Active'))
              And(ValueExists('Startup'))
                  And(ValueExists('Cost'))
                   And(ValueExists('Kind'))Then
                     begin
                      CBActive.Checked:=ReadBool('Active');
                      CBStart.Checked:=ReadBool('Startup');
                      EditCost.Text:=FloatToStr(ReadFloat('Cost'));
                      CBKind.ItemIndex:=ReadInteger('Kind');
                     end;
          end
        else
          begin
            WriteBool('Active',CBActive.Checked);
            WriteBool('Startup',CBStart.Checked);
            WriteFloat('Cost',StrToFloat(EditCost.Text));
            WriteInteger('Kind',CBKind.ItemIndex);
            If TimerCheck.Enabled <> CBActive.Checked Then
              If OnLine Then
                If Not TimerCheck.Enabled Then
                  SaveStart
                else
                  SaveUpDate(True);
            Tree.SaveToFile(FilePath);
          end;
    Finally
      CloseKey;
      Free
    end;
  TimerCheck.Enabled:=CBActive.Checked;
  if not TimerCheck.Enabled Then
    begin
      OnLine:=False;
      LabEnable.Caption:='Disabled';
      LabStart.Caption:='00:00:00';
      LabTime.Caption:='00:00:00';
      LabFinish.Caption:='00:00:00';
      LabCost.Caption:='0.00';
      AddToSysTray(Application.Title,Application.Icon);
    end
  else
     LabEnable.Caption:='Enabled';
  AddRemoveStartUp(CBStart.Checked);
  Case CBKind.ItemIndex of
   0:Prix := StrToFloat(EditCost.Text) / 3600;
   1:Prix := StrToFloat(EditCost.Text) / 60;
   2:Prix := StrToFloat(EditCost.Text);
  end;
  LabPrice.Caption:=EditCost.Text+' DA/'+Copy(CBKind.Text,1,1);
end;

procedure TMainForm.DTPDateKeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#13 then
  DTPDateChange(Sender);
end;

procedure TMainForm.DTPMonthKeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#13 then
  DTPMonthChange(Sender);
end;

procedure TMainForm.WMEndSession( var  Msg: TWMEndSession);
var
   Reg: TRegistry;
begin
 Reg := TRegistry.Create;
  try
   Reg.RootKey := HKEY_CURRENT_USER;
   if  Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\RunOnce', True)  then
    begin
     Reg.WriteString(Application.Title,'"' + ParamStr(0) + '"');
     Reg.CloseKey;
    end ;
  finally
   Reg.Free;
   inherited ;
  end ;
end ;

procedure TMainForm.WMHotkey(Var msg:TWMHotkey);
Begin
  if msg.HotKey=1 then
    ActShowHideExecute(Nil)
end;

procedure TMainForm.TrayMessage(var Msg:TMessage);
 var Souris:TPoint;
begin
 if(Msg.LParam=WM_RBUTTONDOWN)then
  begin
   GetCursorPos(souris);
   SetForegroundWindow(Handle);
   Popup.Popup(souris.x,souris.y);
  end;
 if(Msg.LParam=WM_LBUTTONDBLCLK)then
   ActShowHideExecute(Nil)
end;

Procedure TMainForm.AddToSysTray(Msg:String;Icon:TIcon);
var
  I:byte;
begin
  with IconData do
    begin
      cbSize:=SizeOf(IconData);
      Wnd:=Handle;uID:=1;
      uFlags:=NIF_ICON or NIF_TIP or NIF_MESSAGE;
      uCallbackMessage:=WM_MYMESSAGE;
      hIcon:=Icon.Handle;
      for i:=0 to length(Msg)-1 do
       szTip[i]:=Msg[i+1];
      szTip[length(Msg)]:=#0;
      Shell_NotifyIcon(NIM_Modify,@IconData)
    end;
end;

procedure TMainForm.TimerCheckTimer(Sender: TObject);
type
 TaPInAddr = Array[0..10] of PInAddr;
 PaPInAddr = ^TaPInAddr;
var
 phe: PHostEnt;
 pptr: PaPInAddr;
 Buffer: Array[0..63] of Char;
 GInitData: TWSAData;
 OldState: Boolean;
 Buff,i: Integer;
 Reg:Treginifile;
begin
 WSAStartup($101, GInitData);
 GetHostName(Buffer, SizeOf(Buffer));
 phe := GetHostByName(buffer);
 CurrentHost := LowerCase(phe.h_name);
 if phe = nil then Exit;
 pPtr := PaPInAddr(phe^.h_addr_list);
 I := 0;
 while pPtr^[I] <> nil do
  begin
   CurrentIP := inet_ntoa(pptr^[I]^);
   Inc(I);
  end;
 WSACleanup;
 OldState := Online;
 Buff:=0;
 Reg:=Treginifile.Create('');
 Reg.RootKey:=HKEY_LOCAL_MACHINE;
 Reg.OpenKey('System\CurrentControlSet\Services\RemoteAccess',False);
 Reg.ReadBinaryData('Remote Connection',Buff, 16);
 Reg.CloseKey;
 Reg.Free;
 OnLine := Buff=1;
 Shearch;
 if (OldState <> OnLine) then
   begin
     if Online then
       SaveStart
     else
       SaveUpDate(True);
     Tree.SaveToFile(FilePath);
   end;
 If Online Then
  begin
   LabTime.Caption:=TimeToStr(StrToTime(LabTime.Caption)+StrToTime('00:00:01'));
   LabCost.Caption:=GetCount(LabTime.Caption,Prix);
   If SecondOf(StrToTime(LabTime.Caption))=0 then
    SaveUpDate(False)
  end;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
 Function GetTime:String;
  var GetCount:Cardinal;
 begin
  GetCount:=gettickcount;
  Result:=IntToStr(getCount div 86400000)+' Day(s), '
   +FormatDateTime('hh:mm',Encodetime((GetCount div 3600000)mod 24,
   (GetCount div 60000)mod 60,0,0))
 end;
begin
 LabNowDay.Caption:=FormatDateTime('dd-MM-yy',Now);
 LabNowTime.Caption:=FormatDateTime('hh:mm',Now);
 LabDays.Caption:=GetTime;
 LabIp.Caption:=CurrentIP;
 LabHost.Caption:=CurrentHost;
 case Online of
  True:
    begin
      LabState.Caption:='On Line';
    //  ActAuto.Enabled:=False;
     // ActManual.Enabled:=False;
     // ActDisconnect.Enabled:=True;
    end;
  False:
    begin
      LabState.Caption:='Off Line';
    //  ActAuto.Enabled:=True;
    //  ActManual.Enabled:=True;
    //  ActDisconnect.Enabled:=False;
    end;
 end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
 ShowWindow(Application.Handle,Sw_Hide);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_DELETE,@IconData);
  UnRegisterHotkey(Handle,1);
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  If MessageDlg('Send to Taskbar ?',MtConfirmation,
    [MbYes,MbNo],0)=MrYes Then
      begin
        CanClose:=False;
        ActShowHideExecute(Sender);
      end;
end;

Procedure TMainForm.Shearch;
Var
  i,j,k:integer;
begin
  FoundYear:=False;
  FoundMonth:=False;
  FoundDay:=False;
  Node:=nil;
  With Tree.Items do
    begin
      If Count>0 then
        For i:=0 to Tree.Items.Count - 1 do
          If Tree.Items[i].Text=IntToStr(YearOf(Now))then
            begin
              FoundYear:=True;
              Node:=Tree.Items[i];
              For j:=0 to Tree.Items[i].Count - 1 do
                If Tree.Items[i].Item[j].Text=IntToStr(MonthOf(Now))then
                  begin
                    FoundMonth:=True;
                    Node:=Tree.Items[i].Item[j];
                    For k:=0 to Tree.Items[i].Item[j].Count - 1 do
                      If Tree.Items[i].Item[j].Item[k].Text=IntToStr(DayOf(Now))then
                        begin
                          FoundDay:=True;
                          Node:=Tree.Items[i].Item[j].Item[k];
                          Break
                        end;
                    Break;
                  end;
              Break
            end;
    end;
end;

Procedure TMainForm.SaveStart;
begin
  LabStart.Caption:=FormatDateTime('hh:mm:ss',Now);
  AddToSysTray('You are connected since '+LabStart.Caption,ImgConnect.Picture.Icon);
  LabTime.Caption:='00:00:00';
  LabFinish.Caption:='00:00:00';
  LabCost.Caption:='0.00';
  With Tree.Items do
    Case FoundYear Of
      True:Case FoundMonth Of
             True:Case FoundDay of
                    True:
                      AddChild(Node,LabStart.Caption);
                    False:
                      begin
                        Node:=AddChild(Node,IntToStr(DayOf(Now)));
                        AddChild(Node,LabStart.Caption)
                      end;
                  end;
             False:
               begin
                 Node:=AddChild(Node,IntToStr(MonthOf(Now)));
                 Node:=AddChild(Node,IntToStr(DayOf(Now)));
                 AddChild(Node,LabStart.Caption)
               end;
           end;
      False:
        begin
          Node:=Add(Nil,IntToStr(YearOf(Now)));
          Node:=AddChild(Node,IntToStr(MonthOf(Now)));
          Node:=AddChild(Node,IntToStr(DayOf(Now)));
          AddChild(Node,LabStart.Caption)
        end;
    end;
end;

Procedure TMainForm.SaveUpDate( Const Value:Boolean);
begin
  If Value then
    begin
      LabFinish.Caption:=FormatDateTime('hh:mm:ss',Now);
      AddToSysTray('You are disconnected since '+LabFinish.Caption,ImgDisconnect.Picture.Icon);
    end;
  With Tree.Items do
    Case FoundYear Of
      True:Case FoundMonth Of
             True:Case FoundDay of
                    True:
                      Node.Item[Node.Count-1].Text:=Copy(Node.Item[Node.Count-1].Text,1,8)
                        +' '+FormatDateTime('hh:mm:ss',Now);
                    False:
                      Begin
                        Node:=Node.Item[Node.Count-1];
                        Node.Item[Node.Count-1].Text:=Copy(Node.Item[Node.Count-1].Text,1,8)
                          +' 00:00:00';
                        Node:=AddChild(Node.Parent,IntToStr(DayOf(Now)));
                        AddChild(Node,'00:00:00 '+FormatDateTime('hh:mm:ss',Now));
                      end;
                  end;
             False:
               begin
                 Node:=Node.Item[Node.Count-1].Item[Node.Count-1];
                 Node.Item[Node.Count-1].Text:=Copy(Node.Item[Node.Count-1].Text,1,8)
                   +' 00:00:00';
                 Node:=AddChild(Node.Parent.Parent,IntToStr(MonthOf(Now)));
                 Node:=AddChild(Node,IntToStr(DayOf(Now)));
                 AddChild(Node,'00:00:00 '+FormatDateTime('hh:mm:ss',Now));
               end;
           end;
      False:
        If Count>0 then
          begin
            Nodes:=Tree.Items;
            Node:=Tree.Items[Nodes.Count-1];
            Node.Text:=Copy(Node.Text,1,8)+' 00:00:00';
            Node:=Add(Nil,IntToStr(YearOf(Now)));
            Node:=AddChild(Node,IntToStr(MonthOf(Now)));
            Node:=AddChild(Node,IntToStr(DayOf(Now)));
            AddChild(Node,'00:00:00 '+FormatDateTime('hh:mm:ss',Now));
          end;
    end;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
 If AutoHide Then
   begin
    Hide;
    AutoHide:=False;
   end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
 var
  I:byte;
  Msg:String;
begin
 FilePath:=ChangeFileExt(Application.ExeName,'.cst');
 if FileExists(FilePath) then
  Tree.LoadFromFile(Filepath);
 ReadWriteReg(True);
 Msg:=Application.Title;
 with IconData do
    begin
      cbSize:=SizeOf(IconData);
      Wnd:=Handle;uID:=1;
      uFlags:=NIF_ICON or NIF_TIP or NIF_MESSAGE;
      uCallbackMessage:=WM_MYMESSAGE;
      hIcon:=Application.Icon.Handle;
      for i:=0 to length(Msg)-1 do
       szTip[i]:=Msg[i+1];
      szTip[length(Msg)]:=#0;
      Shell_NotifyIcon(NIM_ADD,@IconData)
   end;
 RegisterHotkey(Handle,1,Mod_Control+Mod_Alt,ord(13));
end;

procedure TMainForm.ActAutoExecute(Sender: TObject);
begin
InternetAutodial(2,0);
end;

procedure TMainForm.ActDisconnectExecute(Sender: TObject);
begin
  If MessageDlg('Are you sure you want to Hang up the current connection ?',
    MtConfirmation,[MbYes, MbNo],0)=MrYes Then
      InternetAutodialHangup(0);
end;

procedure TMainForm.ActManualExecute(Sender: TObject);
begin
InternetAutodial(0,0);
end;

procedure TMainForm.ActSHowHideExecute(Sender: TObject);
begin
  if Visible then
    begin
      ActSHowHide.Caption:='&Show';
      ActSHowHide.ImageIndex:=7;
      Hide;
    end
  else
    begin
      ActSHowHide.Caption:='&Hide';
      ActSHowHide.ImageIndex:=8;
      Show
    end;
end;

procedure TMainForm.ActCloseExecute(Sender: TObject);
begin
Close
end;

procedure TMainForm.ActConnectionExecute(Sender: TObject);
begin
 Page.ActivePage:=TabCon;
 ActConnection.Enabled:=False;
 ActSearsh.Enabled:=True;
 ActOpt.Enabled:=True;
 ActAbout.Enabled:=True;
 if Not Visible Then
   ActShowHideExecute(Sender);
end;

procedure TMainForm.ActSearshExecute(Sender: TObject);
begin
  Page.ActivePage:=TabSea;
  ActConnection.Enabled:=True;
  ActSearsh.Enabled:=False;
  ActOpt.Enabled:=True;
  ActAbout.Enabled:=True;
 if Not Visible Then
   ActShowHideExecute(Sender);
end;

procedure TMainForm.ActOptExecute(Sender: TObject);
begin
  Page.ActivePage:=TabOpt;
  ActConnection.Enabled:=True;
  ActSearsh.Enabled:=True;
  ActOpt.Enabled:=False;
  ActAbout.Enabled:=True;
 if Not Visible Then
   ActShowHideExecute(Sender);
end;

procedure TMainForm.ActAboutExecute(Sender: TObject);
begin
  Page.ActivePage:=TabAbout;
  ActConnection.Enabled:=True;
  ActSearsh.Enabled:=True;
  ActOpt.Enabled:=True;
  ActAbout.Enabled:=False;
 if Not Visible Then
   ActShowHideExecute(Sender);
end;

procedure TMainForm.ActClearExecute(Sender: TObject);
begin
 If Tree.Items.Count>0 then
   If MessageDlg('Are you sure you want to delete all day''s costs ?',mtConfirmation,[MbYes,MbCancel],0)=Mryes then
    begin
     Tree.Items.Clear;
     Tree.SaveToFile(FilePath);
    end;
end;

procedure TMainForm.EditCostKeyPress(Sender: TObject; var Key: Char);
begin
  If Not (Key In ['0'..'9', DecimalSeparator, Chr(8)]) Then Key := #0;
end;

procedure TMainForm.BtnOkClick(Sender: TObject);
begin
  If Length(EditCost.Text)<=0 Then
    begin
      MessageDlg('You should specify the cost unit',MtWarning, [MbOk], 0);
      Exit;
    end;
  ReadWriteReg(False);
  ActConnectionExecute(Sender);
end;

procedure TMainForm.PMCloseClick(Sender: TObject);
begin
  If MessageDlg('Are you sure you want to quit '+Application.Title+' ?',MtConfirmation,
    [MbYes,MbNo],0)=MrYes Then
       Application.Terminate
end;

procedure TMainForm.DTPMonthChange(Sender: TObject);
 Var i,j,k,l:integer;
     Str:string;
begin
  LabMonthCost.Caption:='0';
  DTPDate.Date:=DTPMonth.Date;
  for i:=0 to Tree.Items.Count-1 do
   if Tree.Items[i].Text=IntToStr(YearOf(DTPMonth.Date)) Then
    Begin
     for j:=0 to Tree.Items[i].Count-1 do
      if Tree.Items[i].Item[j].Text=IntToStr(MonthOf(DTPMonth.Date)) Then
       Begin
        for k:=0 to Tree.Items[i].Item[j].Count-1 do
          Begin
           For l:=0 to Tree.Items[i].Item[j].Item[k].Count-1 do
             begin
              Str:=Tree.Items[i].Item[j].Item[k].Item[l].Text;
              LabMonthCost.Caption:=FloatToStr(StrToFloat(LabMonthCost.Caption)+
              StrToFloat(GetCount(TimeToStr(StrToTime(Copy(Str,Pos(' ',Str)+1,
               Length(Str)))-StrToTime(Copy(Str,1,Pos(' ',Str)))) ,Prix)));
             end;
           end;
        Break;
       end;
    end;


end;

procedure TMainForm.DTPDateChange(Sender: TObject);
var i,j,k,l:integer;
    LItem:TListItem;
    Str:String;
begin
 List.Items.Clear;
 LabDayCount.Caption:='0';
 LabDayTime.Caption:='0';
 LabDayCost.Caption:='0';
 DTPMonth.Date:=DTPDate.Date;
 for i:=0 to Tree.Items.Count-1 do
  if Tree.Items[i].Text=IntToStr(YearOf(DTPDate.Date))Then
   Begin
    for j:=0 to Tree.Items[i].Count-1 do
     if Tree.Items[i].Item[j].Text=IntToStr(MonthOf(DTPDate.Date))Then
      Begin
       for k:=0 to Tree.Items[i].Item[j].Count-1 do
        if Tree.Items[i].Item[j].Item[k].Text=IntToStr(DayOf(DTPDate.Date))Then
         Begin
          For l:=0 to Tree.Items[i].Item[j].Item[k].Count-1 do
           With LItem Do
            begin
             LItem:=List.Items.Add;
             Str:=Tree.Items[i].Item[j].Item[k].Item[l].Text;
             Caption:=IntToStr(L+1);
             SubItems.Add(Copy(Str,1,Pos(' ',Str)));
             SubItems.Add(Copy(Str,Pos(' ',Str)+1,Length(Str)));
             SubItems.Add(TimeToStr(StrToTime(SubItems[1])-StrToTime(SubItems[0])));
             LabDayTime.Caption:=TimeToStr(StrToTime(LabDayTime.Caption)+StrToTime(SubItems[2]));
            end;
          LabDayCount.Caption:=IntToStr(Tree.Items[i].Item[j].Item[k].Count);
          LabDayCost.Caption:=GetCount(LabDayTime.Caption,Prix);
          Break;
         end;
      end;
   end;
end;

procedure TMainForm.PageChange(Sender: TObject);
begin
  Case Page.ActivePageIndex of
    0:ActConnectionExecute(Sender);
    1:ActSearshExecute(Sender);
    2:ActOptExecute(Sender);
    3:ActAboutExecute(Sender);
  end;
end;

procedure TMainForm.Label20Click(Sender: TObject);
begin
ShellExecute(0,'open',pchar('mailto:'+Label20.Caption),nil,nil,Sw_Show)
end;

procedure TMainForm.Label23Click(Sender: TObject);
begin
ShellExecute(0,'open',pchar(Label23.Caption),nil,nil,Sw_Show)
end;

end.
