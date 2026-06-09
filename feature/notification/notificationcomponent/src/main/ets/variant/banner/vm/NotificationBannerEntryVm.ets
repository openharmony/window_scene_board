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

import { NotificationConfig } from '../../../common/NotificationConfig';
import { NotificationEntryEvent } from '../../../common/event/NotificationEvent';
import { AbilityState, bannerMgr,
  DisplayNotificationErrorCode,
  DisplayNotificationMaintenance,
  EmergencyThermalSafeManager,
  ForegroundAppEvent,
  OobeAdapter,
  SystemUICommonUtil,
  TaskItem, TaskQueue,
  WindowAdapter,
  SmartRemindType,
} from '@ohos/systemuicommon';
import type { BannerPanelTypeState } from '@ohos/systemuicommon';
import { BannerPanelType } from '@ohos/systemuicommon';
import type { IState } from '@ohos/systemuicommon';
import { StateType } from '@ohos/systemuicommon';
import type { OnStateChangeListener } from '@ohos/systemuicommon';
import { HeadsUpChangeEvent } from '@ohos/systemuicommon';
import { NotificationSysEventReporter } from '@ohos/systemuicommon';
import I18n from '@ohos.i18n';
import { display } from '@kit.ArkUI';
import { NotificationBase, NotificationEvent } from '@ohos/systemuicommon/newTsIndex';
import { ArrayUtils, CommonUtils, LogDomain, Logger } from '@ohos/basicutils/src/main/ets/TsIndex';
import { SettingsConstants, WindowConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { DeviceHelper,
  CustomPromise,
  DropDownPanelManagerWrapper,
  EventManager, EvtBus,
  HiDfxEventUtil,
  ScreenOnOffEvent,
  TargetPanel,
  WindowEvent } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { LiveHeadsUpShowEvent } from '@ohos/systemuicommon/src/main/ets/notification/model/BannerShowStatusModel';
import { AppProtectedStatusVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedStatusVm';
import { hideBannerNtfContentObj } from '../../../model/HideBannerNtfContentObj';
import { DropDownAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/DropDownAdapter';

const TAG = 'NotificationBannerEntryVm';
const log: Logger = Logger.getLogHelper(LogDomain.NC);

interface DropDownTrust {
  isLiveType?: boolean;
  creatorBundleName?: string;
}

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
 * 横幅任务队列时间间隔
 */
const HEADS_UP_TASK_QUEUE_INTERVAL = 60;

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

/**
 * phone横幅通知管理
 *
 * @since 2023-01-17
 */
export class NotificationBannerEntryVm {
  /**
   * 回调器
   */
  private callback?: HeadsUpCallback;

  /**
   * 横幅通知的观察者，有观察者的时候，横幅通知不允许隐藏
   */
  private watchers: number = 0;

  /**
   * 统一事件管理
   */
  protected eventMgr: EventManager = EvtBus.createEventManager();

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
  private ignoredList: Map<string, Date> = new Map();

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
   * 横幅处理队列
   */
  private handleQueue: TaskQueue = new TaskQueue(TAG, 1);

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
    log.showInfo(TAG, 'On screen on_off, off status is [%{public}s]', event.isScreenOff());
    this.isScreenOff = event.isScreenOff();
    if (event.isScreenOff()) {
      this.hideHeadsUpWindow();
    }
  };

  setIsMidScene(isMidScene: boolean | undefined): void {
    this.isMidScene = isMidScene;
  }

  /**
   * 前台应用切换事件
   *
   * @param event 事件
   */
  private onForegroundAppEvent = (state?: ForegroundAppEvent): void => {
    log.showInfo(TAG, `onForegroundAppEvent. ${state?.bundleNames}`)
    let bundleNames = state?.bundleNames?.slice(-1); //原事件传递的列表存在已在后台但未清除的数据，因此使用最新一次的前台包名
    // 存在横幅且横幅应用切换至前台
    let appForeground: boolean | undefined = bannerMgr.isBannerPanelType(BannerPanelType.TYPE_HEADS_UP) &&
      state?.switchAbilityState === AbilityState.ABILITY_STATE_FOREGROUND &&
    bundleNames?.includes(this.headsUpEvent.bundleName ?? '') && !this.checkIsStartingFloatingWindow();
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
      .on(NotificationEvent, this.onNotificationTaskEvent)
        // 屏幕显示熄灭事件
      .on(ScreenOnOffEvent, this.screenOnOffChangeListener)
        // 应用前后台切换事件
      .on(ForegroundAppEvent, this.onForegroundAppEvent)
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
    log.showInfo(TAG, 'addWatcher:' + this.watchers);
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
      log.showInfo(TAG, 'removeWatcher:' + this.watchers);
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
    this.callback = undefined;
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
   * 直接隐藏横幅窗口
   */
  hideHeadsUpWindow(): void {
    log.showInfo(TAG, 'hide banner without anim');
    this.hideHeadsUpWindowWithAnim(true);
  }

  /**
   * 立即隐藏横幅窗口
   */
  releasePanel(): void {
    log.showInfo(TAG, 'hide banner immediately');
    bannerMgr.releasePanelHeadsUp();
    this.notifyNtfEntryChange(undefined);
  }

  /**
   * 上滑收起横幅，延迟隐藏横幅窗口
   */
  hideHeadsUpWindowWithDelay(): void {
    log.showInfo(TAG, 'hide banner with delay for anim');
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
  private postHeadsUpChangeEvent(entry?: NotificationBase): void {
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
    log.showInfo(TAG, `expanded:${isItemExpanded} sticky:${!isAutoCancel} watchers:${this.watchers}`);

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
    log.showInfo(TAG, `timer valid:${this.hasCancelTimeout}`);
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
        let entry: NotificationBase = this.callback?.getNtfEntry();
        log.showInfo(TAG, 'setIgnoreNtf：' + entry.creatorBundleName);
        this.ignoredList.set(`${entry.creatorBundleName}_${entry.creatorUid}`, new Date());
      }
    } catch (err) {
      log.showError(TAG, 'setIgnoreNtf error:' + err);
    }
  }

  /**
   * 通知应用当前是否仍在抑制期
   *
   * @param newEntry 通知数据
   * @returns true抑制
   */
  private isIgnoredNtf(newEntry: NotificationBase): boolean {
    // 实况通知不存在抑制规格
    if (newEntry?.isLiveView()) {
      return false;
    }
    let lastTime: Date = this.ignoredList.get(`${newEntry.creatorBundleName}_${newEntry.creatorUid}`) as Date;
    if (CommonUtils.isInvalid(lastTime)) {
      // 记录不存在，说明不需要忽略
      log.showInfo(TAG, 'isIgnoredNtf：lastTime empty, false' );
      return false;
    }
    let now: Date = new Date();
    if (now.getTime() - lastTime.getTime() <= IGNORE_NTF_INTERVAL) {
      // 记录存在，且没超过忽略的时间阈值，需要忽略
      log.showInfo(TAG, 'isIgnoredNtf：true: ' + newEntry?.toSimpleString());
      return true;
    }

    // 存在记录，但是超过了时间，则不忽略，同时清除记录
    this.ignoredList.delete(`${newEntry.creatorBundleName}_${newEntry.creatorUid}`);
    log.showInfo(TAG, 'isIgnoredNtf：false: ' + newEntry?.toSimpleString());
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
    return this.isItemExpand;
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
    if (this.checkShouldHideWindowTimeout()) {
      this.hideHeadsUpWindowWithAnim(true);
    }
  };

  /**
   * 尝试弹出横幅
   */
  private requestShowHeadsUp = async (newEntry: NotificationBase): Promise<void> => {
    this.clearCloseRunnable();
    this.clearShowNewRunnable();
    if (await this.checkHeadsUpWindowShow(newEntry)) {
      // 清除change任务
      this.clearPostChangeRunnable();
      // 显示窗口
      let timeout = this.getCancelTimeout(newEntry);
      //实况横幅存在时，需要发送实况横幅收起事件，然后在做普通横幅展示
      if (bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_HEADS_UP)) {
        const event = new LiveHeadsUpShowEvent();
        event.headUpStatus = LiveHeadsUpShowEvent.EVENT_HIDE_BANNER;
        EvtBus.post(LiveHeadsUpShowEvent, event);
      }
      //如果存在实况横幅，同时横幅属于非常驻/非即时横幅才允许弹普通通知横幅
      if (bannerMgr.preemptPromise && !bannerMgr.isExclusiveLiveBanner) {
        log.showInfo(TAG, 'preempt banner start');
        bannerMgr.preemptPromise.then(()=> {
          log.showInfo(TAG, 'preempt banner end');
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

  private async showBanner(newEntry: NotificationBase, timeout?: number): Promise<void> {
    if (await WindowAdapter.isShowing(WindowConstants.WINDOW_NAME_DROPDOWN)) {
      log.showInfo(TAG, 'dropdown panel is showing');
      return;
    }
    if (bannerMgr.requestPanelHeadsUp(timeout, this.onCancelTimeoutRunnable)) {
      log.showInfo(TAG, 'requestShowHeadsUp ' + newEntry?.toSimpleString());
      // 横幅窗口请求成功，刷新数据
      this.notifyNtfEntryChange(newEntry);
      // 记录超时取消任务
      this.hasCancelTimeout = CommonUtils.isNumber(timeout);
    } else {
      // 实况面板场景，横幅显示失败
      log.showInfo(TAG, 'requestShowHeadsUp live list show, interrupt: ' + newEntry?.toSimpleString());
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
  private onNotificationTaskEvent = (event: NotificationEvent): void => {
    if (SystemUICcmConfig.instance.isEnabledLive2 && event.notificationList?.[0]?.isLiveView()) {
      return;
    }
    const ntfHash = event.notificationList[0]?.hashCode;
    log.showInfo(TAG, `onNotificationTaskEvent. ntf: ${ntfHash}, eventType: ${event.eventType}`)
    const task = new TaskItem(`onNotificationTaskEvent_${event.eventType}`, async () => {
      this.onNotificationEvent(event);
      if (event.eventType === NotificationEntryEvent.EVENT_TYPE_POST_ADD ||
        event.eventType === NotificationEntryEvent.EVENT_TYPE_POST_UPDATE) {
        await SystemUICommonUtil.sleep(HEADS_UP_TASK_QUEUE_INTERVAL);
      }
    });
    if (this.callback?.touchPromise || this.callback?.deformPromise) {
      log.showInfo(TAG, `wait promise: ${this.callback?.touchPromise ? 'touchPromise' : ''} ${this.callback?.deformPromise ? 'deformPromise' : ''}`)
      Promise.all([this.callback?.touchPromise, this.callback?.deformPromise]).then(() => {
        this.handleQueue.add(task);
      });
    } else {
      this.handleQueue.add(task);
    }
  };

  private onNotificationEvent = (event: NotificationEvent): void => {
    switch (event.eventType) {
    // 新增/更新场景，通知数据同一个则更新，不同则横幅重新弹出
      case NotificationEntryEvent.EVENT_TYPE_POST_ADD:
      case NotificationEntryEvent.EVENT_TYPE_POST_UPDATE:
        if (ArrayUtils.isEmpty(event.notificationList)) {
          return;
        }
        this.handleHeadsUpAddOrUpdate(event.notificationList[0],
          event.eventType === NotificationEntryEvent.EVENT_TYPE_POST_UPDATE);
        break;
      // 移除通知，隐藏横幅
      case NotificationEntryEvent.EVENT_TYPE_POST_CANCEL:
        if (ArrayUtils.isEmpty(event.notificationList)) {
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
  };

  /**
   * 横幅新增、更新事件处理
   *
   * @param entry 数据
   * @param isUpdate 是否更新场景
   */
  private handleHeadsUpAddOrUpdate(entry: NotificationBase, isUpdate: boolean): void {
    // 横幅通知打点上报
    this.reportHeadsUp(entry, isUpdate);
    this.reportOnScreen(entry, isUpdate);
    if (!this.isAllowShowHeadsUp(entry, isUpdate)) {
      return;
    }
    log.showInfo(TAG, 'show heads up: ' + entry.toSimpleString());
    // 同一个通知，数据更新
    if (this.isOldEquals(entry)) {
      this.requestShowHeadsUp?.(entry);
    } else { // 不同通知，隐藏窗口后，重新显示
      this.beforeHandleHeadsUpShow(entry);
    }
  }

  private isAllowShowHeadsUp(entry: NotificationBase, isUpdate: boolean): boolean {
    if (!EmergencyThermalSafeManager.instance.isShowNotification(entry?.creatorBundleName)) {
      return false;
    }
    // 在OOBE阶段不显示横幅通知
    if (OobeAdapter.isOobe) {
      log.showInfo(TAG, 'do not show heads up during OOBE phase');
      DisplayNotificationMaintenance.doReport(entry, DisplayNotificationErrorCode.OOBE_NOT_SHOW);
      return false;
    }

    // 横幅更新为非横幅，则收起横幅
    if (!entry.isHeadsUp) {
      this.hideHeadsUp(entry);
      log.showInfo(TAG, `Not support heads up`);
      return false;
    }

    // 横幅抑制
    if (this.isIgnoredNtf(entry)) {
      // 被忽略的横幅通知
      log.showInfo(TAG, 'onNtfEntryEvent ignore it: ' + entry.toSimpleString());
      DisplayNotificationMaintenance.doReport(entry, DisplayNotificationErrorCode.IGNORE_BANNER);
      return false;
    }

    // 避免下载通知一直横幅提示，如果是下载通知更新情况，仅更新数据，不提示横幅
    if (isUpdate && entry.isLiveView() && entry.isConvertFromNormal) {
      log.showInfo(TAG, 'onNtfEntryEvent UPDATE isDownloadTemplate: ' + entry.toSimpleString());
      // 下载通知横幅还存在，则更新数据
      if (this.isOldEquals(entry)) {
        this.notifyNtfEntryChange(entry);
      }
      DisplayNotificationMaintenance.doReport(entry, DisplayNotificationErrorCode.DOWNLOAD_UPDATE);
      return false;
    }

    return true;
  }

  private hideHeadsUp(entry: NotificationBase): void {
    if (!this.isOldEquals(entry)) {
      return;
    }
    if (this.callback?.getNtfEntry()?.isHeadsUpStick) {
      this.hideHeadsUpWindowWithAnim(true);
    }
  }

  private beforeHandleHeadsUpShow(entry: NotificationBase): void {
    if (this.closeTimeoutId) {
      // 窗口隐藏瞬间来新通知时，面板还未释放，需要延时show
      this.clearCloseRunnable();
      setTimeout(() => {
        this.handleHeadsUpShow(entry);
      }, HEADS_UP_NTF_DATA_CHANGE_DELAY);
    } else {
      this.handleHeadsUpShow(entry);
    }
  }

  private async handleHeadsUpShow(entry: NotificationBase): Promise<void> {
    // 当前横幅窗口是否显示
    let isHeadsUp = bannerMgr.isBannerPanelType(BannerPanelType.TYPE_HEADS_UP);
    // 如果存在常驻横幅则不显示
    if (isHeadsUp && this.isExistKeepHeadsUp()) {
      log.showWarn(TAG, 'exist keepHeadsUp, not show.');
      DisplayNotificationMaintenance.doReport(entry, DisplayNotificationErrorCode.EXIST_PERMANENT_HEADS_UP);
      return;
    }
    // 如果下拉面板打开，则需要处理是否显示横幅通知
    if (await WindowAdapter.isShowing(WindowConstants.WINDOW_NAME_DROPDOWN)) {
      log.showInfo(TAG, `dropdown panel is shown, bundle:${entry?.creatorBundleName}`);
      let dropDownEvent = DropDownPanelManagerWrapper.getInstance().getDropDownEvent();
      // 处于控制中心且在下拉面板显示横幅白名单中，收起下拉面板显示横幅
      if (dropDownEvent.target === TargetPanel.CONTROL_CENTER_PANEL && dropDownTrustList.some(item =>
      item.isLiveType === entry?.isLiveView() && item.creatorBundleName === entry?.creatorBundleName)) {
        log.showInfo(TAG, 'show banner because the notice is in dropdown trust list');
        DropDownAdapter.hideWindowDirectly();
        Promise.resolve().then(() => {
          this.doShowHeadsUp(isHeadsUp, entry);
        });
      } else {
        log.showWarn(TAG, 'Will not show banner because dropdown panel is shown.');
        DisplayNotificationMaintenance.doReport(entry, DisplayNotificationErrorCode.DROPDOWN_PANEL_SHOW);
      }
      return;
    }

    this.doShowHeadsUp(isHeadsUp, entry);
  }

  private doShowHeadsUp(isHeadsUp: boolean, entry: NotificationBase): void {
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
   * @returns void
   */
  private async reportHeadsUp(entry: NotificationBase, isUpdate: boolean): Promise<void> {
    if (CommonUtils.isInvalid(entry)) {
      return;
    }
    let settingSound: number = this.initSettingSound(entry);
    const smartReminderType = this.getSmartReminderType(entry, isUpdate);
    log.showInfo(TAG, `Smart Reminder Info smartReminderType: ${smartReminderType}`);

    NotificationSysEventReporter.notificationReceived({
      IS_PUSH: entry.isFromPush ? 0 : 1,
      IS_ONGOING: entry.isOngoing ? 0 : 1,
      IS_LIVE: entry.isLiveView() ? 0 : 1,
      RECEIVED_SCENE: entry?.isLiveView() ? 4 : 2,
      CREATOR_BUNDLE_NAME: entry.creatorBundleName,
      NOTIFICATION_ID: entry.id,
      NOTIFICATION_SLOT_TYPE: entry.slotType,
      IS_SCREEN_OFF: this.isScreenOff ? 0 : 1,
      settingLock: entry.remindConfig.isLockScreenEnable() ? 0 : 1,
      settingBanner: entry.remindConfig.isBannerEnable() ? 0 : 1,
      settingSound: settingSound,
      language: I18n.System.getSystemLanguage(),
      style: '',
      isunremoveable: !entry.isRemoveAllowed,
      PRIVILEGE_TYPE: entry.isFromSystemApp ? 1 : 0,
      HAS_SOUND: Boolean(entry.customSound),
      CHANNEL_ID: entry.channelId,
      TRACE_ID: entry.traceId,
      BUNDLE_TYPE: entry?.bundleType,
      SMART_REMINDER_TYPE: smartReminderType,
    });
  }

  private reportOnScreen(entry: NotificationBase, isUpdate: boolean): void {
    if (CommonUtils.isInvalid(entry)) {
      return;
    }
    NotificationSysEventReporter.notificationOnScreen({
      IS_PUSH: entry.isFromPush ? 0 : 1,
      IS_GROUP: 0,
      CREATOR_BUNDLE_NAME: entry.creatorBundleName,
      NOTIFICATION_ID: entry.id,
      NOTIFICATION_SLOT_TYPE: null,
      DISPLAY_SCENE: this.isDisplayHeadsUp(entry, isUpdate) ? 3 : 4,
      TRACE_ID: entry.traceId,
      NOTIFICATION_CONTROL_FLAGS: entry.controlConfig?.flags,
    });
  }

  private isDisplayHeadsUp(entry: NotificationBase, isUpdate: boolean): boolean {
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
  protected async checkHeadsUpWindowShow(newEntry: NotificationBase): Promise<boolean> {
    // dropdown窗口或锁屏窗口显示时，不显示横幅
    if (await WindowAdapter.isShowing(WindowConstants.WINDOW_NAME_LOCK_SCREEN)) {
      log.showInfo(TAG, 'checkHeadsUpWindowShow ntf panel is showing');
      return false;
    }
    log.showInfo(TAG, 'checkHeadsUpWindowShow show ' + WINDOW_NAME);
    return true;
  }

  // 横幅显示异常打点
  private async checkHeadsUpShowAbnormal(newEntry: NotificationBase): Promise<void> {
    if (await WindowAdapter.isShowing(WindowConstants.WINDOW_NAME_DROPDOWN) ||
      await WindowAdapter.isShowing(WindowConstants.WINDOW_NAME_LOCK_SCREEN)) {
      // 其他面板显示，确实不需要显示横幅
      return;
    }
    // 排除不显示的情况，如果没有在显示横幅，是有问题的
    if (!await WindowAdapter.isShowing(WINDOW_NAME)) {
      HiDfxEventUtil.reportHeadsUpShowAbnormal();
    }
  }

  /**
   * 获取取消横幅的超时时间
   *
   * @param entry 通知数据
   * @returns 超时时间
   */
  private getCancelTimeout(entry?: NotificationBase): number | undefined {
    return this.needCancelHeadsUp(entry) ? HEADS_UP_DURATION : undefined;
  }

  /**
   * 是否需要自动取消横幅
   *
   * @param entry校验通知数据
   * @return true倒计时后收起横幅
   */
  private needCancelHeadsUp(entry?: NotificationBase): boolean {
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
    log.showInfo(TAG, 'hide banner with anim');
    let hasHeadsUp = !CommonUtils.isInvalid(this.callback?.getNtfEntry());
    this.notifyNtfEntryChange(undefined, isInterruptNotify ?? false);

    // 当前横幅面板显示，则动效结束后收起面板
    const duration =
      this.isMidScene ? NotificationConfig.HEADS_UP_DISAPPEAR_DURATION : NotificationConfig.HEADS_UP_HIDE_DURATION;
    const isBannerPanelType = bannerMgr.isBannerPanelType(BannerPanelType.TYPE_HEADS_UP);
    log.showWarn(TAG, `isClosePanel:${isClosePanel}， hasHeadsUp:${hasHeadsUp}, isBannerPanelType:${isBannerPanelType}`);
    if (isClosePanel && isBannerPanelType) {
      this.clearCloseRunnable();
      this.closeTimeoutId = setTimeout(() => {
        this.closeTimeoutId = undefined;
        log.showInfo(TAG, 'hideHeadsUpWindowWithAnim releasePanelHeadsUp');
        bannerMgr.releasePanelHeadsUp();
      }, hasHeadsUp ? duration : 0);
    }
  }

  /**
   * 取消关闭横幅面板任务
   */
  private clearCloseRunnable(): void {
    if (this.closeTimeoutId !== undefined) {
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
  private isOldEquals(newEntry: NotificationBase): boolean {
    return newEntry?.hashCode === this.callback?.getNtfEntry()?.hashCode;
  }

  /**
   * 通知数据切换
   *
   * @param ntfEntry 通知数据
   * @param isInterruptNotify 是否拦截发送横幅切换事件
   */
  private notifyNtfEntryChange(ntfEntry: NotificationBase | undefined, isInterruptNotify: boolean = false): void {
    this.callback?.notifyNtfEntryChange(ntfEntry);

    // 发送横幅切换事件
    if (!isInterruptNotify) {
      this.postHeadsUpChangeEvent(ntfEntry);
    }
  }

  private initSettingSound(entry: NotificationBase): number {
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

  /**
   * 获取智能提醒类型
   * @param entry 消息通知
   * @param isUpdate 是否更新
   * @returns 智能提醒类型
   */
  private getSmartReminderType(entry: NotificationBase, isUpdate: boolean): SmartRemindType {
    if (!this.isAllowShowHeadsUp(entry, isUpdate)) {
      return SmartRemindType.NO_HEADS_UP;
    }

    if (AppProtectedStatusVm.instance.isProtected(entry.creatorBundleName, entry.appIndex)) {
      return SmartRemindType.APP_LOCK_HIDE;
    }

    return SmartRemindType.MESSAGE_DISPLAY;
  }
}

/**
 * 横幅组件回调
 */
export interface HeadsUpCallback {
  /**
   * 触摸promise
   */
  touchPromise?: CustomPromise<void>;

  /**
   * 形变promise
   */
  deformPromise?: CustomPromise<void>;

  /**
   * 获取通知数据
   *
   * @return 通知数据
   */
  getNtfEntry(): NotificationBase;

  /**
   * 通知数据变更
   *
   * @param ntfEntry 通知数据
   */
  notifyNtfEntryChange(ntfEntry: NotificationBase | undefined): void;

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
