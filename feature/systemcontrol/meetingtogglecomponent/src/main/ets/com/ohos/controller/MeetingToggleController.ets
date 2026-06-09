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
} from '@ohos/basicutils';
import {
  PluginClickInfo,
  sEventManager,
  obtainLocalEvent,
} from '@ohos/frameworkwrapper';
import { StartAbilityUtilAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/StartAbilityUtilAdapter';
import { FASlotName } from '@ohos/commonconstants';
import { sToggleSubWindowController } from '@ohos/controlcentercommon/src/main/ets/windowmanager/ToggleSubWindowController';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';

const TAG = 'Model.MeetingToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export class MeetingToggleController extends ToggleBaseViewModel {

  public startServiceFunc: (() => void) = () => {
    sEventManager.publish(obtainLocalEvent('hideControlPanel', ''));
  }

  constructor() {
    super();
    this.getViewData().label = '';
    this.getViewData().icon = $r('app.media.ic_meeting');
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
    return true;
  }

  handleOneClick(): void {
    this.startServiceFunc();
  }

  openMeetingSubPanel(): void {
    sToggleSubWindowController.showSubWindowByClickInfo(FASlotName.MEETING, {
      clickType: 'window',
      bundleName: 'com.ohos.settings',
      abilityName: 'MeetingUIExtensionSettingsAbility',
      uiExtensionType: 'sys/commonUI',
      windowHeight: 370
    } as PluginClickInfo);
  }
}
