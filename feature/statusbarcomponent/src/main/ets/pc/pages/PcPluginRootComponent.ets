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
import { PluginSlot, viewMgrPolicy, ViewType, GlobalContext, EventManager, EvtBus,
  localEventManager, PluginClickType,
  PluginClickInfo } from '@ohos/frameworkwrapper';
import { ResUtils, SCBFoldStatePropertyChangeEvent } from '@ohos/windowscene';
import { PcLocalPluginComponent } from './PcLocalPluginComponent';
import { PcAccessPluginComponent } from './PcAccessPluginComponent';
import { PcAccessRightMenu } from './PcAccessRightMenu';
import { StatusBarType, styleMgr } from '@ohos/systemuicommon';
import { PluginProperty } from '../viewdata/PluginProperty';
import sEventHandler from '../manager/StatusBarEventPoster';
import { PcRemotePluginComponent } from './PcRemotePluginComponent';
import { StateManager, StateProperty } from '../manager/StateManager';
import { AnimManager, AnimProperty } from '../manager/AnimManager';
import { PluginRootViewModel } from '../viewmodel/PluginRootViewModel';
import { PluginStyle } from '../style/PluginStyle';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/constants/StyleConstants';
import { CommonConstants } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { EventConstants } from '@ohos/launchercommon/src/main/ets/constants/EventConstants';
import { vibratorMgr } from '@ohos/launchercommon/src/main/ets/manager/VibratorManager';
import { HoverTips } from './HoverTips';
import { LengthMetricsUtil } from '../common/LengthMetricsUtil';
import { PcStatusBarDragMgr } from '../manager/PcStatusBarDragMgr';
import { StatusBarEventId, StatusBarEventManager } from '../manager/StatusBarEventManager';
import { CustomEvent, StatusBarCustomEvent } from '../utils/events';
import { BigScreenStatus } from '../common/BigScreenStatus';
import { trayPanelMenuVM } from '../viewmodel/TrayPanelMenuVM'
import { windowMgr } from '@ohos/windowscene';
import { StyleType } from '../utils/enum';
import { PluginGroupingManager } from '../plugingroup/PluginGroupingManager';
import { PluginPosUtils } from '../common/PluginPosUtil';
import { StyleManager } from '../style/PluginStyleManager';
import { PluginStyleUtil } from '../common/PluginStyleUtil';
import { PluginWindowManager } from '../pluginwindow/PluginWindowManager';
import { PluginGroupType } from '../common/PluginConstants';
import { PluginSlotMappingNew } from '../common/PluginSlotMappingNew';

const TAG = 'PluginRootComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const HOVER_ENTER_TIPS_DELAY: number = 700;
const HOVER_LEAVE_TIPS_DELAY: number = 0;
const WHITE = '#FFFFFF';
/**
 * 无法拖动的图标，不需要长按震动
 */
const NON_DRAG_PLUGIN_IN_DYNAMIC: Set<string> = new Set([
  PluginSlot.SLOT_STATUS_VIRTUAL_KEYBOARD,
  PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE,
  PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT,
  PluginSlot.SLOT_STATUS_LOCATION,
  PluginSlot.SLOT_CAPSULE_KEY_MOUSE
]);

/**
 * plugin组件，处理本地、远程plugin
 *
 * @since 2024-7-31
 */
