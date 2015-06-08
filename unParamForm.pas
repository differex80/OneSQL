unit unParamForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxGridCustomTableView, cxGridTableView,
  cxGridCustomView, cxClasses, cxGridLevel, cxGrid, Menus, StdCtrls, cxButtons,
  ExtCtrls, cxCheckBox, cxDropDownEdit, cxNavigator;

type
  TparamForm = class(TForm)
    cxParamsLevel1: TcxGridLevel;
    cxParams: TcxGrid;
    tvParams: TcxGridTableView;
    tcActive: TcxGridColumn;
    tcParam: TcxGridColumn;
    tcType: TcxGridColumn;
    tcValue: TcxGridColumn;
    Panel1: TPanel;
    buOK: TcxButton;
    buCancel: TcxButton;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  paramForm: TparamForm;

implementation

uses unDm;

{$R *.dfm}

procedure TparamForm.FormShow(Sender: TObject);
begin
  cxParams.SetFocus;
end;

end.
