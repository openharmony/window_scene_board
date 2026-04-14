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
  SingletonHelper,
  LogDomain,
  LogHelper,
  CommonUtils,
  AnimateToScheduleUtils,
  DomainName,
  Trace,
  TraceUtil,
  AppStorageUtil,
  DataProperty
} from '@ohos/basicutils';
import {
  DropDownEvent,
  TargetPanel,
  TargetChangeState,
  WindowEvent,
  DropDownStatus,
  GlobalContext,
  EvtBus,
  RequestWindowEvent,
  HiSysEventUtil,
  HiSysDataResult,
  DeviceHelper,
  ViewManagerPolicy,
  HiDfxEventUtil,
  sSettingsUtil,
  CutoutEvent,
  EventManager,
  ViewArea as ScreenRect,
  DropdownViewEvent,
} from '@ohos/frameworkwrapper';
import { ScreenSessionAdapter } from '../adapter/ScreenSessionAdapter';
import { WindowConstants } from '@ohos/commonconstants';
import { RotationConstants } from '@ohos/commonconstants';
import { ViewType } from '@ohos/frameworkwrapper';
import curves from '@ohos.curves';
import { DropDownPanelManagerWrapper } from '@ohos/frameworkwrapper';
import settings from '@ohos.settings';
import display from '@ohos.display';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { bannerMgr } from '../banner/phone/BannerManager';
import { BannerPanelType } from '../banner/common/info/BannerState';
import { NotificationSysEventReporter, SwitchType } from '../utils/NotificationSysEventReporter';
import { SceneFlag } from '../base/common/SceneFlag';
import screenLock from '@ohos.screenLock';
import { statusBarMaskManager } from '../statusbar/mask/statusBarMaskManager';
import { AccessibilityPageShowHide } from '../accessibility/AccessibilityData';
import { AccessibilityUtil } from '../accessibility/AccessibilityUtil';
import { ControlCenterAnimatingEvent, StaticBlurEvent } from '@ohos/systemuiutils/src/main/ets/sysdialog/CommonEvent';
import { StatisticsMaintenance } from '../maintenance/StatisticsMaintenance';
import { LayoutUtils } from '@ohos/systemuiutils/src/main/ets/base/LayoutUtils';
import { DropdownVm } from '../vm/DropdownVm';
import { StatusBarMoveDownVmV1, StatusBarMoveDownVmV2 } from '../statusbar/vm/StatusBarMoveDownVm';
import { SystemUICcmConfig } from '../utils/SystemUICcmConfig';
import { ArkUIAdapter } from '../utils/ArkUIAdapter';
import { ViewManagerAdapter } from '../adapter/ViewManagerAdapter';
import { StatusBarViewControllerAdapter } from '../adapter/StatusBarViewControllerAdapter';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import { EnvVm } from '../vm/EnvVm';
import { DropDownAdapter } from '../adapter/DropDownAdapter';

const TAG = 'DropDownPanelManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 无中间孔，通知面板下拉范围，2 / 3
 */
const DROPDOWN_RANGE_NOTIFICATION = 2.0 / 3.0;
/**
 * 有中间孔，通知面板下拉范围，中间孔右边界划分，即设备宽度1/2+中间孔宽度1/2
 */
const DROPDOWN_RANGE_NOTIFICATION_MID = 0.5;

/**
 * 面板下拉阈值
 */
const DISTANCE_SHOW_DROPDOWN_PANEL = 95;

/**
 * 最小滑动距离
 */
const TOUCH_SLOP = 5;

/**
 * 横滑触发切换双中心阈值
 */
const DISTANCE_DROP_HORIZONTAL_MIN = 200;

/**
 * 上滑收起面板阈值
 */
const DISTANCE_FOLD_DROPDOWN = -15;

/**
 * 交替下拉反悔速度阈值
 */
const SPEED_VERTICAL_FLING = -1000;

/**
 * 交替下拉反悔速度限值
 */
const SPEED_VERTICAL_FLING_LIMIT = -3000;

const ONFINISH_CALLBACK_TIMEOUT: number = 5000;

/**
 * 锁屏下拉控制中心配置
 */
const CC_DOWN_IN_LOCK_ENABLE: string = 'settings.biometrics.drop_down_control_center_enable';

export class DropDownPanelConstants {
  /**
   * 下拉跟手常数
   */
  public static readonly FINGER_BEHAVIOR_K = -1.848;
  public static readonly STATUS_BAR_CLOCK_GEOMETRY_TRANSITION_ID: string = 'statusBarClockGeometryTransitionId';
  public static readonly NOTIFICATION_TIME_VIEW_SHOW_DELAY: number = 0;
  public static readonly NOTIFICATION_TIME_VIEW_HIDE_DURATION: number = 400;
  public static readonly PHONE_STATUS_CLOCK_SCALE_FONT_SIZE: number = 17;
  public static readonly PANEL_OPACITY_DURATION: number = 350;
  public static readonly PANEL_OPACITY_DURATION_WITH_FAST_SPEED: number = 100;
  public static readonly DISTANCE_FOLD_NOTIFICATION_DROPDOWN = -80;
  public static readonly DISTANCE_FOLD_NOTIFICATION_DROPDOWN_OUTER_HOME = -40;
  public static readonly UP_SLIDE_SPEED_THRESHOLD = -250;
}

export class PanelDismissReason {
  public static readonly SLIDE_HORIZONTAL = 1; // 左右返回手势
  public static readonly SLIDE_UP_WHEN_REACH_END = 2; // 触底上滑
  public static readonly CLICK_BLANK = 3; // 点击空白
  public static readonly SLIDE_UP = 4; // 上滑
  public static readonly OTHER = 5; // 其它
}

export class ScreenInfo {
  public width: number = 0;
  public height: number = 0;
}

interface ISwitchDropdownPanel {
  contentTransX: number;
  contentOpacity: number;
  contentScale: number;
  contentZIndex: number;
  horizontalDropPanelPosition: number;
  /**
   * 隐藏面板
   */
  hidePanel: () => void;
  /**
   * 下拉面板切换垂直抛滑速度到达阈值后的目标面板显示
   *
   * @returns Promise<void>
   */
  onPanelVerticalFlingSwitchShow: () => Promise<void>;

