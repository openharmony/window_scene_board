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
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { HoverConstants } from '@ohos/commonconstants';
import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import {
  sEventManager,
  obtainLocalEvent,
  EvtBus,
  WindowEvent,
  PluginSlot,
  EventManager,
} from '@ohos/frameworkwrapper';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { ColorModeViewModel } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewModel';
import { ColorModeViewData } from '@ohos/systemuicommon/src/main/ets/template/newStyle/ColorModeViewData';
import { BrightnessOptionUtils } from '@ohos/systemuicommon/src/main/ets/template/newStyle/BrightnessOptionUtils';
import { StorageAdapter } from '@ohos/controlcentercommon/src/main/ets/adapter/StorageAdapter';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import StyleConfiguration, { ControlCenterHeaderStyle } from '../../common/StyleConfiguration';
import sControlCenterBaseController from '../../controller/ControlCenterBaseController';
import { CC_LAYOUT_CONFIGS, ControlCenterLayoutIndex } from '../../controller/ControlCenterLayoutController';
import { HeaderViewModel } from '../../viewModel/HeaderViewModel';
import { HeaderViewData } from '../../model/HeaderViewData';
import { ControlCenterHomeViewData } from '../../vm/ControlCenterHomeViewData';
import sControlCenterController from '../../controller/ControlCenterController';
import { ControlCenterAnimationData } from '../../model/ControlCenterAnimationData';
import { ScreenStatusVm } from '@ohos/systemuicommon/src/main/ets/vm/ScreenStatusVm';
import { curves } from '@kit.ArkUI';
import Constants, { HEADER_BUTTON_TRANSLATE_COMPACT } from '../../common/Constants'
import { ControlCenterViewModel } from '../../viewModel/ControlCenterViewModel';
import { KeyCode } from '@kit.InputKit';
import { ControlCenterHiSysEventUtil } from '@ohos/controlcentercommon/src/main/ets/hiSysEvent/ControlCenterHiSysEventUtil';
import { AccessibilityVm } from '@ohos/systemuicommon/src/main/ets/vm/AccessibilityVm';

const TAG = 'Ctrl.HeaderLayout';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

export const ICON_ID_SETTINGS = TAG + '_Image_settings';
export const COMPONENT_ID_SETTINGS = TAG + '_Bg_settings';
const COMPONENT_ID_CONTROL_CENTER = TAG + '_Text_controlCenter';
const COMPONENT_ID_EDIT = TAG + '_Image_edit';
const COMPONENT_ID_EDIT_BTN = TAG + '_Image_edit_btn';
const COMPONENT_ID_EDIT_BUTTON = 'Ctrl.HeaderLayout_Image_edit_button';

const LOCK_STATUS_UNLOCKED: number = 2;
const HEADER_BUTTON_TRANSLATE: number = -20;
enum ButtonType {
  LEFT_BUTTON = 1,
  RIGHT_BUTTON = 2
}

