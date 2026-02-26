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
  File last update : 2026-02-21T23:41:24.130+01:00
  Signature : 00caca3f99adfc9b6f7599ce5b5463c22da043c0
  ***************************************************************************
*)

/// <summary>
///   Manifest of modifications
/// </summary>
unit uManifest;

interface

uses
  System.Classes,
  System.SysUtils,
  System.JSON,
  system.Generics.Collections;

type
  /// <summary>
  ///   Record for Asset
  /// </summary>
  TAssetEntry = record
    /// <summary>
    ///   Hash code
    /// </summary>
    Hash: string;
    /// <summary>
    ///   File name of the asset
    /// </summary>
    FileName: string;
    /// <summary>
    ///   Asset modified
    /// </summary>
    IsModified: Boolean;
  end;

  /// <summary>
  ///   Manifest class
  /// </summary>
  TManifest = class
  private
    FFileName: string;
    FData: TDictionary<string, TAssetEntry>;
  public
    constructor Create;
    destructor Destroy; override;

    function GetAsset( aAssetName: string; out aAsset: TAssetEntry ): Boolean;

    procedure Load( aFileName: string );
    procedure Save;
    procedure SetEntry( aAssetName: string; aAsset: TAssetEntry );

    property Data: TDictionary<string, TAssetEntry> read FData;
  end;

implementation

uses
  System.IOUtils;

{ TManifest }

constructor TManifest.Create;
begin
  FData := TDictionary<string, TAssetEntry>.Create;
end;

destructor TManifest.Destroy;
begin
  FreeAndNil( FData );

  inherited;
end;

function TManifest.GetAsset( aAssetName: string; out aAsset: TAssetEntry ): Boolean;
begin
  Result := FData.TryGetValue( aAssetName, aAsset );
end;

procedure TManifest.Load( aFileName: string );
var
  LAssetEntry: TAssetEntry;
begin
  FFileName := aFileName;

  if FileExists( aFileName ) then
  begin
    var LJSonString := TFile.ReadAllText( aFileName );

    var LJSonObject := TJSONObject.ParseJSONValue( LJSonString ) as TJSONObject;

    if Assigned( LJSonObject ) then
    begin
      for var LPair in LJSonObject do
      begin
        var LAsset := LPair.JsonValue as TJSONObject;

        LAssetEntry.Hash := LAsset.GetValue<string>( 'hash' );
        LAssetEntry.FileName := LAsset.GetValue<string>( 'file' );
        LAssetEntry.IsModified := False;

        FData.Add( LPair.JsonString.Value, LAssetEntry );
      end;

      FreeAndNil( LJSonObject );
    end;
  end;
end;

procedure TManifest.Save;
begin
  var LJSONObject := TJSONObject.Create;
  try
    for var Pair in FData do
    begin
      var LEntryObj := TJSONObject.Create;
      LEntryObj.AddPair( 'hash', Pair.Value.Hash );
      LEntryObj.AddPair( 'file', Pair.Value.FileName );
      LEntryObj.AddPair( 'isModified', Pair.Value.IsModified );

      LJSONObject.AddPair( Pair.Key, LEntryObj );
    end;

    TFile.WriteAllText( FFileName, LJSONObject.ToJSON );
  finally
    LJSONObject.Free;
  end;
end;

procedure TManifest.SetEntry( aAssetName: string; aAsset: TAssetEntry );
begin
  if not ( FData.ContainsKey( aAssetName ) ) then
  begin
    FData.Add( aAssetName, aAsset );
  end
  else
  begin
    FData[ aAssetName ] := aAsset;
  end;
end;

end.

