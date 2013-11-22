object Dm: TDm
  OldCreateOrder = False
  Height = 229
  Width = 347
  object Aguia: TSQLConnection
    ConnectionName = 'Aguia'
    DriverName = 'MSSQL'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=MSSQL'
      'SchemaOverride=%.dbo'
      'DriverUnit=Data.DBXMSSQL'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DBXCommonDriver190.' +
        'bpl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=19.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXMsSqlMetaDataCommandFactory,DbxMSSQLDr' +
        'iver190.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXMsSqlMetaDataCommandFact' +
        'ory,Borland.Data.DbxMSSQLDriver,Version=19.0.0.0,Culture=neutral' +
        ',PublicKeyToken=91d62ebb5b0d1b1b'
      'LibraryName=dbxmss.dll'
      'VendorLib=sqlncli10.dll'
      'VendorLibWin64=sqlncli10.dll'
      'HostName=192.168.0.10,1033'
      'Database=Aguia_Sia'
      'MaxBlobSize=-1'
      'LocaleCode=0000'
      'IsolationLevel=ReadCommitted'
      'OSAuthentication=False'
      'PrepareSQL=True'
      'User_Name=sa'
      'Password=G@sol2010'
      'BlobSize=-1'
      'ErrorResourceFile='
      'OS Authentication=False'
      'Prepare SQL=False')
    Connected = True
    Left = 31
    Top = 19
  end
  object SPConsUm: TSQLStoredProc
    SchemaName = 'dbo'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = Aguia
    Left = 113
    Top = 20
  end
  object iTEF: TSQLConnection
    ConnectionName = 'iTEF'
    DriverName = 'SQLite'
    LoginPrompt = False
    Params.Strings = (
      'DriverName=SQLite'
      'DriverUnit=Data.DbxSqlite'
      
        'DriverPackageLoader=TDBXSqliteDriverLoader,DBXSqliteDriver170.bp' +
        'l'
      
        'MetaDataPackageLoader=TDBXSqliteMetaDataCommandFactory,DbxSqlite' +
        'Driver170.bpl'
      'FailIfMissing=False'
      
        'Database=C:\Users\gilson.delima\Documents\GitHub\Cascol\iTEF\Win' +
        '32\Debug\itef.s3db')
    Connected = True
    Left = 28
    Top = 145
  end
  object SQLQry1: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = iTEF
    Left = 104
    Top = 136
  end
  object Correntistas: TSQLConnection
    ConnectionName = 'Correntista'
    DriverName = 'MSSQL'
    LoginPrompt = False
    Params.Strings = (
      'ErrorResourceFile='
      'SchemaOverride=%.dbo'
      'DriverUnit=Data.DBXMSSQL'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DBXCommonDriver190.' +
        'bpl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=19.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXMsSqlMetaDataCommandFactory,DbxMSSQLDr' +
        'iver190.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXMsSqlMetaDataCommandFact' +
        'ory,Borland.Data.DbxMSSQLDriver,Version=19.0.0.0,Culture=neutral' +
        ',PublicKeyToken=91d62ebb5b0d1b1b'
      'GetDriverFunc=getSQLDriverMSSQL'
      'LibraryName=dbxmss.dll'
      'VendorLib=sqlncli10.dll'
      'VendorLibWin64=sqlncli10.dll'
      'HostName=192.168.0.10,1033'
      'Database=Correntista'
      'MaxBlobSize=-1'
      'LocaleCode=0000'
      'IsolationLevel=ReadCommitted'
      'OSAuthentication=False'
      'PrepareSQL=True'
      'User_Name=sa'
      'Password=G@sol2010'
      'BlobSize=-1'
      'OS Authentication=False'
      'Prepare SQL=False'
      'DriverName=MSSQL')
    Connected = True
    Left = 31
    Top = 83
  end
  object SPCorrUm: TSQLStoredProc
    SchemaName = 'dbo'
    MaxBlobSize = -1
    Params = <>
    SQLConnection = Correntistas
    Left = 113
    Top = 84
  end
end
