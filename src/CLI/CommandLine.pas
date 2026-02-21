unit CommandLine;

interface

uses
  System.Classes,
  system.SysUtils;

type
  /// <summary>
  ///   Parse the command line
  /// </summary>
  TCommandLine = class
  private
    FBuildMode: string;
    FRepository: string;
    FManifest: string;
    FDestinationFolder: string;
    FCI: Boolean;
    FErrors: TArray<string>;

    class var FInstance: TCommandLine;

    /// <summary>
    ///   Find the specified switch in the command line
    /// </summary>
    function FindSwitch( aSwitch: string; out aValue: string ): Boolean;

    /// <summary>
    ///   Show help for the command line
    /// </summary>
    procedure Help;
    procedure SetCI( const Value: Boolean );
    /// <summary>
    ///   Add an erro to show
    /// </summary>
    procedure AddError( aError: string );
  public
    constructor Create;
    destructor Destroy; override;

    class constructor Create;
    class destructor Destroy;

    /// <summary>
    ///   get the singleton instance of the class
    /// </summary>
    class function GetInstance: TCommandLine;

    /// <summary>
    ///   True if command line si correct,
    /// </summary>
    function Ok: Boolean;

    /// <summary>
    ///   Renamme or not the assets
    /// </summary>
    property BuildMode: string read FBuildMode;
    /// <summary>
    ///   Origin folder of the asset files
    /// </summary>
    property Repository: string read FRepository;
    /// <summary>
    ///   Destination folder for the asset files
    /// </summary>
    property DestinationFolder: string read FDestinationFolder;
    /// <summary>
    ///   Manifest file for to keep modify history
    /// </summary>
    property Manifest: string read FManifest;
    /// <summary>
    ///   Run in CI/CD context
    /// </summary>
    property CI: Boolean read FCI write SetCI;
  end;

implementation

{ TCommandLine }

constructor TCommandLine.Create;
var
  LValue: string;
begin
  var LShowHelp := False;
  SetLength( FErrors, 0 );

  if FindSwitch( '--prod', FBuildMode ) then
  begin
    FBuildMode := 'prod';
  end
  else
  begin
    FBuildMode := 'dev';
  end;

  if FindSwitch( '--ci', LValue ) then
  begin
    FCI := True;
  end
  else
  begin
    FCI := False;
  end;

  if FindSwitch( '--help', LValue ) then
  begin
    Help;

    Exit;
  end;

  if not ( FindSwitch( '-r', FRepository ) ) then
  begin
    AddError( 'Missing parameter : -r' );

    LShowHelp := True;
  end;

  if not ( FindSwitch( '-d', FDestinationFolder ) ) then
  begin
    AddError( 'Missing parameter : -d' );

    LShowHelp := True;
    ;
  end;

  if not ( FindSwitch( '-m', FManifest ) ) then
  begin
    AddError( 'Missing parameter : -m' );

    LShowHelp := True;
    ;
  end;

  if LShowHelp then
  begin
    Help;
  end;
end;

procedure TCommandLine.AddError( aError: string );
begin
  SetLength( FErrors, Length( FErrors ) + 1 );
  FErrors[ High( FErrors ) ] := aError;
end;

class constructor TCommandLine.Create;
begin
  FInstance := nil;
end;

class destructor TCommandLine.Destroy;
begin
  if ( Assigned( FInstance ) ) then
  begin
    FreeAndNil( FInstance );
  end;
end;

function TCommandLine.FindSwitch( aSwitch: string; out aValue: string ): Boolean;
begin
  Result := False;

  for var i := 1 to ParamCount do
  begin
    if ( CompareText( ParamStr( i ), aSwitch ) = 0 ) then
    begin
      if ( i < ParamCount ) and ( ParamStr( i + 1 )[ 1 ] <> '-' ) then
      begin
        aValue := ParamStr( i + 1 );
      end;

      Exit( True );
    end;
  end;
end;

destructor TCommandLine.Destroy;
begin

end;

class function TCommandLine.GetInstance: TCommandLine;
begin
  if not ( Assigned( FInstance ) ) then
  begin
    FInstance := TCommandLine.Create;
  end;

  Result := FInstance;
end;

procedure TCommandLine.Help;
begin
  Writeln( 'AssetForge 0.1.0 [2026-02-21|Delphi 13|MSWindows|64]' );
  Writeln( 'Cache-safe asset hashing tool' );
  Writeln( '' );
  Writeln( 'This is a free software under MIT licence. There is NO' );
  Writeln( 'WARRANTY; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.' );
  Writeln( '' );
  if ( Length( FErrors ) > 0 ) then
  begin
    Writeln( 'Error(s) found in command line :' );

    for var i := 0 to High( FErrors ) do
    begin
      Writeln( '  - ' + FErrors[ i ] );
    end;

    Writeln( '' );
  end;
  Writeln( 'Usage : AssetForge.exe [Options] [Folders]' );
  Writeln( 'Valid options are :' );
  Writeln( '  --help: show this help' );
  Writeln( '  --dev: don''t rename assets' );
  Writeln( '  --prod: rename assets' );
  Writeln( '  --ci: run in continous integration ocntext' );
  Writeln( '  -r: origin folder' );
  Writeln( '  -d: destination folder' );
  Writeln( '  -m: path for manifest file' );

  if not ( FCI ) then
  begin
    Readln;
  end
  else
  begin
    raise Exception.Create('Error(s) found in command line');
  end;
end;

function TCommandLine.Ok: Boolean;
begin
  Exit( ( FDestinationFolder <> '' ) and ( FRepository <> '' ) and ( FManifest <> '' ) );
end;

procedure TCommandLine.SetCI( const Value: Boolean );
begin
  FCI := Value;
end;

end.

