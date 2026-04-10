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

import { ConfigurationConstant } from '@kit.AbilityKit';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import StyleConfiguration, { ToggleLabelStyle } from '@ohos/systemuicommon/src/main/ets/template/common/StyleConfiguration';
import {
  ResUtils,
  windowMgr
} from '@ohos/windowscene';
import {
  PluginPosition,
  PluginSlot,
  ConfigurationEvent,
  EvtBus,
  GlobalContext,
  WindowPositionChangeEvent,
  PluginClickInfo,
  PluginInfo,
  PluginParseInfo,
  WindowEvent,
  viewMgrPolicy
} from '@ohos/frameworkwrapper';
import {
  ControlCenterLayoutIndex
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/ControlCenterLayoutController';
import { PrivacySensorViewData } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/model/PrivacySensorViewData';
import {
  PrivacySensorViewModel,
  ControlCenterPrivacyType
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/viewModel/PrivacySensorViewModel';
import { ColorModeViewData, ColorModeViewModel, DropDownPanelManager } from '@ohos/systemuicommon/Index';
import Constants from './common/constants';
import { PrivacyEvent } from './Event/PrivacyEvent';
import { ControlCenterPluginMgr } from '@ohos/controlcentercommon/src/main/ets/base/ControlCenterPluginMgr';
import { WindowConstants } from '@ohos/commonconstants';
import { ControlCenterHiSysEventUtil } from '@ohos/controlcentercommon/src/main/ets/hiSysEvent/ControlCenterHiSysEventUtil';

const TAG = 'privacySensor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@Component
export default struct PrivacySensor {
  @State fontStyle: ToggleLabelStyle = StyleConfiguration.getToggleLabelStyle();
  @Consume privacySensorData: PrivacySensorViewData;
  @Consume ccLayoutIndex: ControlCenterLayoutIndex;
  viewModel: PrivacySensorViewModel = PrivacySensorViewModel.getInstance(this.privacySensorData);
  @StorageLink('controlCenterFontScale') controlCenterFontScale: number = 1;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @StorageLink('currColorMode') currColorMode: number =
    GlobalContext.getContext().config.colorMode as number;
  private eventMgr = EvtBus.createEventManager();
  private privacyEvent: PrivacyEvent = new PrivacyEvent();

  aboutToAppear() {
    this.eventMgr.on(ConfigurationEvent, this.viewModel.languageChangeListener);
    this.eventMgr.on(WindowEvent, (event: WindowEvent): void => {this.onWindowEvent(event)});
    this.viewModel.initData();
  }

  aboutToDisappear() {
    this.eventMgr.offAll();
  }

  isDarkMode() {
    return this.currColorMode !== ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT;
  }

  /**
   * 窗口show/hide事件
   *
   * @param event 事件
   */
  private onWindowEvent(event: WindowEvent): void {
    if (event.isWindowShow() && event.windowName === PluginSlot.SLOT_STATUS_CONTROL_CENTER) {
      let controlCenterPosition = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
      if (!controlCenterPosition) {
        return
      }
      this.loadPrivacyUIExtension();
      windowMgr.updateWindowPosition(PluginSlot.SLOT_CONTROL_PRIVACY_PANEL, {
        left: controlCenterPosition.left,
        top: controlCenterPosition.top,
        width: controlCenterPosition.width,
        // 避免当页面关闭又打开过快时导致窗口有一瞬间可视
        height: 0,
      });
      this.privacyEvent.setValue(true)
      EvtBus.post(PrivacyEvent, this.privacyEvent)
    } else if (event.isWindowHide() && event.windowName === PluginSlot.SLOT_CONTROL_PRIVACY_PANEL) {
      this.privacyEvent.setValue(false)
      EvtBus.post(PrivacyEvent, this.privacyEvent)
    }
  }

  build() {
    Row({ space: 6 }) {
      if (this.privacySensorData.privacySensorTypeArray.includes(ControlCenterPrivacyType.CAMERA.valueOf())) {
        Image($r('app.media.privacy_camera')).imageSizeStyle()
      }
      if (this.privacySensorData.privacySensorTypeArray.includes(ControlCenterPrivacyType.MICROPHONE.valueOf())) {
        Image($r('app.media.privacy_microphone')).imageSizeStyle()
      }
      if (this.privacySensorData.privacySensorTypeArray.includes(ControlCenterPrivacyType.LOCATION.valueOf())) {
        Image($r('app.media.privacy_position')).imageSizeStyle()
      }
      Row({ space: 4 }) {
        Text(this.privacySensorData.recentAppName)
          .fontSize(this.privacySensorData.privacySensorFontSize * this.controlCenterFontScale + 'vp')
          .lineHeight(this.privacySensorData.privacySensorLineHeight + 'vp')
          .padding({bottom:ResUtils.getNumber($r('app.float.control_center_privacy_text_padding_bottom'))})
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .constraintSize({
            maxWidth: this.privacySensorData.textMaxWidth
          })
          .fontColor(!this.isDarkMode()
            ? this.colorModeViewData.wifiOnTextColor
            : this.colorModeViewData.wifiOffTextColor)

        Image($r('app.media.privacy_right_arrow'))
          .width(this.privacySensorData.privacySensorArrowWidth)
          .height(this.privacySensorData.privacySensorArrowHeight)
          .fillColor(!this.isDarkMode()
            ? this.colorModeViewData.wifiOnTextColor
            : this.colorModeViewData.wifiOffTextColor)
          .rotate({ y: 1, angle: this.privacySensorData.isRTL ? 180 : 0 })
          .opacity(0.6)
      }
    }
    .height(this.privacySensorData.privacySensorHeight)
    .margin({
      top: ResUtils.getNumber($r('app.float.control_center_privacy_margin_top')),
    })
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
    .clickEffect({ level: ClickEffectLevel.LIGHT })
    .key(Constants.CONTROL_PANEL_ID_PRIVACY_SENSOR)
    .onClick(() => {
      ControlCenterHiSysEventUtil.reportCCClickPrivacySensor({
        TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`,
      })
      if (ControlCenterPluginMgr.isPcMode) {
        windowMgr.showWindowWithAnim(WindowConstants.WINDOW_NAME_PRIVACY_INDICATOR)
        return;
      }
      let pos = windowMgr.getWindowPosition(PluginSlot.SLOT_CONTROL_PRIVACY_PANEL);
      EvtBus.post(WindowPositionChangeEvent, {
        windowName: PluginSlot.SLOT_CONTROL_PRIVACY_PANEL,
        position: PluginPosition.POSITION_NONE,
        caller: PluginSlot.SLOT_STATUS_CONTROL_CENTER,
        area: {
          left: pos.left,
          top: pos.top,
          width: pos.width,
          height: pos.height
        }
      });
      windowMgr.showWindowWithAnim(PluginSlot.SLOT_CONTROL_PRIVACY_PANEL, true);
    })
    .padding({
      left: ResUtils.getNumber($r('app.float.control_center_privacy_hotPadding')),
      right: ResUtils.getNumber($r('app.float.control_center_privacy_hotPadding'))
    })
    .accessibilityGroup(true)
    .accessibilityText(this.viewModel.getPrivacySensorText(this.privacySensorData.recentAppName))
  }

  @Styles
  imageSizeStyle() {
    .width(this.privacySensorData.privacySensorImgSize)
    .height(this.privacySensorData.privacySensorImgSize)
  }

  private loadPrivacyUIExtension(): void {
    viewMgrPolicy.hideView(PluginSlot.SLOT_CONTROL_PRIVACY_PANEL);
    let pluginInfo: PluginInfo = new PluginInfo();
    pluginInfo.pluginParseInfo = new PluginParseInfo();
    let area : Area | undefined = undefined;
    windowMgr.setStatusIconCaches('SLOT_CONTROL_PRIVACY_PANEL', area);
    pluginInfo.pluginParseInfo.bundleName = 'com.ohos.security.privacycenter'
    pluginInfo.pluginParseInfo.pluginAbilityName = 'IndicatorDetailingAbility'
    pluginInfo.pluginParseInfo.pluginSlot = 'SLOT_CONTROL_PRIVACY_PANEL'
    pluginInfo.pluginParseInfo.clickInfo = new PluginClickInfo()
    pluginInfo.pluginParseInfo.clickInfo.enableOperate = 'true'
    pluginInfo.pluginParseInfo.clickInfo.clickType = 'window';
    pluginInfo.pluginParseInfo.clickInfo.abilityName = 'IndicatorDetailingAbility';
    pluginInfo.pluginParseInfo.pluginIconType = 'privacy'
    pluginInfo.pluginParseInfo.isLocalPlugin = false;
    pluginInfo.pluginParseInfo.isNeedRedHot = false;
    pluginInfo.pluginParseInfo.pluginDeviceType = '2in1';
    windowMgr.setWindowData(PluginSlot.SLOT_CONTROL_PRIVACY_PANEL, pluginInfo);
  }
}
