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

import {
  LogHelper,
  LogDomain,
  SingletonHelper,
} from '@ohos/basicutils';
import {
  PluginClickInfo,
  sEventManager,
  obtainLocalEvent,
  DeviceHelper,
  obtainStartAbilityWithWant,
  GlobalContext,
} from '@ohos/frameworkwrapper';
import { StartAbilityUtilAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/StartAbilityUtilAdapter';
import { FASlotName, ExtAppConstants } from '@ohos/commonconstants';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { EventManagerAdapter } from '@ohos/systemuicommon';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { ToggleStyle } from '@ohos/controlcentercommon/src/main/ets/toggle/interface/ToggleStyle';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import StartOptions from '@ohos.app.ability.StartOptions';

const TAG = 'Model.DpinToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export class DpinToggleController extends ToggleBaseViewModel {

  private mdName: string = 'pc_settings';

  startService(): void {
    try {
      sEventManager.publish(obtainLocalEvent('hideControlPanel', ''));
      const want: Want = {
        bundleName: 'com.ohos.exfusiondisplay',
        abilityName: 'EntryAbility',
        parameters: {
          entrance: 'controlCenter',
        }
      };
      const option: StartOptions = {
        windowMode: AbilityConstant.WindowMode.WINDOW_MODE_FULLSCREEN,
      };

      let context = GlobalContext.getContext();
      if (!context) {
        log.showError(`${TAG} getContext failed`);
        return;
      }
      context.startAbility(want, option);

    } catch (error) {
      log.showError(`startAbility com.ohos.exfusiondisplay EntryAbility failed, message is ${error?.message}`);
    }
  }

  public startServiceFunc: (() => void) | undefined = () => {
    try {
      log.showInfo('go display_settings');
      EventManagerAdapter.startAbility(obtainStartAbilityWithWant({
        bundleName: ExtAppConstants.ABILITY_SETTINGS_BUNDLENAME,
        abilityName: ExtAppConstants.ABILITY_SETTINGS_ABILITYNAME,
        uri: 'display_settings',
        moduleName: this.mdName,
      }));
      DropDownPanelManager.hideWindowDirectly();
    } catch (error) {
      log.showError(`startAbility display_settings failed, message is ${error?.message}`);
    }
  }

  constructor() {
    super();
    this.getViewData().label = $r('app.string.control_center_complex_toggle_dpin_title');
    this.getViewData().icon = $r('sys.symbol.desktop_site');
  }

  decorateStyle(style: ToggleStyle): ToggleStyle | undefined {
    style.toggleParam?.isSymbolIcon(true)
      .symbolRendering(SymbolRenderingStrategy.MULTIPLE_COLOR)
    return style;
  }

  isLoadLottie(): boolean {
    return true;
  }

  isDarkReverse(): boolean {
    return true;
  }

  onStart(): void {
    super.onStart();
    log.showInfo('onStart');
  }

  isAvailable(): boolean {
    return false;
  }

  handleOneClick(): void {
    this.startService();
  }
}