@Component
export struct PcPluginRootComponent {
  /**
   * plugin数据信息
   */
  @ObjectLink property: PluginProperty;
  /**
   * 屏幕宽度
   */
  @StorageProp('screenWidth') screenWidth: number = 0;
  /**
   * 根组件标示，用于复用时区分对象
   * 建议必传，区分各自业务场景
   */
  @Provide rootParentId: string = 'root';
  @State stateProperty: StateProperty | null = null;
  @State animProperty: AnimProperty | undefined = undefined;
  @State pluginStyle: PluginStyle | null = null;
  @StorageProp('statusBarType') @Watch('onStatusBarTypeChange') statusBarType: number = StatusBarType.TYPE_MAIN_MAC_STATUS_BAR;
  @StorageProp('isClipPrivacyIndicator') isClipPrivacyIndicator: boolean = true;
  @State isPopupShow: boolean = false;
  private isGroupPlugin: boolean = true;
  private isTray: boolean = false;
  private pluginRootVM: PluginRootViewModel | null = null;
  private updatePropertyMargin: Function | null = null;
  @StorageProp('dockHeight') dockHeight: number = 0;
  private hoverDelayTimer: number | null = null;
  private onItemAreaChange = (oldArea: Area, newArea: Area): void => {
  };
  @StorageLink('isPopupMenuShow') isDockPopupShow: boolean = true;
  @Consume contentColor: string;
  private eventMgr: EventManager = EvtBus.createEventManager();
  @Provide @Watch('onMenuOpenChange') isMenuOpen: boolean = false;
  @Provide isMenuOpenNotTray: boolean = false;
  @StorageLink('isPluginMenuOpen') isPluginMenuOpen: boolean = false;
  private bigScreenStatus: BigScreenStatus = BigScreenStatus.getInstance();

  /**
   * 图标被点击时动效，用于PC图标
   */
  private clickAnimation: AnimateParam = {
    duration: 200,
    curve: Curve.Sharp,
    onFinish: (() => {
      if (this.stateProperty && this.animProperty) {
        this.animProperty.scaleX = 1;
        this.animProperty.scaleY = 1;
        this.animProperty.backgroundScaleX = 1;
        this.animProperty.backgroundScaleY = 1;
        this.stateProperty.isClicked = false;
        log.showInfo(`slot: ${this.property?.getSlot()}, isClicked: ${this.stateProperty.isClicked}`);
        this.animProperty.isPluginIconAnimating = false;
      }
    })
  }
  /**
   * hover时图标动效，用于PC图标
   */
  private hoverStartAnimation: AnimateParam = {
    duration: 200,
    curve: Curve.Friction,
    iterations: 1,
    playMode: PlayMode.Normal,
    onFinish: (() => {
      if (this.stateProperty && this.animProperty) {
        this.animProperty.isPluginIconAnimating = false;
      }
    })
  }
  /**
   * 非hover时图标动效，用于PC图标
   */
  private hoverEndAnimation: AnimateParam = {
    duration: 150,
    curve: Curve.Friction,
    iterations: 1,
    playMode: PlayMode.Normal,
    onFinish: (() => {
      if (this.stateProperty && this.animProperty) {
        this.animProperty.isPluginIconAnimating = false;
      }
    })
  }

  aboutToAppear(): void {
    log.showDebug('aboutToAppear slot: ' + this.property?.getSlot());
    this.property?.getGroupMenuInfo();
    this.stateProperty = StateManager.getInstance().getState(this.property.getSlot());
    this.animProperty = AnimManager.getInstance().getAnim(this.property.getSlot());
    this.pluginRootVM = new PluginRootViewModel(this.property, this.rootParentId);
    this.pluginStyle = StyleManager.getInstance()
      .requestStyle(StyleType.PLUGIN, this.property.getSlot()) as PluginStyle;
    this.updatePropertyMargin?.(this.property.getSlot(), this.property.index, this.statusBarType, this.property.isLast);
    this.pluginRootVM.init();
    this.eventMgr
      .on(SCBFoldStatePropertyChangeEvent, this.onBigScreenStatusChange);
  }

  aboutToDisappear(): void {
    this.eventMgr.offAll();
    this.pluginRootVM?.onDestroy();
    log.showInfo('aboutToDisappear slot: ' + this.property?.getSlot());
  }

  @Builder
  RightMenuBuilder(isTrayPanelMenu: boolean = false) {
    PcAccessRightMenu({
      property: this.property,
      isTrayPanelMenu: isTrayPanelMenu
    })
  }

  /**
   * 获取图标动画
   *
   * @returns 图标动画
   */
  getAnimation(): AnimateParam | null {
    if (!this.stateProperty || !this.animProperty) {
      log.showDebug('param error');
      return null;
    }
    log.showDebug(`isClicked:${this.stateProperty.isClicked}, isHovered:${this.stateProperty.isHovered}`);
    if (this.stateProperty.isClicked) {
      return this.clickAnimation;
    }
    if (this.isWindowStyle()) {
      log.showDebug('window type has no scale animation');
      return null;
    }
    if (this.stateProperty.isHovered) {
      return this.hoverStartAnimation;
    } else {
      return this.hoverEndAnimation;
    }
  }

