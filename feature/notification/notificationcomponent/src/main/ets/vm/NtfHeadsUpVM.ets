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

import { NotificationEntry } from '../model/NotificationEntry';
import { CommonUtils, ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { SettingsConstants } from '@ohos/commonconstants';
import { WindowConstants, SettingsKeyConstants, SCBConstants } from '@ohos/commonconstants';
import {
  EvtBus,
  EventManager,
  PluginSlot,
  WindowEvent,
  HiDfxEventUtil,
  sSettingsUtil,
  SCBWindowSceneConfig,
  ScreenLockEvent,
  viewMgrPolicy,
  ViewType,
  DeviceHelper
} from '@ohos/frameworkwrapper';
import { windowMgr, SCBSystemBarProperty, SCBSceneSessionManager,
  SCBSpecificSceneSessionList,
  SpecificPanelZOrder,
  sSCBOobeManager,
  SCBSessionRect} from '@ohos/windowscene';
import { NotificationEntryEvent } from '../common/event/NotificationEvent';
import { hideBannerNtfContentObj } from '../model/HideBannerNtfContentObj';
import { notificationConfigManager } from '../manager/NotificationConfigManager';
import {
  NotificationConfigEvent,
  NotificationConfigEventType
} from '@ohos/systemuicommon/src/main/ets/model/NotificationConfigEvent';
import { HideBannerContentType } from '@ohos/systemuicommon/src/main/ets/constants/HideBannerContentType';
import sceneSessionManager from '@ohos.sceneSessionManager';
import Window from '@ohos.window';
import { NotificationSysEventReporter } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import I18n from '@ohos.i18n';

const TAG = 'SysUI_NtfHeadsUpVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 空回调
 */
class EmptyCallback implements HeadsUpCallback {
  public getNtfEntries(): NotificationEntry[] {
    log.warn('emptyCallback getNtfEntries');
    return [];
  }

  public notifyNtfEntryChange(_ntfEntry: NotificationEntry[]) {
    log.warn('emptyCallback notifyNtfEntryChange');
  }
}

/**
 * 通知view信息
 */
class EntryViewInfo {
  public isHover: boolean = false;
  /**
   * 是否处于滑动手势中
   */
  public isGestureActioning: boolean = false;
  /**
   * 5s倒计时删除通知timerId
   */
  public cancelTimerId?: number = undefined;
  /**
   * 提前修改退出动效定时器
   */
  public changeTransitionTimerId?: number = undefined;
}

const EMPTY_CALLBACK = new EmptyCallback();
/**
 * 横幅窗口名
 */
const WINDOW_NAME = WindowConstants.WINDOW_NAME_BANNER;

/**
 * 横幅弹框显示5秒
 */
const HEADS_UP_DURATION = 5000;

/**
 * 横幅弹框显示的时候，再来一个横幅通知显示的间隔
 */
const HEADS_UP_SWITCH_CONTENT_INTERVAL = 200;

/**
 * 横幅忽略的冷却时间
 */
const IGNORE_NTF_INTERVAL = 60 * 1000;

const HEADS_UP_SWITCH_SHOWING_CONTENT_INTERVAL = 600;

/**
 * 互斥的面板窗口名
 * 这些窗口show时，隐藏横幅通知窗口
 */
const EXCLUDE_WINDOW_NAMES = [
  // PC通知中心
  PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL,
  // Phone下拉面板
  WindowConstants.WINDOW_NAME_DROPDOWN,
  // 锁屏窗口
  WindowConstants.WINDOW_NAME_LOCK_SCREEN
];

const INVALID_Z_INDEX = -1;
const ABOVE_INPUT_Z_INDEX = 3001;

/**
 * 横幅通知管理
 *
 * @since 2023-01-17
 */
export class NtfHeadsUpVM {
  /**
   * 回调器
   */
  private callback: HeadsUpCallback = EMPTY_CALLBACK;
  /**
   * 沉浸模式回调器
   */
  private tintCallbacks = new Set<HeadsUpTintCallback>();
  /**
   * 统一事件管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  /**
   * 自动隐藏横幅通知的任务id
   */
  private autoCancelId: number | null = null;
  /**
   * 条目是否展开状态
   */
  private isItemExpand: boolean = false;
  /**
   * 被忽略一段时间的横幅通知应用列表
   */
  private ignoredList: Map<number, Date> = new Map();
  /**
   * 是否处于沉浸模式
   */
  private isInTint: boolean = false;
  /**
   * 是否锁屏
   */
  private isLockScreen?: boolean = undefined;
  /**
   * 默认zIndex
   */
  private defaultZIndex: number = INVALID_Z_INDEX;
  private viewInfoMap: Map<string, EntryViewInfo> = new Map();

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
      .on(NotificationEntryEvent, this.onNtfEntryEvent)
      .on(ScreenLockEvent, this.onScreenLockEvent)

    // 监听状态栏沉浸事件
    SCBSceneSessionManager.getInstance().registerSystemBarPropertyCallbacks(this.systemBarPropertyCB);
    notificationConfigManager.subscribeChangeEvent(this.onNotificationConfigChange);
    hideBannerNtfContentObj.registerHiddenContentChangedEvent(this.onGlobalHiddenContentChange);
  }

  /**
   * 锁屏关闭横幅通知
   * @param event 事件
   */
  private onScreenLockEvent = (event: ScreenLockEvent): void => {
    if (this.isLockScreen === event.isLockScreen) {
      return;
    }
    this.isLockScreen = event.isLockScreen;
    log.showInfo(`isLockScreen:${this.isLockScreen}`);
    if (windowMgr.isShowing(WINDOW_NAME)) {
      windowMgr.hideWindowImmediately(WINDOW_NAME);
    }
  }

  registerTintCallback(cb: HeadsUpTintCallback) {
    log.showInfo(`registerTintCallback`);
    if (!cb) {
      return;
    }
    this.tintCallbacks.add(cb);
  }

  private systemBarPropertyCB = (property: SCBSystemBarProperty): void => {
    this.isInTint = !property.enable;
    this.notifyTintChange(this.isInTint);
  }

  unregisterTintCallback(cb: HeadsUpTintCallback) {
    log.showInfo(`unregisterTintCallback`);
    if (!cb) {
      return;
    }
    this.tintCallbacks.delete(cb);
  }

  /**
   * 销毁
   */
  onDestroy(): void {
    this.eventMgr.offAll();
    this.callback = EMPTY_CALLBACK;
    this.tintCallbacks.clear();
    // 取消监听状态栏沉浸事件
    SCBSceneSessionManager.getInstance().unRegisterSystemBarPropertyCallbacks(this.systemBarPropertyCB);
    notificationConfigManager.unsubscribeChangeEvent(this.onNotificationConfigChange);
    hideBannerNtfContentObj.unregisterHiddenContentChangedEvent(this.onGlobalHiddenContentChange);
  }

  /**
   * 全局通知配置变化事件
   */
  private onGlobalHiddenContentChange = (data: boolean): void => {
    log.showInfo(`Change hideBannerContent for ${data}`);
    if (!windowMgr.isShowing(WINDOW_NAME)) {
      log.showInfo('banner not showing, no need to deal');
      return;
    }
    let entries = this.callback.getNtfEntries();
    if (CommonUtils.containerIsEmpty(entries)) {
      log.showWarn('oldEntry is null');
      return;
    }
    entries.forEach(item => this.setHideContent(item));
    this.notifyNtfEntryChange(entries);
  };
  /**
   * 应用通知配置变化事件
   */
  private onNotificationConfigChange = async (event: NotificationConfigEvent): Promise<void> => {
    if (event.type === NotificationConfigEventType.HIDE_BANNER_CONTENT) {
      const creatorUid = event.uid;
      const bannerHideContentMode = event.index;
      log.showInfo(`Change hideBannerContent for ${creatorUid} to ${bannerHideContentMode}`);
      if (!windowMgr.isShowing(WINDOW_NAME)) {
        log.showInfo('banner not showing, no need to deal');
        return;
      }
      let entries = this.callback.getNtfEntries();
      if (CommonUtils.containerIsEmpty(entries)) {
        log.showWarn('oldEntries is null');
        return;
      }
      let hideContentChangedEntries = entries.filter(item => item.creatorUid === creatorUid &&
        item.bannerHideContentMode !== bannerHideContentMode);
      if (hideContentChangedEntries.length === 0) {
        log.info('no need to update hide content mode');
        return;
      }
      hideContentChangedEntries.forEach(item => {
        item.bannerHideContentMode = bannerHideContentMode;
        this.setHideContent(item);
      });
      this.notifyNtfEntryChange(entries);
    }
  };

  setItemHoverState(entry: NotificationEntry, isHover: boolean): void {
    log.showInfo(`setItemHoverState ${entry.hashCode} to ${isHover}`);
    let info = this.viewInfoMap.get(entry.hashCode);
    if (!info) {
      log.warn('hasCancelTimer no viewInfo')
      info = new EntryViewInfo();
      this.viewInfoMap.set(entry.hashCode, info);
    }
    info.isHover = isHover;
    // 判断是否需要隐藏窗口
    if (!this.hasCancelTimer(entry) && this.checkShouldDeleteEntry(entry)) {
      this.removeEntry(entry);
    }
  }

  /**
   * 定时器超时后，是否需要隐藏窗口
   */
  private checkShouldDeleteEntry(entry: NotificationEntry): boolean {
    log.debug(`checkShouldDeleteEntry ${entry.hashCode}`);
    if (entry.isHeadsUpStick) {
      log.info('checkShouldDeleteEntry isStick, not delete');
      return false;
    }
    let info = this.viewInfoMap.get(entry.hashCode);
    if (!info) {
      log.warn('checkShouldDeleteEntry no viewInfo, should delete')
      return true;
    }
    if (info.isHover || info.isGestureActioning) {
      log.warn('checkShouldDeleteEntry is hover or isGestureActioning, not delete');
      return false;
    }
    log.info('checkShouldDeleteEntry, should delete');
    return true;
  }

  /**
   * 是否有关闭倒计时
   */
  private hasCancelTimer(entry: NotificationEntry): boolean {
    log.debug(`hasCancelTimer ${entry.hashCode}`);
    let info = this.viewInfoMap.get(entry.hashCode);
    if (!info) {
      log.warn('hasCancelTimer no viewInfo')
      return false;
    }
    return info.cancelTimerId !== undefined;
  }

  public setIsGestureActioning(entry: NotificationEntry, isGestureActioning: boolean): void {
    log.debug(`setIsGestureActioning ${entry.hashCode} ${isGestureActioning}`);
    let info = this.viewInfoMap.get(entry.hashCode);
    if (!info) {
      log.warn('hasCancelTimer no viewInfo')
      info = new EntryViewInfo();
      this.viewInfoMap.set(entry.hashCode, info);
    }
    info.isGestureActioning = isGestureActioning;
    if (!this.hasCancelTimer(entry) && this.checkShouldDeleteEntry(entry)) {
      entry.notifyOutChanged();
      // 延迟删除，保证退场动画修改成功
      setTimeout(() => {
        this.removeEntry(entry);
      }, DeviceHelper.isPC() ? 100 : 0);
    }
  }

  isInTintStatus(): boolean {
    return this.isInTint;
  }

  private isIgnoredNtf(newEntry: NotificationEntry): boolean {
    let lastTime: Date = this.ignoredList.get(newEntry.creatorUid) as Date;
    if (CommonUtils.isInvalid(lastTime)) {
      // 记录不存在，说明不需要忽略
      log.showInfo('isIgnoredNtf：lastTime empty, false' );
      return false;
    }
    let now: Date = new Date();
    if (now.getTime() - lastTime.getTime() <= IGNORE_NTF_INTERVAL) {
      // 记录存在，且没超过忽略的时间阈值，需要忽略
      log.showInfo('isIgnoredNtf：true' );
      return true;
    }

    // 存在记录，但是超过了时间，则不忽略，同时清除记录
    this.ignoredList.delete(newEntry.creatorUid);
    log.showInfo('isIgnoredNtf：false' );
    return false;
  }

  /**
   * 窗口show/hide事件
   *
   * @param event 事件
   */
  private onWindowEvent = (event: WindowEvent): void => {
    log.showInfo(`onWindowEvent ${event.windowName} ${event.eventType} ${event.eventState}`);
    // 互斥面板显示，直接隐藏横幅通知
    if (event.isWindowStartShow() && ArrayUtils.contains(EXCLUDE_WINDOW_NAMES, event.windowName)) {
      this.hideHeadsUpWindowWithAnim(false);
      return;
    }
    if (event.isMatchName(WINDOW_NAME)) {
      if (event.isWindowEndHide()) {
        log.showInfo(`isWindowEndHide`)
        this.notifyNtfEntryChange([], false);
        if (this.defaultZIndex !== INVALID_Z_INDEX) { // 横幅通知关闭后还原zIndex
          viewMgrPolicy.setZIndex(ViewType.NOTIFICATION_BANNER, this.defaultZIndex);
          log.showInfo(`change zIndex to default ${this.defaultZIndex}`);
          this.defaultZIndex = INVALID_Z_INDEX;
        }
      } else if (event.isWindowStartShow()) {
        this.keepZIndexAboveInputStatusBar();
      }
    }
  }

  /**
   * 保证横幅通知不被输入法悬浮窗挡住
   * @description 检测到输入法悬浮窗和横幅通知有交叉后将横幅通知zIndex的比悬浮窗高1，横幅通知关闭后还原zIndex
   */
  private keepZIndexAboveInputStatusBar(): void {
    const bannerPos = windowMgr.getWindowPosition(WINDOW_NAME);
    const inputMethodZOrder: number =
      (SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType === SCBConstants.UITYPE_PC) ?
      SpecificPanelZOrder.INPUT_METHOD_STATUS_BAR : SpecificPanelZOrder.ABOVE_KEYGUARD;
    const list: SCBSpecificSceneSessionList =
      SCBSceneSessionManager.getInstance().getSpecificContainerSessionList(inputMethodZOrder);
    const intersectAndActiveInputStatusBar: boolean = list.some((item) => item.isActive &&
      item.session.type === sceneSessionManager.SessionType.TYPE_INPUT_METHOD_STATUS_BAR &&
      this.intersect(bannerPos, item.currRect));
    if (!intersectAndActiveInputStatusBar) {
      log.info('no intersectAndActiveInputStatusBar, no need to change zIndex');
      return;
    }
    const defaultZIndex = viewMgrPolicy.getZIndex(ViewType.NOTIFICATION_BANNER);
    if (!defaultZIndex) {
      log.warn('defaultZIndex is null, not to change index');
      return;
    }
    this.defaultZIndex = defaultZIndex;
    viewMgrPolicy.setZIndex(ViewType.NOTIFICATION_BANNER, ABOVE_INPUT_Z_INDEX);
    log.info('change zIndex success');
  }

  /**
   * 检测两个区域是否重叠
   * @param rect1
   * @param rect2
   */
  private intersect(rect1: Window.Rect, rect2: SCBSessionRect): boolean {
    return !(
      rect1.left + rect1.width <= rect2.left.getPx() ||
        rect2.left.getPx() + rect2.width.getPx() <= rect1.left ||
        rect1.top + rect1.height <= rect2.top.getPx() ||
        rect2.top.getPx() + rect2.height.getPx() <= rect1.top
    );
  }

  private getSettingSound(entry: NotificationEntry): number {
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

  private report(newEntry: NotificationEntry): void {
    NotificationSysEventReporter.notificationReceived({
      IS_PUSH: newEntry.isFromPush ? 0 : 1,
      IS_ONGOING: newEntry.isOngoing ? 0 : 1,
      IS_LIVE: newEntry.isLiveType() ? 0 : 1,
      RECEIVED_SCENE: newEntry?.isHeadsUp() ? 4 : 2,
      CREATOR_BUNDLE_NAME: newEntry.creatorBundleName,
      NOTIFICATION_ID: newEntry.id,
      NOTIFICATION_SLOT_TYPE: newEntry.slotType,
      IS_SCREEN_OFF: 1,
      settingLock: 1,
      settingBanner: newEntry.remindConfig.isBannerEnable() ? 0 : 1,
      settingSound: this.getSettingSound(newEntry),
      language: I18n.System.getSystemLanguage(),
      style: newEntry.style,
      isunremoveable: !newEntry.isRemoveAllowed,
      PRIVILEGE_TYPE: newEntry.isFromSystemApp ? 1 : 0,
      IS_STICKY: newEntry.isHeadsUpStick ? 1 : 0
    });
  }

  /**
   * 通知数据add/remove事件
   *
   * @param event 事件
   */
  private onNtfEntryEvent = (event: NotificationEntryEvent): void => {
    switch (event.eventType) {
      // 新增/更新场景，通知数据同一个则更新，不同则横幅重新弹出
      case NotificationEntryEvent.EVENT_TYPE_POST_ADD:
      case NotificationEntryEvent.EVENT_TYPE_POST_UPDATE:
        if (!event.notificationList?.length) {
          return;
        }
        let newEntry = event.notificationList[0];
        if (!this.isAllowShowHeadsUp(newEntry, event.eventType === NotificationEntryEvent.EVENT_TYPE_POST_UPDATE)) {
          return;
        }

        if (this.isIgnoredNtf(newEntry)) {
          // 被忽略的横幅通知
          return;
        }
        log.showInfo(`banner is in tint:${this.isInTint}`);

        this.setHideContent(newEntry);
        let oldEntries = this.callback.getNtfEntries();
        let isExisted = oldEntries.some(item => newEntry.hashCode === item.hashCode);
        let sticky: boolean = newEntry.isHeadsUpStick;
        log.showInfo(`show heads up: ${newEntry.creatorBundleName}, ${newEntry.hashCode}, sticky:${sticky}, isExisted:${isExisted}`);
        // 存在相同通知，数据更新
        if (isExisted) {
          this.replaceEntry(newEntry);
        } else { // 不存在相同通知
          this.report(newEntry);
          let index = oldEntries.findIndex(item => item.isHeadsUpStick === sticky);
          if (index >= 0) {
            log.info(`already exist sticky:${sticky} entry`);
            this.removeCancelRunnable(oldEntries[index]);
            oldEntries.splice(index, 1);
          }
          oldEntries.push(newEntry);
          this.postCancelRunnable(newEntry);
          this.notifyNtfEntryChange(oldEntries, true, true);
        }
        break;
      case NotificationEntryEvent.EVENT_TYPE_POST_CANCEL:
        // 移除通知，隐藏横幅
        if (ArrayUtils.isEmpty(event.notificationList)) {
          return
        }
        let removeEntry = event.notificationList[0];
        log.info(`cancel entry:${removeEntry.hashCode}`);
        this.removeEntry(removeEntry);
        break;
      default:
        break;
    }
  }

  private isAllowShowHeadsUp(entry: NotificationEntry, isUpdate: boolean): boolean {
    let bannerNotDisturb = sSettingsUtil.getSystemValue(SettingsKeyConstants.BANNER_NO_DISTURB, 'false') === 'true';
    if (bannerNotDisturb) {
      log.info('bannerNotDisturb');
      this.hideHeadsUpWindowWithAnim(false);
      return false;
    }

    // 横幅更新为非横幅，则收起横幅
    if (!entry.isHeadsUp()) {
      if (this.callback.getNtfEntries().some(item => item.hashCode === entry.hashCode)) {
        log.info('headsUp convert to noHeadsUp');
        this.removeEntry(entry);
      }
      return false;
    }

    // 避免下载通知一直横幅提示，如果是下载通知更新情况，仅更新数据，不提示横幅
    if (isUpdate && entry?.isLiveType() && entry.isConvertFromNormal) {
      log.showInfo('onNtfEntryEvent UPDATE isDownloadTemplate: ' + entry.toSimpleString());
      this.replaceEntry(entry);
      return false;
    }

    return true;
  }
  /**
   * 设置是否需要隐藏横幅通知内容
   * @param newEntry
   */
  setHideContent(newEntry: NotificationEntry): void {
    log.showInfo(`setHideContent app:${newEntry.bannerHideContentMode} global:${hideBannerNtfContentObj.getIsHiddenContent()}`)
    let isHide: boolean = false;
    if (newEntry.bannerHideContentMode === HideBannerContentType.FOLLOW_SYSTEM) {
      isHide = hideBannerNtfContentObj.getIsHiddenContent();
    } else if (newEntry.bannerHideContentMode === HideBannerContentType.ALWAYS) {
      isHide = false;
    } else if (newEntry.bannerHideContentMode === HideBannerContentType.NEVER) {
      isHide = true;
    }
    newEntry.setShouldHideContent(isHide);
  }

  /**
   * 检测是否显示横幅窗口
   */
  private needHeadsUpWindowShow(): boolean {
    // 窗口可见，重新计时
    if (windowMgr.isShowing(WINDOW_NAME)) {
      log.showInfo('checkHeadsUpWindowShow is showing ' + WINDOW_NAME);
      return false;
    }
    // dropdown窗口或PC通知面板或锁屏窗口显示时，不显示横幅; 锁屏期间常驻横幅允许显示
    if (windowMgr.isShowing(WindowConstants.WINDOW_NAME_DROPDOWN) ||
    windowMgr.isShowing(PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL) ||
    windowMgr.isShowing(WindowConstants.WINDOW_NAME_LOCK_SCREEN)) {
      log.showInfo('checkHeadsUpWindowShow ntf panel is showing');
      return false;
    }
    if (DeviceHelper.is2In1DevicePcType() && sSCBOobeManager.isEnable()) {
      log.showError('this is in oobe!');
      return false;
    }
    log.showInfo('checkHeadsUpWindowShow show ' + WINDOW_NAME);
    return true;
  }

  // 横幅显示异常打点
  private checkHeadsUpShowAbnormal(sticky: boolean = false): void {
    if (windowMgr.isShowing(WindowConstants.WINDOW_NAME_DROPDOWN) ||
    windowMgr.isShowing(PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL) ||
      (windowMgr.isShowing(WindowConstants.WINDOW_NAME_LOCK_SCREEN) && !sticky)) {
      // 其他面板显示，确实不需要显示横幅
      return;
    }
    // 排除不显示的情况，如果没有在显示横幅，是有问题的
    if (!windowMgr.isShowing(WINDOW_NAME)) {
      HiDfxEventUtil.reportHeadsUpShowAbnormal();
    }
  }

  /**
   * 开启自动删除通知倒计时
   */
  private postCancelRunnable(entry: NotificationEntry): void {
    if (entry.isHeadsUpStick) {
      log.info('stick entry, ignore.');
      return;
    }
    const key = entry.hashCode;
    log.showInfo(`postCancelRunnable ${key}`);
    let info = this.viewInfoMap.get(key);
    if (!info) {
      info = new EntryViewInfo();
      this.viewInfoMap.set(key, info);
    }
    info.changeTransitionTimerId =
      info.cancelTimerId = setTimeout(() => {
        entry.notifyOutChanged();
      }, HEADS_UP_DURATION * 0.95);
    info.cancelTimerId = setTimeout(() => {
      // 超过时间后，如果当前为展开状态，则等收起时再隐藏窗口
      if (!this.checkShouldDeleteEntry(entry)) {
        this.removeCancelRunnable(entry);
        return;
      }
      // 删除通知
      this.removeEntry(entry);
    }, HEADS_UP_DURATION);
  }

  /**
   * 移除自动删除通知任务
   */
  private removeCancelRunnable(entry: NotificationEntry): void {
    if (entry.isHeadsUpStick) {
      log.info('stick entry, ignore.');
      return;
    }
    const key = entry.hashCode;
    log.showInfo(`removeCancelRunnable ${key}`);
    let info = this.viewInfoMap.get(key);
    if (!info || !info.cancelTimerId) {
      return;
    }
    clearTimeout(info.cancelTimerId);
    info.cancelTimerId = undefined;
  }

  /**
   * 显示横幅窗口
   */
  private showHeadsUpWindow(): void {
    log.showInfo('show banner');
    return windowMgr.showWindowWithAnim(WINDOW_NAME);
  }

  /**
   * 隐藏横幅窗口
   */
  private hideHeadsUpWindowWithAnim(checkEntry: boolean): void {
    log.showInfo('hideHeadsUpWindowWithAnim');
    setTimeout(() => {
      if (!checkEntry || this.callback.getNtfEntries().length === 0) {
        log.showInfo('hideHeadsUpWindowWithAnim hideWindowCallback');
        windowMgr.hideWindowCallback(WINDOW_NAME);
      }
    }, 250);
  }

  /**
   * 通知数据切换
   *
   * @param ntfEntries 通知数据
   */
  private notifyNtfEntryChange(ntfEntries: NotificationEntry[], needControlWindow: boolean = true,
    isAddEntry: boolean = false): void {
    // 当准备清空通知数据时，恢复通知数据展开状态
    let oldEntries = this.callback.getNtfEntries();
    if (CommonUtils.containerIsEmpty(ntfEntries)) {
      oldEntries.forEach(item => item.resetItemExpandState());
    }
    if (needControlWindow && !CommonUtils.containerIsEmpty(ntfEntries) && this.needHeadsUpWindowShow()) {
      this.showHeadsUpWindow();
    }
    this.callback.notifyNtfEntryChange(ntfEntries, isAddEntry);
    if (needControlWindow && CommonUtils.containerIsEmpty(ntfEntries)) {
      this.hideHeadsUpWindowWithAnim(true);
    }
  }

  private notifyTintChange(inTint: boolean): void {
    this.tintCallbacks.forEach((listener: HeadsUpTintCallback) => {
      listener.notifyTintStatusChange(inTint);
    })
  }

  public removeEntry(entry: NotificationEntry) {
    log.info(`removeEntry ${entry.hashCode}`);
    let entries = this.callback.getNtfEntries();
    let index = entries.findIndex(item => entry.hashCode === item.hashCode);
    if (index < 0) {
      log.warn('removeEntry failed, entry not exist');
      return;
    }
    entries.splice(index, 1);
    if (this.viewInfoMap.has(entry.hashCode)) {
      this.viewInfoMap.delete(entry.hashCode);
    }
    this.removeCancelRunnable(entry);
    log.warn('removeEntry success');
    this.notifyNtfEntryChange(entries);
  }

  public replaceEntry(entry: NotificationEntry) {
    let entries = this.callback.getNtfEntries();
    let index = entries.findIndex(item => entry.hashCode === item.hashCode);
    if (index < 0) {
      log.warn('removeEntry failed, entry not exist');
      return;
    }
    entries.splice(index, 1, entry);
    this.removeCancelRunnable(entry);
    this.postCancelRunnable(entry);
    log.warn(`replaceEntry success ${entry.hashCode}`);
    this.notifyNtfEntryChange(entries);
  }

  public removeAndPushEntry(entry: NotificationEntry) {
    let entries = this.callback.getNtfEntries();
    let index = entries.findIndex(item => entry.hashCode === item.hashCode);
    if (index < 0) {
      log.warn('removeEntry failed, entry not exist');
      return;
    }
    entries.splice(index, 1);
    entries.push(entry);
    this.removeCancelRunnable(entry);
    this.postCancelRunnable(entry);
    log.warn(`removeAndPushEntry success ${entry.hashCode}`);
    this.notifyNtfEntryChange(entries, true, true);
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
  getNtfEntries(): NotificationEntry[];

  /**
   * 通知数据变更
   *
   * @param ntfEntry 通知数据
   */
  notifyNtfEntryChange(ntfEntry: NotificationEntry[], isAddEntry: boolean): void;

}

export interface HeadsUpTintCallback {
  /**
   * 沉浸模式变更
   *
   * @param inTint 是否处于沉浸模式
   */
  notifyTintStatusChange(inTint: boolean): void;
}
