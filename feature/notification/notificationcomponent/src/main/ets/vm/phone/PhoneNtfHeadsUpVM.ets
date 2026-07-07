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

import type { NotificationEntry } from '../../model/NotificationEntry';
import { NotificationConfig } from '../../common/NotificationConfig';
import {
  CommonUtils,
  ArrayUtils,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import {
  EvtBus,
  WindowEvent,
  HiDfxEventUtil,
  ScreenOnOffEvent,
  DeviceHelper,
  DropDownPanelManagerWrapper,
  TargetPanel,
  CustomPromise,
  sEventManager,
  obtainLocalEvent,
  ViewManagerPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import type { EventManager } from '@ohos/frameworkwrapper';
import { SettingsConstants } from '@ohos/commonconstants';
import { windowMgr, SCBOobeManager } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { NotificationEntryEvent } from '../../common/event/NotificationEvent';
import {
  BannerPanelTypeState,
  immersiveKgMgr,
  IState,
  OnStateChangeListener,
  phoneAppMgr,
  TaskItem,
  TaskQueue } from '@ohos/systemuicommon';
import {
  AbilityState,
  bannerMgr,
  BannerPanelType,
  ForegroundAppEvent,
  HeadsUpChangeEvent,
  NotificationSysEventReporter,
  NtfAutoScreenOnEvent,
  StateType,
  SmartRemindType
} from '@ohos/systemuicommon';
import I18n from '@ohos.i18n';
import { display } from '@kit.ArkUI';
import {
  DisplayNotificationErrorCode,
  DisplayNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/DisplayNotificationMaintenance';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import { hideBannerNtfContentObj } from '../../model/HideBannerNtfContentObj';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { LiveHeadsUpShowEvent } from '@ohos/systemuicommon/src/main/ets/notification/model/BannerShowStatusModel';
import { InnerEventUtil } from '@ohos/systemuicommon/newTsIndex';
import { EmergencyThermalSafeManager } from '@ohos/systemuicommon/src/main/ets/manager/EmergencyThermalSafeManager';
import { WakeUpUtils } from '../../common/WakeUpUtils';

const TAG = 'SysUI_PhoneNtfHeadsUpVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 横幅窗口名
 */
const WINDOW_NAME = WindowConstants.WINDOW_NAME_BANNER;

/**
 * 横幅弹框显示5秒
 */
export const HEADS_UP_DURATION = 5000;

/**
 * 横幅忽略的冷却时间，1分钟
 */
const IGNORE_NTF_INTERVAL = 60 * 1000;

/**
 * 横幅面板收起时，横幅切换事件延时时长
 */
const CHANGE_EVENT_TIMEOUT = 200;

/**
 * 横幅通知转场动效切换后的延迟时间，防止刚切换不生效情况
 */
export const HEADS_UP_TRANSITION_EFFECT_CHANGE_DELAY = 20;

/**
 * 横幅数据切换时延
 */
const HEADS_UP_NTF_DATA_CHANGE_DELAY = 25;

/**
 * 互斥的面板窗口名
 * 这些窗口show时，隐藏横幅通知窗口
 */
const EXCLUDE_WINDOW_NAMES = [
  // Phone下拉面板
  WindowConstants.WINDOW_NAME_DROPDOWN,
  // 锁屏窗口
  WindowConstants.WINDOW_NAME_LOCK_SCREEN
];

// 下拉面板显示横幅白名单
const dropDownTrustList: DropDownTrust[] = [
  {
    isLiveType: true,
    creatorBundleName: 'com.ohos.callui'
  }
];

export const REFRESH_STATUS_BAR_NTF = 'REFRESH_STATUS_BAR_NTF';

/**
 * 横幅任务队列时间间隔
 */
const HEADS_UP_TASK_QUEUE_INTERVAL = 60;
const FLOAT_WINDOW_PROMISE_MAX_DURATION = 60000;

/**
 * phone横幅通知管理
 *
 * @since 2023-01-17
 */
export class PhoneNtfHeadsUpVm {
  /**
   * 回调器
   */
  private callback: HeadsUpCallback | null = null;

  /**
   * 横幅通知的观察者，有观察者的时候，横幅通知不允许隐藏
   */
  private watchers: number = 0;

  /**
   * 统一事件管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 横幅状态切换事件
   */
  private headsUpEvent: HeadsUpChangeEvent = HeadsUpChangeEvent.create();

  /**
   * 是否启动超时收起任务
   */
  private hasCancelTimeout: boolean = false;

  /**
   * 条目是否展开状态
   */
  private isItemExpand: boolean = false;

  /**
   * 被忽略一段时间的横幅通知应用列表
   */
  private ignoredList: Map<number, Date> = new Map();

  /**
   * 是否中景窗
   */
  private isMidScene: boolean | undefined = false;

  /**
   * 倒计时关闭横幅面板的ID
   */
  private closeTimeoutId?: number;

  /**
   * 等待上一条横幅收起后，显示新一条横幅的倒计时ID
   */
  private showNewTimeoutId?: number;

  /**
   * 收起横幅面板时，横幅切换事件延时任务ID
   */
  private releaseChangeTimeoutId?: number;

  /**
   * 是否息屏
   */
  private isScreenOff?: boolean;
  /**
   * 通知更新冻结的promise
   */
  public freezeMap: Map<string, CustomPromise<void>> = new Map();

  // 当前冻结的promise
  private currentPromise?: CustomPromise<void>;
  /**
   * 悬浮窗拉起过程中的promise
   */
  private floatWindowPromise?: CustomPromise<void>;
  /**
   * 悬浮窗拉起动效兜底定时器id
   */
  private floatWindowTimerId?: number;
  /**
   * 当前是否有横幅需要延迟展示（亮屏后展示）
   */
  private hasHeadsUpToShow: boolean = false;
  /**
   * 通知列表第一条数据
   */
  private currentEntry?: NotificationEntry | undefined;
  /**
   * 收到通知是否自动亮屏
   */
  protected isNtfAutoScreenOn: boolean = false;
  /**
   * 是否在锁屏密码页面
   */
  private isPwdVisible: boolean = false;

  /**
   * 横幅处理队列
   */
  private handleQueue: TaskQueue = new TaskQueue(TAG, 1, HEADS_UP_TASK_QUEUE_INTERVAL);

  /**
   * 基础状态切换监听
   * banner面板当前显示类型变化
   */
  private onStateChange: OnStateChangeListener = {
    onStateChange: (state: IState): void => {
      if (state?.getStateType() === StateType.TYPE_BANNER_PANEL_TYPE) {
        let panelState = state as BannerPanelTypeState;

        // 面板切换为实况面板时，置位
        if (panelState?.isPanelLiveList()) {
          this.resetParam();
        } else if (!panelState?.isPanelHeadsUp()) {
          // 切换面板为非横幅时，检测横幅切换事件
          this.releaseChangeTimeoutId = setTimeout(() => {
            this.postHeadsUpChangeEvent(undefined);
          }, CHANGE_EVENT_TIMEOUT);
        }
      }
    }
  };

  private screenOnOffChangeListener = (event: ScreenOnOffEvent): void => {
    log.showInfo('On screen on_off, off status is [%{public}s]', event.isScreenOff());
    this.isScreenOff = event.isScreenOff();
    this.showHeadsUpWindowScreenOn();
  };

  /**
   * 收到通知自动亮屏开关事件
   *
   * @param event 事件
   */
  private onNtfAutoScreenOnEvent = (event: NtfAutoScreenOnEvent): void => {
    this.isNtfAutoScreenOn = event.isNtfAutoScreenOnEnable();
    log.showInfo(`onNtfAutoScreenOnEvent isNtfAutoScreenOn: ${event.isNtfAutoScreenOnEnable()}`);
  };

  /**
   * 小外屏亮屏时显示横幅
   */
  private showHeadsUpWindowScreenOn(): void {
    // 不是小外屏/展开或者半折叠/息屏/没有横幅要发 return
    if (DeviceHelper.isFoldExpandedOrHalf() ||
    this.isScreenOff || !this.hasHeadsUpToShow) {
      return;
    }
    log.showInfo(`show headsUp on screenOn`);
    // 横幅窗口请求成功，刷新数据
    this.requestShowHeadsUp?.(this.currentEntry);

  }

  setIsMidScene(isMidScene: boolean | undefined): void {
    this.isMidScene = isMidScene;
  }

  /**
   * 前台应用切换事件
   *
   * @param event 事件
   */
  private onForegroundAppEvent = (state?: ForegroundAppEvent): void => {
    let bundleNames = state?.bundleNames?.slice(-1); //原事件传递的列表存在已在后台但未清除的数据，因此使用最新一次的前台包名
    // 存在横幅且横幅应用切换至前台
    let appForeground: boolean | undefined = bannerMgr.isBannerPanelType(BannerPanelType.TYPE_HEADS_UP) &&
      state?.switchAbilityState === AbilityState.ABILITY_STATE_FOREGROUND &&
    bundleNames?.includes(this.headsUpEvent.bundleName ?? '') && !this.checkIsStartingFloatingWindow();

    log.showInfo(`onForegroundAppEvent bundleName: ${bundleNames}, appForeground: ${appForeground}`);
    if (appForeground) {
      this.hideHeadsUpWindowWithAnim(true);
      bannerMgr.cancelTimeoutHide();
    }
  };

  private checkIsStartingFloatingWindow(): boolean {
    if (!this.callback?.isStartingFloatingWindow) {
      return false;
    }
    return this.callback?.isStartingFloatingWindow();
  }

  /**
   * 初始化
   *
   * @param callback 回调器
   */
  init(callback: HeadsUpCallback): void {
    this.callback = callback;

    // 窗口show/hide事件
    this.eventMgr.on(WindowEvent, this.onWindowEvent)
      // 通知add/remove事件
      .on(NotificationEntryEvent, this.onNtfEntryTaskEvent)
      // 屏幕显示熄灭事件
      .on(ScreenOnOffEvent, this.screenOnOffChangeListener)
      // 应用前后台切换事件
      .on(ForegroundAppEvent, this.onForegroundAppEvent)
      // 收到通知自动亮屏开关事件
      .on(NtfAutoScreenOnEvent, this.onNtfAutoScreenOnEvent)
      // 横幅切换事件生产者
      .produceOn(HeadsUpChangeEvent, this.onProduceHeadsUpChangeEvent);

    // 监听面板切换
    bannerMgr.registerStateChangeListener(StateType.TYPE_BANNER_PANEL_TYPE, this.onStateChange);
  }

  /**
   * 添加记录
   * 横幅触摸时，不自动收起
   *
   * @param ob 记录对象
   */
  addWatcher(ob: Object): void {
    this.watchers++;
    log.showInfo('addWatcher:' + this.watchers);
  }

  /**
   * 移除记录
   * 脱手后，检测横幅收起
   *
   * @param ob 记录对象
   */
  removeWatcher(ob: Object): void {
    if (this.watchers > 0) {
      this.watchers--;
      log.showInfo('removeWatcher:' + this.watchers);
      if (this.checkShouldHideWindow()) {
        this.hideHeadsUpWindowWithAnim(true);
      }
    }
  }

  /**
   * 重置观察者
   */
  resetWatcher(): void {
    this.watchers = 0;
  }

  /**
   * 销毁
   */
  onDestroy(): void {
    this.resetParam();
    this.eventMgr.offAll();
    this.callback = null;
    // 取消监听面板切换
    bannerMgr.unregisterStateChangeListener(StateType.TYPE_BANNER_PANEL_TYPE, this.onStateChange);
  }

  /**
   * 设置条目展开状态
   *
   * @param isItemExpand 是否展开
   */
  setItemExpandState(isItemExpand: boolean): void {
    if (this.isItemExpand !== isItemExpand) {
      this.isItemExpand = isItemExpand;
      // 判断是否需要隐藏窗口
      if (this.checkShouldHideWindow()) {
        this.hideHeadsUpWindowWithAnim(true);
      }
    }
  }

  /**
   * 设置显示密码页面状态
   */
  setPwdVisible(isPwdVisible: boolean): void {
    this.isPwdVisible = isPwdVisible;
  }

  /**
   * 直接隐藏横幅窗口
   */
  public hideHeadsUpWindow = (): void => {
    log.showInfo('hide banner without anim');
    this.hideHeadsUpWindowWithAnim(true);
  };

  /**
   * 上滑收起横幅，延迟隐藏横幅窗口
   */
  hideHeadsUpWindowWithDelay(): void {
    log.showInfo('hide banner with delay for anim');
    this.hideHeadsUpWindowWithAnim(true);
    // 手动收起，取消定时收起任务
    bannerMgr.cancelTimeoutHide();
  }

  /**
   * 横幅切换事件生产者
   *
   * @returns 横幅切换事件
   */
  private onProduceHeadsUpChangeEvent = (): HeadsUpChangeEvent => {
    return this.headsUpEvent;
  };

  /**
   * 发送横幅切换事件
   *
   * @param entry 横幅数据
   */
  private postHeadsUpChangeEvent(entry?: NotificationEntry): void {
    let ntfBundle = entry?.creatorBundleName;
    let ntfHashCode = entry?.hashCode;

    // 对比横幅hash变化，则发送事件
    if (CommonUtils.equals(this.headsUpEvent.hashCode, ntfHashCode)) {
      return;
    }
    this.headsUpEvent.bundleName = ntfBundle;
    this.headsUpEvent.hashCode = ntfHashCode;
    EvtBus.post(HeadsUpChangeEvent, this.headsUpEvent);
  }

  /**
   * 定时器超时后，是否需要隐藏窗口
   */
  private checkShouldHideWindowTimeout(): boolean {
    let isItemExpanded = this.isItemExpanded();
    let isAutoCancel = this.needCancelHeadsUp();
    log.showInfo(`expanded:${isItemExpanded} sticky:${!isAutoCancel} watchers:${this.watchers}`);

    // 当条目切换为非展开时，判断时间是否已达到（且是可以自动隐藏的通知），达到则直接隐藏窗口
    if (isItemExpanded || !isAutoCancel) {
      return false;
    }
    if (this.watchers > 0) {
      return false;
    }
    return true;
  }

  /**
   * 非定时器超时的时候，检测是否需要隐藏窗口
   */
  private checkShouldHideWindow(): boolean {
    // 超时任务未到时间
    log.showInfo(`timer valid:${this.hasCancelTimeout}`);
    if (this.hasCancelTimeout) {
      return false;
    }
    return this.checkShouldHideWindowTimeout();
  }

  /**
   * 设置通知忽略，抑制应用横幅1分钟
   *
   * @param isItemExpand 是否展开
   */
  setIgnoreNtf(): void {
    try {
      if (this.callback) {
        let entry: NotificationEntry = this.callback?.getNtfEntry();
        log.showInfo('setIgnoreNtf：' + entry.creatorBundleName);
        this.ignoredList.set(entry.creatorUid, new Date());
      }
    } catch (err) {
      log.showError('setIgnoreNtf error:' + err);
    }
  }

  /**
   * 通知应用当前是否仍在抑制期
   *
   * @param newEntry 通知数据
   * @returns true抑制
   */
  private isIgnoredNtf(newEntry: NotificationEntry): boolean {
    // 实况通知不存在抑制规格
    if (newEntry?.isLiveType()) {
      return false;
    }

    let lastTime: Date = this.ignoredList.get(newEntry.creatorUid) as Date;
    if (CommonUtils.isInvalid(lastTime)) {
      // 记录不存在，说明不需要忽略
      log.showInfo('isIgnoredNtf：lastTime empty, false' );
      return false;
    }
    let now: Date = new Date();
    if (now.getTime() - lastTime.getTime() <= IGNORE_NTF_INTERVAL) {
      // 记录存在，且没超过忽略的时间阈值，需要忽略
      log.showWarn('isIgnoredNtf：true: ' + newEntry?.toSimpleString());
      return true;
    }

    // 存在记录，但是超过了时间，则不忽略，同时清除记录
    this.ignoredList.delete(newEntry.creatorUid);
    log.showInfo('isIgnoredNtf：false: ' + newEntry?.toSimpleString());
    return false;
  }

  /**
   * 当前条目是否展开状态
   *
   * @return true 展开
   */
  private isItemExpanded(): boolean {
    let entry = this.callback?.getNtfEntry();
    if (CommonUtils.isInvalid(entry)) {
      return false;
    }
    return (entry as NotificationEntry).isExpandable && this.isItemExpand;
  }

  /**
   * 参数置位
   */
  private resetParam(): void {
    this.watchers = 0;
    this.isItemExpand = false;
    this.hasCancelTimeout = false;
    this.clearCloseRunnable();
    this.clearShowNewRunnable();
    this.notifyNtfEntryChange(undefined);
  }

  /**
   * 窗口show/hide事件
   *
   * @param event 事件
   */
  private onWindowEvent = (event: WindowEvent): void => {
    // 互斥面板显示，直接隐藏横幅通知
    if (event.isWindowStartShow() && ArrayUtils.contains(EXCLUDE_WINDOW_NAMES, event.windowName)) {
      this.hideHeadsUpWindow();
    }
  };

  /**
   * 横幅显示超时，触发收起动效
   */
  private onCancelTimeoutRunnable = (): void => {
    // 超时收起检测
    this.hasCancelTimeout = false;
    const promise: CustomPromise<void> | undefined = this.freezeMap.get('clickFloating');
    if (promise) {
      promise.then(this.hideHeadsUpWindow);
    } else if (this.checkShouldHideWindowTimeout()) {
      this.hideHeadsUpWindowWithAnim(true);
    }
  };

  /**
   * 尝试弹出横幅
   */
  private requestShowHeadsUp = (newEntry?: NotificationEntry): void => {
    this.clearCloseRunnable();
    this.clearShowNewRunnable();
    if (this.checkHeadsUpWindowShow(newEntry)) {
      // 清除change任务
      this.clearPostChangeRunnable();
      // 显示窗口
      let timeout = this.getCancelTimeout(newEntry);
      //实况横幅存在时，需要发送实况横幅收起事件，然后在做普通横幅展示
      if (bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_HEADS_UP)) {
        const event = new LiveHeadsUpShowEvent();
        event.headUpStatus = LiveHeadsUpShowEvent.EVENT_HIDE_BANNER;
        InnerEventUtil.post(LiveHeadsUpShowEvent, event);
      }
      //如果存在实况横幅，同时横幅属于非常驻/非即时横幅才允许弹普通通知横幅
      if (bannerMgr.preemptPromise && !bannerMgr.isExclusiveLiveBanner) {
        log.showInfo('preempt banner start');
        bannerMgr.preemptPromise.then(()=> {
          log.showInfo('preempt banner end');
          this.showBanner(newEntry, timeout);
        });
      } else {
        this.showBanner(newEntry, timeout);
      }
    } else {
      // 检查显示异常情况
      this.checkHeadsUpShowAbnormal(newEntry);
    }
  };

  private showBanner(newEntry?: NotificationEntry, timeout?: number): void {
    // 其他场景dropdown窗口，不显示横幅
    if (windowMgr.isShowing(WindowConstants.WINDOW_NAME_DROPDOWN)) {
      log.showInfo('dropdown panel is showing');
      this.postRefreshStatusbarNtf();
      return;
    }
    if (bannerMgr.requestPanelHeadsUp(timeout, this.onCancelTimeoutRunnable)) {
      log.showInfo('requestShowHeadsUp ' + newEntry?.toSimpleString());
      // 横幅窗口请求成功，刷新数据
      this.notifyNtfEntryChange(newEntry);
      // 记录超时取消任务
      this.hasCancelTimeout = CommonUtils.isNumber(timeout);
    } else {
      // 实况面板场景，横幅显示失败
      log.showInfo('requestShowHeadsUp live list show, interrupt: ' + newEntry?.toSimpleString());
      DisplayNotificationMaintenance.doReport(newEntry, DisplayNotificationErrorCode.LIVE_VIEW_PANEL_SHOW);
    }
  }

  /**
   * 清除发送横幅切换事件任务
   */
  private clearPostChangeRunnable(): void {
    if (CommonUtils.isNumber(this.releaseChangeTimeoutId)) {
      clearTimeout(this.releaseChangeTimeoutId);
      this.releaseChangeTimeoutId = undefined;
    }
  }

  /**
   * 清除新横幅等待任务
   */
  private clearShowNewRunnable(): void {
    if (CommonUtils.isNumber(this.showNewTimeoutId)) {
      clearTimeout(this.showNewTimeoutId);
      this.showNewTimeoutId = undefined;
    }
  }

  /**
   * 通知数据add/remove任务处理
   *
   * @param event 事件
   */
  private onNtfEntryTaskEvent = (event: NotificationEntryEvent): void => {
    const task = new TaskItem('onNtfEntryTaskEvent', () => this.onNtfEntryEvent(event));
    this.handleQueue.add(task);
  };

  /**
   * 通知数据add/remove事件
   *
   * @param event 事件
   */
  private onNtfEntryEvent = (event: NotificationEntryEvent): void => {
    if (this.currentPromise) {
      log.showWarn('Wait freeze promise for %{public}d', event.eventType);
      this.currentPromise.then(() => this.doNotificationEvent(event));
    } else {
      this.doNotificationEvent(event);
    }
  };

  private doNotificationEvent(event: NotificationEntryEvent): void {
    switch (event.eventType) {
      // 新增/更新场景，通知数据同一个则更新，不同则横幅重新弹出
      case NotificationEntryEvent.EVENT_TYPE_POST_ADD:
      case NotificationEntryEvent.EVENT_TYPE_POST_UPDATE:
        if (!event.notificationList?.length) {
          return;
        }
        if (SystemUICcmConfig.instance.isEnabledLive2 && event.notificationList[0].isLiveType()) {
          return;
        }
        // 保存当前通知的entry 小外屏来通知亮屏后需显示横幅
        this.currentEntry = event.notificationList[0];
        this.handleHeadsUpAddOrUpdate(event.notificationList[0],
          event.eventType === NotificationEntryEvent.EVENT_TYPE_POST_UPDATE);
        break;
      // 移除通知，隐藏横幅
      case NotificationEntryEvent.EVENT_TYPE_POST_CANCEL:
        if (!event.notificationList?.length) {
          return;
        }
        for (let removeEntry of event.notificationList) {
          // 移除当前通知，直接隐藏横幅窗口
          if (this.isOldEquals(removeEntry)) {
            this.isMidScene ? this.hideHeadsUpWindowWithAnim() : this.hideHeadsUpWindow();
            break;
          }
        }
        break;
      default:
        break;
    }
  }
  /**
   * 冻结通知更新，避免通知更新影响UI渲染
   */
  public setUpdateFreeze(key: string, timeout = 2000): void {
    log.showInfo('Set update freeze');
    const promise: CustomPromise<void> = new CustomPromise();
    this.freezeMap.set(key, promise);
    this.currentPromise = promise;
    // 设置超时时间兜底，避免业务侧没有取消导致通知不更新
    let timerId = setTimeout(promise.resolve, timeout);

    promise.then(() => {
      clearTimeout(timerId);
      log.showInfo(`freezeMap delete ${key}`);
      this.freezeMap.delete(key);
      if (this.freezeMap.size === 0) {
        this.currentPromise = undefined;
      };
    });
  }

  isForeground(ntfEntry: NotificationEntry): boolean {
    return phoneAppMgr.isExistsForegroundApp(app => app.bundleName === (ntfEntry.wantAgentInfo?.want?.bundleName ?? ''));
  }

  public setDeformFreeze(): void {
    log.showWarn(`setDeformFreeze`);
    if (this.floatWindowPromise) {
      log.showWarn(`cur is freezing for deform`);
      return;
    }
    this.floatWindowPromise = new CustomPromise();
    this.floatWindowPromise.then(() => {
      clearTimeout(this.floatWindowTimerId);
      this.floatWindowPromise = undefined;
    });
  }

  public releaseDeformFreeze(): void {
    log.showWarn(`releaseDeformFreeze`);
    this.floatWindowPromise?.resolve();
  }

  /**
   * 解除通知更新冻结
   */
  public releaseUpdateFreeze(key: string): void {
    log.showInfo('Release update freeze');
    this.freezeMap.get(key)?.resolve();
  }

  private isAllowShowHeadsUp(entry: NotificationEntry, isUpdate: boolean): boolean {
    if (!EmergencyThermalSafeManager.instance.isShowNotification(entry?.creatorBundleName)) {
      return false;
    }
    // 在OOBE阶段不显示横幅通知
    if (SCBOobeManager.isOobeActivated()) {
      log.showInfo('do not show heads up during OOBE phase');
      DisplayNotificationMaintenance.doReport(entry, DisplayNotificationErrorCode.OOBE_NOT_SHOW);
      return false;
    }

    // 横幅更新为非横幅，则收起横幅
    if (!entry?.isHeadsUp()) {
      this.hideHeadsUp(entry);
      log.showInfo(`Not support heads up`);
      return false;
    }

    // 横幅抑制
    if (this.isIgnoredNtf(entry)) {
      // 被忽略的横幅通知
      log.showInfo('onNtfEntryEvent ignore it: ' + entry.toSimpleString());
      DisplayNotificationMaintenance.doReport(entry, DisplayNotificationErrorCode.IGNORE_BANNER);
      return false;
    }

    // 避免下载通知一直横幅提示，如果是下载通知更新情况，仅更新数据，不提示横幅
    if (isUpdate && entry?.isLiveType() && entry.isConvertFromNormal) {
      log.showInfo('onNtfEntryEvent UPDATE isDownloadTemplate: ' + entry.toSimpleString());
      // 下载通知横幅还存在，则更新数据
      if (this.isOldEquals(entry)) {
        this.notifyNtfEntryChange(entry);
      }
      DisplayNotificationMaintenance.doReport(entry, DisplayNotificationErrorCode.DOWNLOAD_UPDATE);
      return false;
    }

    if (this.outerHomeCheck(entry)) {
      return false;
    }
    return true;
  }

  private hideHeadsUp(entry: NotificationEntry): void {
    if (!this.isOldEquals(entry)) {
      return;
    }
    if (entry.isLiveType()) {
      this.hideHeadsUpWindow();
    } else if (this.callback?.getNtfEntry()?.isHeadsUpStick) {
      this.hideHeadsUpWindowWithAnim(true);
    }
  }

  private outerHomeCheck(entry: NotificationEntry): boolean {
    if (DeviceHelper.isFoldExpandedOrHalf()) {
      return false;
    }
    if (AppStorage.get('isPwdVisible')) {
      log.showInfo(`Password is visible, heads up is not supported.`);
      DisplayNotificationMaintenance.doReport(entry, DisplayNotificationErrorCode.PWD_VISIBLE);
      return true;
    }
    if (this.checkIsAod()) {
      log.showInfo(`In AOD, heads up is not supported.`);
      DisplayNotificationMaintenance.doReport(entry, DisplayNotificationErrorCode.IN_AOD);
      return true;
    }
    // 实况列表存在时 不弹横幅
    if (bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_LIST)) {
      log.showInfo(`liveList is showing, heads up is not supported.`);
      DisplayNotificationMaintenance.doReport(entry, DisplayNotificationErrorCode.LIVE_VIEW_PANEL_SHOW);
      return true;
    }
    return false;
  }

  private checkIsAod(): boolean | undefined {
    const shouldScreenOn = this.currentEntry?.shouldScreenOn(this.isNtfAutoScreenOn);
    log.showInfo(`checkIsAod shouldScreenOn: ${shouldScreenOn}`);

    // 若当前未亮屏、通知应亮屏(开关或通知标记)、通知支持锁屏通知，则点亮屏幕
    if (this.isScreenOff && shouldScreenOn && this.currentEntry?.isLockScreenEnable) {
      WakeUpUtils.wakeUpScreen(this.currentEntry?.controlConfig.isExtraScreenOn());
      log.showInfo(`checkIsAod wakeUpScreen`);
      return false;
    }
    return immersiveKgMgr.getOneMirrorState().getAodStyle(true)?.isAod;
  }

  /**
   * 发送刷新状态栏通知图标事件
   */
  postRefreshStatusbarNtf(): void {
    // 检测到不需要显示横幅时 通知数据还未刷新 避免时序问题
    Promise.resolve().then(() => {
      log.showInfo(`refresh ntfIcon in HeadsupVm`);
      sEventManager.publish(obtainLocalEvent(REFRESH_STATUS_BAR_NTF, true));
    });
  }

  /**
   * 横幅新增、更新事件处理
   *
   * @param entry 数据
   * @param isUpdate 是否更新场景
   */
  private handleHeadsUpAddOrUpdate(entry: NotificationEntry, isUpdate: boolean): void {
    // 横幅通知打点上报
    this.reportHeadsUp(entry, isUpdate);
    this.reportOnScreen(entry, isUpdate);
    if (!this.isAllowShowHeadsUp(entry, isUpdate)) {
      this.postRefreshStatusbarNtf();
      return;
    }
    log.showInfo('show heads up: ' + entry.toSimpleString());
    // 同一个通知，数据更新
    if (this.isOldEquals(entry)) {
      this.requestShowHeadsUp?.(entry);
    } else { // 不同通知，隐藏窗口后，重新显示
      this.handleHeadsUpAdd(entry);
    }
  }

  private handleHeadsUpAdd(entry: NotificationEntry): void {
    if (this.floatWindowPromise) {
      this.floatWindowTimerId = setTimeout(this.floatWindowPromise.resolve, FLOAT_WINDOW_PROMISE_MAX_DURATION);
      this.floatWindowPromise.then(() => this.beforeHandleHeadsUpShow(entry));
    } else {
      this.beforeHandleHeadsUpShow(entry);
    }
  }

  private beforeHandleHeadsUpShow(entry: NotificationEntry): void {
    if (this.closeTimeoutId) {
      // 窗口隐藏瞬间来新通知时，面板还未释放，需要延时show
      log.showInfo('beforeHandleHeadsUpShow releasePanelHeadsUp');
      this.clearCloseRunnable();
      setTimeout(() => {
        this.handleHeadsUpShow(entry);
      }, HEADS_UP_NTF_DATA_CHANGE_DELAY);
    } else {
      this.handleHeadsUpShow(entry);
    }
  }
  private handleHeadsUpShow(entry: NotificationEntry): void {
    // 当前横幅窗口是否显示
    let isHeadsUp = bannerMgr.isBannerPanelType(BannerPanelType.TYPE_HEADS_UP);
    // 如果存在常驻横幅则不显示
    if (isHeadsUp && this.isExistKeepHeadsUp()) {
      log.warn('exist keepHeadsUp, not show.');
      DisplayNotificationMaintenance.doReport(entry, DisplayNotificationErrorCode.EXIST_PERMANENT_HEADS_UP);
      return;
    }
    // 如果下拉面板打开，则需要处理是否显示横幅通知
    if (windowMgr.isShowing(WindowConstants.WINDOW_NAME_DROPDOWN)) {
      log.showInfo(`dropdown panel is shown, bundle:${entry?.creatorBundleName} isLiveType:${entry?.isLiveType()}`);
      let dropDownEvent = DropDownPanelManagerWrapper.getInstance().getDropDownEvent();
      // 处于控制中心且在下拉面板显示横幅白名单中，收起下拉面板显示横幅
      if (dropDownEvent.target === TargetPanel.CONTROL_CENTER_PANEL && dropDownTrustList.some(item =>
      item.isLiveType === entry?.isLiveType() && item.creatorBundleName === entry?.creatorBundleName)) {
        log.showInfo('show banner because the notice is in dropdown trust list');
        DropDownPanelManagerWrapper.getInstance().hideWindowDirectly();
        Promise.resolve().then(() => {
          this.doShowHeadsUp(isHeadsUp, entry);
        });
      } else {
        log.warn('Will not show banner because dropdown panel is shown.');
        DisplayNotificationMaintenance.doReport(entry, DisplayNotificationErrorCode.DROPDOWN_PANEL_SHOW);
      }
      return;
    }

    this.doShowHeadsUp(isHeadsUp, entry);
  }

  private doShowHeadsUp(isHeadsUp: boolean, entry: NotificationEntry): void {
    // 如果存在横幅，则收起横幅动效后再显示横幅
    if (isHeadsUp && !CommonUtils.isInvalid(this.callback?.getNtfEntry())) {
      // 触发收起动效
      let needDelay = this.callback?.updateHeadsUpTransitionEffect();
      if (needDelay) {
        // 直接通知横幅已切换
        this.postHeadsUpChangeEvent(entry);
        this.hideHeadsUpWindowWithAnim(false, true);
        this.clearShowNewRunnable();
        this.requestShowHeadsUp?.(entry);
      } else {
        this.hideHeadsUpWindowWithAnim(false);
        this.clearShowNewRunnable();
        this.requestShowHeadsUp?.(entry);
      }
    } else {
      // 直接弹出
      this.requestShowHeadsUp?.(entry);
    }
  }

  private isExistKeepHeadsUp(): boolean | undefined {
    return this.callback?.getNtfEntry()?.isHeadsUpStick;
  }

  /**
   * 横幅打点
   *
   * @param entry 数据
   * @param isUpdate 是否更新
   * @returns void
   */
  private async reportHeadsUp(entry: NotificationEntry, isUpdate: boolean): Promise<void> {
    if (CommonUtils.isInvalid(entry)) {
      return;
    }
    const pushIsDeliver = entry?.isDeliverPushNotification;
    let settingSound: number = this.initSettingSound(entry);
    let smartReminderType = this.getSmartReminderType(entry, isUpdate);
    log.showInfo(`Smart Reminder Info: smartReminderType-${smartReminderType}`);

    NotificationSysEventReporter.notificationReceived({
      IS_PUSH: entry.isFromPush ? 0 : 1,
      IS_ONGOING: entry.isOngoing ? 0 : 1,
      IS_LIVE: entry.isLiveType() ? 0 : 1,
      RECEIVED_SCENE: entry?.isHeadsUp() ? 4 : 2,
      CREATOR_BUNDLE_NAME: entry.creatorBundleName,
      NOTIFICATION_ID: entry.id,
      NOTIFICATION_SLOT_TYPE: entry.slotType,
      IS_SCREEN_OFF: this.isScreenOff ? 0 : 1,
      settingLock: entry.remindConfig.isLockScreenEnable() ? 0 : 1,
      settingBanner: entry.remindConfig.isBannerEnable() ? 0 : 1,
      settingSound: settingSound,
      language: I18n.System.getSystemLanguage(),
      style: entry.style,
      isunremoveable: !entry.isRemoveAllowed,
      PRIVILEGE_TYPE: entry.isFromSystemApp ? 1 : 0,
      SMART_REMINDER_TYPE: smartReminderType,
      USER_ID: entry.creatorUserId,
      HASHCODE: entry.hashCode,
      HAS_SOUND: Boolean(entry?.soundDescriptor),
      CHANNEL_ID: entry?.channelId,
      BUNDLE_TYPE: entry.bundleType,
      TRACE_ID: entry.traceId,
    });
  }
  
  private reportOnScreen(entry: NotificationEntry, isUpdate: boolean): void {
    if (CommonUtils.isInvalid(entry)) {
      return;
    }
    NotificationSysEventReporter.notificationOnScreen({
      IS_PUSH: entry.isFromPush ? 0 : 1,
      IS_GROUP: 0,
      CREATOR_BUNDLE_NAME: entry.creatorBundleName,
      NOTIFICATION_ID: entry.id,
      NOTIFICATION_SLOT_TYPE: entry.isInAggregate ? null : entry.slotType,
      DISPLAY_SCENE: this.isDisplayHeadsUp(entry, isUpdate) ? 3 : 4,
      PUSH_DATA: JSON.stringify(entry.pushData),
      NOTIFICATION_CONTROL_FLAGS: entry.controlConfig?.flags,
      TRACE_ID: entry.traceId,
    });
  }

  private isDisplayHeadsUp(entry: NotificationEntry, isUpdate: boolean): boolean {
    if (!this.isAllowShowHeadsUp(entry, isUpdate)) {
      return false;
    }
    const panel = DropDownPanelManagerWrapper.getInstance().getDropDownEvent().target;
    if (panel === TargetPanel.NOTIFICATION_PANEL || panel === TargetPanel.CONTROL_CENTER_PANEL) {
      return false;
    }
    return true;
  }

  /**
   * 检测是否允许显示横幅窗口
   */
  private checkHeadsUpWindowShow(newEntry?: NotificationEntry): boolean {

    // 其他场景dropdown窗口或锁屏窗口显示时，不显示横幅
    if (windowMgr.isShowing(WindowConstants.WINDOW_NAME_LOCK_SCREEN)) {
      log.showInfo('checkHeadsUpWindowShow ntf panel is showing');
      this.postRefreshStatusbarNtf();
      return false;
    }
    log.showInfo('checkHeadsUpWindowShow show ' + WINDOW_NAME);
    return true;
  }

  /**
   * 获取智能提醒类型
   * @param entry 消息通知
   * @param isUpdate 是否更新
   * @returns 智能提醒类型
   */
  private getSmartReminderType(entry: NotificationEntry, isUpdate: boolean): SmartRemindType {
    if (!this.isShowHeadsUp(entry, isUpdate)) {
      return SmartRemindType.NO_HEADS_UP;
    }

    if (AppProtectedVm.get().isProtected(entry.bundleIdxTag)) {
      return SmartRemindType.APP_LOCK_HIDE;
    }

    return SmartRemindType.MESSAGE_DISPLAY;
  }

  /**
   * 是否显示横幅
   * @param entry 消息通知
   * @param isUpdate 是否更新
   * @returns 是：显示横幅， 否：横幅
   */
  private isShowHeadsUp(entry: NotificationEntry, isUpdate: boolean): boolean {
    // 1.在OOBE阶段不显示横幅通知, 2.横幅更新为非横幅, 3.横幅抑制, 4.如果是锁屏页面，不弹出横幅
    if (SCBOobeManager.isOobeActivated() || !entry?.isHeadsUp() || this.isIgnoredNtf(entry) ||
    AppStorage.get('isPwdVisible')) {
      return false;
    }

    // 不处于控制中心且不在下拉面板显示横幅白名单中，不显示横幅
    const dropDownNotShow = (windowMgr.isShowing(WindowConstants.WINDOW_NAME_DROPDOWN) &&
      (DropDownPanelManagerWrapper.getInstance().getDropDownEvent().target !== TargetPanel.CONTROL_CENTER_PANEL ||
        !dropDownTrustList.some(item =>
        item.isLiveType === entry?.isLiveType() &&
          item.creatorBundleName === entry?.creatorBundleName)
      ));
    // 设置了isAlertOnce属性通知, 只弹一次横幅。或者是下载通知更新情况，仅更新数据，不提示横幅
    const updateNotShow = isUpdate && (entry?.isAlertOnce || (entry?.isLiveType() && entry.isConvertFromNormal));
    // 如果存在常驻横幅则不显示
    const stickNotShow = bannerMgr.isBannerPanelType(BannerPanelType.TYPE_HEADS_UP) && this.isExistKeepHeadsUp();
    if (dropDownNotShow || updateNotShow || stickNotShow) {
      return false;
    }

    if (windowMgr.isShowing(WindowConstants.WINDOW_NAME_LOCK_SCREEN)) {
      // 其他场景dropdown窗口或锁屏窗口显示时，不显示横幅
      return false;
    }

    return true;
  }

  handleHasHeadsUpToShow(hasHeadsUpToShow: boolean): void {
    this.hasHeadsUpToShow = hasHeadsUpToShow;
    // 有横幅需要亮屏后显示
    if (hasHeadsUpToShow) {
      setTimeout(() => {
        // 超过两秒没亮屏 直接刷新通知图标
        if (this.isScreenOff) {
          this.hasHeadsUpToShow = false;
          this.postRefreshStatusbarNtf();
        }
      }, 2000);
    }
  }

  // 横幅显示异常打点
  private checkHeadsUpShowAbnormal(newEntry?: NotificationEntry): void {
    if (windowMgr.isShowing(WindowConstants.WINDOW_NAME_DROPDOWN) ||
      windowMgr.isShowing(WindowConstants.WINDOW_NAME_LOCK_SCREEN)) {
      // 其他面板显示，确实不需要显示横幅
      return;
    }
    // 排除不显示的情况，如果没有在显示横幅，是有问题的
    if (!windowMgr.isShowing(WINDOW_NAME)) {
      HiDfxEventUtil.reportHeadsUpShowAbnormal();
      DisplayNotificationMaintenance.doReport(newEntry, DisplayNotificationErrorCode.HEADS_UP_SHOW_FAILED);
    }
  }

  /**
   * 获取取消横幅的超时时间
   *
   * @param entry 通知数据
   * @returns 超时时间
   */
  private getCancelTimeout(entry?: NotificationEntry): number | undefined {
    return this.needCancelHeadsUp(entry) ? HEADS_UP_DURATION : undefined;
  }

  /**
   * 是否需要自动取消横幅
   *
   * @param entry校验通知数据
   * @return true倒计时后收起横幅
   */
  private needCancelHeadsUp(entry?: NotificationEntry): boolean {
    if (CommonUtils.isInvalid(entry)) {
      entry = this.callback?.getNtfEntry();
    }
    return entry?.isHeadsUpStick ? false : true;
  }

  /**
   * 隐藏横幅窗口
   *
   * @param isClosePanel 是否动效完成收起面板
   * @param isInterruptNotify 是否拦截通知切换事件
   */
  private hideHeadsUpWindowWithAnim(isClosePanel?: boolean, isInterruptNotify?: boolean): void {
    log.showInfo('hide banner with anim');
    let hasHeadsUp = !CommonUtils.isInvalid(this.callback?.getNtfEntry());
    this.notifyNtfEntryChange(undefined, isInterruptNotify ?? false);

    // 当前横幅面板显示，则动效结束后收起面板
    const duration =
      this.isMidScene ? NotificationConfig.HEADS_UP_DISAPPEAR_DURATION : NotificationConfig.HEADS_UP_HIDE_DURATION;
    const isBannerPanelType = bannerMgr.isBannerPanelType(BannerPanelType.TYPE_HEADS_UP);
    log.showWarn(`isClosePanel:${isClosePanel}， hasHeadsUp:${hasHeadsUp}, isBannerPanelType:${isBannerPanelType}`);
    if (isClosePanel && isBannerPanelType) {
      this.clearCloseRunnable();
      this.closeTimeoutId = setTimeout(() => {
        this.closeTimeoutId = undefined;
        log.showInfo('hideHeadsUpWindowWithAnim releasePanelHeadsUp');
        bannerMgr.releasePanelHeadsUp();
      }, hasHeadsUp ? duration : 0);
    }
  }

  /**
   * 取消关闭横幅面板任务
   */
  private clearCloseRunnable(): void {
    if (CommonUtils.isNumber(this.closeTimeoutId)) {
      clearTimeout(this.closeTimeoutId);
      this.closeTimeoutId = undefined;
    }
  }

  /**
   * 通知更新场景，是否相等
   *
   * @param newEntry 新通知数据
   * @returns true相等
   */
  private isOldEquals(newEntry: NotificationEntry): boolean {
    return CommonUtils.equals(newEntry, this.callback?.getNtfEntry());
  }

  /**
   * 通知数据切换
   *
   * @param ntfEntry 通知数据
   * @param isInterruptNotify 是否拦截发送横幅切换事件
   */
  private notifyNtfEntryChange(ntfEntry: NotificationEntry | undefined, isInterruptNotify: boolean = false): void {
    // 当准备清空通知数据时，恢复通知数据展开状态
    let oldEntry = this.callback?.getNtfEntry();
    if (CommonUtils.isInvalid(ntfEntry)) {
      oldEntry?.resetItemExpandState();
    }
    this.callback?.notifyNtfEntryChange(ntfEntry as NotificationEntry);

    // 发送横幅切换事件
    if (!isInterruptNotify) {
      this.postHeadsUpChangeEvent(ntfEntry);
    }
  }

  private initSettingSound(entry: NotificationEntry): number {
    let SETTING_SOUND: number = 0;
    if (entry.isSoundEnable && entry.isVibrationEnable) {
      SETTING_SOUND = 0;
    } else if (entry.isSoundEnable) {
      SETTING_SOUND = 1;
    } else if (entry.isVibrationEnable) {
      SETTING_SOUND = SettingsConstants.ringModeIsJustVibration;
    } else {
      SETTING_SOUND = SettingsConstants.ringModeIsRingAndVibration;
    }
    return SETTING_SOUND;
  }
}

/**
 * 横幅组件回调
 */
export interface HeadsUpCallback {
  /**
   * 获取通知数据
   *
   * @return 通知数据
   */
  getNtfEntry(): NotificationEntry;

  /**
   * 通知数据变更
   *
   * @param ntfEntry 通知数据
   */
  notifyNtfEntryChange(ntfEntry: NotificationEntry): void;

  /**
   * 更新横幅隐藏动画
   *
   * @param isNtfCancel 通知是否被删除
   */
  updateHeadsUpTransitionEffect(isNtfCancel?: boolean): boolean;

  /**
   * 是否在拉起悬浮窗
   *
   * @returns 判断结果
   */
  isStartingFloatingWindow?(): boolean;
}

export interface RefreshStatusNotification {
  isRefresh: boolean;
}

export class DropDownTrust {
  public isLiveType?: boolean;
  public creatorBundleName?: string;
}