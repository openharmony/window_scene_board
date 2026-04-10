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

import {
  HiSysEventUtil,
  PluginSlot,
  EventManager,
  EvtBus,
  WindowEvent,
  DeviceHelper,
  localEventManager,
  EventConstants,
} from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper, } from '@ohos/basicutils';
import { windowMgr, ResUtils, StartAbilityUtil, } from '@ohos/windowscene';
import { ExtAppConstants, HoverConstants, } from '@ohos/commonconstants';
import { IUserData } from '@ohos/screenlockcommon';
import StyleConfiguration, {
  ControlCenterHeaderStyle
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/common/StyleConfiguration';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { ColorModeViewData, ColorModeViewModel, BrightnessOptionUtils } from '@ohos/systemuicommon/Index';
import { HeaderViewModel } from '@ohos/controlcentercomponent/src/main/ets/com/ohos/viewModel/HeaderViewModel'
import Constants from './common/constants';
import { LengthMetrics } from '@kit.ArkUI';

const TAG = 'Ctrl.HeaderLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

const COMPONENT_ID_CONTROL_CENTER = TAG + '_Text_controlCenter';
const COMPONENT_ID_SETTINGS = TAG + '_Image_settings';
const COMPONENT_ID_EDIT_MODE = TAG + '_Image_edit_mode';
const COMPONENT_ID_EDIT_MODE_WRAPPER = TAG + '_Image_edit_mode_wrapper';

const CONTROL_CENTER_SETTING_BUTTON_TOP_MARGIN: number = 2;
const CONTROL_CENTER_SETTING_BUTTON_RIGHT_MARGIN: number = -8;
const SHADOW_OFFSET_Y: number = 4
const CONTROL_CENTER_HEADER_LEFT_PADDING: number = 27;
const CONTROL_CENTER_HEADER_RIGHT_PADDING: number = 30;
const HAD_CONTROL_CENTER_HEADER_RIGHT_PADDING: number = 15;

export enum HeaderButtonType {
  NOTHING,
  SETTINGS,
  EDIT_MODE,
}

@Component
export default struct ControlCenterHeaderLayout {
  @StorageLink('userList') accountList: IUserData[] = []
  @StorageLink('userActivateList') accountActivateList: IUserData[] = []
  @StorageLink('accountFlag') accountFlag: boolean = true;
  @State style: ControlCenterHeaderStyle = StyleConfiguration.getControlCenterHeaderStyle();
  private buttonType: HeaderButtonType = HeaderButtonType.NOTHING;
  @StorageLink('isLandscape') isLandscape: boolean = false;
  @StorageLink('isMarkingRenderGroup') isMarkingRenderGroup: boolean = false;
  accountButtonX: number = 0;
  @Prop isVertical: boolean = true;
  @State animateScale: number = HoverConstants.HOVER_DEFAULT_SCALE;
  private settingDialogController?: CustomDialogController | null;
  private eventMgr: EventManager = EvtBus.createEventManager();
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  private isHad: boolean = DeviceHelper.isHAD();
  @State isPress: boolean = false;
  @State isHover: boolean = false;
  @StorageLink('controlCenterFontScale') controlCenterFontScale: number = 1;
  @StorageLink('isMarkingRenderGroupOfControl') isMarkingRenderGroupOfControl: boolean = false;

  aboutToAppear() {
    log.showInfo(TAG, 'aboutToAppear');
    this.settingDialogController?.close();
    this.settingDialogController = null;
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      if (event.isMatchName(PluginSlot.SLOT_STATUS_CONTROL_CENTER) && event.isWindowEndHide()) {
        this.animateScale = HoverConstants.HOVER_DEFAULT_SCALE;
      }
    });
  }

  aboutToDisappear() {
    log.showInfo(TAG, 'aboutToDisappear');
    this.settingDialogController?.close();
    this.settingDialogController = null;
    this.eventMgr.offAll();
  }

  /**
   * 跳转设置主界面
   */
  onSettingClick = () => {
    log.showInfo(TAG, `settingClick`);
    HiSysEventUtil.reportCCSettingIconClick({
      LOCK_STATUS: 2,
      TIMESTAMP: `${DropDownPanelManager.getLastDropdownTime()}`
    });
    this.closePanel();
    this.startSetting();
  }
  /**
   * 跳转编辑主界面
   */
  onEditModeClick = () => {
    log.showInfo(TAG, `editModeClick`);
    AppStorage.setOrCreate('isPcEditMode', true);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_JUMP_TO_EDIT_MODE_PAGE, []);
  }
  /**
   * 图标hover效果
   *
   * @param event 悬浮事件
   */
  onHoverChanged = (isHover?: boolean) => {
    if (isHover === undefined) {
      return;
    }
    this.isHover = isHover;
    animateTo({
      duration: HoverConstants.HOVER_ANIMATE_DURATION,
      curve: Curve.Sharp
    }, () => {
      this.animateScale = isHover ? HoverConstants.HOVER_SETTING_BTN_SCALE : HoverConstants.HOVER_DEFAULT_SCALE;
    });
  }

  private closePanel() {
    windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
  }

  private startSetting() {
    StartAbilityUtil.startAbilityFromOther({
      bundleName: ExtAppConstants.PKG_SETTINGS,
      abilityName: ExtAppConstants.ABILITY_SETTINGS_MAIN,
      moduleName: 'pc_settings'
    });
  }

  private getIconBackgroundColor(): ResourceColor {
    if (this.isPress) {
      return $r('sys.color.ohos_id_color_click_effect');
    } else if (this.isHover) {
      return $r('sys.color.ohos_id_color_hover');
    } else {
      return Color.Transparent;
    }
  }

  @Builder
  editModeEntrance() {
    Stack({ alignContent: Alignment.Center }) {
      SymbolGlyph($r(HeaderViewModel.getInstance().getIconName('square_and_pencil', 'ic_public_edit')))
        .fontSize($r('app.float.Control_center_edit_symbol_icon_size'))
        .id(COMPONENT_ID_EDIT_MODE)
        .fontColor([this.colorModeViewData.commonIconOffColor])
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOptionOnBackground)
        .renderGroup(this.isMarkingRenderGroupOfControl)
        .draggable(false)
    }
    .onClick(this.onEditModeClick)
    .onHover(this.onHoverChanged)
    .onTouch((event?: TouchEvent) => {
      if (event && (event.type === TouchType.Down)) {
        this.isPress = true;
      } else if (event && (event.type === TouchType.Up)) {
        this.isPress = false;
        this.isHover = false;
      }
    })
    .backgroundColor(this.getIconBackgroundColor())
    .borderRadius($r('app.float.Control_center_setting_border'))
    .margin({
      top: LengthMetrics.vp(CONTROL_CENTER_SETTING_BUTTON_TOP_MARGIN),
      end: LengthMetrics.vp(CONTROL_CENTER_SETTING_BUTTON_RIGHT_MARGIN),
    })
    .width($r('app.float.Control_center_header_btn_wrapper_width'))
    .height($r('app.float.Control_center_header_btn_wrapper_height'))
    .id(COMPONENT_ID_EDIT_MODE_WRAPPER)
  }

  @Builder
  settingsBtn() {
    Column() {
      Image($r('app.media.ic_public_settings'))
        .draggable(false)
        .objectFit(ImageFit.Contain)
        .size({
          width: $r('app.float.Control_center_setting_icon_width'),
          height: $r('app.float.Control_center_setting_icon_width')
        })
        .fillColor(this.colorModeViewData.commonIconOffColor)
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOptionOnBackground)
        .id(COMPONENT_ID_SETTINGS)
        .edgeAntialiasing(0.4)
    }
    .margin({
      top: LengthMetrics.vp(CONTROL_CENTER_SETTING_BUTTON_TOP_MARGIN),
      end: LengthMetrics.vp(CONTROL_CENTER_SETTING_BUTTON_RIGHT_MARGIN),
    })
    .onClick(this.onSettingClick)
    .borderRadius($r('app.float.Control_center_setting_border'))
    .width($r('app.float.Control_center_setting_width'))
    .height($r('app.float.Control_center_setting_width'))
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .id(Constants.CONTROL_PANEL_ID_SETTINGS)
    .backgroundColor(this.getIconBackgroundColor())
    .scale({ x: this.animateScale, y: this.animateScale })
    .onHover(this.onHoverChanged)
    .onTouch((event?: TouchEvent) => {
      if (event && (event.type === TouchType.Down)) {
        this.isPress = true;
      } else if (event && (event.type === TouchType.Up)) {
        this.isPress = false;
        this.isHover = false;
      }
    })
  }

  build() {
    Flex({
      direction: FlexDirection.Row, alignItems: ItemAlign.Center,
      justifyContent: FlexAlign.SpaceBetween
    }) {
      Row() {
        Text($r('app.string.control_center'))
          .draggable(false)
          .fontSize(ResUtils.getNumber($r('app.float.Control_center_head_font_size')) *
          this.controlCenterFontScale + 'vp')
          .fontColor(this.colorModeViewData.wifiOffTextColor)
          .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
          .renderGroup(this.isMarkingRenderGroupOfControl)
          .textAlign(TextAlign.Start)
          .align(Alignment.Start)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontWeight(FontWeight.Bold)
          .flexGrow(1)
          .id(COMPONENT_ID_CONTROL_CENTER)
          .fontFamily('HarmonyHeiTi')
          .height($r('app.float.Control_center_head_height'))
      }
      .padding({
        top: $r('app.float.Control_center_head_line_top_padding')
      })
      .justifyContent(FlexAlign.Center)
      .width($r('app.float.Control_center_head_width'))
      .height($r('app.float.Control_center_head_height'))

      if (this.buttonType === HeaderButtonType.SETTINGS) {
        this.settingsBtn()
      } else if (this.buttonType === HeaderButtonType.EDIT_MODE) {
        this.editModeEntrance()
      }
    }
    .padding({
      start: LengthMetrics.vp(CONTROL_CENTER_HEADER_LEFT_PADDING),
      end: LengthMetrics.vp(this.isHad ? HAD_CONTROL_CENTER_HEADER_RIGHT_PADDING : CONTROL_CENTER_HEADER_RIGHT_PADDING),
    })
    .width('100%')
    .height($r('app.float.Control_center_head_height'))
  }
}