  @Builder
  localPlugin() {
    PcLocalPluginComponent({
      property: this.property,
      animProperty: this.animProperty,
      iconWidth: this.pluginStyle?.iconWidth,
      pluginStyle: this.pluginStyle,
      mAnimation: this.getAnimation(),
    })
  }

  @Builder
  accessPlugin() {
    PcAccessPluginComponent({
      property: this.property,
    })
      .id(`${TAG}_AccessPluginComponent_${this.property?.getSlot()}`)
      .width(this.pluginStyle?.getIconWidth())
      .height(this.pluginStyle?.iconHeight)
      .borderRadius(this.pluginStyle?.iconContainerRadius)// 动效期间不切割
      .clip(false)
      .scale({ x: this.animProperty?.scaleX, y: this.animProperty?.scaleY })
      .animation(this.getAnimation())// 屏蔽事件，防止消费touch事件,状态胶囊自定义点击事件放开
      .enabled(this.pluginStyle?.iconEnable || this.property?.isEnabled())
  }

  @Builder
  loadPlugin() {
    // 区分本应用和三方应用
    if (this.property?.isLocalPlugin()) {
      this.localPlugin()
    } else if (this.property?.isPluginTypeAccess()) {
      this.accessPlugin()
    }
  }

  /**
   * 加载图标
   */
  @Builder
  loadPluginWithInnerContainer() {
    if (this.pluginStyle?.innerContainerVisible) {
      // double border container
      Stack() {
        // inner border and blur container
        Row() {
        }
        .width(this.getValueAfterReduce(this.pluginStyle?.getIconWidth(),
          this.pluginStyle?.borderWidth * 2) as Length)
        .height(this.getValueAfterReduce(this.pluginStyle?.iconHeight,
          this.pluginStyle?.borderWidth * 2))
        .borderRadius(this.getValueAfterReduce(this.pluginStyle?.iconContainerRadius,
          this.pluginStyle?.borderWidth))
        .border({
          width: ResUtils.getNumberFromLength(this.pluginStyle?.borderWidth),
          color: this.pluginStyle?.innerBorderColor,
        })
        // undefined value will display, so need defined boolean type
        .visibility(this.pluginStyle?.innerContainerVisible ? Visibility.Visible : Visibility.None)

        this.loadPlugin()
      }
      .id('loadPluginWithInnerContainer_doubleBorderContainer')
      .border({
        width: ResUtils.getNumberFromLength(this.pluginStyle?.borderWidth),
        color: this.pluginStyle?.outerBorderColor,
        radius: this.pluginStyle?.iconContainerRadius
      })
    } else {
      this.loadPlugin()
    }
  }

  /**
   * 加载子布局
   */
  @Builder
  loadPluginWithContainer() {
    this.loadPluginWithInnerContainer();
    // 背景
    if (this.pluginStyle?.isNeedIconBg &&
      (this.stateProperty?.isSelected || this.stateProperty?.isHovered || this.stateProperty?.isClicked) &&
      this.buildBgLog()) {
      Row()
        .width(this.getPluginRootBgWidth())
        .height(this.pluginStyle?.iconBgHeight)
        .borderRadius(this.pluginStyle?.iconBgRadius)
        .backgroundColor(this.pluginStyle?.getCurrentBgColorByContentColor(this.contentColor === WHITE,
          this.stateProperty?.isSelected,
          this.stateProperty?.isHovered, this.stateProperty?.isClicked))
        .offset({ x: this.pluginStyle?.iconBgOffsetX })
        .enabled(false)
        .id(`${TAG}_Row_background`)
    }
  }

  buildBgLog(): boolean {
    log.showInfo(`isNeedIconBg: ${this.pluginStyle?.isNeedIconBg}, ` +
      `stateProperty: ${JSON.stringify(this.stateProperty)}`);
    return true;
  }

  private getPluginRootBgWidth(): Length | undefined {
    if (this.isGroupPlugin) {
      return this.pluginStyle?.getBgWidth();
    } else if (this.isTray) {
      return this.pluginStyle?.getBgWidth();
    } else {
      if (this.isWindowStyle()) {
        return ResUtils.getNumberFromLength($r('app.float.icon_container_width_window'));
      }
      return this.pluginStyle?.getBgWidth();
    }
  }