  /**
   * 下拉面板切换垂直抛滑速度到达阈值后的源面板消失
   *
   * @returns Promise<void>
   */
  onPanelVerticalFlingSwitchDismiss: () => Promise<void>;
}

export interface DropdownCallback {
  /**
   * 回调标签，用于问题定位
   */
  tag: string;
  /**
   * 是否为通知中心
   */
  isNC: boolean;
  /**
   * 返回手势回调
   * @returns 返回true表示不能关闭下拉面板
   */
  onBackPress?: () => boolean;
  /**
   * 下拉面板隐藏回调
   */
  onHide?: () => void;
  /**
   * 下拉面板回调
   * @returns 返回true表示不能关闭下拉面板
   */
  onDropdown?: () => boolean;
}

export class DropDownPanelManager {
  static get instance() {
    return sDropDownPanelManager;
  }

  private lastKioskQueryTime: number = 0;
  private lastKioskAllowCC: boolean = true;
  private PARAM_EDM_KIOSK_ALLOW_CONTROL_CENTER: string = 'persist.edm.kiosk.allow_control_center';
  /**
   * 双中心切换动效处理公共组件
   */
  public switchDropdownPanelMap: Map<TargetPanel, ISwitchDropdownPanel> = new Map();
  /**
   * 上滑收起面板阈值
   */
  public static readonly DISTANCE_FOLD_DROPDOWN = -80;
  /**
   * 收起面板动效曲线
   */
  private readonly dismissCurve = curves.cubicBezierCurve(0.33, 0.0, 0.67, 1.0);
  /**
   * 下拉事件
   */
  private dropDownEvent: DropDownEvent;
  /**
   * 下拉状态
   */
  private dropDownStatus: DropDownStatus = DropDownStatus.create();
  /**
   * 手指起始X值
   */
  private startX: number = 0;
  /**
   * 手指起始Y值
   */
  private startY: number = 0;
  private startTime: number = 0;
  private isVerticalBack: boolean = false;
  private isEndAnimRunning: boolean = false;
  private startPositionX: number = 0;
  private startPositionY: number = 0;
  private endPositionX: number = 0;
  private endPositionY: number = 0;
  /**
   * 快捷开关数据
   */
  public quickToggleData: string = '';
  /**
   * 当前是否灭屏状态
   */
  private isScreenOff: boolean = false;
  /**
   * 面板是否正在收起
   */
  private isDismissing: boolean = false;
  /**
   * 截屏事件或录屏事件回调
   */
  private dismissCallback?: () => void = undefined;
  /**
   * 记录双中心标题栏滑动方向，区分下拉跟手与横滑切换
   */
  private dropDirection: TargetChangeState = TargetChangeState.NONE;
  private screenInfo?: ScreenInfo = undefined;
  /**
   * 最后拉起面板的时间
   */
  public lastDropDownTime: number = 0;
  /**
   * 是否横屏
   */
  public isLandscape: boolean = false;
  private panelDismissReason: number = PanelDismissReason.OTHER;
  private mIotMainProxy: UIExtensionProxy | null = null;
  private onFinishTimeoutTimeId: number = -1;
  private staticBlurEvent: StaticBlurEvent = new StaticBlurEvent();
  private startFromPanelStatusBar: boolean = false;
  private isNtfPanel: boolean = false;
  /**
   * 是否是一键删除场景
   */
  public isClearAll: boolean = false;
  /**
   * 挖孔集
   * cutout_position => 挖孔区域
   */
  private cutouts: Map<number, ScreenRect> = new Map();
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  /**
   * 是否允许锁屏时下拉控制中心
   */
  private isControlCenterDownInLockEnable: boolean = true;
  /**
   * kiosk模式通知中心开关
   */
  private PARAM_EDM_KIOSK_ALLOW_NOTIFICATION_CENTER: string = 'persist.edm.kiosk.allow_notification_center';
  /**
   * 更新控制中心快捷开关数据
   *
   *  @param quickToggleData 快捷开关数据
   */
  public updateQuickToggleData(quickToggleData: string): void {
    this.quickToggleData = quickToggleData;
  }

  /**
   * 获取控制中心快捷开关数据
   */
  public getQuickToggleData(): string {
    return this.quickToggleData;
  }

  /**
   * 点击区域是否允许滑动切换面板
   *
   * @param eventPosY 点击Y坐标
   * @param eventPosX 点击X坐标
   */
  public isAllowSwitch?: (eventPosY: number, eventPosX: number) => boolean;
  /**
   * 点击区域是否在通知可视列表内
   */
  public isInNtfVisibleList?: (eventPosY: number, eventPosX: number, itemIndex?: number) => boolean;

  private callbackSet: Set<DropdownCallback> = new Set();

  constructor() {
    this.dropDownEvent = DropDownPanelManagerWrapper.getInstance().getDropDownEvent();
    this.eventMgr.on(CutoutEvent, this.onCutoutEvent);
    this.eventMgr.on(DropdownViewEvent, this.onDropdownViewEvent);
  }

  /**
   * 发送请求收起下拉面板事件
   *
   * @param isAnim 是否收起动效
   */
  postRequestHideWindow(isAnim: boolean): void {
    let event = RequestWindowEvent.create(WindowConstants.WINDOW_NAME_DROPDOWN, RequestWindowEvent.REQUEST_HIDE);
    event.hasWindowAnim = isAnim;
    EvtBus.post(RequestWindowEvent, event);
  }

  /**
   * 挖孔位置切换事件
   */
  private onCutoutEvent = (event: CutoutEvent): void => {
    // 缓存挖孔数据
    this.cutouts.set(event.cutoutPosition, event.cutoutRect);
  };

  private onDropdownViewEvent = (event: DropdownViewEvent): void => {
    log.showInfo(`onDropdownViewEvent, isShow: ${event.isShow}`);
    if (event.isShow) {
      ViewManagerAdapter.showView(ViewType.DROPDOWN);
    } else {
      ViewManagerAdapter.hideView(ViewType.DROPDOWN);
    }
  };

  /**
   * 获取孔类型和宽度
   * @returns
   */
  private getCutoutInfo(): HotRegionCutoutInfo {
    let cutoutType = CutoutEvent.CUTOUT_MID;
    let cutoutWidth = 0;
    let orders = [CutoutEvent.CUTOUT_MID, CutoutEvent.CUTOUT_LEFT, CutoutEvent.CUTOUT_RIGHT];
    for (let order of orders) {
      let info = this.cutouts?.get(order);
      if (!CommonUtils.isInvalidRect(info)) {
        cutoutType = order;
        cutoutWidth = info?.width ?? 0;
        break;
      }
    }
    return {
      cutoutType,
      cutoutWidth
    }
  }

