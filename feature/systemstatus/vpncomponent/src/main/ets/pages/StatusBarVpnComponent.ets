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
import { PluginSlot } from '@ohos/frameworkwrapper';
import { VpnData } from '../common/Constants';
import StyleConfiguration from '../common/StyleConfiguration';
import { StatusBarVpnComponentStyle } from '../common/StyleConfiguration';
import controller from '../controller/VpnController';
import { AccessibilityVm } from '@ohos/systemuicommon/newIndex';
import { GlobalContext } from '@ohos/frameworkwrapper';
// instrument ignore file

const TAG = 'vpn-StatusBarIconItemVpnComponent';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const COMPONENT_ID = TAG + '_Image_icon';

@Component
export default struct StatusBarVpnComponent {
  @State mVpnData: VpnData = controller.getData();
  @State style: StatusBarVpnComponentStyle = StyleConfiguration.getStatusBarVpnComponentStyle();
  @Consume contentColor: string;

  aboutToAppear(): void {
    log.showInfo('aboutToAppear vpn');
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear vpn');
  }

  build() {
    Row() {
      Image($r('app.media.ic_status_bar_vpn'))
        .matchTextDirection(true)
        .draggable(false)
        .objectFit(ImageFit.Contain)
        .width(this.style.staticBarVpnWidth)
        .height(this.style.staticBarVpnHeight)
        .fillColor(this.contentColor)
        .id(COMPONENT_ID)
    }
    .height('100%')
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
  }

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled || !this.mVpnData.isConnected) {
      return '';
    }
    const res = GlobalContext.getContext()?.resourceManager;
    return res.getStringByNameSync('accessibility_status_bar_vpn_connected');
  }
}