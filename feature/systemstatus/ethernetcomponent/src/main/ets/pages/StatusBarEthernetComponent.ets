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
import { LogDomain, Logger } from '@ohos/basicutils';
import { GlobalContext, PluginSlot } from '@ohos/frameworkwrapper';
import { EthernetData } from '../common/Constants';
import { StatusBarEthernetController } from './../controller/StatusBarEthernetController'
import { AccessibilityVm } from '@ohos/systemuicommon/newIndex';

const TAG = 'StatusBarIconItemEthernetComponent';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);
const COMPONENT_ID = TAG + '_Image_icon';
const controller: StatusBarEthernetController = StatusBarEthernetController.get();

@Component
export default struct StatusBarEthernetComponent {
  @State mEthernetData: EthernetData = controller.getData();
  @Consume contentColor: string;
  @StorageProp('isEthernetNetworkValidated') isEthernetNetworkValidated: boolean = false;

  build() {
    Row() {
      Image(this.isEthernetNetworkValidated ? $r('app.media.ic_statusbar_wirednetworks') :
        $r('app.media.ic_statusbar_wirednetworks_exception'))
        .draggable(false)
        .objectFit(ImageFit.Contain)
        .height($r('app.float.statusbar_ethernet_height'))
        .fillColor(this.contentColor)
        .id(COMPONENT_ID)
    }
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
    .height('100%')
  }

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled || !this.mEthernetData.isConnected) {
      return '';
    }
    let accessibilityText = '';
    try {
      const res = GlobalContext.getContext()?.resourceManager;
      accessibilityText = this.isEthernetNetworkValidated ? res.getStringByNameSync('accessibility_ethernet_connected') :
        res.getStringByNameSync('accessibility_ethernet_disconnected');
    } catch (err) {
      log.showError(TAG, `getAccessibilityText failed, err: ${err.message}`);
    }
    return accessibilityText;
  }
}