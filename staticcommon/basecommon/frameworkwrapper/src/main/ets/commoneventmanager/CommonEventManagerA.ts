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

import CES from '@ohos.commonEventManager';
import { AccountMgr } from '../accountmanager/AccountManager';
import { EvtBus } from '../eventbus/EventBus';
import { AccountEvent } from '../eventbus/events/Events';
import {
  CommonEvent,
  PackageCommonEvent,
  SplitScreenEvent,
  MediaControlEvent,
  TimeChangeEvent,
  ScreenOnOffEvent,
  SimPinVerifyEvent,
  HideWindowPanelEvent,
  FileChangeEvent,
  DownloadStatusChangeEvent,
  DownloadingProgressChangeEvent,
  InstallStatusChangeEvent,
  ShutDownEvent,
  WeekSchedulerReporterEvent,
  PackageDataClearedEvent,
  SleepingModeChangeEvent,
  UserUnlockedEvent,
  DisposedRuleAddEvent,
  DisposedRuleDeleteEvent,
  UpdateMigrateStatusChangeEvent,
  BundleMappingChangeEvent,
  RgmStatusChangeEvent
} from '../eventbus/events/CommonEvents';
import { BusinessError } from '@ohos.base';
import { CommonEventData } from 'commonEvent/commonEventData';
import { CommonEventSubscribeInfo } from 'commonEvent/commonEventSubscribeInfo';
import { CommonEventSubscriber } from 'commonEvent/commonEventSubscriber';
import { CommonEventPublishData } from 'commonEvent/commonEventPublishData';
import {
  SingletonHelper,
  CommonUtils,
  ArrayUtils,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';

const TAG = 'CommonEventManagerA';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const CUSTOM_EVENT_MEDIA_CONTROL_MESSAGE = 'MediaControlMessage';

const CUSTOM_EVENT_TOUCH_PINCH_BEGIN_EVENT = 'TOUCH_PINCH_BEGIN_EVENT';

const CUSTOM_EVENT_THREE_FINGER_SWIPER_BEGIN = 'THREE_FINGER_SWIPER_BEGIN';

const CUSTOM_EVENT_FOUR_FINGER_SWIPER_BEGIN = 'FOUR_FINGER_SWIPER_BEGIN';

const CUSTOM_EVENT_FAF_FILE_CHANGE = 'DeskTopPasteFileUri';

const COMMON_EVENT_USER_SLEEP_STATE_CHANGED = 'COMMON_EVENT_USER_SLEEP_STATE_CHANGED';

const CUSTOM_EVENT_SIM_VERIFY_PIN = 'TELEPHONY_EXT_VERIFYPIN';

export const CUSTOM_EVENT_WEEK_SCHEDULER_REPORTER = 'WEEK_SCHEDULER_REPORTER';

const PERMISSION_RECEIVE_APP_INSTALL_INFO_CHANGE = 'ohos.permission.RECEIVE_APP_INSTALL_INFO_CHANGE';

/**
 * 广播数据转内部数据的结构类型
 */
type InnerEvent<T extends CommonEvent> = new (eventData: CommonEventData) => T;

/**
 * 多任务广播相关事件类型
 */
export const enum RecentEventType {
  ENTER_RECENT = 'ENTER_RECENT', // 进入多任务
  START_SCENE_FROM_RECENT = 'START_SCENE_FROM_RECENT', // 在多任务点击一个应用进入
  GESTURE_BACK = 'GESTURE_BACK', // 侧滑
  SCENE_PANEL_STATE_CHANGE = 'SCENE_PANEL_STATE_CHANGE', // 窗口状态变化
  RECENT_CLEAR_ALL = 'RECENT_CLEAR_ALL' //多任务点击一键清理
}

export const enum NavBarEventType {
  NAVBAR_UP = 'NAVBAR_UP_EVENT', // 进入多任务
  EXECUTE_HOME = 'EXECUTE_HOME_EVENT', // 悬浮导航home键
  EXECUTE_RECENT = 'EXECUTE_RECENT_EVENT', // 悬浮导航recent键
}

/**
 * 回桌面广播相关事件类型
 */
export const enum ReturnDesktopEventType {
  SLIP_UP = 'SLIP_UP',
  BACK_TO_HOME = 'BACK_TO_HOME', // 侧滑退出
}

  /**
 * 外部广播事件管理
 * 外部广播统一只注册一个，由内部EventBus进行转发
 *
 * @since 2022-10-07
 */
class CommonEventManagerA {
  readonly CUSTOM_RECENT_EVENT = 'RECENT_EVENT'; // 多任务相关场景广播
  readonly CUSTOM_NAVBAR_EVENT = 'NAVBAR_EVENT'; // 底部上滑抬手事件
  readonly CUSTOM_RETURN_DESKTOP_EVENT = 'RETURN_DESKTOP_EVENT'; // 回桌面相关场景广播
  readonly CUSTOM_SCENE_PANEL_EVENT = 'SCENE_PANEL_EVENT'; // 窗口相关场景广播
  readonly CUSTOM_GESTURE_EVENT = 'CUSTOM_GESTURE_EVENT'; // 窗口相关场景广播
  readonly CUSTOM_BACK_HOME_EVENT = 'CUSTOM_BACK_HOME_EVENT'; // 侧滑退出场景广播

  /**
   * 所有外部广播集
   */
  private static readonly ALL_EVENTS: CommonEventSubscribeInfo[] = [
    // 无权限广播集
    {
      events: [
        CES.Support.COMMON_EVENT_PACKAGE_ADDED, // 新应用安装
        CES.Support.COMMON_EVENT_PACKAGE_REMOVED, // 应用卸载
        CES.Support.COMMON_EVENT_PACKAGE_FULLY_REMOVED, // 应用完全卸载
        CES.Support.COMMON_EVENT_PACKAGE_REPLACED, // 应用更新安装
        CES.Support.COMMON_EVENT_PACKAGE_CHANGED, // 应用包更改
        CES.Support.COMMON_EVENT_SPLIT_SCREEN, // 应用分屏广播
        CUSTOM_EVENT_MEDIA_CONTROL_MESSAGE, // 播控消息
        CES.Support.COMMON_EVENT_TIME_CHANGED, // 时间被设置
        CES.Support.COMMON_EVENT_TIMEZONE_CHANGED, // 时区变化
        CES.Support.COMMON_EVENT_TIME_TICK, // 当前时间变化
        CES.Support.COMMON_EVENT_SCREEN_OFF, // 灭屏
        CES.Support.COMMON_EVENT_SCREEN_ON, // 亮屏
        CUSTOM_EVENT_SIM_VERIFY_PIN, // SIM卡PIN码校验广播
        CUSTOM_EVENT_TOUCH_PINCH_BEGIN_EVENT, // 三指捏合
        CUSTOM_EVENT_THREE_FINGER_SWIPER_BEGIN, // 三指滑动
        CUSTOM_EVENT_FOUR_FINGER_SWIPER_BEGIN, // 四指滑动
        CUSTOM_EVENT_FAF_FILE_CHANGE,
        CES.Support.COMMON_EVENT_SHUTDOWN, // 关机
        CUSTOM_EVENT_WEEK_SCHEDULER_REPORTER, // 周报
        CES.Support.COMMON_EVENT_PACKAGE_DATA_CLEARED, //应用包数据清除
        COMMON_EVENT_USER_SLEEP_STATE_CHANGED, // 睡眠模式变化
        CES.Support.COMMON_EVENT_USER_UNLOCKED, // 系统账号认证解锁状态
        CES.Support.COMMON_EVENT_DYNAMIC_ICON_CHANGED, // 动态图标使能/去使能广播
        DisposedRuleAddEvent.DISPOSED_RULE_ADD_EVENT,
        DisposedRuleDeleteEvent.DISPOSED_RULE_DELETE_EVENT,
        UpdateMigrateStatusChangeEvent.UPDATE_MIGRATE_STATUS_CHANGE_EVENT,
        RgmStatusChangeEvent.RGM_STATUS_CHANGED
      ]
    },
  ];

  private static readonly APP_GALLERY_EVENTS: CommonEventSubscribeInfo[] = [
    // 应用中心公共事件集
    {
      events: [
        DownloadStatusChangeEvent.DOWNLOAD_STATUS_CHANGE,
        DownloadingProgressChangeEvent.DOWNLOAD_PROGRESS_CHANGE,
        InstallStatusChangeEvent.INSTALL_STATUS_CHANGE
      ],
      publisherPermission: PERMISSION_RECEIVE_APP_INSTALL_INFO_CHANGE
    },
    {
      events: [
        BundleMappingChangeEvent.BUNDLE_MAPPING_CHANGE
      ],
      publisherBundleName: 'com.ohos.appgallery',
    }
  ];

  /**
   * 外部广播映射内部事件类型
   */
  private allInnerEvents: Map<string, InnerEvent<CommonEvent>> = new Map();

  /**
   * 所有已注册广播
   */
  private mSubscribers: Set<CommonEventSubscriber> = new Set();

  /**
   * 当前用户id
   */
  private mCurrentUserId?: number;

  /**
   * 事件map初始化
   */
  private initInnerEventMap(): void {
    // 包管理事件
    this.allInnerEvents.set(CES.Support.COMMON_EVENT_PACKAGE_ADDED, PackageCommonEvent);
    this.allInnerEvents.set(CES.Support.COMMON_EVENT_PACKAGE_REMOVED, PackageCommonEvent);
    this.allInnerEvents.set(CES.Support.COMMON_EVENT_PACKAGE_FULLY_REMOVED, PackageCommonEvent);
    this.allInnerEvents.set(CES.Support.COMMON_EVENT_PACKAGE_REPLACED, PackageCommonEvent);
    this.allInnerEvents.set(CES.Support.COMMON_EVENT_PACKAGE_CHANGED, PackageCommonEvent);
    this.allInnerEvents.set(CES.Support.COMMON_EVENT_DYNAMIC_ICON_CHANGED, PackageCommonEvent);
    // 分屏条事件
    this.allInnerEvents.set(CES.Support.COMMON_EVENT_SPLIT_SCREEN, SplitScreenEvent);
    // 播控事件
    this.allInnerEvents.set(CUSTOM_EVENT_MEDIA_CONTROL_MESSAGE, MediaControlEvent);
    // 时间变化事件
    this.allInnerEvents.set(CES.Support.COMMON_EVENT_TIME_CHANGED, TimeChangeEvent);
    this.allInnerEvents.set(CES.Support.COMMON_EVENT_TIMEZONE_CHANGED, TimeChangeEvent);
    this.allInnerEvents.set(CES.Support.COMMON_EVENT_TIME_TICK, TimeChangeEvent);
    // 亮灭屏事件
    this.allInnerEvents.set(CES.Support.COMMON_EVENT_SCREEN_OFF, ScreenOnOffEvent);
    this.allInnerEvents.set(CES.Support.COMMON_EVENT_SCREEN_ON, ScreenOnOffEvent);
    // SIM卡PIN码校验事件
    this.allInnerEvents.set(CUSTOM_EVENT_SIM_VERIFY_PIN, SimPinVerifyEvent);
    // 三指捏合
    this.allInnerEvents.set(CUSTOM_EVENT_TOUCH_PINCH_BEGIN_EVENT, HideWindowPanelEvent);
    // 三指滑动
    this.allInnerEvents.set(CUSTOM_EVENT_THREE_FINGER_SWIPER_BEGIN, HideWindowPanelEvent);
    // 四指滑动
    this.allInnerEvents.set(CUSTOM_EVENT_FOUR_FINGER_SWIPER_BEGIN, HideWindowPanelEvent);
    this.allInnerEvents.set(CUSTOM_EVENT_FAF_FILE_CHANGE, FileChangeEvent);

    // 应用市场下载状态变更事件
    this.allInnerEvents.set(DownloadStatusChangeEvent.DOWNLOAD_STATUS_CHANGE, DownloadStatusChangeEvent);
    // 应用市场下载进度变更事件
    this.allInnerEvents.set(DownloadingProgressChangeEvent.DOWNLOAD_PROGRESS_CHANGE, DownloadingProgressChangeEvent);
    // 应用市场安装状态变更事件
    this.allInnerEvents.set(InstallStatusChangeEvent.INSTALL_STATUS_CHANGE, InstallStatusChangeEvent);
    this.allInnerEvents.set(ShutDownEvent.SHUT_DOWN_EVENT, ShutDownEvent);
    this.allInnerEvents.set(CUSTOM_EVENT_WEEK_SCHEDULER_REPORTER, WeekSchedulerReporterEvent);
    this.allInnerEvents.set(PackageDataClearedEvent.EVENT_PACKAGE_DATA_CLEARED, PackageDataClearedEvent);
    // 睡眠模式发生变化事件
    this.allInnerEvents.set(COMMON_EVENT_USER_SLEEP_STATE_CHANGED, SleepingModeChangeEvent);
    // 系统账号认证解锁事件
    this.allInnerEvents.set(CES.Support.COMMON_EVENT_USER_UNLOCKED, UserUnlockedEvent);
    this.allInnerEvents.set(BundleMappingChangeEvent.BUNDLE_MAPPING_CHANGE, BundleMappingChangeEvent);
    this.allInnerEvents.set(DisposedRuleAddEvent.DISPOSED_RULE_ADD_EVENT, DisposedRuleAddEvent);
    this.allInnerEvents.set(DisposedRuleDeleteEvent.DISPOSED_RULE_DELETE_EVENT, DisposedRuleDeleteEvent);
    this.allInnerEvents.set(UpdateMigrateStatusChangeEvent.UPDATE_MIGRATE_STATUS_CHANGE_EVENT,
      UpdateMigrateStatusChangeEvent);
    this.allInnerEvents.set(RgmStatusChangeEvent.RGM_STATUS_CHANGED, RgmStatusChangeEvent);
  }

  /**
   * 广播监听初始化
   */
  init(): void {
    log.showInfo('CEManager.init()');
    this.initInnerEventMap();
    // 监听用户切换，更换广播监听用户
    EvtBus.on(AccountEvent, (event) => this.setCurrentUserId(event?.accountInfo?.localId));
    // 初始化当前用户广播
    AccountMgr.getCurrentAccountId().then((userId) => this.setCurrentUserId(userId));
  }

  /**
   * 发送外部广播
   *
   * @param event 广播事件
   * @param options 广播参数
   */
  publishCommentEvent(event: string, options: CommonEventPublishData): void {
    AccountMgr.getCurrentAccountId().then((userId) => {
      if (AccountMgr.isInvalidAccount(userId)) {
        log.showInfo('publishCommentEvent user id invalid');
        return;
      }
      try {
        CES.publishAsUser(event, userId, options, (err) => {
          log.showInfo('publishCommentEvent fail:');
        });
      } catch (error) {
        log.error('publishCommentEvent publishAsUser try error', error);
      }
      log.showInfo('publishCommentEvent complete:%{public}s', event);
    });
  }

  /**
   * 切换用户id
   *
   * @param userId 当前活跃用户id
   */
  private setCurrentUserId(userId: number | undefined): void {
    if (AccountMgr.isInvalidAccount(userId)) {
      log.showInfo('setCurrentUserId user id err');
      return;
    }
    // 用户无变化，无需重复变更
    if (this.mCurrentUserId === userId) {
      log.showInfo('setCurrentUserId user id has not change');
      return;
    }
    // 刷新userID，重新注册广播
    this.mCurrentUserId = userId;
    this.unregisterAllCommonEvent();
    this.registerAllCommonEvent();
  }

  /**
   * 注册所有广播
   */
  private registerAllCommonEvent(): void {
    if (AccountMgr.isInvalidAccount(this.mCurrentUserId)) {
      log.showInfo('registerAllCommonEvent user id err');
      return;
    }
    let AGEvents = CommonEventManagerA.APP_GALLERY_EVENTS;
    if (!ArrayUtils.isEmpty(AGEvents)) {
      AGEvents.forEach((subscribeInfo) => {
        subscribeInfo.userId = this.mCurrentUserId;
        CES.createSubscriber(subscribeInfo).then((subscribe) => {
          // AG 不同点在于需要添加权限
          CES.subscribe(subscribe, this.handleCommonEventCallback.bind(this));
          this.mSubscribers.add(subscribe);
        }).catch((error: BusinessError) => {
          log.showError(TAG, 'registerAllCommonEvent subscribe error');
        });
      });
      log.showInfo(TAG, 'registerAGEvents all event');
    }

    let allEvents = CommonEventManagerA.ALL_EVENTS;
    if (ArrayUtils.isEmpty(allEvents)) {
      log.showInfo('registerAllCommonEvent has not event');
      return;
    }
    // 遍历注册
    allEvents.forEach((subscribeInfo) => {
      subscribeInfo.userId = this.mCurrentUserId;
      try {
        CES.createSubscriber(subscribeInfo).then((subscribe) => {
          try {
            CES.subscribe(subscribe, this.handleCommonEventCallback.bind(this));
          } catch (err) {
            log.error('registerAllCommonEvent subscribe try error', err);
          }
          this.mSubscribers.add(subscribe);
        }).catch((err: BusinessError) => {
          log.error('registerAllCommonEvent createSubscriber error', err);
        });
      } catch (error) {
        log.error('registerAllCommonEvent createSubscriber try error', error);
      }
    });
  }

  /**
   * 注销所有广播
   */
  private unregisterAllCommonEvent(): void {
    if (ArrayUtils.isEmpty(this.mSubscribers)) {
      log.showInfo('unregisterAllCommonEvent has not register any event');
      return;
    }
    // 遍历注销，清空集合
    try {
      this.mSubscribers.forEach((subscriber) => CES.unsubscribe(subscriber));
    } catch (error) {
      log.error('unregisterAllCommonEvent unsubscribe try error', error);
    }
    this.mSubscribers.clear();
  }

  /**
   * 处理广播回调
   *
   * @param err 异常
   * @param data 广播数据
   */
  private handleCommonEventCallback(err: BusinessError, data: CommonEventData): void {
    if (err) {
      log.error('handleCommonEventCallback rec event err: ', err);
    }
    // 广播异常
    if (CommonUtils.isInvalid(data)) {
      return;
    }
    let innerMap = this.allInnerEvents;
    let innerEvent = innerMap.get(data.event);
    if (innerEvent === undefined) {
      log.showInfo('handleCommonEventCallback has not inner event map');
      return;
    }
    log.showDebug('handleCommonEventCallback post inner event:%{public}s', data.event);
    // 转换发送内部事件
    EvtBus.post(innerEvent, new innerEvent(data));
  }
}

// 单例
export let CEManager = SingletonHelper.getInstance(CommonEventManagerA, TAG);