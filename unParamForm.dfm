object paramForm: TparamForm
  Left = 0
  Top = 0
  BorderWidth = 4
  Caption = 'SQL Parameters'
  ClientHeight = 319
  ClientWidth = 567
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object cxParams: TcxGrid
    Left = 0
    Top = 0
    Width = 567
    Height = 284
    Align = alClient
    TabOrder = 0
    LookAndFeel.NativeStyle = True
    object tvParams: TcxGridTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object tcActive: TcxGridColumn
        Caption = 'Active?'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Properties.ValueChecked = '1'
        Properties.ValueUnchecked = '0'
        HeaderAlignmentHorz = taCenter
        MinWidth = 50
        Options.Filtering = False
        Options.GroupFooters = False
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        Width = 50
      end
      object tcParam: TcxGridColumn
        Caption = 'Param'
        HeaderAlignmentHorz = taCenter
        MinWidth = 150
        Options.Editing = False
        Options.Filtering = False
        Options.GroupFooters = False
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        SortIndex = 0
        SortOrder = soAscending
        Width = 150
      end
      object tcType: TcxGridColumn
        Caption = 'Type'
        PropertiesClassName = 'TcxComboBoxProperties'
        Properties.Items.Strings = (
          'Integer'
          'Decimal'
          'String'
          'Substitution')
        HeaderAlignmentHorz = taCenter
        MinWidth = 104
        Options.GroupFooters = False
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        Width = 104
      end
      object tcValue: TcxGridColumn
        Caption = 'Value'
        HeaderAlignmentHorz = taCenter
        Options.GroupFooters = False
        Options.Grouping = False
        Options.Moving = False
        Width = 197
      end
    end
    object cxParamsLevel1: TcxGridLevel
      GridView = tvParams
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 284
    Width = 567
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      567
      35)
    object buOK: TcxButton
      Left = 492
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Execute'
      Default = True
      LookAndFeel.NativeStyle = True
      ModalResult = 1
      OptionsImage.ImageIndex = 0
      OptionsImage.Images = dm.imListSmall
      TabOrder = 0
    end
    object buCancel: TcxButton
      Left = 411
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = 'Cancel'
      LookAndFeel.NativeStyle = True
      ModalResult = 2
      OptionsImage.ImageIndex = 1
      OptionsImage.Images = dm.imListSmall
      TabOrder = 1
    end
  end
end
