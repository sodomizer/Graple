program GrapleSkinEditor;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  GDIImageList in 'GDIImageList.pas',
  Skins in 'Skins.pas',
  StringHashTable in 'StringHashTable.pas',
  ElementForm in 'ElementForm.pas' {Form2},
  SkinSettingsForm in 'SkinSettingsForm.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
