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
import { PrivacySensorViewData } from '../../model/PrivacySensorViewData';
import { PrivacySensorViewModel } from '../../viewModel/PrivacySensorViewModel';
import {
  PRIVACY_SENSOR_OFFSET_COMPACT,
} from '../../common/Constants';
import { ConfigurationEvent, EvtBus } from '@ohos/frameworkwrapper';
import { ControlCenterLayoutIndex, CC_LAYOUT_CONFIGS } from '../../controller/ControlCenterLayoutController';
import { ControlCenterAnimationData } from '../../model/ControlCenterAnimationData';
import StyleConfiguration, { ToggleLabelStyle } from '@ohos/systemuicommon/src/main/ets/template/common/StyleConfiguration';
import { LengthMetrics, MeasureText } from '@kit.ArkUI';
import DropDownPanelManager, { PanelDismissReason } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import PrivacySensorComponent from './PrivacySensorComponent';
import MultimediaSensorComponent from './MultimediaSensorComponent';

// 设置/编辑按钮 marginTop（76） + 按钮高度的一半（40/2） - 隐私指示器高度的一半（28/2） = 82
const PRIVACY_SENSOR_DEFAULT_OFFSET = 76 + 20 - 14;
const PRIVACY_SENSOR_OFFSET_NORMAL_LANDSCAPE: number =
  PRIVACY_SENSOR_DEFAULT_OFFSET;

@Component
export default struct PrivacySensor {
  private eventMgr = EvtBus.createEventManager();
  @State fontStyle: ToggleLabelStyle = StyleConfiguration.getToggleLabelStyle();
  @Consume privacySensorData: PrivacySensorViewData;
  @Consume ccLayoutIndex: ControlCenterLayoutIndex;
  viewModel: PrivacySensorViewModel = PrivacySensorViewModel.getInstance(this.privacySensorData);
  @ObjectLink animationData: ControlCenterAnimationData;
  @StorageLink('controlCenterFontScale') controlCenterFontScale: number = 1;

  aboutToAppear() {
    this.eventMgr.on(ConfigurationEvent, this.viewModel.languageChangeListener);
    this.viewModel.initData();
  }

  aboutToDisappear() {
    this.eventMgr.offAll();
  }

  build() {
    Row({ space: 12 }) {
      MultimediaSensorComponent({ animationData: this.animationData });
      PrivacySensorComponent({ animationData: this.animationData });
    }
    .margin(this.getPrivacySensorPanelMargin())
    .padding({ start: LengthMetrics.vp(8), end: LengthMetrics.vp(8) })
    .offset({ y: this.ccLayoutIndex !== ControlCenterLayoutIndex.NORMAL_LANDSCAPE ?
      PRIVACY_SENSOR_OFFSET_NORMAL_LANDSCAPE : 27 })
    .height(this.privacySensorData.privacySensorHeight)
    .width(this.getPrivacySensorPanelWidth())
    .justifyContent(FlexAlign.Center)
    .gesture(GestureGroup(GestureMode.Exclusive,
      TapGesture().onAction((event?: GestureEvent): void => {
        if (this.ccLayoutIndex === ControlCenterLayoutIndex.NORMAL_LANDSCAPE) {
          return;
        }
        DropDownPanelManager.setDismissReason(PanelDismissReason.CLICK_BLANK);
        DropDownPanelManager.onTapAction(event);
      }),
      PanGesture()
        .onActionStart((event?: GestureEvent): void => {
          DropDownPanelManager.onPanActionStart(event);
        })
        .onActionUpdate((event?: GestureEvent): void => {
          DropDownPanelManager.onPanActionUpdate(event);
        })
        .onActionEnd((event?: GestureEvent): void => {
          DropDownPanelManager.onPanActionEnd(event as GestureEvent,
            this.ccLayoutIndex === ControlCenterLayoutIndex.NORMAL_LANDSCAPE);
        })))
    .opacity(this.animationData.opacity)
    .translate({ y: this.animationData.itemTranslate + Math.max(this.animationData.translate, 0) })
    .scale({
      x: this.animationData.scale,
      y: this.animationData.scale
    })
    .accessibilityLevel('no')
    .focusable(this.privacySensorData.isApplicationInterview)
  }

  @Styles
  imageSizeStyle() {
    .width(this.privacySensorData.privacySensorImgSize)
    .height(this.privacySensorData.privacySensorImgSize)
  }

  private getPrivacySensorPanelWidth(): number | string {
    let panelWidth: number = Number(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.mainPanelWidth);
    if (isNaN(panelWidth)) {
      panelWidth = 320;
    }
    if (this.ccLayoutIndex === ControlCenterLayoutIndex.NORMAL_PORTRAIT) {
      // 直板机竖屏: 80(减去俩按钮宽度) - 16()
      return panelWidth - 80 - 16;
    } else if (this.ccLayoutIndex === ControlCenterLayoutIndex.NORMAL_LANDSCAPE) {
      // 直板机横屏，折叠屏外屏横屏： 无按钮，不需要额外减去宽度
      return panelWidth;
    }
    // 其他场景，默认减去俩个按钮的宽度
    return panelWidth - 80;
  }

  private getPrivacySensorPanelMargin(): Margin | Length | undefined {
    if (this.ccLayoutIndex === ControlCenterLayoutIndex.FOLD_EXPANDED ||
      this.ccLayoutIndex === ControlCenterLayoutIndex.PAD) {
      // 平板和 折叠屏内屏，margin 额外 + 40(一个按钮宽度)
      let margin = CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.mainPanelMargin as Margin;
      if (margin != undefined) {
        return { right: margin.right as number + 40};
      }
    }
    // 其余场景 undefined
    return undefined;
  }
}
