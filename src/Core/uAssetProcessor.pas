/// <summary>
///   Renames modified resource files with a hash string of the file (e.g.,
///   MyScript.HashCode.js).
/// </summary>
unit uAssetProcessor;

interface

uses
  System.SysUtils,
  uManifest;

type
  /// <summary>
  ///   Renames asset file
  /// </summary>
  TAssetProcessor = class
  public
    /// <summary>
    ///   Check if asset is modified, and if yes renamme it
    /// </summary>
    /// <param name="aSourceFile">
    ///   Source file
    /// </param>
    /// <param name="aDestFolder">
    ///   Destination folder
    /// </param>
    /// <param name="aManifest">
    ///   Manifest file
    /// </param>
    procedure Process( aSourceFile, aDestFolder: string; aManifest: TManifest );
  end;

implementation

uses
  System.Hash,
  System.IOUtils,
  CommandLine;

{ TAssetProcessor }

procedure TAssetProcessor.Process( aSourceFile, aDestFolder: string;
  aManifest: TManifest );
var
  LEntry: TAssetEntry;
  LEntryExist: Boolean;
  LNewFileName: string;
begin
  var LFullHash := THashSHA2.GetHashStringFromFile( aSourceFile );
  var LShortHash := Copy( LFullHash, 1, 12 );

  if aManifest.GetAsset( TPath.GetFileName( aSourceFile ), LEntry ) then
  begin
    LEntryExist := True;

    if ( LEntry.Hash = LShortHash ) then
    begin
      // fichier non modifié
      Exit;
    end;
  end
  else
  begin
    LEntryExist := False;
  end;

  var LBaseName := TPath.GetFileNameWithoutExtension( aSourceFile );
  var LExt := TPath.GetExtension( aSourceFile );

  if ( CompareText( TCommandLine.GetInstance.BuildMode, 'prod' ) = 0 ) then
  begin
    LNewFileName := LBaseName + '.' + LShortHash + LExt;

    ForceDirectories( TPath.Combine( aDestFolder, '_old' ) );

    if LEntryExist then
    begin
      TFile.Move( TPath.Combine( aDestFolder, LEntry.FileName ),
        TPath.Combine( aDestFolder, '_old', LEntry.FileName ) );
    end;
  end
  else
  begin
    LNewFileName := aSourceFile;
  end;

  TFile.Copy( aSourceFile,
    TPath.Combine( aDestFolder, LNewFileName ),
    True );

  LEntry.Hash := LShortHash;
  LEntry.FileName := LNewFileName;
  LEntry.IsModified := True;

  aManifest.SetEntry( TPath.GetFileName( aSourceFile ), LEntry );
end;

end.

