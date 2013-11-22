object WebModule1: TWebModule1
  OldCreateOrder = False
  Actions = <
    item
      Default = True
      Name = 'WebActionMenuPri'
      PathInfo = '/'
      OnAction = WebModule1DefaultHandlerAction
    end
    item
      Name = 'ADMINISTRATIVO'
      PathInfo = '/ADM'
      OnAction = WebModule1ADMINISTRATIVOAction
    end
    item
      Name = 'EFETIVA_PGTO_BICO'
      PathInfo = '/EFETIVA_PGTO_BICO'
      OnAction = WebModule1EFETIVA_PGTO_BICOAction
    end
    item
      Name = 'SITEF'
      PathInfo = '/SITEF'
    end
    item
      Name = 'SELECIONA_OPCAO'
      PathInfo = '/SELECIONA_OPCAO'
      OnAction = WebModule1SELECIONA_OPCAOAction
    end
    item
      Name = 'SELECIONA_NRO_CAR'
      PathInfo = '/SELECIONA_NRO_CAR'
    end
    item
      Name = 'CONFIRMA_PGTO_BICO'
      PathInfo = '/CONFIRMA_PGTO_BICO'
      OnAction = WebModule1CONFIRMA_PGTO_BICOAction
    end
    item
      Name = 'CONTINUA_PGTO_BICO'
      PathInfo = '/CONTINUA_PGTO_BICO'
    end
    item
      Name = 'CANCELAR_CUPOM'
      PathInfo = '/CANCELAR_CUPOM'
      OnAction = WebModule1CANCELAR_CUPOMAction
    end
    item
      Name = 'INFORMA_PGTO'
      PathInfo = '/INFORMA_PGTO'
      OnAction = WebModule1INFORMA_PGTOAction
    end
    item
      Name = 'CONFIRMA_PGTO_CAR'
      PathInfo = '/CONFIRMA_PGTO_CAR'
    end
    item
      Name = 'SELECIONA_MENU_PRI'
      PathInfo = '/SELECIONA_MENU_PRI'
      OnAction = WebModule1SELECIONA_MENU_PRIAction
    end
    item
      Name = 'EFETIVA_PGTO_CAR'
      PathInfo = '/EFETIVA_PGTO_CAR'
    end
    item
      Name = 'INFORMA_PGTO_CAR'
      PathInfo = '/INFORMA_PGTO_CAR'
    end
    item
      Name = 'RETORNO_ADM_SITEF'
      PathInfo = '/RETORNO_ADM_SITEF'
      OnAction = WebModule1RETORNO_ADM_SITEFAction
    end
    item
      Name = 'MENU_FISCAL_FUNC'
      PathInfo = '/MENU_FISCAL_FUNC'
      OnAction = WebModule1MENU_FISCAL_FUNCAction
    end>
  Height = 230
  Width = 415
end
