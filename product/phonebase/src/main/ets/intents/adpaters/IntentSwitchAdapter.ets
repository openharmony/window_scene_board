/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import insightIntent from '@ohos.app.ability.insightIntent';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { FlashlightController } from '@ohos/flashlightcomponent/src/main/ets/com/ohos/controller/FlashlightController';
import { IntentCodeConstants, IntentItemConstants, INTENT_CODE } from '../utils/IntentConstants';

const TAG: string = 'IntentSwitchAdaptor'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);
const context: Context | undefined = AppStorage.get<Context>('intentPageContext');

/**
 * Query Switch Status Method Mapping
 */
const switchStatusFunRecord: Record<string, Function> = {
  'PIP_SWITCH': () => {},
  'MULTI_DOCK_SWITCH': () => {},
};

/**
 * Method mapping for enabling the configuration item
 */
const switchAvailableFunRecord: Record<string, Function> = {
  'OpenFlashlight': () => { return FlashlightController.getInstance().getSwitchAvailable(true) },
  'CloseFlashlight': () => { return FlashlightController.getInstance().getSwitchAvailable(false) },
}

/**
 * Method mapping for enabling the configuration item
 */
const setSwitchOnFunRecord: Record<string, Function> = {
  'PIP_SWITCH': () => {},
  'MULTI_DOCK_SWITCH': () => {},
}

/**
 * Method mapping for disabling the configuration item switch
 */
const setSwitchOffFunRecord: Record<string, Function> = {
  'PIP_SWITCH': () => {},
  'MULTI_DOCK_SWITCH': () => {},
}

/**
 * Method mapping for set flash light
 */
const setFlashlightFunRecord: Record<string, Function> = {
  'OpenFlashlight': () => {
    return FlashlightController.getInstance().setSwitchState(true)
  },
  'CloseFlashlight': () => {
    return FlashlightController.getInstance().setSwitchState(false)
  },
}

const SWITCH_ON: number = 0;
const SWITCH_OFF: number = 1;

/**
 * Intention Framework Operation Setting Switch Transfer Class
 *
 * @since 2024-05-23
 */
export class IntentSwitchAdaptor {
  public static getSettingSwitch(itemName: string, appBundleName: string): insightIntent.ExecuteResult {
    let switchFlag: number = IntentSwitchAdaptor.getSwitchStatus(itemName) ? SWITCH_ON : SWITCH_OFF;
    let rsp: Record<string, Object> = {
      'itemName': itemName,
      'appBundleName': appBundleName,
      'switchFlag': switchFlag,
    }
    let defaultRsp: insightIntent.ExecuteResult = {
      code: IntentCodeConstants.DEFAULT_CODE_SUCCESS,
      result: rsp,
    }
    return defaultRsp;
  }

  public static setSettingSwitch(itemName: string, appBundleName: string, switchFlag: number):
    insightIntent.ExecuteResult {
    let rsp: Record<string, Object> = {
      'itemName': itemName,
      'switchFlag': switchFlag,
      'appBundleName': appBundleName,
    }
    let defaultRsp: insightIntent.ExecuteResult = {
      code: IntentCodeConstants.DEFAULT_CODE_SUCCESS,
      result: rsp,
    }

    if (switchFlag === SWITCH_ON) {
      if (IntentSwitchAdaptor.getSwitchStatus(itemName)) {
        log.showInfo(`switch: ${itemName} has already turn on`);
        return defaultRsp;
      } else {
        if (IntentSwitchAdaptor.setSwitchOn(itemName)) {
          log.showInfo(`switch: ${itemName} turn on success`);
          return defaultRsp;
        }
      }
    } else if (switchFlag === SWITCH_OFF) {
      if (!IntentSwitchAdaptor.getSwitchStatus(itemName)) {
        log.showInfo(`switch: ${itemName} has already turn off`);
        return defaultRsp;
      } else {
        if (IntentSwitchAdaptor.setSwitchOff(itemName)) {
          log.showInfo(`switch: ${itemName} turn off success`);
          return defaultRsp;
        }
      }
    }
    let errorRsp: insightIntent.ExecuteResult = {
      code: IntentCodeConstants.DEFAULT_CODE_UNSUPPORTED,
      result: {
        errMsg: INTENT_CODE[IntentCodeConstants.DEFAULT_CODE_UNSUPPORTED]
      },
    }
    return errorRsp;
  }

  /**
   * Obtains the real-time status of the switch.
   */
  public static getSwitchStatus(itemName: string): boolean {
    let switchStatus: boolean = switchStatusFunRecord[itemName]();
    log.showInfo(`Get setting switch status, itemName: ${itemName}, status: ${switchStatus}`);
    return switchStatus;
  }

  public static setFlashlight(intentName: string): insightIntent.ExecuteResult {
    let isOpen: boolean = intentName === IntentItemConstants.FLASH_LIGHT_OPEN;
    log.showInfo(`setFlashlight: ${intentName}, isOpen: ${isOpen}`);
    let rsp: Record<string, Object> = {
      'intentName': intentName,
    }
    let defaultRsp: insightIntent.ExecuteResult = {
      code: IntentCodeConstants.DEFAULT_CODE_FAILED,
      result: rsp,
    }
    let switchAvailableCode: IntentCodeConstants = switchAvailableFunRecord[intentName]();
    if (switchAvailableCode != IntentCodeConstants.DEFAULT_CODE_SUCCESS) {
      return {
        code: switchAvailableCode,
        result: rsp,
      } as insightIntent.ExecuteResult
    }
    if (setFlashlightFunRecord[intentName]()) {
      return {
        code: IntentCodeConstants.DEFAULT_CODE_SUCCESS,
        result: rsp,
      } as insightIntent.ExecuteResult
    }
    return defaultRsp;
  }

  /**
   * Turning on the switch of a specific setting item
   */
  public static setSwitchOn(itemName: string): boolean {
    let turnOnRsp: boolean = setSwitchOnFunRecord[itemName]();
    log.showInfo(`Turn on setting switch, itemName: ${itemName}, operation rsp: ${turnOnRsp}`);
    return turnOnRsp;
  }

  /**
   * Turn off the switch of a specific setting item.
   */
  public static setSwitchOff(itemName: string): boolean {
    let turnOffRsp: boolean = setSwitchOffFunRecord[itemName]();
    log.showInfo(`Turn off setting switch, itemName: ${itemName}, operation rsp: ${turnOffRsp}`);
    return turnOffRsp;
  }
}


