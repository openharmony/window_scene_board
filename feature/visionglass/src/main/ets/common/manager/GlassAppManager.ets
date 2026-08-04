/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EvtBus, AbilityStateChangedEvent } from '@ohos/frameworkwrapper';
import { AbilityState } from '@ohos/systemuicommon';
import { BusinessError } from '@kit.BasicServicesKit';
import xrGlassesAppService from '@hms.xrGlassesService.xrGlassesAppService';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'GlassAppManager');

export class GlassAppManager {
  public static instance: GlassAppManager | undefined = undefined;
  public readonly glassName: string = 'com.ohos.visionglass';
  public readonly abilityName: string = 'AppCenterAbility'
  public visionGlassStatus: number | null = null;
  private glassStatusChangeCallback = (event: AbilityStateChangedEvent): void => {
    if (event.bundleName === this.glassName && event.state === AbilityState.ABILITY_STATE_TERMINATED &&
      event.abilityName === this.abilityName) {
      log.showInfo(`GlassAppStatusChangeEvent state is ${event.state}`);
      try {
        const MIRROR_MODE_ID: number = 0;
        xrGlassesAppService.setSpaceMode(MIRROR_MODE_ID)
          .then((result: number) => {
            log.showInfo(`setSpaceMode mirror success,result is ${result}`);
          })
          .catch((err: BusinessError) => {
            log.showError(`setSpaceMode mirror fail,error is ${err.code}`);
          })
      } catch (err) {
        log.showError(`setSpaceMode mirror fail2,error is ${err.code}`);
      }
    }
  }

  /*
   * 注册app状态变化监听回调
   * */
  public registerAppStatusListener(): void {
    log.showInfo(`registerAppStatusListener`);
    EvtBus.on(AbilityStateChangedEvent, this.glassStatusChangeCallback);
  }

  /*
   * 注销app状态变化监听回调
   * */
  public unRegisterAppStatusListener(): void {
    log.showInfo(`unRegisterAppStatusListener`);
    EvtBus.off(AbilityStateChangedEvent, this.glassStatusChangeCallback);
    GlassAppManager.destroyInstance();
  }

  /*
   * 获取当前类单例
   * */
  public static getInstance(): GlassAppManager {
    if (!GlassAppManager.instance) {
      log.showInfo(`getInstance new instance`);
      GlassAppManager.instance = new GlassAppManager();
    }
    return GlassAppManager.instance;
  }

  /*
   * 销毁当前单例
   * */
  public static destroyInstance(): void {
    log.showInfo(`destroyInstance`);
    GlassAppManager.instance = undefined;
  }
}