/**
 * Copyright (c) 2024-2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { windowMgr } from '@ohos/windowscene';
import {
  EvtBus,
  EventManager,
  ScreenOnOffEvent,
  viewMgrPolicy,
  ViewType,
  PluginSlot,
  WindowEvent,
  WindowPositionChangeEvent,
  ConfigurationEvent,
  HideWindowPanelEvent,
  reportIntervalMgr,
  HiSysEventUtil,
  PluginPosition,
  GlobalContext,
  SettingsUtil,
  DeviceHelper,
  HideAppConfigLoadEvent} from '@ohos/frameworkwrapper';
import { SmartDockStyleConfig } from '@ohos/smartdock';
import PcSmartDockViewModel from '../viewmodel/SmartDockViewModel';
import StatusBarEventPoster from '@ohos/statusbarcomponent/src/main/ets/pc/manager/StatusBarEventPoster';
import {
  SCBFoldStatePropertyChangeEvent,
  SCBPropertyChangeReason,
  SCBScreenProperty,
  SCBScreenSessionManager
} from '@ohos/windowscene';
import ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import { StatusBarTint } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarTint';
import { StyleConstants, GetHideAppsFromConfig } from '@ohos/launchercommon/src/main/ets/TsIndex';
import measure from '@ohos.measure';
import { Constants } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import curves from '@ohos.curves';
import { SCBFoldState } from '@ohos/statusbarcomponent/src/main/ets/pc/utils/enum';
import type ctx from '@ohos.app.ability.common';
import { Constants as StatusbarConstants } from '@ohos/statusbarcomponent/src/main/ets/pc/common/Constants';
import { LengthMetrics } from '@kit.ArkUI';
import { StyleManager } from '@ohos/statusbarcomponent/src/main/ets/pc/style/PluginStyleManager';
import { StatusBarStyle } from '@ohos/statusbarcomponent/src/main/ets/pc/style/PcStatusBarStyle';
import {
  PluginWindowManager
} from '@ohos/statusbarcomponent/src/main/ets/pc/pluginwindow/PluginWindowManager';
import { PcStatusBarDragMgr } from '@ohos/statusbarcomponent/src/main/ets/pc/manager/PcStatusBarDragMgr';
import {
  PluginGroupingManager
} from '@ohos/statusbarcomponent/src/main/ets/pc/plugingroup/PluginGroupingManager';
import {
  PluginGroupType,
  PluginPositionType } from '@ohos/statusbarcomponent/src/main/ets/pc/common/PluginConstants';
import { LocalGroup } from '@ohos/statusbarcomponent/src/main/ets/pc/pages/StatusBarLocalGroup';
import { StatusBarGroupComponent } from '@ohos/statusbarcomponent/src/main/ets/pc/pages/StatusBarGroupComponent';
import screenSessionManager from '@ohos.screenSessionManager';
import { RotationConstants } from '@ohos/commonconstants';
import { trayPanelMenuVM } from '@ohos/statusbarcomponent/src/main/ets/pc/viewmodel/TrayPanelMenuVM';

const TAG = 'DockStatusBarComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const SPACING: number = 48;
const VERTICAL_SPACING: number = 28; // 竖屏下状态栏图标和dock栏图标的安全间距
const ARROW_IMAGE_SIZE: number = 26;
const BUTTON_SIZE: number = 40;
const BUTTON_RIGHT_MARGIN: number = 0;
const BUTTON_WIDTH: number = 32;
const END_SPACE_LEFT: number = 16;
const END_SPACE_RIGHT: number = 16;
const ITEM_SPACE: number = 0;
const LIGHT_COLOR: string = '#000000';
const DARK_COLOR: string = '#FFFFFF';
const HOVER_ENTER_TIPS_DELAY: number = 700;
const HOVER_LEAVE_TIPS_DELAY: number = 0;
const POPUP_MIN_TEXT_WIDTH: number = 64;
const HARMONY_RING_WIDTH: number = 60;
const GROUP_COMPONENT_END_MARGIN: number = 2.5;
const VASSISTANT_BUNDLE_NAME = 'com.ohos.vassistant';

@Component
export struct DockStatusBarComponent {
  private mSmartDockStyleConfig: SmartDockStyleConfig = PcSmartDockViewModel.getInstance().getStyleConfig();
  @Provide contentColor: string = DARK_COLOR;
  @Provide iconsOpacityInfo: PluginSlot[] = [];
  @State isRight: boolean = true;
  @State arrowResource: ResourceStr = $r('sys.media.ohos_ic_public_arrow_up');
  @State showTray: boolean = false;
  @State isHover: boolean = false;
  @State isPopupShow: boolean = false;
  @Link leftStatusBarWidth: number;
  @Link rightStatusBarWidth: number;
  @Link @Watch('colorModeChange') currColorMode: number;
  @StorageProp('dockHeight') dockHeight: number = 0;
  private hoverDelayTimer: number | null = null;
  @StorageLink('isPopupMenuShow') isDockPopupShow: boolean = true;
  @State constraintSizeNumber : number = 0;
  @State spaceRowWidth: number = 0;
  @State isVertical: boolean = false;
  private mScreenWidth: number = this.mSmartDockStyleConfig.mScreenWidth;
  @State isAIHide: boolean = GetHideAppsFromConfig.getInstance().isHideApp(VASSISTANT_BUNDLE_NAME);
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  @State showArrowButton: boolean = true;
  private trayPosChangeCurve: curves.ICurve = curves.interpolatingSpring(0, 1, 660, 66);
  @State pluginStyle: StatusBarStyle = StyleManager.getInstance().getDockStatusBarStyle();

  private colorModeChange(): void {
    this.contentColor = (this.currColorMode === 0) ? DARK_COLOR : LIGHT_COLOR;
    log.showInfo(`this.colorMode:${this.currColorMode} contentColor:${this.contentColor}`);
  }

  aboutToAppear(): void {
    log.showInfo('DockStatusBarComponent, aboutToAppear');
    // HXY默认初始化为横屏,根据当前屏幕状态初始化
    this.isVertical = this.isVerticalInit();
    this.spaceRowWidth = DeviceHelper.isSuperFoldMachine() && this.isVertical ?
      this.calculateSpaceRowWidth(VERTICAL_SPACING) : this.calculateSpaceRowWidth(SPACING);
    this.constraintSizeNumber = this.calculateMaxWidth();
    this.initWindowPolicy();
    PcStatusBarDragMgr.getInstance().registerShowArrowButtonCallback(this.onShowArrowButton);
    this.colorModeChange();
    if (this.isRight) {
      // 固定区的图标都添加完成后才能确保groupWrapperWidth的宽度计算完成，再判断是否需要将多余的图标挤位回托盘
      setTimeout(() => {
        log.showInfo('slot to Tray when GroupWrapperComponent is ready!');
        PcStatusBarDragMgr.getInstance().slotToTray();
      }, 3000);
    }
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.onScreenPropertyChange);
  }

  //是否应该竖屏初始化
  isVerticalInit(): boolean {
    const curStatus = screenSessionManager.getSuperFoldStatus();
    const curRotation = screenSessionManager.getSuperRotation();
    log.showInfo(`init curStatus: ${curStatus},  rotation: ${curRotation}`);
    return !(curStatus === screenSessionManager.SuperFoldStatus.SUPER_FOLD_STATUS_EXPANDED &&
      (curRotation === RotationConstants.ROTATION_90 ||
        curRotation === RotationConstants.ROTATION_270));
  }

  aboutToDisappear() {
    log.showInfo('DockStatusBarComponent, aboutToDisappear');
    PcStatusBarDragMgr.getInstance().unregisterShowArrowButtonCallback();
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.onScreenPropertyChange);
    this.eventMgr.offAll();
  }

  private onShowArrowButton = (showArrowButton: boolean): void => {
    log.showInfo(`onShowArrowButton showArrowButton: ${showArrowButton}`);
    this.showArrowButton = showArrowButton;
  };

  private onArrowStateChange(showTray: boolean): void {
    if (showTray) {
      this.arrowResource = $r('sys.media.ohos_ic_public_arrow_down');
      windowMgr.showWindowWithAnim(PluginSlot.SLOT_STATUS_TRAY_PANEL, true);
      PluginWindowManager.getInstance().hideAppOrRecentWindow();
    } else {
      this.arrowResource = $r('sys.media.ohos_ic_public_arrow_up');
      windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_TRAY_PANEL);
    }
    this.showTray = showTray;
  }

  /**
   * 初始化
   */
  private initWindowPolicy(): void {
    log.showInfo('init window Policy');
    // 监听窗口事件
    this.eventMgr
      .on(WindowEvent, (event: WindowEvent): void => {
        this.onWindowEvent(event)
      })
      .on(ScreenOnOffEvent, (event: ScreenOnOffEvent): void => {
        this.onScreenOnOffEvent(event)
      })
      .on(HideWindowPanelEvent, (event: HideWindowPanelEvent) => {
        this.hideWindowPanel();
      })
      .on(SCBFoldStatePropertyChangeEvent, this.onSuperFoldStatusChange)
      .on(HideAppConfigLoadEvent, this.handleHideAppConfigLoadEvent);
  }

  handleHideAppConfigLoadEvent = (event: HideAppConfigLoadEvent): void => {
    this.isAIHide = GetHideAppsFromConfig.getInstance().isHideApp(VASSISTANT_BUNDLE_NAME);
    log.showInfo(`dockstatus handleHideAppConfigLoadEvent ${this.isAIHide}`);
  }

  onSuperFoldStatusChange = (superFoldStateProperty: SCBFoldStatePropertyChangeEvent) => {
    if (!superFoldStateProperty.tarState || superFoldStateProperty.tarState === SCBFoldState.UNKNOWN) {
      log.showError('status error!');
      return;
    }
    log.showInfo(`onSuperFoldStatusChange property, bSideWidth: ${superFoldStateProperty.bSideWidth}, ` +
      `curState: ${superFoldStateProperty.curState}, tarState: ${superFoldStateProperty.tarState}`);
    this.mScreenWidth = px2vp(superFoldStateProperty.bSideWidth);
    this.spaceRowWidthChangeOnSuperFoldStatusChange(superFoldStateProperty);
    this.isVertical = superFoldStateProperty.tarState !== SCBFoldState.UNFOLDED_HORIZONTAL;
    this.constraintSizeNumber = this.calculateMaxWidth();
    log.showInfo(`constrainSizeNumber: ${this.constraintSizeNumber}`);
    // 竖屏时多余的图标放入托盘
    if (superFoldStateProperty.tarState === SCBFoldState.UNFOLDED_VERTICAL) {
      PcStatusBarDragMgr.getInstance().slotToTray();
    }
  }

  onScreenPropertyChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    if (reason !== SCBPropertyChangeReason.CHANGE_MODE) {
      return;
    }
    log.showInfo(`screen width is :${screenProperty.width}`);
    this.mScreenWidth = px2vp(screenProperty.width);
    this.constraintSizeNumber = this.calculateMaxWidth();
  }

  // 状态变化时更新安全边距
  private spaceRowWidthChangeOnSuperFoldStatusChange(superFoldStateProperty: SCBFoldStatePropertyChangeEvent) {
    // 横屏时更新为48
    if (superFoldStateProperty.tarState === SCBFoldState.UNFOLDED_HORIZONTAL) {
      this.spaceRowWidth = this.calculateSpaceRowWidth(SPACING);
    } else {
      this.spaceRowWidth = this.calculateSpaceRowWidth(VERTICAL_SPACING);
    }
  }

  private hideWindowPanel(): void {
    this.onArrowStateChange(false);
  }

  /**
   * 监听窗口show/hide事件
   *
   * @param event 事件
   */
  private onWindowEvent(event: WindowEvent): void {
    // 非当前窗口，如果是开始展示则隐藏
    if (event.windowName !== PluginSlot.SLOT_STATUS_TRAY_PANEL) {
      log.showInfo(`onWindowEvent tray item: ${event.windowName}`);
      return;
    }
    if (event.isWindowStartShow()) {
      this.onArrowStateChange(true);
    } else if (event.isWindowEndHide()) {
      this.onArrowStateChange(false);
    }
  }

  /**
   * 亮灭屏事件
   *
   * @param event 事件
   */
  private onScreenOnOffEvent(event: ScreenOnOffEvent): void {
    // 熄屏隐藏面板
    if (event.isScreenOff()) {
      // 提前隐藏弹框
      windowMgr.hideWindowImmediately(PluginSlot.SLOT_STATUS_TRAY_PANEL);
    }
  }

  private calculateSpaceRowWidth(spacing: number): number {
    return spacing - ITEM_SPACE - this.mSmartDockStyleConfig.mListItemGap;
  }

  private calculateMaxWidth(): number {
    log.showInfo(`onWindowEvent mScreenWidth: ${this.mScreenWidth}`);
    let iconAreaScale: number = 1.0 / 3.0;
    if (DeviceHelper.isSuperFoldMachine() && this.isVertical || this.mScreenWidth <= 840) {
      iconAreaScale = 1.0 / 2.0;
      log.showInfo('calculateMaxWidth iconAreaScale:' + iconAreaScale);
    }
    PcStatusBarDragMgr.getInstance().statusBarRightWidth = this.mScreenWidth * iconAreaScale - BUTTON_WIDTH -
      BUTTON_RIGHT_MARGIN - END_SPACE_RIGHT;
    log.showInfo(`statusBarRightWidth: ${PcStatusBarDragMgr.getInstance().statusBarRightWidth}`);
    return this.mScreenWidth * iconAreaScale + this.spaceRowWidth +
      BUTTON_WIDTH + BUTTON_RIGHT_MARGIN;
  }

  /**
   * 根据壁纸深浅色改变图标背景色
   */
  private getCurrentBgColorByContentColor(): ResourceColor {
    // 优先选中状态
    if (this.showTray) {
      return this.contentColor === DARK_COLOR ? '#26FFFFFF' : '#19000000';
    }
    // 其次hover状态
    if (this.isHover) {
      return this.contentColor === DARK_COLOR ? '#19FFFFFF' : '#0C000000';
    }
    return Color.Transparent;
  }

  @Builder
  arrowButton() {
    Column() {
      Image(this.arrowResource)
        .draggable(false)
        .width(ARROW_IMAGE_SIZE)
        .height(ARROW_IMAGE_SIZE)
        .fillColor(this.contentColor)
        .opacity(0.9)
    }
    .key(`${TAG}_arrowbutton`)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .groupDefaultFocus(false)
    .width(BUTTON_WIDTH)
    .height(BUTTON_SIZE)
    .margin({ end: LengthMetrics.vp(BUTTON_RIGHT_MARGIN) })
    .onTouch((event) => {
      if (event?.type === TouchType.Down) {
        if (trayPanelMenuVM.isHaveMenuOpen()) {
          trayPanelMenuVM.setNeedCloseTrayPanelThisTime(false);
        }
        event?.stopPropagation();
      }
    })
    .onClick(() => {
      EvtBus.post(WindowPositionChangeEvent, {
        windowName: PluginSlot.SLOT_STATUS_TRAY_PANEL,
        position: PluginPosition.POSITION_RIGHT,
        area: windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_TRAY_PANEL)
      });
      this.reportClickEvent();
      this.onArrowStateChange(!this.showTray);
    })
    .onHover((isHover) => {
      this.isDockPopupShow = true;
      log.showInfo(`isHover:${this.isHover}, isDockPopupShow:${this.isDockPopupShow}}`);
      this.isHover = isHover
      this.delayHoverTips(isHover ? HOVER_ENTER_TIPS_DELAY : HOVER_LEAVE_TIPS_DELAY, isHover);
    })
    .borderRadius(8)
    .backgroundColor(this.getCurrentBgColorByContentColor())
    .onAreaChange((oldArea, newArea) => {
      PcStatusBarDragMgr.getInstance().setArrowRect(newArea);
      let trayArea = PluginGroupingManager.getInstance()
        .getPluginGroup(PluginPositionType.BOTTOM_RIGHT, PluginGroupType.TRAY);
      trayArea.updateLocalGroupArea(newArea);
      StatusBarEventPoster.getInstance().postAreaEvent(PluginSlot.SLOT_STATUS_TRAY_PANEL, trayArea.getGroupArea());
      if (windowMgr.isShowing(PluginSlot.SLOT_STATUS_TRAY_PANEL)) {
        animateTo({
          curve: this.trayPosChangeCurve,
        }, () => {
          EvtBus.post(WindowPositionChangeEvent, {
            windowName: PluginSlot.SLOT_STATUS_TRAY_PANEL,
            position: PluginPosition.POSITION_RIGHT,
            area: windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_TRAY_PANEL)
          });
        })
      }
    })
    .bindPopup(this.popupShowJudge(), {
      builder: this.hoverTipsBuilder(),
      placement: Placement.Top,
      mask: false,
      enableArrow: false,
      autoCancel: true,
      showInSubWindow: true,
      radius: StyleConstants.DEFAULT_8,
      shadow: ShadowStyle.OUTER_DEFAULT_SM,
      backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR,
      offset: { x: 0, y: (BUTTON_SIZE - this.dockHeight) / 2}
    })
    .opacity(this.pluginStyle.opacity)
    .arrowButtonDragStyle()
  }

  @Styles
  arrowButtonDragStyle(): void {
    .onDragEnter((event: DragEvent, extraParams?: string) => {
      log.showInfo('arrowButton onDragEnter');
      if (CheckEmptyUtils.isEmpty(extraParams)) {
        return;
      }
      if (!PcStatusBarDragMgr.getInstance().checkCanDrop(extraParams)) {
        return;
      }
      EvtBus.post(WindowPositionChangeEvent, {
        windowName: PluginSlot.SLOT_STATUS_TRAY_PANEL,
        position: PluginPosition.POSITION_RIGHT,
        area: windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_TRAY_PANEL)
      });
      PcStatusBarDragMgr.getInstance().onDragEnterArrow(event, extraParams);
      if (!PcStatusBarDragMgr.getInstance().isTrayAreaVisableEmpty()) {
        this.showTray = true;
        this.onArrowStateChange(this.showTray);
      }
    })
    .onDragMove((event: DragEvent, extraParams?: string) => {
      log.showInfo('arrowButton onDragMove');
      PcStatusBarDragMgr.getInstance().onDragEnterArrow(event, extraParams);
    })
    .onDragLeave((event?: DragEvent, extraParams?: string) => {
      log.showInfo('arrowButton onDragLeave');
    })
    .onDrop((event: DragEvent, extraParams?: string) => {
      if (CheckEmptyUtils.isEmpty(extraParams)) {
        return;
      }
      if (event) {
        event.useCustomDropAnimation = true;
        event.setResult(DragResult.DRAG_FAILED);
      }
      PcStatusBarDragMgr.getInstance().OnDropInArrow(event, extraParams);
    })
  }

  private reportClickEvent(): void {
    reportIntervalMgr.addEventCount(PluginSlot.SLOT_STATUS_TRAY_PANEL);
    HiSysEventUtil.hiSysOnIconItemClick(PluginSlot.SLOT_STATUS_TRAY_PANEL);
  }

  private popupShowJudge(): boolean {
    if (this.showTray) {
      this.isPopupShow = false;
    }
    this.isPopupShow = this.isPopupShow && this.isDockPopupShow;
    return this.isPopupShow;
  }

  private clearHoverDelayTimer(): void {
    log.showDebug(`clearHoverDelayTimer happen`);
    if (this.hoverDelayTimer) {
      clearTimeout(this.hoverDelayTimer);
      this.hoverDelayTimer = null;
    }
  }

  private delayHoverTips(delay: number, isHovered: boolean): void {
    this.clearHoverDelayTimer();
    this.hoverDelayTimer = setTimeout(() => {
      this.isPopupShow = isHovered;
      this.clearHoverDelayTimer();
      log.showDebug(`delayHoverTips happen end, isPopupShow: ${this.isPopupShow}`);
    }, delay);
  }

  @Builder
  hoverTipsBuilder() {
    Row() {
      Text($r('app.string.more'))
        .draggable(false)
        .id(`StatusBarPluginForPC_Text_tray`)
        .fontSize($r(StatusbarConstants.PC_HOVER_TIPS_TEXT))
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .fontWeight(FontWeight.Regular)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .textAlign(TextAlign.Center)
        .maxLines(1)
        .align(Alignment.Center)
    }
    .justifyContent(FlexAlign.Center)
    .padding({ top: $r('sys.float.padding_level1') })
    .margin($r('sys.float.padding_level4'))
  }

  private getHoverTipsTextWidth(name: string): number | string {
    let width: number | string = POPUP_MIN_TEXT_WIDTH;
    if (CheckEmptyUtils.checkStrIsEmpty(name)) {
      return width;
    }
    width = this.getTextWidth(name, width);
    return width;
  }

  private getTextWidth(appName: string, width: number): number {
    let needTextWidth: number = Math.round(px2vp(measure.measureText({
      textContent: appName,
      fontSize: $r('sys.float.ohos_id_text_size_body1'),
      fontWeight: FontWeight.Regular,
      overflow: TextOverflow.Ellipsis,
      maxLines: 1
    }))) + StyleConstants.DEFAULT_16;
    return needTextWidth > width ? needTextWidth : width;
  }

  build() {
    Row({
      space: ITEM_SPACE,
    }) {
      if (this.isRight) {
        Row()
          .width(this.spaceRowWidth)
          .height('100%')
        if (this.showArrowButton) {
          this.arrowButton()
        }
        StatusBarGroupComponent({
          positionPos: PluginPositionType.BOTTOM_RIGHT
        }).height(BUTTON_SIZE)
          .opacity(this.pluginStyle.opacity)
          .margin({ end: LengthMetrics.vp(this.isAIHide ? 0 : GROUP_COMPONENT_END_MARGIN) })
        LocalGroup({
          localGroupProperty: PluginGroupingManager.getInstance()
            .getPluginGroup(PluginPositionType.ASSISTANT_VOICE, PluginGroupType.FIRST_GROUP),
          positionPos: PluginPositionType.ASSISTANT_VOICE
        }).height(BUTTON_SIZE)
          .constraintSize({
            maxWidth: BUTTON_SIZE
          })
          .width('auto')
          .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
            log.showInfo(`assistantVoice width: ${newValue.width}`);
            let width = Number(newValue.width) + GROUP_COMPONENT_END_MARGIN;
            PcStatusBarDragMgr.getInstance().setAssistantVoiceWidth(width);
          })
          .visibility(this.isAIHide ? Visibility.None : Visibility.Visible)
        Row()
          .width(END_SPACE_RIGHT)
          .height('100%')
      } else {
        Row()
          .width(END_SPACE_RIGHT - 10) // 右侧鸿蒙环容器变大，宽度减小10vp保证布局不变
          .height('100%')
        StatusBarGroupComponent({
          positionPos: PluginPositionType.BOTTOM_LEFT
        })
        Row()
          .width(this.spaceRowWidth)
          .height('100%')
      }
    }
    .constraintSize({ maxWidth: this.constraintSizeNumber })
    .justifyContent(this.isRight ? FlexAlign.End : FlexAlign.Start)
    .alignItems(VerticalAlign.Center)
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      log.showInfo(`onSizeChange ${newValue.width}`);
      if (this.isRight) {
        this.rightStatusBarWidth = Number(newValue.width);
        log.showInfo(`rightStatusBarWidth ${this.rightStatusBarWidth}`);
      } else {
        this.leftStatusBarWidth = Number(newValue.width);
        log.showInfo(`leftStatusBarWidth ${this.leftStatusBarWidth}`);
      }
    })
  }
}