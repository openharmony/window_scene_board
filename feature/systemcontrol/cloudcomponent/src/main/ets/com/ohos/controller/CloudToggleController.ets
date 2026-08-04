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

import { PluginClickInfo } from '@ohos/frameworkwrapper';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { FASlotName } from '@ohos/commonconstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { performanceMonitor } from '@kit.ArkUI';
import { BusinessError, systemParameterEnhance } from '@kit.BasicServicesKit';

const TAG = 'Ctrl.CloudToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const CLOUD_CCM_CONFIG = 'const.cloud.feature_enable';
const CLOUD_MODE = 'ohos.boot.minisys.mode';
const WINDOW_HEIGHT = 272;

export class CloudToggleController extends ToggleBaseViewModel {

  private isMinisysMode: boolean = false;
  private static instance?: CloudToggleController = undefined;

  constructor() {
    super();
    this.getViewData().label = $r('app.string.cloud_lai');
    this.getViewData().icon = $r('sys.symbol.satellite');
  }

  handleOneClick(): void {
    this.openDetailPageFunc();
  }

  public openDetailPageFunc: (() => void) = () => {
    this.handleOnControlCenterWithScreenLockForUIE(
      ():void => this.showCloudSubWindow(FASlotName.CLOUD), true);
  }

  onStart(): void {
    try {
      this.isMinisysMode = systemParameterEnhance.getSync(CLOUD_MODE, '') === 'cloud';
    } catch (error) {
      let message = (error as BusinessError).message;
      let code = (error as BusinessError).code;
      log.error(TAG, `ControlCenterPage aboutToAppear error code is ${code}, message is ${message}`);
    }
    this.getViewData().isOn = this.isMinisysMode;
  }

  decorateStyle(style: ToggleStyle): ToggleStyle | undefined {
    style.toggleParam?.isSymbolIcon(true)
    return style;
  }

  isAvailable(): boolean {
    let isSupport: string = 'false';
    try {
      isSupport = systemParameterEnhance.getSync(CLOUD_CCM_CONFIG, 'false');
    } catch (error) {
      log.showError('get cloudMode fail', error);
    }
    let isEnable = isSupport === 'true';
    return isEnable;
  }

  private showCloudSubWindow(slot: string): void {
    performanceMonitor.begin('INTO_CC_SUB_WIFI_ANI', performanceMonitor.ActionType.LAST_UP);
    sToggleSubWindowController.showSubWindowByClickInfo(FASlotName.CLOUD, {
      clickType: 'window',
      bundleName: 'com.ohos.cloudmodeassistant',
      abilityName: 'CloudControCenterUIAbility',
      uiExtensionType: 'sys/commonUI',
      windowHeight: WINDOW_HEIGHT
    } as PluginClickInfo);
  }
}