@Component
export default struct ControlCenterHeaderLayout {
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  private isEditAvailable: boolean = true;
  private showToast?: (msg: ResourceStr) => void;
  private eventMgr: EventManager | undefined = undefined;
  private toggleData: string[] = [];
  @State style: ControlCenterHeaderStyle = StyleConfiguration.getControlCenterHeaderStyle();
  @Consume ccLayoutIndex: ControlCenterLayoutIndex;
  @StorageLink('isMarkingRenderGroupOfControl') isMarkingRenderGroupOfControl: boolean = false;
  @State viewData: HeaderViewData = new HeaderViewData();
  @State rightBtnScale: number = HoverConstants.HOVER_DEFAULT_SCALE;
  @State leftBtnScale: number = HoverConstants.HOVER_DEFAULT_SCALE;
  @StorageLink('lockStatus') lockStatus: number = 0;
  @State homeViewData?: ControlCenterHomeViewData = sControlCenterController.getHomeViewData();
  @ObjectLink animationData: ControlCenterAnimationData;
  @StorageLink('isSysColor') isSysColor: boolean = true;
  @StorageProp('isAccessibilityMode') isAccessibilityMode: boolean = false;
  @StorageLink('controlCenterFontScale') controlCenterFontScale: number = 1;

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    HeaderViewModel.getInstance().initData(this.viewData);
    if (this.eventMgr === undefined) {
      this.eventMgr = EvtBus.createEventManager();
    }
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      if (event.isMatchName(PluginSlot.SLOT_STATUS_CONTROL_CENTER) && event.isWindowEndHide()) {
        this.rightBtnScale = HoverConstants.HOVER_DEFAULT_SCALE;
        this.leftBtnScale = HoverConstants.HOVER_DEFAULT_SCALE;
      }
    });
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    if (this.eventMgr !== undefined) {
      this.eventMgr.offAll();
    }
  }

  build() {
    Row() {
      if (this.isAccessibilityMode) {
        Column() {
          this.loadLeftIconButton();
        }
        .id(COMPONENT_ID_EDIT_BUTTON)
        .onClick(StorageAdapter.getLockStatus() === LOCK_STATUS_UNLOCKED ? this.onToggleEditClick : () => {
          this.showToast?.(ResUtils.getInnerString($r('app.string.control_center_unlocked_for_editing')));
          // 锁屏场景点击编辑按钮打点
          ControlCenterHiSysEventUtil.reportCCEditIconClick({
            TIMESTAMP:  `${DropDownPanelManager.getLastDropdownTime()}`,
            SWITCHNUMBER: this.toggleData?.length,
            SWITCHLIST: this.toggleData?.join(','),
            LOCKSTATUS: AppStorage.get('lockStatus'),
          })
        })
        .focusable(true)
        .accessibilityText(ResUtils.getInnerString($r('app.string.cc_accessibility_str_entry_edit')))
        .accessibilityRole(AccessibilityRoleType.BUTTON)
      } else {
        this.loadLeftIconButton();
      }

      Text($r('app.string.control_center_edit_panel_title_edit'))
        .font({ size: 20 * this.controlCenterFontScale + 'vp', family: 'HarmonyHeiTi', weight: 'SemiBold' })
        .fontColor(this.getEditTextFontColor())
        .margin({ left: 12, right: 12 })
        .accessibilityLevel('no')
      Blank()
      if (this.isAccessibilityMode) {
        Column() {
          this.loadRightIconButton();
        }
        .onClick(HeaderViewModel.getInstance().onSettingClick)
        .focusable(true)
        .accessibilityText(ResUtils.getInnerString($r('app.string.cc_accessibility_str_entry_setting')))
        .accessibilityRole(AccessibilityRoleType.BUTTON)
      } else {
        this.loadRightIconButton();
      }
    }
    .opacity(this.animationData.opacity)
    .translate({
      y: this.homeViewData?.showEditModeHeader ? HEADER_BUTTON_TRANSLATE :
        this.animationData.itemTranslate + Math.max(this.animationData.translate, 0)
    })
    .scale({ x: this.animationData.scale, y: this.animationData.scale })
    .width(CC_LAYOUT_CONFIGS[this.ccLayoutIndex]?.panelWidth)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  handleToggleEditClick = () => {
    log.showInfo('handleToggleEditClick');
    if (this.isEditAvailable) {
      sEventManager.publish(obtainLocalEvent('ControlCenterState', ControlCenterState.TOGGLE_EDIT));
    }
  }

  /**
   * 进入快捷开关编辑界面
   */
  onToggleEditClick = () => {
    log.showDebug(`editClick`);
    sControlCenterBaseController.handleOnControlCenterWithScreenLock(():void => this.handleToggleEditClick());
  }
  /**
   * 图标hover效果
   *
   * @param event 悬浮事件
   */
  onHoverChanged = (type: ButtonType, isHover?: boolean) => {
    if (isHover === undefined) {
      return;
    }
    animateTo({
      duration: HoverConstants.HOVER_ANIMATE_DURATION,
      curve: Curve.Sharp
    }, () => {
      switch (type) {
        case ButtonType.LEFT_BUTTON:
          this.leftBtnScale = isHover ? HoverConstants.HOVER_SETTING_BTN_SCALE : HoverConstants.HOVER_DEFAULT_SCALE;
          break;
        case ButtonType.RIGHT_BUTTON:
          this.rightBtnScale = isHover ? HoverConstants.HOVER_SETTING_BTN_SCALE : HoverConstants.HOVER_DEFAULT_SCALE;
          break;
        default:
          break;
      }
    });
  }

  @Builder
  loadLeftIconButton() {
    Row() {
      SymbolGlyph(this.homeViewData?.showEditModeHeader ?
      $r(HeaderViewModel.getInstance().getIconName('chevron_backward', 'ic_back_edit')) :
      $r(HeaderViewModel.getInstance().getIconName('square_and_pencil', 'ic_public_edit')))
        .size({width: this.style.buttonDiameter, height: this.style.buttonDiameter})
        .padding(this.style.iconPadding)
        .fontSize(Constants.ICON_FONT_SIZE + 'vp') // 保持宽高比进行缩小或者放大，使得图片完全显示在显示边界内。
        .fontColor([$r('app.color.Control_center_icon_setting_color')])
        .renderGroup(this.isMarkingRenderGroupOfControl)
        .draggable(false)
        .id(COMPONENT_ID_EDIT)
    }
    .id(COMPONENT_ID_EDIT_BTN)
    .height(this.style.buttonDiameter)
    .width(this.style.buttonDiameter)
    .opacity(this.getLockStatus() === LOCK_STATUS_UNLOCKED ? 1 : 0.4)
    .backgroundColor($r('app.color.Control_center_icon_setting_bg_color'))
    .backgroundBrightnessInternal(this.colorModeViewData.isBrightnessActive ?
      BrightnessOptionUtils.getInstance().backgroundSevenDarkOption : undefined)
    .borderRadius(this.style.buttonDiameter)
    .onClick(StorageAdapter.getLockStatus() === LOCK_STATUS_UNLOCKED ? this.onToggleEditClick : () => {
      this.showToast?.(ResUtils.getInnerString($r('app.string.control_center_unlocked_for_editing')));
      // 锁屏场景点击编辑按钮打点
      ControlCenterHiSysEventUtil.reportCCEditIconClick({
        TIMESTAMP:  `${DropDownPanelManager.getLastDropdownTime()}`,
        SWITCHNUMBER: this.toggleData?.length,
        SWITCHLIST: this.toggleData?.join(','),
        LOCKSTATUS: AppStorage.get('lockStatus'),
      })
    })
    .focusable(true)
    .onHover((isHover?: boolean) => this.onHoverChanged(ButtonType.LEFT_BUTTON, isHover))
    .scale({ x: this.leftBtnScale, y: this.leftBtnScale })
    .onTouch((event: TouchEvent) => {
      this.buttonClickEffect(event, true);
    })
    .accessibilityLevel('no')
  }

  @Builder
  loadRightIconButton() {
    Row() {
      SymbolGlyph(this.homeViewData?.showEditModeHeader ?
      $r(HeaderViewModel.getInstance().getIconName('checkmark', 'ic_public_ok_filled_edit')) :
      $r(HeaderViewModel.getInstance().getIconName('gearshape', 'ic_public_settings')))
        .size({width: this.style.buttonDiameter, height: this.style.buttonDiameter})
        .padding(this.style.iconPadding)
        .fontSize(Constants.ICON_FONT_SIZE + 'vp') // 保持宽高比进行缩小或者放大，使得图片完全显示在显示边界内。
        .fontColor([$r('app.color.Control_center_icon_setting_color')])
        .renderGroup(this.isMarkingRenderGroupOfControl)
        .draggable(false)
        .id(ICON_ID_SETTINGS)
    }
    .id(COMPONENT_ID_SETTINGS)
    .height(this.style.buttonDiameter)
    .width(this.style.buttonDiameter)
    .backgroundColor($r('app.color.Control_center_icon_setting_bg_color'))
    .backgroundBrightnessInternal(this.colorModeViewData.isBrightnessActive ?
      BrightnessOptionUtils.getInstance().backgroundSevenDarkOption : undefined)
    .borderRadius(this.style.buttonDiameter)
    .visibility(this.viewData.isSettingIconVisible ? Visibility.Visible : Visibility.Hidden)
    .onClick(HeaderViewModel.getInstance().onSettingClick)
    .focusable(true)
    .onHover((isHover?: boolean) => this.onHoverChanged(ButtonType.RIGHT_BUTTON, isHover))
    .scale({ x: this.rightBtnScale, y: this.rightBtnScale })
    .onTouch((event: TouchEvent) => {
      this.buttonClickEffect(event, false);
    })
    .accessibilityLevel('no')
    .onKeyPreIme((event: KeyEvent) => {
      return ControlCenterViewModel.onKeyPreForbidAction(event, KeyCode.KEYCODE_DPAD_RIGHT)
    })
  }

  private buttonClickEffect(event: TouchEvent, isLeft: boolean) {
    if (event.type === TouchType.Down) {
      animateTo({
        curve: curves.springMotion(0.31, 0.94)
      }, () => {
        if (isLeft) {
          this.leftBtnScale = 0.9;
        } else {
          this.rightBtnScale = 0.9;
        }
      });
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      animateTo({
        curve: curves.springMotion(0.31, 0.94)
      }, () => {
        if (isLeft) {
          this.leftBtnScale = 1;
        } else {
          this.rightBtnScale = 1;
        }
      });
    }
  }

  private getEditTextFontColor(): string {
    let isShowEditText: boolean | undefined = false;
    isShowEditText = this.homeViewData?.showEditModeHeader;
    return isShowEditText ? '#ffffffff' : '#00ffffff';
  }

  private getLockStatus(): number {
    // 隔离主线程调用
    if (ThreadUtil.isMainThread) {
      return this.lockStatus;
    } else {
      return ScreenStatusVm.instance.lockStatus;
    }
  }
}
