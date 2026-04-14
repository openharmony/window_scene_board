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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import statusBarSuperPrivacyController from '../controller/StatusBarSuperPrivacyController';
import StyleConfiguration, { StartsBarSuperPrivacyComponentStyle } from '../common/StyleConfiguration';
import { SuperPrivacyModeData } from '../common/Constants';
import { GlobalContext, PluginSlot } from '@ohos/frameworkwrapper';
import { AccessibilityVm } from '@ohos/systemuicommon/newIndex';

const TAG = 'StatusBarSuperPrivacyPage';
const COMPONENT_ID_STATUSBARSUPERPRIVACY = 'StatusBarSuperPrivacyComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Component
export default struct StatusBarSuperPrivacyComponent {
  @State superPrivacyModeData: SuperPrivacyModeData = statusBarSuperPrivacyController.getData();
  @State style: StartsBarSuperPrivacyComponentStyle = StyleConfiguration.getStartsBarSuperPrivacyComponentStyle();
  @Consume contentColor: string;

  aboutToAppear(): void {
    log.showInfo(`StatusBarSuperPrivacyPage aboutToAppear`);
  }

  aboutToDisappear(): void {
    log.showInfo(`StatusBarSuperPrivacyPage aboutToDisappear`);
  }

  build() {
    Row() {
      Image($r('app.media.key_shield_fill'))
        .draggable(false)
        .id(COMPONENT_ID_STATUSBARSUPERPRIVACY)
        .objectFit(ImageFit.Contain)
        .width(this.style.statusBarSuperPrivacyWidth)
        .height(this.style.statusBarSuperPrivacyHeight)
        .fillColor(this.contentColor)
    }
    .height('100%')
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
  }

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled || !this.superPrivacyModeData.isSuperPrivacyMode) {
      return '';
    }
    const res = GlobalContext.getContext()?.resourceManager;
    return res.getStringByNameSync('accessibility_status_bar_super_privacy_open');
  }
}