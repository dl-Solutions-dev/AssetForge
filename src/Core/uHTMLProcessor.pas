unit uHTMLProcessor;

interface

uses
  system.Classes,
  System.SysUtils,
  uManifest;

type
  /// <summary>
  ///   modify asset reference in the html code
  /// </summary>
  THTMLProcessor = class
  public
    /// <summary>
    ///   replace assets references
    /// </summary>
    /// <param name="aSourceFile">
    ///   HTML Source file
    /// </param>
    /// <param name="aManifest">
    ///   Manifest file
    /// </param>
    /// <param name="aDestFolder">
    ///   Destination folder
    /// </param>
    procedure ReplaceReferencesInHtml( aSourceFile: string; aManifest: TManifest; aDestFolder: string );
  end;

implementation

uses
  System.IOUtils;

{ THTMLProcessor }

procedure THTMLProcessor.ReplaceReferencesInHtml( aSourceFile: string;
  aManifest: TManifest; aDestFolder: string );
begin
  var LContent := TFile.ReadAllText( aSourceFile );

  for var Pair in aManifest.Data do
  begin
    var LOriginalName := TPath.GetFileName( Pair.Key );

    LContent := StringReplace( LContent,
      LOriginalName,
      Pair.Value.FileName,
      [ rfReplaceAll ] );
  end;

  TFile.WriteAllText(
    TPath.Combine( aDestFolder, TPath.GetFileName( aSourceFile ) ),
    LContent
    );
end;

end.

