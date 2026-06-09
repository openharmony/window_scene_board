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
import controller from '../controller/NfcController';
import { StyleConfigurationCommon, CommonStyle } from '@ohos/systemuicommon/Index';
import StyleConfiguration, { StatusNfcComponentStyle } from '../common/StyleConfiguration';
import { ImageIconModifier } from '@ohos/systemuicommon/Index';
import { GlobalContext, PluginSlot } from '@ohos/frameworkwrapper';
import { ToggleViewData } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleViewData';
import { AccessibilityVm } from '@ohos/systemuicommon/newIndex';
// instrument ignore file

const TAG = 'NfcData-StatusBarIconItemNFCModeComponent';
const COMPONENT_ID_NFC = TAG + '_Image_nfc';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

@Component
export default struct StatusBarIconItemNFCModeComponent {
  @StorageProp('NfcModel_NfcStatus') mNfcData: ToggleViewData = controller.getViewData();
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  @State style: StatusNfcComponentStyle = StyleConfiguration.getStatusNfcComponentStyle();

  /**
   * 内容颜色
   */
  @Consume @Watch('onContentColorChange') contentColor: string;

  private imageModifier: ImageIconModifier = new ImageIconModifier(COMPONENT_ID_NFC);

  onContentColorChange(): void {
    log.info(TAG, `onContentColorChange ${this.contentColor}`);
    this.imageModifier?.modifyContentColor(this.contentColor);
  }

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled || !this.mNfcData.isOn) {
      return '';
    }
    const res = GlobalContext.getContext()?.resourceManager;
    return res.getStringByNameSync('accessibility_status_bar_nfc_open');
  }

  aboutToAppear() {
    this.imageModifier.initContentColor(this.contentColor);
    log.showInfo(TAG, 'aboutToAppear');
  }

  aboutToDisappear() {
    log.showInfo(TAG, 'aboutToDisappear');
  }

  build() {
    Row() {
      Image($r('app.media.ic_statusbar_nfc'))
        .attributeModifier(this.imageModifier)
        .draggable(false)
        .id(COMPONENT_ID_NFC)
        .objectFit(ImageFit.Contain)
        .width(this.style.statusBarNfcWidth)
        .height(this.style.statusBarNfcHeight)
    }
    .height('100%')
    .opacity($r('app.float.icon_component_opacity'))
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
  }
}