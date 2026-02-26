(* C2PP
  ***************************************************************************

  AssetForge

    Copyright 2026 - Dany Leblanc under MIT license.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
  OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
    THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
  OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.

  ***************************************************************************
  File last update : 2026-02-22T22:36:22.000+01:00
  Signature : 12570e4b4b1bf5c91875a91aaf55895c1fde09cd
  ***************************************************************************
*)

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

  ForceDirectories( aDestFolder );

  TFile.WriteAllText(
    TPath.Combine( aDestFolder, TPath.GetFileName( aSourceFile ) ),
    LContent
    );
end;

end.

