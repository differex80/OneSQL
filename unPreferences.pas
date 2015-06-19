unit unPreferences;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxPCdxBarPopupMenu, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, dxColorEdit, FileCtrl, StdCtrls, cxButtons, cxPC, ExtCtrls, ShellApi,
  cxColorComboBox, IniFiles, SynEdit, SynEditHighlighter, SynHighlighterSQL,
  System.UITypes, System.Types, dxBarBuiltInMenu;

type
  TPreferences = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    cxPageControl1: TcxPageControl;
    tsEditor: TcxTabSheet;
    tsGrid: TcxTabSheet;
    tsGeneral: TcxTabSheet;
    buCancel: TcxButton;
    buSave: TcxButton;
    GroupBox1: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    GroupBox2: TGroupBox;
    ceEditorColor: TdxColorEdit;
    colorDialog: TColorDialog;
    fd: TFontDialog;
    buFontEditor: TcxButton;
    ceEditorBackground: TdxColorEdit;
    Label5: TLabel;
    sePreview: TSynEdit;
    syntax: TSynSQLSyn;
    laKeywords: TLabel;
    ceKeywords: TdxColorEdit;
    buKeywordsBold: TcxButton;
    buKeywordsItalic: TcxButton;
    laFunctions: TLabel;
    ceFunctions: TdxColorEdit;
    buFunctionsBold: TcxButton;
    buFunctionsItalic: TcxButton;
    laTables: TLabel;
    ceTables: TdxColorEdit;
    buTablesBold: TcxButton;
    buTablesItalic: TcxButton;
    laNumbers: TLabel;
    ceNumbers: TdxColorEdit;
    buNumbersBold: TcxButton;
    buNumbersItalic: TcxButton;
    laStrings: TLabel;
    ceStrings: TdxColorEdit;
    buStringsBold: TcxButton;
    buStringsItalic: TcxButton;
    laDataTypes: TLabel;
    ceDataTypes: TdxColorEdit;
    buDataTypesBold: TcxButton;
    buDataTypesItalic: TcxButton;
    laComments: TLabel;
    ceComments: TdxColorEdit;
    buCommentsBold: TcxButton;
    buCommentsItalic: TcxButton;
    Label15: TLabel;
    GroupBox3: TGroupBox;
    Label6: TLabel;
    buFontGrid: TcxButton;
    Label9: TLabel;
    ceGridColor: TdxColorEdit;
    Label10: TLabel;
    ceGridBackground: TdxColorEdit;
    GroupBox4: TGroupBox;
    edNullString: TEdit;
    Label1: TLabel;
    ceNullStringBackground: TdxColorEdit;
    buNullStringBold: TcxButton;
    buNullStringItalic: TcxButton;
    Panel3: TPanel;
    tsAbout: TcxTabSheet;
    paInfoLeft: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    paInfoRight: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    laVersion: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    GroupBox5: TGroupBox;
    Label18: TLabel;
    edSqlDirectory: TEdit;
    cbLineEnding: TComboBox;
    Label23: TLabel;
    buSqlDirectory: TcxButton;
    GroupBox6: TGroupBox;
    cboxShowObjectInspector: TCheckBox;
    procedure buFontEditorClick(Sender: TObject);
    procedure buSaveClick(Sender: TObject);
    procedure ColorEditInitPopup(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure buKeywordsBoldClick(Sender: TObject);
    procedure ceNullStringBackgroundPropertiesInitPopup(Sender: TObject);
    procedure buNullStringBoldClick(Sender: TObject);
    procedure buNullStringItalicClick(Sender: TObject);
    procedure tsAboutResize(Sender: TObject);
    procedure Label20Click(Sender: TObject);
    procedure buSqlDirectoryClick(Sender: TObject);
  private
    { Private declarations }
    procedure Preview;
    function GetAppVersionStr: string;
  public
    { Public declarations }
  end;

var
  Preferences: TPreferences;

implementation

uses unDm;

{$R *.dfm}

procedure TPreferences.buFontEditorClick(Sender: TObject);
begin
  fd.Font := TcxButton(Sender).Font;
  if fd.Execute then
  begin
    TcxButton(Sender).Font := fd.Font;
    Preview;
  end;
end;

procedure TPreferences.buKeywordsBoldClick(Sender: TObject);
begin
  Preview;
end;

procedure TPreferences.buNullStringBoldClick(Sender: TObject);
begin
  if TcxButton(Sender).Down then
    edNullString.Font.Style := edNullString.Font.Style + [fsBold]
  else
    edNullString.Font.Style := edNullString.Font.Style - [fsBold]
end;

procedure TPreferences.buNullStringItalicClick(Sender: TObject);
begin
  if TcxButton(Sender).Down then
    edNullString.Font.Style := edNullString.Font.Style + [fsItalic]
  else
    edNullString.Font.Style := edNullString.Font.Style - [fsItalic]
end;

procedure TPreferences.buSaveClick(Sender: TObject);
var
  IniFile: TIniFile;
begin
  if not SysUtils.DirectoryExists(edSqlDirectory.Text) then
  begin
    raise Exception.Create('Invalid Sql Directory!');
    edSqlDirectory.SetFocus;
    exit;
  end;

  IniFile := dm.GetConfigIniFile;
  try
    with IniFile do
    begin
      {General}
      WriteString(secGeneral, 'SqlDirectory', edSqlDirectory.Text);
      WriteInteger(secGeneral, 'LineEnding', cbLineEnding.ItemIndex);
      dm.LineEnding := cbLineEnding.ItemIndex;
      WriteBool(secGeneral, 'ShowObjectInspector', cboxShowObjectInspector.Checked);
      {DataGrid}
      WriteString(secDataGrid, 'FontName', buFontGrid.Font.Name);
      WriteInteger(secDataGrid, 'FontSize', buFontGrid.Font.Size);
      WriteBool(secDataGrid, 'FontBold', fsBold in buFontGrid.Font.Style);
      WriteBool(secDataGrid, 'FontItalic', fsItalic in buFontGrid.Font.Style);
      WriteInteger(secDataGrid, 'Color', ceGridColor.ColorValue);
      WriteInteger(secDataGrid, 'Background', ceGridBackground.ColorValue);
      WriteString(secDataGrid, 'NullString', edNullString.Text);
      WriteBool(secDataGrid, 'NullStringBold', fsBold in edNullString.Font.Style);
      WriteBool(secDataGrid, 'NullStringItalic', fsItalic in edNullString.Font.Style);
      WriteInteger(secDataGrid, 'NullStringBackground', ceNullStringBackground.ColorValue);
      {Editor}
      WriteString(secEditor, 'FontName', buFontEditor.Font.Name);
      WriteInteger(secEditor, 'FontSize', buFontEditor.Font.Size);
      WriteBool(secEditor, 'FontBold', fsBold in buFontEditor.Font.Style);
      WriteBool(secEditor, 'FontItalic', fsItalic in buFontEditor.Font.Style);
      WriteInteger(secEditor, 'Color', ceEditorColor.ColorValue);
      WriteInteger(secEditor, 'Background', ceEditorBackground.ColorValue);
      {Syntax Highlight}
      WriteInteger(secHighlight, 'Keywords', ceKeywords.ColorValue);
      WriteBool(secHighlight, 'KeywordsBold', buKeywordsBold.Down);
      WriteBool(secHighlight, 'KeywordsItalic', buKeywordsItalic.Down);
      WriteInteger(secHighlight, 'Functions', ceFunctions.ColorValue);
      WriteBool(secHighlight, 'FunctionsBold', buFunctionsBold.Down);
      WriteBool(secHighlight, 'FunctionsItalic', buFunctionsItalic.Down);
      WriteInteger(secHighlight, 'Comments', ceComments.ColorValue);
      WriteBool(secHighlight, 'CommentsBold', buCommentsBold.Down);
      WriteBool(secHighlight, 'CommentsItalic', buCommentsItalic.Down);
      WriteInteger(secHighlight, 'DataTypes', ceDataTypes.ColorValue);
      WriteBool(secHighlight, 'DataTypesBold', buDataTypesBold.Down);
      WriteBool(secHighlight, 'DataTypesItalic', buDataTypesItalic.Down);
      WriteInteger(secHighlight, 'Tables', ceTables.ColorValue);
      WriteBool(secHighlight, 'TablesBold', buTablesBold.Down);
      WriteBool(secHighlight, 'TablesItalic', buTablesItalic.Down);
      WriteInteger(secHighlight, 'Numbers', ceNumbers.ColorValue);
      WriteBool(secHighlight, 'NumbersBold', buNumbersBold.Down);
      WriteBool(secHighlight, 'NumbersItalic', buNumbersItalic.Down);
      WriteInteger(secHighlight, 'Strings', ceStrings.ColorValue);
      WriteBool(secHighlight, 'StringsBold', buStringsBold.Down);
      WriteBool(secHighlight, 'StringsItalic', buStringsItalic.Down);
    end;
  finally
    IniFile.Free;
  end;
  ModalResult := mrOk;
  CloseModal;
end;

procedure TPreferences.buSqlDirectoryClick(Sender: TObject);
var
  sDir: String;
begin
//  foDialog.DefaultFolder := edSqlDirectory.Text;
  if SelectDirectory('Select SQL directory', '', sDir) then
    edSqlDirectory.Text := sDir;
end;

procedure TPreferences.ceNullStringBackgroundPropertiesInitPopup(
  Sender: TObject);
begin
  ColorDialog.Color := TdxColorEdit(Sender).ColorValue;
  if ColorDialog.Execute then
  begin
    TdxColorEdit(Sender).ColorValue := ColorDialog.Color;
    edNullString.Color := ColorDialog.Color;
  end;
  Abort;
end;

procedure TPreferences.ColorEditInitPopup(Sender: TObject);
begin
  ColorDialog.Color := TdxColorEdit(Sender).ColorValue;
  if ColorDialog.Execute then
  begin
    TdxColorEdit(Sender).ColorValue := ColorDialog.Color;
    Preview;
  end;
  Abort;
end;

function TPreferences.GetAppVersionStr: string;
var
  Exe: string;
  Size, Handle: DWORD;
  Buffer: TBytes;
  FixedPtr: PVSFixedFileInfo;
begin
  Exe := ParamStr(0);
  Size := GetFileVersionInfoSize(PChar(Exe), Handle);
  if Size = 0 then
    RaiseLastOSError;
  SetLength(Buffer, Size);
  if not GetFileVersionInfo(PChar(Exe), Handle, Size, Buffer) then
    RaiseLastOSError;
  if not VerQueryValue(Buffer, '\', Pointer(FixedPtr), Size) then
    RaiseLastOSError;
  Result := Format('%d.%d.%d.%d',
    [LongRec(FixedPtr.dwFileVersionMS).Hi,  //major
     LongRec(FixedPtr.dwFileVersionMS).Lo,  //minor
     LongRec(FixedPtr.dwFileVersionLS).Hi,  //release
     LongRec(FixedPtr.dwFileVersionLS).Lo]) //build
end;

procedure TPreferences.Label20Click(Sender: TObject);
var
  S: string;
begin
  S := 'mailto:' + TLabel(Sender).Caption;
  S := S + '?subject=OneSQL%20Support';
  if dm.GetWineAvail() then
    S := 'winebrowser ' + S;
  ShellExecute( Application.Handle,'open', PChar(S), nil, nil, SW_SHOWNORMAL);
end;

procedure TPreferences.FormCreate(Sender: TObject);
var
  IniFile: TIniFile;
  lBold, lItalic: boolean;
begin
  laVersion.Caption := GetAppVersionStr;
  IniFile := dm.GetConfigIniFile;
  try
    with IniFile do
    begin
      {General}
      edSqlDirectory.Text := ReadString(secGeneral, 'SqlDirectory', '');
      cbLineEnding.ItemIndex := dm.Lineending;
      cboxShowObjectInspector.Checked := ReadBool(secGeneral, 'ShowObjectInspector', False);
      {DataGrid}
      buFontGrid.Font.Name := ReadString(secDataGrid, 'FontName', 'Tahoma');
      buFontGrid.Font.Size := ReadInteger(secDataGrid, 'FontSize', 10);
      buFontGrid.Font.Style := [];
      lBold := ReadBool(secDataGrid, 'FontBold', False);
      if lBold then
        buFontGrid.Font.Style := buFontGrid.Font.Style + [fsBold];
      lItalic := ReadBool(secDataGrid, 'FontItalic', False);
      if lItalic then
        buFontGrid.Font.Style := buFontGrid.Font.Style + [fsItalic];
      ceGridColor.ColorValue := ReadInteger(secDataGrid, 'Color', clBlack);
      ceGridBackground.ColorValue := ReadInteger(secDataGrid, 'Background', clWhite);
      edNullString.Text := ReadString(secDataGrid, 'NullString', '{null}');
      edNullString.Font.Style := [];
      lBold := ReadBool(secDataGrid, 'NullStringBold', False);
      if lBold then
        edNullString.Font.Style := edNullString.Font.Style + [fsBold];
      buNullStringBold.Down := lBold;
      lItalic := ReadBool(secDataGrid, 'NullStringItalic', False);
      if lItalic then
        edNullString.Font.Style := edNullString.Font.Style + [fsItalic];
      buNullStringItalic.Down := lItalic;
      ceNullStringBackground.ColorValue := ReadInteger(secDataGrid, 'NullStringBackground', clWhite);
      edNullString.Color := ceNullStringBackground.ColorValue;
      {Editor}
      buFontEditor.Font.Name := ReadString(secEditor, 'FontName', 'Courier New');
      buFontEditor.Font.Size := ReadInteger(secEditor, 'FontSize', 10);
      buFontEditor.Font.Style := [];
      lBold := ReadBool(secEditor, 'FontBold', False);
      if lBold then
        buFontEditor.Font.Style := buFontEditor.Font.Style + [fsBold];
      lItalic := ReadBool(secEditor, 'FontItalic', False);
      if lItalic then
        buFontEditor.Font.Style := buFontEditor.Font.Style + [fsItalic];
      ceEditorColor.ColorValue := ReadInteger(secEditor, 'Color', clBlack);
      ceEditorBackground.ColorValue := ReadInteger(secEditor, 'Background', clWhite);
      { Sytax Highlight }
      ceKeywords.ColorValue := ReadInteger(secHighlight, 'Keywords', 15168792);
      buKeywordsBold.Down := ReadBool(secHighlight, 'KeywordsBold', True);
      buKeywordsItalic.Down := ReadBool(secHighlight, 'KeywordsItalic', False);
      ceFunctions.ColorValue := ReadInteger(secHighlight, 'Functions', clFuchsia);
      buFunctionsBold.Down := ReadBool(secHighlight, 'FunctionsBold', True);
      buFunctionsItalic.Down := ReadBool(secHighlight, 'FunctionsItalic', False);
      ceComments.ColorValue := ReadInteger(secHighlight, 'Comments', clGreen);
      buCommentsBold.Down := ReadBool(secHighlight, 'CommentsBold', False);
      buCommentsItalic.Down := ReadBool(secHighlight, 'CommentsItalic', True);
      ceDataTypes.ColorValue := ReadInteger(secHighlight, 'DataTypes', clMaroon);
      buDataTypesBold.Down := ReadBool(secHighlight, 'DataTypesBold', False);
      buDataTypesItalic.Down := ReadBool(secHighlight, 'DataTypesItalic', False);
      ceTables.ColorValue := ReadInteger(secHighlight, 'Tables', clOlive);
      buTablesBold.Down := ReadBool(secHighlight, 'TablesBold', True);
      buTablesItalic.Down := ReadBool(secHighlight, 'TablesItalic', False);
      ceNumbers.ColorValue := ReadInteger(secHighlight, 'Numbers', clBlue);
      buNumbersBold.Down := ReadBool(secHighlight, 'NumbersBold', False);
      buNumbersItalic.Down := ReadBool(secHighlight, 'NumbersItalic', False);
      ceStrings.ColorValue := ReadInteger(secHighlight, 'Strings', clRed);
      buStringsBold.Down := ReadBool(secHighlight, 'StringsBold', False);
      buStringsItalic.Down := ReadBool(secHighlight, 'StringsItalic', False);
      { GridView style }
      buFontGrid.Font.Name := ReadString(secDataGrid, 'FontName', 'Tahoma');
      buFontGrid.Font.Size := ReadInteger(secDataGrid, 'FontSize', 9);
      buFontGrid.Font.Style := [];
      lBold := ReadBool(secDataGrid, 'FontBold', False);
      if lBold then
        buFontGrid.Font.Style := buFontEditor.Font.Style + [fsBold];
      lItalic := ReadBool(secEditor, 'FontItalic', False);
      if lItalic then
        buFontEditor.Font.Style := buFontEditor.Font.Style + [fsItalic];

      ceGridColor.ColorValue := dm.GridContent.TextColor;
      ceGridBackground.ColorValue := dm.GridContent.Color;
    end;
  finally
    IniFile.Free;
  end;
  Preview;
end;

procedure TPreferences.Preview;
var
  Styles: TFontStyles;
begin
  sePreview.Font := buFontEditor.Font;
  sePreview.Font.Color := ceEditorColor.ColorValue;
  sePreview.Color := ceEditorBackground.ColorValue;
  Styles := [];
  syntax.KeyAttri.Foreground := ceKeywords.ColorValue;
  if buKeywordsBold.Down then
    Styles := Styles + [fsBold];
  if buKeywordsItalic.Down then
    Styles := Styles + [fsItalic];
  syntax.KeyAttri.Style := Styles;
  Styles := [];
  syntax.FunctionAttri.Foreground := ceFunctions.ColorValue;
  if buFunctionsBold.Down then
    Styles := Styles + [fsBold];
  if buFunctionsItalic.Down then
    Styles := Styles + [fsItalic];
  syntax.FunctionAttri.Style := Styles;
  Styles := [];
  syntax.CommentAttri.Foreground := ceComments.ColorValue;
  if buCommentsBold.Down then
    Styles := Styles + [fsBold];
  if buCommentsItalic.Down then
    Styles := Styles + [fsItalic];
  syntax.CommentAttri.Style := Styles;
  Styles := [];
  syntax.DataTypeAttri.Foreground := ceDataTypes.ColorValue;
  if buDataTypesBold.Down then
    Styles := Styles + [fsBold];
  if buDataTypesItalic.Down then
    Styles := Styles + [fsItalic];
  syntax.DataTypeAttri.Style := Styles;
  Styles := [];
  syntax.TableNameAttri.Foreground := ceTables.ColorValue;
  if buTablesBold.Down then
    Styles := Styles + [fsBold];
  if buTablesItalic.Down then
    Styles := Styles + [fsItalic];
  syntax.TableNameAttri.Style := Styles;
  Styles := [];
  syntax.NumberAttri.Foreground := ceNumbers.ColorValue;
  if buNumbersBold.Down then
    Styles := Styles + [fsBold];
  if buNumbersItalic.Down then
    Styles := Styles + [fsItalic];
  syntax.NumberAttri.Style := Styles;
  Styles := [];
  syntax.StringAttri.Foreground := ceStrings.ColorValue;
  if buStringsBold.Down then
    Styles := Styles + [fsBold];
  if buStringsItalic.Down then
    Styles := Styles + [fsItalic];
  syntax.StringAttri.Style := Styles;
end;

procedure TPreferences.tsAboutResize(Sender: TObject);
begin
  paInfoLeft.Width := Round(tsAbout.Width div 2);
end;

end.