  /**
   * 拉起截屏或录屏接口
   */
  setPanelDismissCallback(callback: () => void): void {
    this.dismissCallback = callback;
    log.showInfo('setPanelDismissCallback');
  }

  /**
   * 收起实况面板
   */
  private releaseLiveList(): void {
    if (bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_LIST)) {
      bannerMgr.releasePanelLiveList(SceneFlag.SCENE_RELEASE_LIVE_LIST_BY_DROP_DOWN);
      // 通知中心下拉成功并且收起实况面板时刷新EffectComponent高度模糊重新取样
      DropdownVm.instance.effectComponentHeight = 'calc(100% - 1px)';
      setTimeout(() => {
        DropdownVm.instance.effectComponentHeight = '100%';
      }, 50);
    }
  }

  /**
   * 下拉结束时，检测是否回弹动效
   */
  touchEndCheckAnim(): void {
    log.showInfo(`touchEndCheckAnim progress = ${this.dropDownEvent?.progress},
      moveY = ${this.dropDownEvent?.progress} target = ${this.dropDownEvent.target}`
    );
    if (this.dropDownEvent.progress >= 1 && this.dropDownEvent.moveY > 0) {
      // 通知、控制面板拉出时，存在实况面板则收起
      this.releaseLiveList();

      // 通知面板，通知开启回弹动效，由面板控制动效
      if (this.dropDownEvent.target == TargetPanel.NOTIFICATION_PANEL) {
        this.dropDownEvent.isEndAnimRunning = true;
        return;
      }
      animateTo(this.getEndAnim(), () => {
        this.dropDownEvent.moveY = 0;
        this.dropDownEvent.translateY = 0;
        this.dropDownEvent.targetChangedMove = 0;
      });
    }
  }

  /**
   * 获取下拉结束的回弹动画
   *
   * @return 回弹动画
   */
  getEndAnim(): AnimateParam {
    return {
      duration: 500,
      curve: Curve.Friction,
      onFinish: () => {
        this.dropDownEvent.isEndAnimRunning = false;
      }
    };
  }

  /**
   * 收起面板上滑阈值
   *
   * @return 上滑阈值
   */
  getFoldDropDownSlop(): number {
    return DISTANCE_FOLD_DROPDOWN;
  }

  /**
   * obtain card brightness
   *
   * @param isDarkMode whether is dark mode
   * @returns brightness
   */
  public getDropDownCardBrightness(isDarkMode: boolean): number {
    return isDarkMode ? 0.9 : 1.1;
  }

  /**
   * obtain card saturation
   *
   * @param isDarkMode whether is dark mode
   * @returns saturation
   */
  public getDropDownCardSaturation(isDarkMode: boolean): number {
    return isDarkMode ? 1.4 : 1.2;
  }

  /**
   * 获取下拉事件
   */
  public getDropDownEvent(): DropDownEvent {
    return this.dropDownEvent;
  }

  /**
   * 获取下拉状态
   */
  public getDropDownStatus(): DropDownStatus {
    return this.dropDownStatus;
  }

  /**
   * 清除下拉事件状态
   */
  public clearState(): void {
    this.dropDownEvent.reset();
  }

  /**
   * 获取最小滑动距离
   */
  public getTouchSlop(): number {
    return TOUCH_SLOP;
  }

  /**
   * 获取交替下拉反悔速度阈值
   */
  public getVerticalFlingSpeed(): number {
    return SPEED_VERTICAL_FLING;
  }

  /**
   * 获取交替下拉反悔速度限值
   */
  public getVerticalFlingSpeedLimit(): number {
    return SPEED_VERTICAL_FLING_LIMIT;
  }

  /**
   * 获取滑动阈值
   */
  public getPanelShowDistance(): number {
    return DISTANCE_SHOW_DROPDOWN_PANEL;
  }

  /**
   * 更新双中心面板下拉时间，用于计算停留时间
   */
  public updateDropDownTime(): number {
    this.lastDropDownTime = new Date().getTime();
    DropdownVm.instance.lastDropdownTime = this.lastDropDownTime;
    return this.lastDropDownTime;
  }

  public getLastDropdownTime(): number {
    return this.lastDropDownTime;
  }

  public setDismissReason(reason: number): void {
    this.panelDismissReason = reason;
  }

  public onOrientationChanged(isLandscape: boolean): void {
    this.isLandscape = isLandscape;
  }

  /**
   * 更新锁屏下拉控制中心配置
   */
  public updateControlCenterDownInLockEnable(): void {
    sSettingsUtil.getValueAsync(CC_DOWN_IN_LOCK_ENABLE, 'true').then((res: string) => {
      let option: boolean = res !== 'false';
      log.showInfo(`isControlCenterDownInLockEnable, old: ${this.isControlCenterDownInLockEnable}, new: ${option}`);
      if (this.isControlCenterDownInLockEnable !== option) {
        this.isControlCenterDownInLockEnable = option;
        log.showInfo(`set isControlCenterDownInLockEnable: ${option}`);
      }
    })
  }

  /**
   * 获取锁屏下拉控制中心配置
   *
   * @returns true 允许锁屏时下拉
   */
  public getControlCenterDownInLockEnable(): boolean {
    return this.isControlCenterDownInLockEnable;
  }

  /**
   * 监听锁屏下拉控制中心配置
   */
  public registerControlCenterDownInLockEnable(): void {
    let result: boolean = false;
    try {
      this.updateControlCenterDownInLockEnable();
      result = settings.registerKeyObserver(GlobalContext.getContext(), CC_DOWN_IN_LOCK_ENABLE,
        settings.domainName.DEVICE_SHARED, (err, value) => {
          log.showInfo(`registerControlCenterDownInLockEnable, callback value: ${String(value)}, err code:${err?.code}, msg: ${err?.message}`);
          this.updateControlCenterDownInLockEnable();
        })
    } catch (err) {
      log.showError(`registerControlCenterDownInLockEnable failed, err code: ${err?.code}, msg: ${err?.message}`);
    }
    log.showInfo(`registerControlCenterDownInLockEnable, result: ${result}`);
  }

  /**
   * 注销监听锁屏下拉控制中心配置
   */
  public unRegisterControlCenterDownInLockEnable(): void {
    let result: boolean = false;
    try {
      result = settings.unregisterKeyObserver(GlobalContext.getContext(), CC_DOWN_IN_LOCK_ENABLE,
        settings.domainName.DEVICE_SHARED);
    } catch (err) {
      log.showError(`unRegisterControlCenterDownInLockEnable failed, err code: ${err?.code}, msg: ${err?.message}`);
    }
    log.showInfo(`unRegisterControlCenterDownInLockEnable, result: ${result}`);
  }

  /**
   * 当前面板是否可见
   *
   * @returns true可见
   */
  isPanelShowing(): boolean {
    return ViewManagerPolicy.isViewShowing(ViewType.DROPDOWN) ?? false;
  }

  /**
   * 当前面板是否可见
   * @returns true可见
   */
  async isPanelShowingAsync(): Promise<boolean> {
    return await ViewManagerAdapter.isViewShowing(ViewType.DROPDOWN) ?? false;
  }

  /**
   * 有动画展开目标面板
   *
   * @param target 目标面板
   */
  public animToShow(target: TargetPanel): void {
    log.showInfo(`animToShow target = ${target}`);
    if (target === TargetPanel.NONE) {
      return;
    }
    if (target === TargetPanel.CONTROL_CENTER_PANEL) {
      log.showInfo('IntoCC start');
      TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_SHOW);
    } else if (target === TargetPanel.NOTIFICATION_PANEL) {
      log.showInfo('IntoNC start');
      TraceUtil.startTrace(DomainName.NC, Trace.CORE_METHOD_NOTIFICATION_PANEL_SHOW);
    }
    DropDownPanelManagerWrapper.getInstance().postWindowEvent(WindowConstants.WINDOW_NAME_DROPDOWN,
      WindowEvent.EVENT_TYPE_SHOW, WindowEvent.EVENT_STATE_START);
    ViewManagerAdapter.showView(ViewType.DROPDOWN);
    this.setTargetPanel(target);
    this.dropDownEvent.progress = 1;
    this.dropDownEvent.translateY = 0;

    // 通知、控制面板拉出时，存在实况面板则收起
    this.releaseLiveList();
  }

  /**
   * 有动画收起目标面板事件
   *
   * @param target 目标面板
   */
  public animToDismissEvent(): void {
    if (DeviceHelper.isPC()) {
      ViewManagerAdapter.hideView(ViewType.CONTROL_CENTER);
      setTimeout(() => {
        if (this.dismissCallback != undefined) {
          this.dismissCallback();
          this.dismissCallback = undefined;
          log.showInfo('dismissCallback_pc');
        }
      }, 100)
    } else {
      this.animToDismiss();
    }
  }

  /**
   * 有动画收起目标面板
   *
   * @param target 目标面板
   */
  public animToDismiss(): void {
    this.dropDownEvent.translateY = 0;
    log.showInfo('animToDismiss');
    this.mIotMainProxy?.send({ 'method': 'closeControlCenter' });
    this.animDelayToDismiss(0);
  }

  public setIotProxy(proxy: UIExtensionProxy | null): void {
    this.mIotMainProxy = proxy;
  }

  /**
   * 有动画收起目标面板
   *
   * @param target 目标面板
   */
  public async animDelayToDismiss(delay: number, isFingerprintEvent?: boolean): Promise<void> {
    log.showInfo(`animDelayToDismiss, delay = ${delay}`);
    if (!(await ViewManagerAdapter.isViewShowing(ViewType.DROPDOWN))) {
      this.dropDownEvent.reset();
      return;
    }
    if (this.isDismissing) {
      return;
    }
    let currentTargetPanel = this.getCurrentTargetPanel();
    if (currentTargetPanel === TargetPanel.CONTROL_CENTER_PANEL) {
      log.showInfo('ExitCC start');
      TraceUtil.startTrace(DomainName.CC, Trace.CORE_METHOD_CONTROL_CENTER_HIDE);
      performanceMonitor.begin('EXIT_CC_ANI', performanceMonitor.ActionType.LAST_UP);
      HiSysEventUtil.reportControlCenterHide({
        KEEPTIME: new Date().getTime() - this.lastDropDownTime,
        TIMESTAMP: `${this.lastDropDownTime}`,
        ORIENTATION: this.isLandscape ? 1 : 0,
        QUICKTOGGLEDATA: this.quickToggleData,
        TYPE: this.panelDismissReason,
        LOCKSTATUS: AppStorage.get('lockStatus'),
        SCREENTYPE: 0,
      });
      this.panelDismissReason = PanelDismissReason.OTHER;
    } else if (currentTargetPanel === TargetPanel.NOTIFICATION_PANEL) {
      log.showInfo('ExitNC start');
      TraceUtil.startTrace(DomainName.NC, Trace.CORE_METHOD_NOTIFICATION_PANEL_HIDE);
      performanceMonitor.begin('EXIT_NC_ANI', performanceMonitor.ActionType.LAST_UP);
      if (!isFingerprintEvent) {
        HiSysEventUtil.reportNotificationPanelHide({
          TIMESTAMP: `${this.lastDropDownTime}`,
          ORIENTATION: this.isLandscape ? 1 : 0,
          DURATION: `${new Date().getTime() - this.lastDropDownTime}`
        }, await ScreenSessionAdapter.isFoldablePhoneExpandStatus());
      } else {
        NotificationSysEventReporter.notificationBannerDropdownByFinger({
          OPERATION: 'pullUp',
          PANEL_TYPE: 'notification'
        });
      }
    }
    this.isDismissing = true;
    this.onFinishCallbackTimeout();
    if (currentTargetPanel !== TargetPanel.NOTIFICATION_PANEL) {
      AppStorageUtil.setOrCreate('isMarkingRenderGroup', true, new DataProperty(true, false));
      log.showInfo('START_DROP_DOWN_PANEL Set renderGroup true');
    }
    AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_START);
    // 面板回收动效结束之前，状态状态不支持下拉操作
    statusBarMaskManager.setStatusBarMaskState(true);
    log.showInfo('animToDismiss setStatusBarMaskState(true).');
    this.staticBlurEvent.setValue(0);
    EvtBus.post(StaticBlurEvent, this.staticBlurEvent);
    AppStorageUtil.setOrCreate('isDropdownPanelStaticShow', false);
    animateTo({
      duration: DropDownPanelConstants.NOTIFICATION_TIME_VIEW_HIDE_DURATION, // 动画时长
      curve: this.dismissCurve,
      delay: delay, // 动画延迟
      iterations: 1, // 播放次数
      playMode: PlayMode.Normal, // 动画模式
      onFinish: () => {
        log.showInfo('animToDismiss finish.');
        AppStorageUtil.setOrCreate('isDropdownPanelStaticShow', true);
        AnimateToScheduleUtils.raiseAnimateToSchedulePriority(AnimateToScheduleUtils.VALUE_END);
        DropDownPanelManagerWrapper.getInstance().postWindowEvent(WindowConstants.WINDOW_NAME_DROPDOWN,
          WindowEvent.EVENT_TYPE_HIDE, WindowEvent.EVENT_STATE_START);
        this.dropDownEvent.reset();
        ViewManagerAdapter.hideView(ViewType.DROPDOWN);
        if (currentTargetPanel === TargetPanel.CONTROL_CENTER_PANEL) {
          EvtBus.post(ControlCenterAnimatingEvent, { controlCenterAnimating: false });
        }
        if (this.dropDownEvent.progress !== 0 || this.dropDownEvent.moveY !== 0) {
          HiDfxEventUtil.reportShowDropdownPanelAbnormal();
        }
        this.isDismissing = false;
        if (this.dismissCallback != undefined) {
          this.dismissCallback();
          this.dismissCallback = undefined;
          log.showInfo(TAG, 'dismissCallback');
        }
        // 异常打点情况兜底
        performanceMonitor.end('EXIT_NC_ANI');
        performanceMonitor.end('EXIT_CC_ANI');
      }
    }, () => {
      this.dropDownEvent.progress = 0;
      this.dropDownEvent.moveY = 0;
    });
  }

  onFinishCallbackTimeout(): void {
    if (this.onFinishTimeoutTimeId !== -1) {
      clearTimeout(this.onFinishTimeoutTimeId);
    }
    this.onFinishTimeoutTimeId = setTimeout(() => {
      if (this.isDismissing) {
        log.showInfo('The onFinish callback is not received.');
        this.isDismissing = false;
      }
      this.onFinishTimeoutTimeId = -1;
    }, ONFINISH_CALLBACK_TIMEOUT);
  }

  /**
   * 无动画展开目标面板
   *
   * @param target 目标面板
   */
  showWindowDirectly(target: TargetPanel): void {
    DropDownPanelManagerWrapper.getInstance().showWindowDirectly(target);
  }

  /**
   * 无动画收起目标面板
   *
   * @param target 目标面板
   */
  hideWindowDirectly(): void {
    DropDownAdapter.hideWindowDirectly();
  }

  public onTapAction(event?: GestureEvent): void {
    sDropDownPanelManager.animToDismiss();
  }

  public onPanActionStart(event?: GestureEvent): void {
    log.showInfo('onPanActionStart');
    if (this.shouldIgnorePanAction()) {
      log.showWarn(`Should ignore pan action, isDismissing: ${this.isDismissing}`);
      return;
    }
    if (sDropDownPanelManager.dropDownEvent.target === TargetPanel.CONTROL_CENTER_PANEL) {
      performanceMonitor.begin('INTO_NC_FROM_CC', performanceMonitor.ActionType.FIRST_MOVE);
    } else {
      performanceMonitor.begin('INTO_CC_FROM_NC', performanceMonitor.ActionType.FIRST_MOVE);
      TraceUtil.startTrace(DomainName.NC, HiSysEventUtil.INTO_CC_FROM_NC, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    }
    this.startTime = Date.now();
    sDropDownPanelManager.clearDropDirection();
    sDropDownPanelManager.dropDownEvent.targetChanged = TargetChangeState.NONE;
  }

  public onPanActionUpdate(event: GestureEvent): void {
    log.showInfo('onPanActionUpdate');
    if (this.shouldIgnorePanAction()) {
      log.showWarn(`Should ignore pan actionUpdate, isDismissing: ${this.isDismissing}`);
      return;
    }
    let diffX = event.offsetX;
    let diffY = Math.abs(event.offsetY);
    if (sDropDownPanelManager.getDropDirection(diffX, diffY) != TargetChangeState.HORIZONTAL) {
      sDropDownPanelManager.dropDownEvent.targetChangedMove = 0;
      sDropDownPanelManager.dropDownEvent.targetChanged = TargetChangeState.NONE;
      return;
    }
    sDropDownPanelManager.dropDownEvent.moveY = 0;
    sDropDownPanelManager.dropDownEvent.translateY = 0;
    let moveSlop = sDropDownPanelManager.dropDownEvent.target == TargetPanel.CONTROL_CENTER_PANEL
      ? TOUCH_SLOP : -TOUCH_SLOP;
    sDropDownPanelManager.dropDownEvent.targetChangedMove = diffX + moveSlop;
    if ((diffX + moveSlop > 0 && sDropDownPanelManager.dropDownEvent.target == TargetPanel.CONTROL_CENTER_PANEL) ||
      (diffX + moveSlop < 0 && sDropDownPanelManager.dropDownEvent.target == TargetPanel.NOTIFICATION_PANEL)) {
      sDropDownPanelManager.dropDownEvent.targetChanged = TargetChangeState.HORIZONTAL;
    } else {
      sDropDownPanelManager.dropDownEvent.targetChanged = TargetChangeState.HORIZONTAL_REVERSES;
    }
  }

  public onPanActionEnd(event: GestureEvent, isfromPanel?: boolean): void {
    log.showInfo('onPanActionEnd swipe to Up Cancel');
    if (this.shouldIgnorePanAction()) {
      log.showWarn(`Should ignore pan actionEnd, isDismissing: ${this.isDismissing}`);
      return;
    }
    let endX = event.offsetX;
    let endY = event.offsetY;
    if (sDropDownPanelManager.getDropDirection(endX, endY) != TargetChangeState.HORIZONTAL) {
      sDropDownPanelManager.clearDropDirection();
      sDropDownPanelManager.dropDownEvent.targetChangedMove = 0;
      sDropDownPanelManager.dropDownEvent.targetChanged = TargetChangeState.NONE;
      return;
    }
    sDropDownPanelManager.clearDropDirection();
    if (sDropDownPanelManager.dropDownEvent.targetChanged == TargetChangeState.HORIZONTAL_REVERSES) {
      sDropDownPanelManager.dropDownEvent.targetChanged = TargetChangeState.NONE;
      return;
    }
    let speed = Math.abs(endX) * 100 / (Date.now() - this.startTime);
    log.showInfo(`onPanActionEnd speed: ${speed}`);
    sDropDownPanelManager.dropDownEvent.speedX = Math.max(Math.min(speed, 125), 100);
    let result = HiSysDataResult.SUCCESS;
    if (endX < -DISTANCE_DROP_HORIZONTAL_MIN || endX > DISTANCE_DROP_HORIZONTAL_MIN || speed > 30) {
      log.showInfo('onPanActionEnd swipe to ControlCenter');
      sDropDownPanelManager.dropDownEvent.target = endX < 0 ? TargetPanel.CONTROL_CENTER_PANEL
        : TargetPanel.NOTIFICATION_PANEL;
      if (sDropDownPanelManager.dropDownEvent.target === TargetPanel.CONTROL_CENTER_PANEL) {
        AccessibilityUtil.sendControlCenterAccessibility(AccessibilityPageShowHide.SHOW);
      }
      sDropDownPanelManager.dropDownEvent.targetChanged = TargetChangeState.NONE;
    } else {
      sDropDownPanelManager.dropDownEvent.targetChanged = TargetChangeState.HORIZONTAL_UP_BACK;
      result = HiSysDataResult.FAIL;
    }
    HiDfxEventUtil.reportSwipeSwitchControlNtf(sDropDownPanelManager.dropDownEvent.target,
      result, this.startX, this.startY, endX, endY);

    let resolution: string = this.getScreenInfo().width.toString() + 'x' + this.getScreenInfo().height.toString();
    this.switchDropdownPanelEventReport(resolution, isfromPanel);
    sDropDownPanelManager.updateDropDownTime();
  }

  switchDropdownPanelEventReport(resolution: string, isfromPanel?: boolean) {
    // 用户行为打点
    NotificationSysEventReporter.switchDropdownPanel({
      TIME_STAMP: `${sDropDownPanelManager.getLastDropdownTime()}`,
      SWITCH_TYPE: this.getSwitchType(isfromPanel),
      startX: this.startPositionX,
      startY: this.startPositionY,
      endX: this.endPositionX,
      endY: this.endPositionY,
      resolution: resolution,
      orientation: this.isLandscape ? 2 : 1
    });
    if (sDropDownPanelManager.dropDownEvent.target === TargetPanel.NOTIFICATION_PANEL) {
      StatisticsMaintenance.get().showNtfPanel();
    }
  }

  /**
   *  标题栏，在一次滑动过程中，确定方向后，则保持该方向处理，防止横滑竖滑手势冲突
   *
   * @param diffX  横向移动距离
   * @param diffY 纵向移动距离
   * @return 滑动方向
   */
  getDropDirection(diffX: number, diffY: number): TargetChangeState {
    if (sDropDownPanelManager.dropDirection != TargetChangeState.NONE) {
      return sDropDownPanelManager.dropDirection;
    }
    let moveX = Math.abs(diffX);
    let moveY = Math.abs(diffY);
    if (moveX < TOUCH_SLOP && moveY < TOUCH_SLOP) {
      return TargetChangeState.NONE;
    }
    if (moveX > moveY) {
      sDropDownPanelManager.dropDirection = TargetChangeState.HORIZONTAL;
      return sDropDownPanelManager.dropDirection;
    }
    if (moveY > moveX) {
      sDropDownPanelManager.dropDirection = TargetChangeState.VERTICAL;
      return sDropDownPanelManager.dropDirection;
    }
    return TargetChangeState.NONE;
  }

  clearDropDirection(): void {
    log.showInfo('onStatusBarTouchEvent clearDropDirection');
    sDropDownPanelManager.dropDirection = TargetChangeState.NONE;
  }

  /**
   * 设置目标面板
   *
   * @param target 目标面板
   */
  setTargetPanel(target: TargetPanel): void {
    DropDownPanelManagerWrapper.getInstance().setTargetPanel(target);
    if (target === TargetPanel.CONTROL_CENTER_PANEL) {
      AccessibilityUtil.sendControlCenterAccessibility(AccessibilityPageShowHide.SHOW);
    }
  }

  /**
   * 应该忽略平移动作
   */
  shouldIgnorePanAction(): boolean {
    let isLocked: boolean = false;
    try {
      isLocked = screenLock.isLocked();
    } catch (e) {
      log.error('screenLock.isLocked() fail: ', e);
    }
    return isLocked || this.isDismissing || !this.checkKioskPanelEnable(TargetPanel.NOTIFICATION_PANEL) ||
      !this.checkKioskPanelEnable(TargetPanel.CONTROL_CENTER_PANEL);
  }

  /**
   * 判断kiosk模式下，双中心目标面板是否可用
   * @param target 目标面板
   * @returns
   */
  public checkKioskPanelEnable(target: TargetPanel): boolean {
    log.showInfo(`checkKioskPanelEnable targetPanel: ${target}`);
    if (target === TargetPanel.CONTROL_CENTER_PANEL) {
      return this.isControlCenterKioskAllow();
    } else if (target === TargetPanel.NOTIFICATION_PANEL) {
      return this.isNotificationCenterKioskAllow();
    }
    return true;
  }

  /**
   * 控制中心在kiosk模式下是否可用
   * @returns
   */
  public isControlCenterKioskAllow(): boolean {
    if (!EnvVm.instance.isKioskMode) {
      return true;
    }
    // 5s内只查询一次
    if (Date.now() - this.lastKioskQueryTime > 5000) {
      this.lastKioskAllowCC =
        systemParameterEnhance.getSync(this.PARAM_EDM_KIOSK_ALLOW_CONTROL_CENTER, 'false') !== 'false';
      this.lastKioskQueryTime = Date.now();
    }
    log.showInfo(`isControlCenterKioskAllow: ${this.lastKioskAllowCC}`);
    return this.lastKioskAllowCC;
  }

  private isNotificationCenterKioskAllow(): boolean {
    if (!EnvVm.instance.isKioskMode) {
      return true;
    }
    const value =
      systemParameterEnhance.getSync(this.PARAM_EDM_KIOSK_ALLOW_NOTIFICATION_CENTER, 'false') !== 'false';
    log.showInfo(`isNotificationCenterKioskAllow: ${value}`);
    return value;
  }

  /**
   * 设获取当前面板
   */
  getCurrentTargetPanel(): TargetPanel {
    return this.dropDownEvent.target;
  }

  isStartFromPanelStatusBar(): boolean {
    return this.startFromPanelStatusBar;
  }

  setStartFromPanelStatusBar(startFromPanelStatusBar: boolean): void {
    this.startFromPanelStatusBar = startFromPanelStatusBar;
  }

  getEndAnimRunning(): boolean {
    return this.isEndAnimRunning;
  }

  setEndAnimRunning(isEndAnimRunning: boolean): void {
    this.isEndAnimRunning = isEndAnimRunning;
  }

  getVerticalBackStatus(): boolean {
    return this.isVerticalBack;
  }

  setVerticalBackStatus(verticalBack: boolean): void {
    log.showInfo(`setVerticalBackStatus verticalBack: ${verticalBack}`);
    this.isVerticalBack = verticalBack;
  }

  public checkTargetPanelByEvent(event: TouchEvent | null, rotateAngle?: number): TargetPanel {
    if (CommonUtils.isInvalid(event)) {
      log.showError('checkTargetPanelByEvent invalid touch event');
      return TargetPanel.NONE;
    }

    return this.checkTargetPanelByTouchX(event?.changedTouches[0].x ?? 0);
  }

  /**
   * 检测下拉状态，通知面板/控制面板
   * 无中间孔，通知面板 : 控制面板 = 2 : 1;
   * 有中间孔，中间孔右边界划分，左侧通知面板，右侧控制面板
   *
   * @param x down事件落点，TouchObject.x
   * @since 10
   */
  public checkTargetPanelByTouchX(x: number) {
    let winRect = StatusBarViewControllerAdapter.instance.getStatusBarArea();
    let notificationRange = ArkUIAdapter.vp2px(winRect.width) * DROPDOWN_RANGE_NOTIFICATION;
    // 判断是否有中间孔，有的话特殊计算
    let curOrientation = DeviceHelper.getOrientation();
    if (LayoutUtils.isXTProductType()) {
      try {
        curOrientation = display.getDefaultDisplaySync()?.rotation.valueOf();
      } catch (error) {
        log.showError('getOrientation -> getDefaultDisplaySync try error:', error);
      }
    }
    let isPortrait: boolean = curOrientation === display.Orientation.PORTRAIT;
    let info = this.getCutoutInfo();
    let isMidCutout = info.cutoutType === CutoutEvent.CUTOUT_MID ? true : false;
    let midWidth: number = info?.cutoutWidth ?? 0;
    let isFold = !DeviceHelper.isFoldExpandedOrHalf();
    // 中挖孔/小外屏折叠态 热区1:1
    if ((isMidCutout && isPortrait && midWidth > 0) || (isFold)) {
      notificationRange = vp2px(winRect.width + midWidth) * DROPDOWN_RANGE_NOTIFICATION_MID;
    }
    let target = vp2px(x) > notificationRange ? TargetPanel.CONTROL_CENTER_PANEL : TargetPanel.NOTIFICATION_PANEL;
    log.showInfo(`checkTargetPanelByTouchX x: ${x}, notification range: ${notificationRange}, target: ${target}`);
    return target;
  }

  getExpandVal(foldStatus: display.FoldStatus): boolean {
    if (foldStatus === display.FoldStatus.FOLD_STATUS_UNKNOWN || foldStatus === display.FoldStatus.FOLD_STATUS_FOLDED) {
      return false;
    }
    return true;
  }

  /**
   * 检测下拉状态，通知面板/控制面板
   * 无中间孔，通知面板 : 控制面板 = 2 : 1;
   * 有中间孔，中间孔右边界划分，左侧通知面板，右侧控制面板
   *
   * @param startX down事件落点
   * @deprecated since 10，建议使用checkTargetPanelByTouchX代替，减少对底座数据的依赖，当前旋转角度功能不稳定
   */
  public checkTargetPanel(pointX: number, pointY: number, rotateAngle: number): TargetPanel {
    // 状态栏窗口区域
    let winRect = StatusBarViewControllerAdapter.instance.getStatusBarArea();

    // 2:1计算
    let notificationRange = vp2px(winRect.width) * DROPDOWN_RANGE_NOTIFICATION;
    log.showDebug(`checkTargetPanel, rotateAngle: ${rotateAngle}, pointX: ${pointX},
      pointY: ${pointY}, width: ${winRect.width}, height : ${winRect.height}`);
    // 默认 0 或者 360度旋转
    let target = vp2px(pointX) > notificationRange ? TargetPanel.CONTROL_CENTER_PANEL : TargetPanel.NOTIFICATION_PANEL;
    // TODO 中间孔计算
    switch (rotateAngle) {
      case RotationConstants.ROTATION_270:
        target = vp2px(pointY) > notificationRange ? TargetPanel.CONTROL_CENTER_PANEL : TargetPanel.NOTIFICATION_PANEL;
        break;
      case RotationConstants.ROTATION_90:
        target = vp2px(pointY) > (vp2px(winRect.width) - notificationRange) ?
        TargetPanel.NOTIFICATION_PANEL : TargetPanel.CONTROL_CENTER_PANEL;
        break;
      case RotationConstants.ROTATION_180:
        target = vp2px(pointX) > (vp2px(winRect.width) - notificationRange) ?
        TargetPanel.NOTIFICATION_PANEL : TargetPanel.CONTROL_CENTER_PANEL;
        break;
      default:
        break;
    }
    log.showInfo(`checkTargetPanel, target: ${target}, pointX: ${pointX}, width: ${winRect.width}`);
    return target;
  }

  public setScreenOff(isScreenOff: boolean): void {
    this.isScreenOff = isScreenOff;
  }

  public isCurScreenOff(): boolean {
    return this.isScreenOff;
  }

  public isPanelDismissing(): boolean {
    return this.isDismissing;
  }

  public getScreenInfo(): ScreenInfo {
    if (this.screenInfo) {
      return this.screenInfo;
    }

    try {
      let defaultDisplay = display.getDefaultDisplaySync();
      if (defaultDisplay) {
        this.screenInfo = { width: defaultDisplay.width, height: defaultDisplay.height };
        return this.screenInfo;
      }
    } catch (e) {
      log.showError('getDefaultDisplaySync failed');
    }
    return { width: 0, height: 0 };
  }

  public updateStartPosition(positionX: number, positionY: number): void {
    this.startPositionX = positionX;
    this.startPositionY = positionY;
  }

  public updateEndPosition(positionX: number, positionY: number): void {
    this.endPositionX = positionX;
    this.endPositionY = positionY;
  }

  /**
   * 垂直抛滑时，切换下拉面板
   */
  public async switchPanel4VerticalFling(): Promise<void> {
    if (this.dropDownEvent.targetChanged !== TargetChangeState.VERTICAL_FLING_SWITCH) {
      return;
    }

    if (this.dropDownEvent.source === this.dropDownEvent.target) {
      return;
    }
    try {
      await this.switchDropdownPanelMap.get(this.dropDownEvent.source)?.onPanelVerticalFlingSwitchDismiss();
      await this.switchDropdownPanelMap.get(this.dropDownEvent.target)?.onPanelVerticalFlingSwitchShow();
    } catch (e) {
      log.showError(`switch panel for vertical fling fail, code: ${e?.code}, ${e?.message}.`);
    }
  }

  public getIsNtfPanel(): boolean {
      return this.isNtfPanel;
  }

  public setIsNtfPanel(isNtfPanel: boolean): void {
      this.isNtfPanel = isNtfPanel;
  }

  public updateMoveDown(moveY: number): void {
    const isLiveV2 = SystemUICcmConfig.instance.isEnabledLive2;
    if (isLiveV2) {
      StatusBarMoveDownVmV2.getInstance().updateExtraDistance(moveY);
    } else {
      StatusBarMoveDownVmV1.getInstance().updateExtraDistance(moveY);
    }
  }

  public endMoveDown(): void {
    const isLiveV2 = SystemUICcmConfig.instance.isEnabledLive2;
    if (isLiveV2) {
      StatusBarMoveDownVmV2.getInstance().endExtraMove();
    } else {
      StatusBarMoveDownVmV1.getInstance().endExtraMove();
    }
  }

  public checkMoveDown(): boolean {
    const isLiveV2 = SystemUICcmConfig.instance.isEnabledLive2;
    if (isLiveV2) {
      return StatusBarMoveDownVmV2.getInstance().checkNeedMoveDown();
    } else {
      return StatusBarMoveDownVmV1.getInstance().checkNeedMoveDown();
    }
  }

  public registerCallback(callback: DropdownCallback): void {
    this.callbackSet.add(callback);
  }

  public unregisterCallback(callback: DropdownCallback): void {
    this.callbackSet.delete(callback);
  }

  public checkBackPressCallback(): boolean {
    const isNC = this.dropDownEvent.target == TargetPanel.NOTIFICATION_PANEL;
    for (const callback of this.callbackSet) {
      if (isNC === callback.isNC && callback.onBackPress?.()) {
        log.showInfo(`OnBackPress return true on ${callback.tag}`);
        return true;
      }
    }
    return false;
  }

  public onHide(): void {
    log.showInfo('Dropdown panel onHide');
    for (const callback of this.callbackSet) {
      callback.onHide?.();
    }
  }

  public checkDropdownCallback(): boolean {
    const isNC = this.dropDownEvent.target == TargetPanel.NOTIFICATION_PANEL;
    for (const callback of this.callbackSet) {
      if (isNC === callback.isNC && callback.onDropdown?.()) {
        log.showInfo(`onDropdown return true on ${callback.tag}`);
        return true;
      }
    }
    return false;
  }

  public mouseSwitchDropDown(targetPanel: TargetPanel): void {
    this.dropDownEvent.targetChanged = TargetChangeState.VERTICAL_FLING_SWITCH;
    this.setTargetPanel(targetPanel);
    this.switchPanel4VerticalFling();
  }

  public async fingerprintSwitchDropDown(targetPanel: TargetPanel): Promise<void> {
    // 0. 设置源面板
    this.dropDownEvent.source = this.getCurrentTargetPanel();

    // 1. 隐藏目标面板, 防止目标面板直接出现
    this.switchDropdownPanelMap.get(targetPanel)?.hidePanel();

    // 2. 执行当前面板隐藏动效
    await this.switchDropdownPanelMap.get(this.dropDownEvent.source)?.onPanelVerticalFlingSwitchDismiss();

    // 3. 设置当前为垂直抛滑下拉及目标面板
    this.dropDownEvent.targetChanged = TargetChangeState.VERTICAL_FLING_SWITCH;
    this.setTargetPanel(targetPanel);

    // 4. 执行目标面板显示动效
    await this.switchDropdownPanelMap.get(this.dropDownEvent.target)?.onPanelVerticalFlingSwitchShow();
  }

  public mouseDropDownFromDesktop(targetPanel: TargetPanel): void {
    this.dropDownEvent.moveY = 0;
    this.setTargetPanel(targetPanel);
    this.animToShow(targetPanel);
  }

  private getSwitchType(isfromPanel?: boolean): SwitchType {
    if (!isfromPanel) {
      return sDropDownPanelManager.dropDownEvent.target === TargetPanel.CONTROL_CENTER_PANEL ?
      SwitchType.NOTIFICATION_TO_CONTROL_HEADER : SwitchType.CONTROL_TO_NOTIFICATION_HEADER;
    }
    return sDropDownPanelManager.dropDownEvent.target === TargetPanel.CONTROL_CENTER_PANEL ?
    SwitchType.NOTIFICATION_TO_CONTROL_PANEL : SwitchType.CONTROL_TO_NOTIFICATION_PANEL;
  }
}

let sDropDownPanelManager = SingletonHelper.getInstance(DropDownPanelManager, TAG);

export default sDropDownPanelManager as DropDownPanelManager;

/**
 * 动画数据基类
 */
export class ItemAnimOption {
  public opacity: number = 0;
}

/**
 * 判断热区所用孔信息
 */
export interface HotRegionCutoutInfo {
  /**
   * 类型
   */
  cutoutType: number;
  /**
   * 孔宽度
   */
  cutoutWidth: number;
};
