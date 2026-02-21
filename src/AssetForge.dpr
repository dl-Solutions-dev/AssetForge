/// <summary>
///   Deterministic asset hashing for cache-safe production deployments
/// </summary>
program AssetForge;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  CommandLine in 'CLI\CommandLine.pas',
  uMain in 'Core\uMain.pas',
  uManifest in 'Core\uManifest.pas',
  uAssetProcessor in 'Core\uAssetProcessor.pas',
  uHTMLProcessor in 'Core\uHTMLProcessor.pas';

begin
  try
    if ( TCommandLine.GetInstance.Ok ) then
    begin
      var LMain := TMain.Create;
      try
        LMain.Execute;
      finally
        FreeAndNil( LMain );
      end;
    end;
  except
    on E: Exception do
    begin
      Writeln( E.ClassName, ': ', E.Message );

      if ( TCommandLine.GetInstance.Manifest <> '' ) then
      begin
        var LFile: TextFile;

        AssignFile( LFile, ExtractFilePath( TCommandLine.GetInstance.Manifest ) + 'Log.txt' );
        Rewrite( LFile );
        Writeln( LFile, e.Message );
        CloseFile( LFile );
      end;

      ExitCode := 1;
    end;
  end;
end.

