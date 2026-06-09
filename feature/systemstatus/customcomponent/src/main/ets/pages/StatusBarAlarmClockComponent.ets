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

import { LogDomain, Logger } from '@ohos/basicutils';
import { GlobalContext, PluginSlot } from '@ohos/frameworkwrapper';
import { AlarmClockData } from '../common/Constants';
import { StatusBarAlarmClockController } from '../vm/StatusBarAlarmClockController'
import { AccessibilityVm } from '@ohos/systemuicommon/newIndex';

const TAG = 'StatusBarAlarmClock';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);
const COMPONENT_ID = TAG + '_Image_icon';
const controller: StatusBarAlarmClockController = StatusBarAlarmClockController.get();

@Component
export default struct StatusBarAlarmClockComponent {
  @State mAlarmClockData: AlarmClockData = controller.getData();
  @Consume contentColor: string;

  aboutToAppear(): void {
    log.showInfo(TAG, 'aboutToAppear StatusBarAlarmClock');
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, 'aboutToDisappear StatusBarAlarmClock');
  }

  build() {
    Row() {
      Image($r('app.media.ic_statusbar_alarm'))
        .draggable(false)
        .objectFit(ImageFit.Contain)
        .height($r('app.float.statusbar_alarm_clock_height'))
        .fillColor(this.contentColor)
        .id(COMPONENT_ID)
    }
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
    .height('100%')
  }

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled || !this.mAlarmClockData.isAlarmClockExist) {
      return '';
    }
    let accessibilityText = '';
    try {
      const res = GlobalContext.getContext()?.resourceManager;
      accessibilityText = res.getStringByNameSync('accessibility_quick_settings_alarm_set');
    } catch (err) {
      log.showError(TAG, `getAccessibilityText failed, err: ${err.message}`);
    }
    return accessibilityText;
  }
}