  @Styles
  pluginRootStyle(): void {
    .key(this.property?.getSlot())
    .width(this.getPluginRootWidth())
    .height(this.property?.isNeedSetMenuOffset() && !this.isTray ? `${this.dockHeight}vp` :
      this.pluginStyle?.iconContainerHeight)
    .margin({
      start: LengthMetricsUtil.Length2LengthMetrics(this.pluginStyle?.iconContainerLeftMargin),
      end: LengthMetricsUtil.Length2LengthMetrics(this.pluginStyle?.iconContainerRightMargin)
    })
    .scale({ x: this.animProperty?.backgroundScaleX, y: this.animProperty?.backgroundScaleY })
    .animation(this.getAnimation())
    // 动效期间不切割
    .clip(this.isClipPrivacyIndicator)
    .borderRadius(this.pluginStyle?.getBorderRadius())
    .id(`${TAG}_${this.getPluginType()}_${this.property?.getSlot()}`)
  }

  private getPluginRootWidth(): Length | undefined {
    // 适配OpenHarmony环光效，宽度增加到60vp，避免光效被切割
    if (this.property.getSlot() === PluginSlot.SLOT_STATUS_HOS_KEY) {
      return ResUtils.getNumberFromLength('60vp');
    }
    if (this.isGroupPlugin) {
      return this.pluginStyle?.getIconContainerWidth();
    } else if (this.isTray) {
      return this.pluginStyle?.getIconContainerWidth();
    } else {
      if (this.isWindowStyle()) {
        return ResUtils.getNumberFromLength($r('app.float.icon_container_width_window'));
      }
      return this.pluginStyle?.getIconContainerWidth();
    }
  }

  private popupShowJudge(): boolean {
    if (this.stateProperty?.isSelected) {
      this.clearHoverDelayTimer();
      this.isPopupShow = false;
    }
    // 需要给isPopupShow赋值后再返回，以确保状态更新，保证tips会及时变化，否则会导致即使当前tips消失后，鼠标从图标移动后，tips会有短暂的显隐的过程
    this.isPopupShow = this.isPopupShow && this.isDockPopupShow;
    log.showInfo(`isPopupShow: ${this.isPopupShow}, slot: ${this.property?.getSlot()}`);
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
    HoverTips({
      bundleName: this.property.pluginInfo?.pluginParseInfo.bundleName,
      moduleName: this.property.pluginInfo?.pluginParseInfo.moduleName,
      abilityName: this.property.pluginInfo?.pluginParseInfo.pluginAbilityName,
      appIndex: this.property.pluginInfo?.pluginParseInfo.appIndex,
      pluginSlot: this.property.getSlot(),
    })
  }

  @Styles
  pluginEventReceiver(): void {
    .onAreaChange((oldArea, newArea) => {
      log.showInfo(`onAreaChange slot: ${this.property.getSlot()}, newArea: ${JSON.stringify(newArea)}`);
      this.property.updatePluginArea(newArea);
      sEventHandler.getInstance().postAreaEvent(this.property.getSlot(), this.property.area);
      if (newArea && this.isTray && this.stateProperty?.isHovered) {
        log.showInfo(`onAreaChange slot: ${this.property.getSlot()} send hover false`);
        this.onHoverEvent(false, false);
      }
    })
    .onMouse((event) => {
      if (event.action === MouseAction.Press) {
        this.clearHoverDelayTimer();
        this.isPopupShow = false;
        if (trayPanelMenuVM.isHaveMenuOpen() && this.isTray) {
          trayPanelMenuVM.setNeedCloseTrayPanelThisTime(false);
        }
      }
      sEventHandler.getInstance().postMouseEvent(event, this.property.getSlot(), this.property.getSlot());
    })
    .onTouch((event) => {
      if (event?.type === TouchType.Down && trayPanelMenuVM.isHaveMenuOpen() && this.isTray) {
        trayPanelMenuVM.setNeedCloseTrayPanelThisTime(false);
      }
      sEventHandler.getInstance().postTouchEvent(event, this.property.getSlot(), this.property.getSlot());
      this.handleTouchEventBubble(event);
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
      offset: this.property?.isNeedSetMenuOffset() && !this.isTray ? { x: 0, y: 0 } : this.hoverTipsOffset(),
    })
    .onHover((isHovered: boolean, event: HoverEvent) => {
      this.onHoverEvent(event, isHovered);
    })
    .onClick((event: ClickEvent) => {
      sEventHandler.getInstance().postClickEvent(event, this.property.getSlot(), this.property.getSlot());
    })
    .gesture(
      GestureGroup(GestureMode.Exclusive,
        LongPressGesture({ repeat: false })
          .onAction((event) => {
            log.showInfo('longPressGesture received');
            this.openRightClickMenu();
            sEventHandler.getInstance()
              .postLongClickEvent(event, this.property.getSlot(), this.property.getSlot());
            if (event?.source !== SourceType.Mouse && this.isWindowStyle() &&
              !NON_DRAG_PLUGIN_IN_DYNAMIC.has(this.property.getSlot())) {
              vibratorMgr.startVibration(CommonConstants.VIBRATION_EFFECT_MEDIUM,
                CommonConstants.VIBRATION_ATTRIBUTE_LONG_PRESS, TAG);
            }
          })
      )
    )
  }

