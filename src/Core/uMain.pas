/// <summary>
///   Main unit
/// </summary>
unit uMain;

interface

uses
  System.Classes,
  System.SysUtils,
  System.StrUtils;

type
  /// <summary>
  ///   Main class
  /// </summary>
  TMain = class
  public
    /// <summary>
    ///   run the process
    /// </summary>
    procedure Execute;
  end;

implementation

{ TMain }

uses
  System.IOUtils,
  CommandLine,
  uManifest,
  uAssetProcessor,
  uHTMLProcessor;

procedure TMain.Execute;
begin
  var LManifest := TManifest.Create;
  var LAssetProcessor := TAssetProcessor.Create;
  var LHTMLProcessor := THTMLProcessor.Create;
  try
    LManifest.Load( TCommandLine.GetInstance.Manifest );

    var LFiles := TDirectory.GetFiles(
      TCommandLine.GetInstance.Repository,
      '*.*',
      TSearchOption.soAllDirectories
      );

    for var LFileName in LFiles do
    begin
      if MatchText( TPath.GetExtension( LFileName ), [ '.js', '.css', '.png', '.jpg', '.svg' ] ) then
      begin
        var LDest := IncludeTrailingPathDelimiter( TCommandLine.GetInstance.DestinationFolder ) + Copy( ExtractFilePath( LFileName
          ), Length( IncludeTrailingPathDelimiter( TCommandLine.GetInstance.Repository ) ) + 1, Length( LFileName ) );
        LAssetProcessor.Process( LFileName, LDest, LManifest );
      end;
    end;

    for var LFileName in LFiles do
    begin
      if MatchText( TPath.GetExtension( LFileName ), [ '.htm', '.html' ] ) then
      begin
        var LDest := IncludeTrailingPathDelimiter( TCommandLine.GetInstance.DestinationFolder ) + Copy( ExtractFilePath( LFileName
          ), Length( IncludeTrailingPathDelimiter( TCommandLine.GetInstance.Repository ) ) + 1, Length( LFileName ) );
        LHTMLProcessor.ReplaceReferencesInHtml( LFileName, LManifest, LDest );
      end;
    end;

    LManifest.Save;
  finally
    FreeAndNil( LAssetProcessor );
    FreeAndNil( LHTMLProcessor );
    FreeAndNil( LManifest );
  end;
end;

end.

