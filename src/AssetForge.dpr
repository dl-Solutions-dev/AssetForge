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
  File last update : 2026-02-21T23:41:26.000+01:00
  Signature : 8315acbb8c5e1f000a42d29d263043c71b892176
  ***************************************************************************
*)

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

