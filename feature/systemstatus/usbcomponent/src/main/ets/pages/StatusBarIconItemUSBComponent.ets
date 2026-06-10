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
import USBController, { USBLocalData } from '../controller/USBController';
import { CommonStyle, StyleConfigurationCommon } from '@ohos/systemuicommon/Index';
import StyleConfiguration, { StartsBarUSBComponentStyle } from '../common/StyleConfiguration';

const TAG = 'StatusBarIconUSBComponent';
const COMPONENT_ID_USB = TAG + '_Image_usb';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Component
export default struct StatusBarIconItemUSBComponent {
  @State mUSBData: USBLocalData = USBController.getData();
  @State style: StartsBarUSBComponentStyle = StyleConfiguration.getStartsBarUSBComponentStyle();
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  /**
   * 内容颜色
   */
  @Consume contentColor: string;
  private uid: string = '';

  aboutToAppear() {
    this.uid = Date.now().toString();
    log.showInfo(`aboutToAppear, uid: ${this.uid}`);
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear, uid: ${this.uid}`);
  }

  build() {
    SymbolGlyph($r('sys.symbol.externaldrive'))
      .draggable(true)
      .id(COMPONENT_ID_USB)
      .fontSize('20vp')
      .fontColor([this.contentColor])
      .fontWeight(FontWeight.Medium)
  }
}