  private onHoverEvent(event: CustomEvent, isHover: boolean): void {
    this.isDockPopupShow = true;
    this.delayHoverTips(isHover ? HOVER_ENTER_TIPS_DELAY : HOVER_LEAVE_TIPS_DELAY, isHover);
    StatusBarEventManager.getInstance()
      .postSpecial(StatusBarEventId.CUSTOM_EVENT,
        StatusBarCustomEvent.createEvent(event, this.property.getSlot(), this.property.getSlot(), 'hover', isHover));
  }

  onBigScreenStatusChange = (bigScreenStateProperty: SCBFoldStatePropertyChangeEvent) => {
    let groupName: string = this.getGroupName();
    if (!StateManager.getInstance().getState(groupName).isHovered) {
      return;
    }
    log.showInfo(`onBigScreenStatusChange property, bSideWidth: ${bigScreenStateProperty.bSideWidth}, ` +
      `curState: ${bigScreenStateProperty.curState}, tarState: ${bigScreenStateProperty.tarState}`);
    // 横竖屏旋转时清除hover状态
    if (this.bigScreenStatus.isRotateStatus(bigScreenStateProperty)) {
      log.showInfo(`groupName: ${groupName}, slot: ${this.property.getSlot()}`);
      // 清除分组的父组件hover
      if (this.isNeedPostHoverEvent()) {
        StatusBarEventManager.getInstance()
          .postSpecial(StatusBarEventId.CUSTOM_EVENT,
            StatusBarCustomEvent.createEvent(false, groupName, this.property.getSlot(), 'hover', false));
      }
      this.onHoverEvent(false, false);
    }
  }

  private isNeedPostHoverEvent(): boolean {
    return PluginPosUtils.isBottomArea(this.property.getPluginInPosition());
  }

  private getGroupName(): string {
    return PluginGroupingManager.getInstance()
      .getPluginGroup(this.property.getPluginInPosition(), this.property.getPluginInGroup()).getGroupName();
  }

  private hoverTipsOffset(): Position {
    if (this.isHarmonyRingInWindowType()) {
      return { x: 0, y: (this.pluginStyle?.iconContainerHeight as number - this.dockHeight) / 2 };
    } else if (!this.isTray && this.isBottomArea()) {
      return { x: 0, y: (this.pluginStyle?.iconBgHeight as number - this.dockHeight) / 2 };
    }
    return { x: 0, y: 0 };
  }

  private setMenuStatus(isOpen: boolean): void {
    this.isMenuOpenNotTray = isOpen;
    this.isPluginMenuOpen = isOpen;
  }

  private isBottomArea(): boolean {
    return PluginPosUtils.isBottomArea(this.property.getPluginInPosition());
  }

