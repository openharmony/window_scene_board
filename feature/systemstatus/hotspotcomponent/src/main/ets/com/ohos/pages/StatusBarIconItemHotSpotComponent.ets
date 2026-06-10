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
import { HotSpotController } from '../controller/HotSpotController';
import { StyleConfigurationCommon, CommonStyle } from '@ohos/systemuicommon/Index';
import StyleConfiguration, { StatusBarHotSpotComponentStyle } from '../common/StyleConfiguration';
import { HotSpotData } from '../common/Constants';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { AccessibilityVm, ResourceVm } from '@ohos/systemuicommon/newIndex';

const TAG = 'HotSpot-StatusBarIconItemHotSpotComponent';
const COMPONENT_ID = TAG + '_Image_HotSpot';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Component
export default struct StatusBarIconItemHotSpotComponent {
  @State mHotSpotData: HotSpotData = HotSpotController.getInstance().getData();
  @State styleCommon: CommonStyle = StyleConfigurationCommon.getCommonStyle();
  @State style: StatusBarHotSpotComponentStyle = StyleConfiguration.getStatusBarHotSpotComponentStyle();
  /**
   * 内容颜色
   */
  @Consume contentColor: string;

  aboutToAppear() {
    log.showInfo('aboutToAppear');
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  onHotSpotDataChange() {
    log.showInfo('mHotSpotData change: ' + this.mHotSpotData.connectNum);
  }

  private getAccessibilityText(): string {
    if (!AccessibilityVm.instance.isEnabled || !this.mHotSpotData) {
      return '';
    }
    let accessibilityText: string = '';
    try {
      const res = GlobalContext.getContext()?.resourceManager;
      accessibilityText = res.getStringByNameSync('statusbar_talkbackhotspot01');
      if (this.mHotSpotData.connectNum > 0) {
        accessibilityText += ', ' + res.getPluralStringValueSync($r('app.plural.statusbar_talkbackhotspot02'),
          this.mHotSpotData.connectNum);
      }
    } catch (error) {
      log.showError(`getStringByNameSync failed, code = ${error.code}, message = ${error.message}`);
    }
    return accessibilityText;
  }

  build() {
    Stack({ alignContent: Alignment.Start }) {
      Image($r('app.media.ic_statusbar_hotspot'))
        .draggable(false)
        .id(COMPONENT_ID)
        .objectFit(ImageFit.Contain)
        .width(this.style.statusBarHotSpotWidth)
        .height(this.style.statusBarHotSpotHeight)
        .fillColor(this.contentColor)
        .opacity($r('app.float.icon_component_opacity'))
        .onError((error) => {
          log.showError('Load hot spot image error, message: ' + error?.message);
        })
      if (this.mHotSpotData.connectNum > 0) {
        Image(ResourceVm.instance.isRTL ? $r(`app.media.ic_statusbar_mirror_${this.mHotSpotData.connectNum}`) : $r(`app.media.ic_statusbar_${this.mHotSpotData.connectNum}`))
          .draggable(false)
          .objectFit(ImageFit.Contain)
          .width(this.style.statusBarHotSpotWidthWithNumber)
          .height(this.style.statusBarHotSpotHeight)
          .fillColor(this.contentColor)
          .opacity($r('app.float.icon_component_opacity'))
          .onError((error) => {
            log.showError(`Load hot spot image error, connectNum: ${this.mHotSpotData.connectNum}` +
              `, message: ${error?.message}`);
          })
      }
    }
    .height('100%')
    .accessibilityGroup(AccessibilityVm.instance.isEnabled)
    .accessibilityLevel('yes')
    .accessibilityText(this.getAccessibilityText())
  }
}