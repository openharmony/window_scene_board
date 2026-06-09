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

import { Log } from '@ohos/basicutils';
import { ExtAppConstants } from '@ohos/commonconstants';
import {
  PluginSlot,
  HiSysEventUtil
} from '@ohos/frameworkwrapper';
import { windowMgr, StartAbilityUtil } from '@ohos/windowscene';
import { MenuType } from '../common/Constants';
import mModel from '../model/SystemPanelModel';
import StyleConfiguration, {
  ClickableMenuStyle,
  CommonComponentStyle,
  SystemPanelComponentStyle
} from '../common/StyleConfiguration';
import Constants from '../common/Constants';
import { NormalPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import StyleConstants from '../../../common/constants/StyleConstants';
import systemParameter from '@ohos.systemparameter';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { pcShutdownDialogVMP } from '@ohos/shutdownview/src/main/ets/pages/PcShutdownDialogVMP';

const TAG = 'SystemPanel-SystemMenu';
const COMPONENT_ID_CONTENT = TAG + '_Text_content';
const KEY = 'h1_systemUI_product_pc_SystemMenu_';

/**
 * 窗口名
 */
const WINDOW_NAME = PluginSlot.SLOT_STATUS_PERSONAL;
const KEYBOARD = 4;

@Component
export default struct SystemMenu {
  @State styleCommon: CommonComponentStyle = StyleConfiguration.getCommonComponentStyle();
  @State style: SystemPanelComponentStyle = StyleConfiguration.getSystemPanelComponentStyle();
  @State styleClickable: ClickableMenuStyle = StyleConfiguration.getClickableMenuStyle();
  @State isSelected: boolean = false;
  @State isHover: boolean = false;
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Link globalClickable: boolean;
  @Consume persistentId: number;
  private clickable: boolean = true;
  private menuType: number = MenuType.INVAILD_MENU;
  private textContent?: string | Resource;
  private hasDivider: boolean = false;
  private needIcon: boolean = false;
  private iconKey: string = ``;
  private eventType: string = HiSysEventUtil.TOUCH_EVENT;
  private isLastItem: boolean = false;
  private isFirstItem: boolean = false;
  mTimeMeter: number = 0;
  mInterval: number = 500;
  mLastActionTime: number = 0;
  mIsRunning: boolean = false;

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear`);
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId) as NormalPanelInfo;
    mModel.registerStateChangeListener(this);
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`);
    this.reset();
    clearTimeout(this.mTimeMeter);
    mModel.unregisterStateChangeListener(this);
  }

  @Styles
  normalStyles() {
    .border({
      width: '2vp',
      color: '#00000000'
    })
  }

  @Styles
  focusedStyles() {
    .border({
      width: '2vp',
      color: this.panelInfo?.isDark ?
      StyleConstants.DEFAULT_DARK_FOCUSED_COLOR :
      StyleConstants.DEFAULT_FOCUSED_COLOR
    })
  }

  @Styles
  systemMenuStyles() {
    .width('100%')
    .height(this.styleClickable.stackHeight)
    .borderRadius(this.panelInfo?.hoverRadius)
    .padding(({
      left: this.styleClickable.stackPadding,
      right: this.styleClickable.stackPadding,
    }))
    .stateStyles({
      normal: this.normalStyles,
      focused: this.focusedStyles
    })
    .backgroundColor(this.getBackgroundColor())
  }

  @Builder
  clickableSystemMenu() {
    Row() {
      this.systemMenuName()
      if (this.needIcon) {
        this.systemMenuIcon()
      }
    }
    .key(this.getMenuTypeName())
    .systemMenuStyles()
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
    .onClick((event) => {
      this.onClickEvent(event)
    })
    .onTouch((event) => {
      this.onTouchEvent(event)
    })
    .onHover((isHover) => {
      this.isHover = isHover || false;
    })
    .onMouse((event) => {
      this.onMouseEvent(event)
    })
  }
  @Builder
  systemMenuIcon() {
    Row({ space: '8vp' }) {
      Image($r('app.media.ic_add')).draggable(false)
        .width(this.style.systemPanelMultiKeyIconSize)
        .height(this.style.systemPanelMultiKeyIconSize)
        .fillColor(this.colorModeViewData.commonIconOffColor)
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
      Text(this.iconKey)
        .draggable(false)
        .fontColor(this.colorModeViewData.wifiOffTextColor)
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .fontSize(this.panelInfo?.listAssistedTextSize)
        .fontWeight(FontWeight.Regular)
        .fontFamily('HarmonyHeiTi')
    }
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  systemMenuName() {
    Text(this.textContent)
      .draggable(false)
      .id(COMPONENT_ID_CONTENT)
      .fontColor(this.colorModeViewData.wifiOffTextColor)
      .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
      .fontSize(this.panelInfo?.listTextSize)
      .fontWeight(FontWeight.Medium)
      .fontFamily('HarmonyHeiTi')
      .focusable(true)
      .key(this.menuType === MenuType.SETTINGS_MENU ? Constants.REQUEST_FOCUS_MENU : '')
  }

  private onClickEvent(event?: ClickEvent): void {
    Log.showInfo(TAG, `onClickEvent, event: ${JSON.stringify(event)}`);
    // 点击面板，关闭面板
    if (this.menuType != MenuType.LOCK_MENU) {
      windowMgr.hideWindowWithAnim(WINDOW_NAME);
    }
    if (event?.source === KEYBOARD) {
      this.eventType = HiSysEventUtil.SHORTCUT_EVENT;
    }
    this.execClickAction();
  }

  private onMouseEvent(event?: MouseEvent): void {
    Log.showInfo(TAG, `onMouseEvent, event: ${JSON.stringify(event)}`);
    if (!this.clickable) {
      return;
    }
    if (event?.button == MouseButton.Left && event?.action == MouseAction.Press) {
      this.isSelected = true;
      this.eventType = HiSysEventUtil.MOUSE_EVENT;
    } else if (event?.button == MouseButton.Left && event?.action == MouseAction.Release) {
      this.isSelected = false;
    }
  }

  private onTouchEvent(event?: TouchEvent): void {
    Log.showInfo(TAG, `onTouchEvent, event: ${JSON.stringify(event)}`);
    if (!this.clickable) {
      return;
    }
    if (event?.type == TouchType.Down) {
      this.isSelected = true;
      this.eventType = HiSysEventUtil.TOUCH_EVENT;
    } else if (event?.type == TouchType.Up) {
      this.isSelected = false;
    }
    if (event?.stopPropagation) {
      event?.stopPropagation();
    }
  }

  private execClickAction(): void {
    if (this.mIsRunning || this.globalClickable) {
      return;
    }
    this.mIsRunning = true;
    this.globalClickable = true;
    this.runTask();
    this.mTimeMeter = setTimeout(() => {
      Log.showInfo(TAG, `check need run task or not.`);
      this.mIsRunning = false;
      this.globalClickable = false;
    }, this.mInterval);
  }

  private runTask(): void {
    Log.showInfo(TAG, `runTask`);
    try {
      switch (this.menuType) {
        case MenuType.SETTINGS_MENU:
          HiSysEventUtil.reportSystemMenu(this.menuType, this.eventType);
          StartAbilityUtil.startAbilityFromOther({
            bundleName: ExtAppConstants.PKG_SETTINGS,
            abilityName: ExtAppConstants.ABILITY_SETTINGS_MAIN,
            moduleName: 'pc_settings'
          });
          break;
        case MenuType.SLEEP_MENU:
          HiSysEventUtil.reportSystemMenu(this.menuType, this.eventType);
          HiSysEventUtil.reportClickSleepMenuFormData();
          mModel.sleep();
          break;
        case MenuType.LOCK_MENU:
          HiSysEventUtil.reportSystemMenu(this.menuType, this.eventType);
          mModel.lockScreen();
          break;
        case MenuType.REBOOT_MENU:
          AppStorage.setOrCreate('currentClickRebootOrShutdown', 'reboot');
          systemParameter.setSync('persist.dfx.userclicktime', new Date().getTime().toString());
          HiSysEventUtil.hiSysWriteStorage(this.menuType, this.eventType, () => {
            pcShutdownDialogVMP.showPcShutdownView();
          })
          break;
        case MenuType.SHUTDOWN_MENU:
          AppStorage.setOrCreate('currentClickRebootOrShutdown', 'shutdown');
          systemParameter.setSync('persist.dfx.userclicktime', new Date().getTime().toString());
          HiSysEventUtil.hiSysWriteStorage(this.menuType, this.eventType, () => {
            pcShutdownDialogVMP.showPcShutdownView();
          })
          break;
        default:
          Log.showError(TAG, `runTask, unknown action type.`);
      }
    } catch (e) {
      Log.showError(TAG, `runTask error, code: ${e?.code}, message: ${e?.message}`);
    }
  }

  private reset(): void {
    this.isSelected = false;
    this.isHover = false;
  }

  private getMenuTypeName(): string {
    switch (this.menuType) {
      case MenuType.INFO_MENU:
        return KEY + 'info';
      case MenuType.SETTINGS_MENU:
        return KEY + 'setting';
      case MenuType.SLEEP_MENU:
        return KEY + 'sleep';
      case MenuType.LOCK_MENU:
        return KEY + 'lock';
      case MenuType.REBOOT_MENU:
        return KEY + 'reboot';
      case MenuType.SHUTDOWN_MENU:
        return KEY + 'shutdown';
      default:
        Log.showError(TAG, `getMenuTypeName, unknown action type.`);
        return '';
    }
  }

  private getBackgroundColor(): ResourceColor {
    if (this.isSelected) {
      return this.panelInfo?.isDark ?
      StyleConstants.DEFAULT_DARK_PRESS_COLOR : StyleConstants.DEFAULT_PRESS_COLOR;
    }
    if (this.isHover) {
      return this.panelInfo?.isDark ?
      StyleConstants.DEFAULT_DARK_HOVER_COLOR : StyleConstants.DEFAULT_HOVER_COLOR;
    }
    return this.styleClickable.stackBgColorUnSelected;
  }

  onStateChange(panelState: boolean): void {
    Log.showInfo(TAG, `onStateChange panelState: ${panelState}`);
    if (!panelState) {
      this.reset();
    }
  }

  build() {
    Column() {
      Row() {
        if (this.clickable) {
          this.clickableSystemMenu()
        } else {
          Text(this.textContent)
            .draggable(false)
            .id(COMPONENT_ID_CONTENT)
            .fontColor(this.colorModeViewData.wifiOffTextColor)
            .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
            .fontSize(this.style.systemPanelSubTitleFontSize)
            .fontWeight(FontWeight.Regular)
        }
      }
      .width('100%')
      .height(this.styleCommon.menuHeight)
      .borderRadius(this.panelInfo?.hoverRadius)

      if (this.hasDivider) {
        Row() {
          MyDivider()
        }
        .padding({
          left: this.style.systemPanelMarginSize,
          right: this.style.systemPanelMarginSize,
          top: this.style.systemPanelMarginVerticalTop,
          bottom: this.style.systemPanelMarginVerticalBottom
        })
        .width('100%')
      }
    }
    .justifyContent(FlexAlign.Center)
    .padding({
      left: this.style.systemMenuLeftMargin,
      right: this.style.systemMenuRightMargin,
    })
    .margin({
      top: this.isFirstItem ? undefined : this.style.systemPanelMarginTop,
    })
    .onDisAppear(() => {
      this.reset();
    })
  }
}

@Component
struct MyDivider {
  @State style: SystemPanelComponentStyle = StyleConfiguration.getSystemPanelComponentStyle()
  @Consume persistentId: number;
  @State panelInfo: NormalPanelInfo | undefined = undefined;

  aboutToAppear() {
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId) as NormalPanelInfo;
    Log.showInfo(TAG, `MyDivider, aboutToAppear`);
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `MyDivider, aboutToDisappear`);
  }

  build() {
    Column() {
      Divider()
        .vertical(false)
        .strokeWidth(this.style.systemPanelDividerHeight as string)
        .color(this.panelInfo?.separatorColor)
        .lineCap(LineCapStyle.Square)
    }
    .width('100%')
    .height(this.style.systemPanelDividerHeight)
  }
}