  @Builder
  groupPluginBuilder() {
    Stack() {
      this.loadPluginWithContainer();
    }
    .onHover((isHovered: boolean, event: HoverEvent) => {
      this.isDockPopupShow = true;
      this.delayHoverTips(isHovered ? HOVER_ENTER_TIPS_DELAY : HOVER_LEAVE_TIPS_DELAY, isHovered);
    })
    .onMouse((event: MouseEvent) => {
      if (event.action === MouseAction.Press) {
        this.clearHoverDelayTimer();
        this.isPopupShow = false;
      }
    })
    .onTouch((event) => {
      this.handleTouchEventBubble(event);
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
      offset: this.property?.isNeedSetMenuOffset() ? { x: 0, y: 0 } : this.hoverTipsOffset(),
    })
    .onDragEnter((event: DragEvent, extraParams?: string) => {
      log.showInfo('onDragEnter ' + this.property?.getSlot());
      if (this.property?.getSlot() === PluginSlot.SLOT_STATUS_INPUT_PANEL &&
        this.isWindowStyle()) {
        PcStatusBarDragMgr.getInstance().onDragEnterLocalGroup(event, extraParams);
      }
    })
    .onDragLeave((event?: DragEvent, extraParams?: string) => {
      log.showInfo('onDragLeave ' + this.property?.getSlot());
    })
    .onDrop((event?: DragEvent, extraParams?: string) => {
      log.showInfo('onDrop' + this.property?.getSlot());
    })
    .onAreaChange((oldArea: Area, newArea: Area) => {
      if (this.property?.getSlot() === PluginSlot.SLOT_STATUS_INPUT_PANEL &&
        this.isWindowStyle()) {
        PcStatusBarDragMgr.getInstance().setInputItemRect(newArea);
      }
    })
    .pluginRootStyle()
  }

  @Builder
  singlePluginBuilder() {
    Stack() {
      this.loadPluginWithContainer();
    }
    .bindContextMenu(this.property?.isPluginTypeAccess() ? this.RightMenuBuilder : undefined, ResponseType.RightClick,
      this.getSingleMenuOptions(this.rightClickAboutToAppear())
    )
    .bindContextMenu(this.isMenuOpenNotTray, this.property?.isPluginTypeAccess() ? this.RightMenuBuilder : undefined,
      this.getSingleMenuOptions()
    )
    .onAreaChange((oldValue: Area, newValue: Area) => {
      this.onItemAreaChange(oldValue, newValue);
    })
    .pluginEventReceiver()
    .pluginRootStyle()
  }

  private getSingleMenuOptions(aboutToApperFunc?: () => void | undefined): ContextMenuOptions {
    return {
      placement: this.property.isNeedSetMenuOffset() ? Placement.TopLeft : this.property?.menuPlacement,
      backgroundColor: Color.Transparent,
      backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR,
      offset: this.property.isNeedSetMenuOffset() ? { x: 4, y: 8 } : undefined,
      aboutToDisappear: () => {
        this.closeRightClickMenu();
      },
      aboutToAppear: aboutToApperFunc
    };
  }

  private callHideDock(): void {
    localEventManager.sendLocalEvent(EventConstants.EVENT_PC_HIDE_DOCK_CALLBACK);
    log.showInfo('callHideDock');
  }

  private getTrayMenuOptions(aboutToApperFunc?: () => void | undefined): ContextMenuOptions {
    return {
      placement: this.property?.menuPlacement,
      aboutToDisappear: () => {
        this.closeRightClickMenu();
      },
      aboutToAppear: aboutToApperFunc,
      backgroundColor: Color.Transparent,
      backgroundBlurStyle: BlurStyle.COMPONENT_REGULAR
    };
  }

  // 右键点击由右键菜单组件处理，但需要保持变量状态一致
  private rightClickAboutToAppear() {
    return () => {
      // 组件布局刷新时会触发长按bindContextMenu刷新，此时如果为false，会导致这个右键菜单关闭
      this.openRightClickMenu();
    };
  }

  @Builder
  trayBuilder() {
    Stack() {
      this.loadPluginWithContainer();
    }
    .bindContextMenu(this.property?.isPluginTypeAccess() ? this.RightMenuBuilder(true) : undefined,
      ResponseType.RightClick,
      this.getTrayMenuOptions(this.rightClickAboutToAppear())
    )
    .bindContextMenu(this.isMenuOpen,
      this.property?.isPluginTypeAccess() ? this.RightMenuBuilder(true) : undefined,
      this.getTrayMenuOptions()
    )
    .pluginEventReceiver()
    .pluginRootStyle()
  }

  build() {
    if (this.property) {
      if (this.isGroupPlugin) {
        this.groupPluginBuilder()
      } else if (this.isTray) {
        this.trayBuilder()
      } else {
        this.singlePluginBuilder()
      }
    }
  }

  /**
   * reduce the param reduceValue(vp) from the param length
   * @param length original value
   * @param reduceValue vp
   * @returns the original length or the reduce length
   */
  private getValueAfterReduce(length: Length, reduceValue: number): Length {
    if (Number.isNaN(reduceValue)) {
      return 0;
    }
    if (reduceValue == 0) {
      return length;
    }
    // convert length to vp
    const num: number = ResUtils.getNumberFromLength(length);
    if (num <= reduceValue) {
      return length;
    }
    // handle different ppi
    return num - (styleMgr.isPCDPI200() ? px2vp(reduceValue) : reduceValue);
  }

  private isHarmonyRingInWindowType(): boolean {
    return this.property.getSlot() === PluginSlot.SLOT_STATUS_HOS_KEY &&
      this.isWindowStyle();
  }

  private openRightClickMenu() {
    log.showInfo(`openRightClickMenu, isTray: ${this.isTray}`);
    if (!this.property.isPluginTypeAccess()) {
      log.showInfo('not access plugin ,return.');
      return;
    }
    if (!this.isTray) {
      this.setMenuStatus(true);
      return;
    }
    trayPanelMenuVM.setNeedCloseTrayPanelThisTime(false);
    trayPanelMenuVM.updateSlotOfOpenMenu(true, this.property.getSlot());
    this.isMenuOpen = true;
  }

  private closeRightClickMenu() {
    log.showInfo(`closeRightClickMenu, isTray: ${this.isTray}`);
    if (!this.isTray) {
      this.setMenuStatus(false);
      // 融合模式沉浸式下关闭菜单，触发dock隐藏
      this.callHideDock();
      return;
    }
    trayPanelMenuVM.updateSlotOfOpenMenu(false, this.property.getSlot());
    // 右键菜单和长按弹出右键菜单不能使用一个，并且在右键菜单中还需要将该变量置为false，否则会导致第二次右键拉不起菜单
    this.isMenuOpen = false;
  }

  private getPluginType(): string {
    if (this.isGroupPlugin) {
      return 'Group';
    } else if (this.isTray) {
      return 'Tray';
    } else {
      return 'Single'
    }
  }

  onMenuOpenChange() {
    log.showInfo(`onMenuOpenChange, isMenuOpen: ${this.isMenuOpen}`);
    if (this.isMenuOpen) {
      return;
    }
    if (trayPanelMenuVM.isNeedCloseTrayPanel()) {
      log.showInfo('close TrayPanel');
      windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_TRAY_PANEL);
    }
  }

  onStatusBarTypeChange() {
    this.pluginStyle = StyleManager.getInstance()
      .requestStyle(StyleType.PLUGIN, this.property.getSlot()) as PluginStyle;
  }

  private isWindowStyle(): boolean {
    return PluginStyleUtil.isWindowStyle();
  }

  private isDraggable(): boolean {
    return PluginStyleUtil.isWindowStyle() &&
      (this.isTray || (this.property.getPluginInGroup() === PluginGroupType.DYNAMIC_LEFT &&
      !PluginSlotMappingNew.DISABLE_DRAG_PLUGIN.has(this.property.getSlot())));
  }

  private handleTouchEventBubble(event: TouchEvent): void {
    if (event?.type !== TouchType.Down) {
      return;
    }
    const clickInfo: PluginClickInfo | undefined =
      this.property.pluginInfo?.pluginParseInfo['clickInfo'];
    const clickType: string | undefined = clickInfo?.clickType;
    log.showInfo(`slot:${this.property.getSlot()}, clickType:${clickType}`);
    if (!this.isDraggable() && clickType === PluginClickType.TYPE_WINDOW) {
      event?.stopPropagation();
    }
  }
}