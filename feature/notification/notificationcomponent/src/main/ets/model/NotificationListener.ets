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

import Ntf from '@ohos.notificationSubscribe';
import NtfMgr from '@ohos.notificationManager';
import wantAgent, { WantAgent } from '@ohos.app.ability.wantAgent';
import Want from '@ohos.app.ability.Want';
import {
  ImmersiveEntryEvent,
  LiveViewEntryEvent,
  notificationCcmConfig,
  AudioUtil,
  BaseNotification,
  NtfEventType,
  crossModuleCallUtil,
  TaskQueue,
  TaskItem,
  LiveApp2CapsuleEvent,
  TaskQueueFrozenReason,
  LiveType,
  SystemuiConstants,
} from '@ohos/systemuicommon';
import {
  ArrayUtils,
  CommonUtils,
  DomainName,
  LogDomain,
  LogHelper,
  SingletonHelper,
  TraceUtil,
} from '@ohos/basicutils';
import { SettingsKeyConstants, SettingsConstants } from '@ohos/commonconstants';
import {
  AccountEvent,
  DeviceHelper,
  EventManager,
  EvtBus,
  GlobalContext,
  HiDfxEventUtil,
  sSettingsUtil,
  AccountConstants
} from '@ohos/frameworkwrapper';
import { NotificationEntryEvent } from '../common/event/NotificationEvent';
import { NotificationEntry } from './NotificationEntry';
import { ntfMgr as NotificationManager } from './NotificationManager';
import NotificationListLimiter from './NotificationListLimiter';
import { audio } from '@kit.AudioKit';
import { BusinessError, systemParameter } from '@kit.BasicServicesKit';
import { NotificationParserFactory } from '../worker/parser/NotificationParserFactory';
import common from '@ohos.app.ability.common';
import systemSoundManager from '@ohos.multimedia.systemSoundManager';
import { notificationConfigManager } from '../manager/NotificationConfigManager';
import notificationManager from '@ohos.notificationManager';
import { SystemUIStateEventReporter } from '@ohos/systemuicommon/src/main/ets/reporter/SystemUIStateReporter';
import {
  DeleteNotificationErrorCode,
  DeleteNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/DeleteNotificationMaintenance';
import { ParseNotificationMaintenance } from '../maintenance/ParseNotificationMaintenance';
import { DeleteNotificationType } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { StatisticsMaintenance } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsMaintenance';
import { InnerEventUtil, NotificationUtil } from '@ohos/systemuicommon/newTsIndex';
import { NotificationExceptionCode } from '../maintenance/NotificationExceptionCode';
import { HaInitManager } from '../manager/HaInitManager';
import { RingSettingManager } from '../manager/RingSettingManager';
import { NotificationMaintenanceEvent } from '../maintenance/event/NotificationMaintenanceEvent';
import { EmergencyThermalSafeManager } from '@ohos/systemuicommon/src/main/ets/manager/EmergencyThermalSafeManager';
import { RemindPlayManager } from '../manager/RemindPlayManager';
import { SettingSearchManager } from '../manager/SettingSearchManager';
import { Classification, StopReason } from '../remind/RemindConstant';
import { NotificationApiUtil } from '../utils/NotificationApiUtil';
import { CampaignNotificationFilter } from '../common/CampaignNotificationFilter';
import { NotificationListenerEntryCancelEvent } from '@ohos/systemuicommon/src/main/ets/event/NotificationEvent';

const TAG = 'NotificationListener';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 通知对所有用户生效
 */
const USER_ALL = 0;

/**
 * 设备运行模式：工程模式
 */
const FACTORY_RUN_MODE: string = 'factory';
/**
 * 设备运行模式：正常模式
 */
const NORMAL_RUN_MODE: string = 'normal';

/**
 * 系统参数的设备运行模式关键字
 */
const RUN_MODE_KEY: string = 'const.runmode';


/**
 * 通知订阅最大重试次数
 */
const MAX_RETRY_SUBSCRIBE = 4;

/**
 * 解析通知超时时间
 */
const CONSUME_NOTIFICATION_TIMEOUT = 120000;

/**
 * 初始化解析通知超时时间
 */
const INIT_NOTIFICATION_TIMEOUT = 600000;

/**
 * 长时任务实况通知agentBundle Uid
 */
const RSS_LIVE_TYPE_UID = 3051;

/**
 * 通知排序列表
 */
export interface NotificationSortingMap {
  readonly sortings: Record<string, NtfMgr.NotificationSorting>;
  readonly sortedHashCode: Array<string>;
}

/**
 * 通知事件监听
 *
 * @since 2022-12-06
 */
class NotificationListener {
  /**
   * 通知处理队列
   */
  private handleQueue: TaskQueue = new TaskQueue(TAG, 1);
  /**
   * 通知监听注册
   */
  private ntfSubscribe: Ntf.NotificationSubscriber = {
    onConnect: () => {
      log.showWarn(`onListenerConnect`);
      const task: TaskItem = new TaskItem('onConnect', () => this.onListenerConnect(task));
      task.timeout = INIT_NOTIFICATION_TIMEOUT;
      this.handleQueue.add(task);
      task.resultPromise.catch((e: Error) => {
        new ParseNotificationMaintenance(false).reportParseFailed(undefined, e, this.currentUserId);
      });
    },
    onDisconnect: this.onListenerDisconnect,
    onDestroy: this.onListenerDestroy,
    onConsume: (postData: Ntf.SubscribeCallbackData) => {
      log.showWarn(`receive ntf ${postData?.request?.hashCode}`);
      const task: TaskItem = new TaskItem('onConsume', (times) => this.onNotificationPost(postData, task, times));
      task.timeout = CONSUME_NOTIFICATION_TIMEOUT;
      task.timeoutRetryTimes = 1;
      this.handleQueue.add(task);
      task.resultPromise.catch((e: Error) => {
        log.error(`ntf ${postData?.request?.hashCode} consume fail, ${e}`);
        new ParseNotificationMaintenance(false).reportParseFailed(postData?.request, e, this.currentUserId);
      });
      StatisticsMaintenance.get().listenerReceiveNtf(postData?.request);
    },
    onCancel: (cancelData: Ntf.SubscribeCallbackData) => {
      log.showWarn(`cancel ntf ${cancelData?.request?.hashCode}`);
      const task = new TaskItem('onCancel', () => this.onNotificationCancel(cancelData));
      this.handleQueue.add(task);
      DeleteNotificationMaintenance.cancelCallback(cancelData);
    },
    onBatchCancel: (cancelList: Array<Ntf.SubscribeCallbackData>) => {
      log.showWarn(`bactch cancel ntf ${cancelList?.length}`);
      const task = new TaskItem('onBatchCancel', () => this.onNotificationBatchCancel(cancelList));
      this.handleQueue.add(task);
      DeleteNotificationMaintenance.cancelCallbackBatch(cancelList);
    },
  };

  /**
   * 事件集管理
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 通知集
   * userId => 通知hashCode => 通知数据
   */
  private allNtfList: Map<number, Map<string, NotificationEntry>> = new Map();

  /**
   * 当前userID
   */
  private currentUserId: number = 0;

  private ntfListLimiter: NotificationListLimiter = new NotificationListLimiter();

  private isSysTonePlayAllow: boolean = true;

  private isSysVibrationAllow: boolean = true;

  private audioVolumeGroupManager?: audio.AudioVolumeGroupManager;

  private runMode: string = NORMAL_RUN_MODE;

  /**
   * 当前正在处理的通知列表，如果正在处理时更新动作需要更新通知hashCode对应的id，如果删除则清除hashCode
   */
  private handleNotificationMap: Map<string, number> = new Map();
  /**
   * 每条通知正在处理的标识
   */
  private handleId = 0;

  /**
   * 是否已注册订阅，避免重复订阅
   */
  private hasRegistered: boolean = false;

  /**
   * 注册时，避免多次调用注册
   */
  private hasStartRegister: boolean = false;

  /**
   * 初始化
   *
   * @param owner 自身want
   */
  init(owner?: Want): void {
    TraceUtil.startTrace(DomainName.SCB, 'NotificationListener');
    try {
      CampaignNotificationFilter.instance.init();

      HaInitManager.instance.init();

      // 加载通知CCM配置
      notificationCcmConfig.init();

      // 初始化通知配置管理
      notificationConfigManager.init(this.getAllNtf);

      // 监听应用锁状态变化
      AppProtectedVm.get().init();

      // 监听通知新增、移除事件，监听免打扰状态切换
      this.registerNotification();

      // 多用户
      this.eventMgr.on(AccountEvent, this.onAccountEvent.bind(this));

      // 删除未安装元服务实况事件
      this.eventMgr.on(NotificationListenerEntryCancelEvent, this.onNotificationListenerEntryCancelEvent);

      // 通知列表生产
      this.eventMgr.produceOn(NotificationEntryEvent, this.onProduceNtfEntryEvent.bind(this));

      // 实况列表生产
      this.eventMgr.produceOn(LiveViewEntryEvent, this.onProduceLiveViewEntryEvent.bind(this));

      // 沉浸锁屏列表生产
      this.eventMgr.produceOn(ImmersiveEntryEvent, this.onProduceImmersiveEntryEvent.bind(this));

      // 监听系统铃声震动模式
      this.initVolumeGroupManager();

      crossModuleCallUtil.register('hasNotification', this.hasNotification);

      // 通知维测事件订阅
      NotificationMaintenanceEvent.instance.subscribeCastConnectState();

      // 智能提醒开关去使能搜索项
      SettingSearchManager.disableSmartReminderSearchItem(GlobalContext.getContext());

      // PC特有搜索项去使能
      SettingSearchManager.handlePCModeSpecialSearchItem(GlobalContext.getContext());

      // 状态栏使能开关动态使能
      SettingSearchManager.enableStatusBarSearchItem(GlobalContext.getContext());

      // 通知协同开关使能监听
      notificationConfigManager.subscribeDistributionChangeEvent(SettingSearchManager.onDistributionButtonChange);

      // 通知中心周期打点初始化
      SystemUIStateEventReporter.get().init();
    } catch (error) {
      log.error('init error', error);
    }

    try {
      this.runMode = systemParameter.getSync(RUN_MODE_KEY, NORMAL_RUN_MODE);
    } catch (error) {
      this.runMode = NORMAL_RUN_MODE;
      log.error(`Get system run mode fail error: ${error}`);
    }
    TraceUtil.endTrace(DomainName.SCB, 'NotificationListener');
  }

  private getAllNtf = (): Set<number> => {
    const allNtfUid: Set<number> = new Set();
    const allNtfList: NotificationEntry[] = [];
    this.getMapNtfList(this.currentUserId, allNtfList);
    this.getMapNtfList(USER_ALL, allNtfList);
    allNtfList.forEach((ntf, hashcode) => {
      allNtfUid.add(ntf.creatorUid);
    });
    return allNtfUid;
  };

  private hasNotification = (uid: number, notificationId: number): boolean => {
    log.showInfo(`hasNotification uid: ${uid},notificationId: ${notificationId}`);
    const listMap = this.allNtfList.get(this.currentUserId);
    let hasNotification = false;
    listMap?.forEach((ntfEntry) => {
      if (ntfEntry?.creatorUid === uid && ntfEntry?.id === notificationId) {
        hasNotification = true;
      }
    });
    return hasNotification;
  };

  private async initVolumeGroupManager(): Promise<void> {
    try {
      RingSettingManager.instance.init();
      this.audioVolumeGroupManager =
        await audio.getAudioManager().getVolumeManager().getVolumeGroupManager(audio.DEFAULT_VOLUME_GROUP_ID);
      if (this.audioVolumeGroupManager) {
        this.onRingModeEventReceived(await this.audioVolumeGroupManager.getRingerMode());
        this.audioVolumeGroupManager?.on('ringerModeChange', (ringerModeChange) => {
          log.showInfo(`onRingerModeChange, ${ringerModeChange}`);
          this.onRingModeEventReceived(ringerModeChange);
        });
      }
    } catch (error) {
      LogWithHa.error(log, `initVolumeGroupManager error, code: ${error?.code}, message: ${error?.message}`,
        NotificationExceptionCode.GET_VOLUME_MANAGER_FAIL, error, 'listener');
    }
  }

  /**
   * 回收
   */
  onDestroy(): void {
    this.eventMgr.offAll();
  }

  private async subscribeNotification(): Promise<boolean> {
    try {
      await Ntf.subscribe(this.ntfSubscribe);
      this.hasRegistered = true;
      log.showInfo('Subscribe notification successful.');
      this.registerLiveViewFreeze();
      return true;
    } catch (error) {
      LogWithHa.warn(log, `Catch subscribe notification error is ${error?.message}`,
        NotificationExceptionCode.SUBSCRIBE_NTF_FAIL, error, 'listener');
      return false;
    }
  }

  /**
   * 注册应用回胶囊事件，冻结通知解析
   */
  private registerLiveViewFreeze(): void {
    InnerEventUtil.on(LiveApp2CapsuleEvent, (event) => {
      if (event.status) {
        this.handleQueue.freeze(TaskQueueFrozenReason.LIVE_APP_2_CAPSULE);
      } else {
        this.handleQueue.unfreeze(TaskQueueFrozenReason.LIVE_APP_2_CAPSULE);
      }
    });
  }

  /**
   * 注册订阅
   */
  async registerNotification(): Promise<void> {
    if (this.hasRegistered) {
      log.info('notification has already registered ntfCallback.');
      return;
    }
    const result = await this.subscribeNotification();
    if (result) {
      return;
    }
    if (this.hasStartRegister) {
      log.showInfo('Subscribe notification has start register.');
      return;
    }
    let timeSecond = 0;
    let retryTime = 1;
    log.showInfo('Subscribe notification retry.');
    this.hasStartRegister = true;
    const intervalId = setInterval(async () => {
      // 避免多调用，异步重复调用
      if (this.hasRegistered) {
        clearInterval(intervalId); // 停止计时器
        log.info(`Notification register stat: ${this.hasRegistered} ${retryTime}`);
        this.hasStartRegister = false;
        return;
      }
      timeSecond++;
      log.showInfo(`Subscribe notification retry: ${retryTime} ${timeSecond}`);
      if (Math.pow(2, retryTime) === timeSecond) {
        retryTime++;
        await this.subscribeNotification();
      }
      if (this.hasRegistered || retryTime > MAX_RETRY_SUBSCRIBE) {
        clearInterval(intervalId); // 停止计时器
        log.info(`Notification register: ${this.hasRegistered} ${retryTime}`);
        this.hasStartRegister = false;
        return;
      }
    }, 1000);
  }

  /**
   * 取消订阅
   */
  unRegisterNotification(): void {
    Ntf.unsubscribe(this.ntfSubscribe).then(() => {
      this.hasRegistered = false;
      this.hasStartRegister = false;
      log.info('notification unRegisterNtfCallback.');
    });
  }

  /**
   * 获取对应通知数据
   *
   * @param hashCode 通知唯一标示
   * @return 通知数据
   */
  getNtfEntry(hashCode: string): NotificationEntry | undefined {
    return this.allNtfList.get(this.currentUserId)?.get(hashCode);
  }

  /**
   * 获取当前用户通知数量
   */
  getCurrentUserNtfCount(): number {
    return this.allNtfList?.get(this.currentUserId)?.size ?? 0;
  }

  /**
   * 获取当前所有通知数量
   */
  getCurrentNtfCount(): number {
    return (this.allNtfList?.get(this.currentUserId)?.size ?? 0) + (this.allNtfList?.get(0)?.size ?? 0);
  }

  /**
   * 获取当前上半区通知数量
   */
  getCurrentMainNtfCount(): number {
    return this.getCurrentNtfCount() - this.getCurrentMoreNtfCount();
  }

  /**
   * 获取当前下半区通知数量
   */
  getCurrentMoreNtfCount(): number {
    let moreNtfCount: number = 0;
    this.allNtfList?.get(this.currentUserId)?.forEach((entry) => {
      if (entry.isExtraContentType()) {
        moreNtfCount++;
      }
    });
    this.allNtfList?.get(0)?.forEach((entry) => {
      if (entry.isExtraContentType()) {
        moreNtfCount++;
      }
    });
    return moreNtfCount;
  }

  private onRingModeEventReceived(ringModeEvent: audio.AudioRingMode): void {
    log.showInfo(`listen ring mode is ${ringModeEvent}`);
    if (ringModeEvent === audio.AudioRingMode.RINGER_MODE_SILENT) {
      this.isSysTonePlayAllow = false;
      this.isSysVibrationAllow = false;
    }
    if (ringModeEvent === audio.AudioRingMode.RINGER_MODE_NORMAL) {
      this.isSysTonePlayAllow = true;
      this.isSysVibrationAllow = true;
    }
    if (ringModeEvent === audio.AudioRingMode.RINGER_MODE_VIBRATE) {
      this.isSysTonePlayAllow = false;
      this.isSysVibrationAllow = true;
    }
    StatisticsMaintenance.get().setRingMode(ringModeEvent);
  }

  /**
   * 多用户切换回调
   *
   * @param event 事件
   */
  private onAccountEvent(event: AccountEvent): void {
    let userId = event?.accountInfo?.localId ?? AccountConstants.INVALID_ID;
    if (this.currentUserId !== userId) {
      this.currentUserId = userId;
      // 用户切换，重新加载通知
      let allList: NotificationEntry[] = [];
      let liveList: NotificationEntry[] = [];
      this.getMapNtfList(userId, allList, liveList);
      log.showInfo(`onAccountEvent, ntfList length is: ${allList.length}`);
      this.postLiveViewEntryEvent(NotificationEntryEvent.EVENT_TYPE_INIT, liveList);
      this.postImmersiveEvent(NotificationEntryEvent.EVENT_TYPE_INIT, allList);
      this.postNtfEntryEvent(NotificationEntryEvent.EVENT_TYPE_INIT, allList);
    }
  }

  /**
   * 通知事件生产者
   * 返回通知初始化列表
   *
   * @return 初始化列表
   */
  private onProduceNtfEntryEvent(): NotificationEntryEvent {
    let allList: NotificationEntry[] = [];
    this.getMapNtfList(this.currentUserId, allList);
    this.getMapNtfList(USER_ALL, allList);
    log.showInfo(`onProduceNtfEntryEvent, ntfList length is: ${allList.length}`);
    return this.createNtfEntryEvent(NotificationEntryEvent.EVENT_TYPE_INIT, allList);
  }

  /**
   * 实况通知事件生产者
   * 返回实况通知初始化列表
   *
   * @returns 初始化列表
   */
  private onProduceLiveViewEntryEvent(): LiveViewEntryEvent {
    let liveList: NotificationEntry[] = [];
    this.getMapNtfList(this.currentUserId, undefined, liveList);
    this.getMapNtfList(USER_ALL, undefined, liveList);
    return this.createLiveViewEntryEvent(NotificationEntryEvent.EVENT_TYPE_INIT, liveList);
  }

  /**
   *沉浸锁屏通知事件生产者
   * 返回沉浸锁屏况通知初始化列表
   *
   * @returns 初始化列表
   */
  private onProduceImmersiveEntryEvent(): ImmersiveEntryEvent {
    let liveList: NotificationEntry[] = [];
    this.getMapNtfList(this.currentUserId, undefined, liveList);
    this.getMapNtfList(USER_ALL, undefined, liveList);
    return this.createImmersiveEntryEvent(NotificationEntryEvent.EVENT_TYPE_INIT, liveList);
  }

  /**
   * 发送通知事件
   *
   * @param eventType 事件类型
   * @param ntfList 通知集
   */
  private postNtfEntryEvent(eventType: number, ntfList: NotificationEntry[]): void {
    // 非初始化场景，无数据则无需发送事件
    if (eventType !== NotificationEntryEvent.EVENT_TYPE_INIT && ArrayUtils.isEmpty(ntfList)) {
      log.showWarn('postNtfEntryEvent fail: empty data');
      return;
    }
    let event = this.createNtfEntryEvent(eventType, ntfList);
    if (CommonUtils.isInvalid(event)) {
      log.showWarn('postNtfEntryEvent fail: data invalid');
      return;
    }

    EvtBus.post(NotificationEntryEvent, event);
    log.showInfo(`postNtfEntryEvent: ${eventType}, ${ntfList?.length}`);
  }

  /**
   * 创建通知事件
   *
   * @param eventType 事件类型
   * @param ntfList 通知集
   */
  private createNtfEntryEvent(eventType: number, ntfList: NotificationEntry[]): NotificationEntryEvent {
    let event = new NotificationEntryEvent();
    event.eventType = eventType;
    event.notificationList = ArrayUtils.isEmpty(ntfList) ? [] : ntfList;
    return event;
  }

  /**
   * 发送实况通知事件
   *
   * @param eventType 事件类型
   * @param ntfList 通知集
   */
  private postLiveViewEntryEvent(eventType: number, ntfList: Array<BaseNotification>): void {
    // 非初始化场景，无数据则无需发送事件
    if (eventType !== NotificationEntryEvent.EVENT_TYPE_INIT && ArrayUtils.isEmpty(ntfList)) {
      log.showWarn('postLiveViewEntryEvent fail: empty data');
      return;
    }
    let event = this.createLiveViewEntryEvent(eventType, ntfList);
    if (CommonUtils.isInvalid(event)) {
      log.showWarn('postLiveViewEntryEvent fail: data invalid');
      return;
    }
    EvtBus.post(LiveViewEntryEvent, event);
    log.showInfo(`postLiveViewEntryEvent: ${eventType}, ${ntfList?.length}`);
  }

  /**
   * 创建实况通知事件
   *
   * @param eventType 事件类型
   * @param ntfList 通知集
   */
  private createLiveViewEntryEvent(eventType: number, ntfList: Array<BaseNotification>): LiveViewEntryEvent {
    let event = new LiveViewEntryEvent();
    event.eventType = eventType;
    event.liveViewList = ArrayUtils.isEmpty(ntfList) ? [] : ntfList;
    return event;
  }

  /**
   * 发送沉浸锁屏通知事件
   * 沉浸锁屏通知事件必须在普通通知事件之前发送
   *
   * @param eventType 事件类型
   * @param ntfList 通知集
   */
  private postImmersiveEvent(eventType: NtfEventType, ntfList: Array<BaseNotification>): void {
    // 非初始化场景，无数据则无需发送事件
    if (eventType !== NotificationEntryEvent.EVENT_TYPE_INIT && ArrayUtils.isEmpty(ntfList)) {
      log.showWarn('postImmersiveEvent: postData is empty');
      return;
    }
    let event = this.createImmersiveEntryEvent(eventType, ntfList);
    if (CommonUtils.isInvalid(event)) {
      log.showWarn('postImmersiveEvent: postData is invalid');
      return;
    }
    EvtBus.post(ImmersiveEntryEvent, event);
    log.showInfo(`postImmersiveEvent: ${eventType}, ${ntfList?.length}`);
  }

  /**
   * 创建沉浸锁屏通知事件
   *
   * @param eventType 事件类型
   * @param ntfList 通知集
   */
  private createImmersiveEntryEvent(eventType: NtfEventType, ntfList: Array<BaseNotification>):
    ImmersiveEntryEvent {
    let event = new ImmersiveEntryEvent();
    event.eventType = eventType;
    event.notificationList = ArrayUtils.isEmpty(ntfList) ? [] : ntfList;
    return event;
  }

  /**
   * 获取缓存Map中指定user下的通知数据集
   *
   * @param userId 指定user
   * @param allList 全量通知数据集
   * @param liveList 实况通知数据集
   */
  private getMapNtfList(userId: number, allList?: NotificationEntry[], liveList?: NotificationEntry[]): void {
    let listMap = this.allNtfList.get(userId);
    if (ArrayUtils.isEmpty(listMap)) {
      return;
    }
    listMap?.forEach((ntfEntry) => {
      allList?.push(ntfEntry);

      // 实况数据
      this.addLiveNtfToList(ntfEntry, liveList);
    });
  }

  /**
   * 添加实况通知
   *
   * @param entry 通知数据
   * @param liveList 实况列表
   */
  private addLiveNtfToList(entry?: NotificationEntry, liveList?: Array<NotificationEntry | undefined>): void {
    if (entry?.isLiveType()) {
      liveList?.push(entry);
    }
  }

  /**
   * 获取新增、更新类型
   *
   * @param isUpdate 是否更新
   * @returns 事件类型
   */
  private getAddOrUpdateType(isUpdate: boolean): number {
    return isUpdate ? NotificationEntryEvent.EVENT_TYPE_POST_UPDATE : NotificationEntryEvent.EVENT_TYPE_POST_ADD;
  }

  /**
   * 单个通知集
   *
   * @param ntfEntry 通知数据
   * @return 通知集
   */
  private getSingleNtfList(ntfEntry: NotificationEntry): NotificationEntry[] | undefined {
    if (CommonUtils.isInvalid(ntfEntry)) {
      return undefined;
    }
    let result: NotificationEntry[] = [];
    result.push(ntfEntry);
    return result;
  }

  /**
   * 创建通知数据
   *
   * @param postData 原数据
   * @return 通知数据
   */
  private async createNtfEntry(postData: Ntf.SubscribeCallbackData): Promise<NotificationEntry | undefined> {
    if (CommonUtils.isInvalid(postData)) {
      new ParseNotificationMaintenance(false).reportParseFailed(postData?.request, new Error('post data invalid'),
        this.currentUserId);
      return undefined;
    }

    log.showInfo(`createNtfEntry userId: ${postData.request.creatorUserId}, hashCode: ${postData.request.hashCode}`);
    const oldEntry = this.getOldEntry(postData.request.creatorUserId ?? 0, postData.request.hashCode ?? '');
    const needUpdate = this.needParseNewEntry(postData.request, oldEntry);
    const baseNotification = await NotificationParserFactory.parse(postData, needUpdate);
    if (CommonUtils.isInvalid(baseNotification?.creatorUserId)) {
      LogWithHa.warn(log, `parse ntf invalid user id, ${baseNotification?.hashCode}`, NotificationExceptionCode.PARSE_NTF_FAILED);
      return undefined;
    }

    if (!needUpdate && baseNotification) { // 无需解析时直接取用以前的通知信息内容作为新通知信息内容
      baseNotification.appLabel = oldEntry?.appLabel ?? '';
      baseNotification.appIcon = oldEntry?.appIcon;
      baseNotification.appIndex = oldEntry?.appIndex ?? 0;
      baseNotification.isDisplayAtTop = oldEntry?.isDisplayAtTop ?? false;
      baseNotification.isFromSystemApp = oldEntry?.isFromSystemApp;
      baseNotification.isSettingIgnore = oldEntry?.isSettingIgnore ?? false;
      if (oldEntry?.creatorType) {
        baseNotification.creatorType = oldEntry?.creatorType;
      }
      baseNotification.cloneLabelRes = oldEntry?.cloneLabelRes;
      baseNotification.groupName = oldEntry?.groupName ?? '';
    }
    this.setHeadsUpStick(postData.request, baseNotification);
    const entry = new NotificationEntry(baseNotification);
    this.setOtherLiveHeadsUp(entry);
    new ParseNotificationMaintenance(Boolean(oldEntry)).init(entry, postData.request).report();
    return entry;
  }

  private setOtherLiveHeadsUp(entry: NotificationEntry): void {
    if (!entry.isLiveType()) {
      log.showInfo(`nft is not live no need handle`);
      return;
    }
    if (entry.liveViewData?.liveType === LiveType.INVALID || entry.liveViewData?.liveType === LiveType.TYPE_SYSTEM) {
      return;
    }
    if (entry.deliveryTime && (Date.now() - entry.deliveryTime) > SystemuiConstants.LIVE_TIME_DIFF) {
      log.showInfo(`no need show banner, date now ${Date.now()}, live deliveryTime ${entry.deliveryTime}`);
      entry.isShowHeadsUp = false;
    }
  }

  private getOldEntry(creatorUserId: number, hashCode: string): NotificationEntry | undefined {
    return this.allNtfList.get(creatorUserId)?.get(hashCode);
  }

  private needParseNewEntry(request: NtfMgr.NotificationRequest,
                            oldEntry: NotificationEntry | undefined): boolean {
    if (!oldEntry) {
      log.info('oldEnrty is null, need parse.');
      if (request.content.liveView?.extraInfo) {
        log.info('oldEnrty is null, extraInfo exist.');
        // oldEntry不存在时，为消息创建或重启进程恢复场景，将extraInfo.ExtraInfoUpdateKey置为undefined，后面parse所有extraInfo值
        request.content.liveView.extraInfo.ExtraInfoUpdateKey = undefined as ESObject;
      }
      return true;
    }

    // 若新通知中含有sound、extraInfo字段，则必须要更新。
    if (request.sound) {
      log.showInfo('has sound, need parse.');
      return true;
    }
    if (request.content.liveView?.extraInfo) {
      log.showInfo('has extraInfo, need parse.');
      return true;
    }

    if (!ArrayUtils.isEmpty(request.content.systemLiveView?.button?.iconsResource)) {
      log.showInfo(`has icon res, need parse`);
      return true;
    }

    // 若hashCode相同，则creatorUserId、creatorBundleName、creatorUid都相同，无需再次判断
    if (request.agentBundle === oldEntry.agentBundle) {
      log.showInfo('params are same with the oldEntry, no need parse.');
      return false;
    }

    return true;
  }

  /**
   * 缓存通知数据
   *
   * @param ntfEntry 通知数据
   * @return true更新数据，false新增数据
   */
  private saveNtfEntry(ntfEntry?: NotificationEntry): boolean {
    let listMap = this.allNtfList.get(ntfEntry?.creatorUserId ?? 0);
    if (CommonUtils.isInvalid(listMap)) {
      listMap = new Map();
      this.allNtfList.set(ntfEntry?.creatorUserId ?? 0, listMap);
    }
    let oldEntry = listMap?.get(ntfEntry?.hashCode ?? '');
    let isUpdate = !CommonUtils.isInvalid(oldEntry);
    if (isUpdate) {
      ntfEntry?.updateDataWhenUpdate(oldEntry);
      this.cancelOldWantAgent(ntfEntry, oldEntry);
    }
    log.showInfo(`saveNtfEntry cache: ${ntfEntry?.creatorUserId} ${ntfEntry?.hashCode}`);
    if (ntfEntry?.hashCode) {
      listMap?.set(ntfEntry.hashCode, ntfEntry);
    }
    return isUpdate;
  }

  /**
   * push通知更新时，旧通知的wantAgent就不用了。如果旧通知的wantAgent与新通知不一致，需要业务层主动删除，为底层wantAgent兜底，避免wantAgent积压导致内存泄露
   * @param newEntry 新通知
   * @param oldEntry 被更新的旧通知
   */
  private cancelOldWantAgent(newEntry?: NotificationEntry, oldEntry?: NotificationEntry): void {
    log.showInfo(`updating notification, cancel wantAgent for oldEntry:${oldEntry?.hashCode}`);
    const oldWantAgents = this.collectWantAgent(oldEntry);
    const newWantAgents = this.collectWantAgent(newEntry);
    oldWantAgents.forEach((oldAgent) => this.cancelIfNotExistInNewEntry(oldAgent, newWantAgents));
  }

  private collectWantAgent(entry?: NotificationEntry): WantAgent[] {
    const wantAgents: WantAgent[] = [];
    if (entry?.wantAgent) {
      wantAgents.push(entry?.wantAgent);
    }
    if (entry?.removalWantAgent) {
      wantAgents.push(entry?.removalWantAgent);
    }
    for (const button of entry?.actionButtons ?? []) {
      if (button.wantAgent) {
        wantAgents.push(button.wantAgent);
      }
    }
    return wantAgents;
  }

  private async cancelIfNotExistInNewEntry(oldAgent: WantAgent, wantAgents: WantAgent[]): Promise<void> {
    try {
      for (const agent of wantAgents) {
        const isExist = await wantAgent.equal(agent, oldAgent);
        if (isExist) {
          return;
        }
      }
    } catch (err) {
      log.showError('compare wantAgent err, stop do cancel. code:%{public}d, msg:%{public}s', err?.code, err?.message);
      return;
    }

    setTimeout(() => {
      this.doCancel(oldAgent);
    }, 1000);
  }

  private doCancel(agent: WantAgent): void {
    try {
      wantAgent.cancel(agent, (err, res) => {
        if (err) {
          log.showError('cancel wantAgent err, code:%{public}d, msg:%{public}s', err?.code, err?.message);
        }
      });
    } catch (err) {
      log.showError('do cancel wantAgent err, code:%{public}d, msg:%{public}s', err?.code, err?.message);
    }
  }

  /**
   * 通知监听器连接回调
   */
  private async onListenerConnect(task: TaskItem): Promise<void> {
    try {
      // 获取全量通知
      const ntfRequestList = await NtfMgr.getAllActiveNotifications();
      if (ArrayUtils.isEmpty(ntfRequestList)) {
        return;
      }
      log.showInfo('onListenerConnect init ntf, length: ' + ntfRequestList.length);
      await this.createAndPostNtf(ntfRequestList, task);
    } catch (error) {
      LogWithHa.error(log, `getAllActiveNotifications error: ${error}`,
        NotificationExceptionCode.GET_ALL_NTF_FAIL, error, 'listener');
    }
  }

  private async createAndPostNtf(ntfRequestList: Array<notificationManager.NotificationRequest>,
    task: TaskItem): Promise<void> {
    let addList: NotificationEntry[] = [];
    let updateList: NotificationEntry[] = [];
    let liveAddList: NotificationEntry[] = [];
    let liveUpdateList: NotificationEntry[] = [];
    const ntfEntryList: NotificationEntry[] = [];
    for (const request of ntfRequestList) {
      if (!CampaignNotificationFilter.instance.filter(request)) {
        return;
      }
      if (!this.canInitEntry(request)) {
        continue;
      }
      let ntfEntry = await this.createNtfEntry({
        request: request,
        sortingMap: await NotificationUtil.getSortingMap(request),
      });
      if (!ntfEntry) {
        continue;
      }
      // 有的通知在进程启动恢复通知时（在subscribe ANS后会触发 onConsume）已经处理过了，不再重复添加
      if (this.isContainNtf(ntfEntry)) {
        log.showInfo(`Ntf is inited before: ${ntfEntry?.toSimpleString()}`);
        continue;
      }
      if (task.isTimeout) {
        LogWithHa.error(log, `onConnect init timeout`, NotificationExceptionCode.INIT_NTF_FAIL);
        return;
      }
      ntfEntryList.push(ntfEntry);
    }
    ntfEntryList.forEach(entry => {
      const isUpdate = this.saveNtfEntry(entry);
      if (isUpdate) {
        updateList.push(entry);
        this.addLiveNtfToList(entry, liveUpdateList);
      } else {
        addList.push(entry);
        this.addLiveNtfToList(entry, liveAddList);
      }
    });
    this.postEvent(addList, updateList, liveAddList, liveUpdateList);
    this.handleNtfLimit();
  }

  private canInitEntry(request: NtfMgr.NotificationRequest): boolean {
    if (request?.creatorUserId !== this.currentUserId && request?.creatorUserId !== 0) {
      log.showInfo('Notification Dropped due to different UserId ' + request?.creatorBundleName + '. creatorUserId: ' + request?.creatorUserId + ' currentUserId: ' + this.currentUserId);
      return false;
    }
    return true;
  }

  private handleNtfLimit(): void {
    if (this.currentUserId === undefined) {
      return;
    }
    let deleteItems: NotificationEntry[] =
      this.ntfListLimiter.limit([this.allNtfList.get(this.currentUserId) ?? new Map(),
        this.allNtfList.get(USER_ALL) ?? new Map()]);
    log.showInfo(`deleteItems length: ${deleteItems.length}`);
    if (!ArrayUtils.isEmpty(deleteItems)) {
      deleteItems.forEach((entry: NotificationEntry) => {
        log.showInfo(`deleteItem: ${entry.hashCode}`);
        HiDfxEventUtil.reportDeleteNtfOverLimit(entry.creatorBundleName, entry.id, entry.hashCode);
      });

      // 系统移除
      NotificationManager.batchRemoveNtf(deleteItems);
      this.postNtfEntryEvent(NotificationEntryEvent.EVENT_TYPE_POST_CANCEL, deleteItems);
    }
  }

  /**
   * 通知监听器断开连接回调
   */
  private onListenerDisconnect(): void {
    log.showInfo('onListenerDisconnect');
  }

  /**
   * 通知监听器销毁回调
   */
  private onListenerDestroy(): void {
    log.showInfo('onListenerDestroy');
  }

  private getSubscribeMetaInfo(postData: Ntf.SubscribeCallbackData): string {
    const req = postData.request;
    if (req == null) {
      return 'Empty request.';
    } else {
      return `hashCode: ${req.hashCode}, notificationFlags: ${req.notificationFlags?.reminderFlags}`;
    }
  }

  private getHandleId(): number {
    if (this.handleId === Number.MAX_SAFE_INTEGER) {
      this.handleId = 0;
    }
    return this.handleId++;
  }

  /**
   * 接收通知回调
   *
   * @param postData 通知数据
   */
  private async onNotificationPost(postData: Ntf.SubscribeCallbackData, task: TaskItem, times: number): Promise<void> {
    try {
      if (CommonUtils.isInvalid(postData) || CommonUtils.isInvalid(postData?.request)) {
        LogWithHa.warn(log, 'onNotificationPost has not data', NotificationExceptionCode.NO_POST_DATA);
        return;
      }
      if (DeviceHelper.isPC() && postData.request.notificationSlotType === NtfMgr.SlotType.LIVE_VIEW &&
        postData.request.agentBundle?.uid !== RSS_LIVE_TYPE_UID) {
        log.showInfo('PC is not support live view!');
        return;
      }
      let request: notificationManager.NotificationRequest = postData.request;
      if (request.creatorUserId !== this.currentUserId && request.creatorUserId !== 0) {
        log.showWarn('onNotificationPost Dropped a Ntf due to different UserId ' + request.creatorBundleName +
          ': creatorUserId: ' + request.creatorUserId + ' currentUserId: ' + this.currentUserId);
        new ParseNotificationMaintenance(false).reportParseFailed(postData.request, new Error('uerId not match'),
          this.currentUserId);
        return;
      }
      if (this.runMode === FACTORY_RUN_MODE) {
        log.showWarn('DFM factory mode disabled notification message');
        new ParseNotificationMaintenance(false).reportParseFailed(postData.request, new Error('DFM factory mode'),
          this.currentUserId);
        return;
      }
      if (!CampaignNotificationFilter.instance.filter(request)) {
        return;
      }
      log.showInfo('OnNotificationPost. postData: [%{public}s]', this.getSubscribeMetaInfo(postData));
      TraceUtil.startTrace(DomainName.SYS_UI, `onNotificationPost:${request.hashCode}`);
      const handleId = this.getHandleId();
      this.handleNotificationMap.set(request.hashCode ?? '', handleId);
      let ntfEntry = await this.createNtfEntry(postData);
      if (this.handleNotificationMap.get(request.hashCode ?? '') !== handleId) {
        LogWithHa.warn(log, `Notification is updated or canceled: ${request.hashCode}, handleId: ${handleId}`,
          NotificationExceptionCode.HANDLE_ID_NOT_MATCH);
        return;
      }
      this.handleNotificationMap.delete(request.hashCode ?? '');
      if (!ntfEntry) {
        log.showWarn('onNotificationPost create entry fail');
        return;
      }
      if (task.isTimeout || times !== task.currentTimes) {
        // 整体超时会打点解析失败详细信息，这里记录日志上报
        LogWithHa.warn(log, `Notification ${postData.request.hashCode} is timeout, consume times ${times}, task time ${task.currentTimes}`,
          NotificationExceptionCode.PARSE_NTF_TIMEOUT);
        return;
      }
      this.handlePostAfterCreate(ntfEntry, request);
      SystemUIStateEventReporter.get().updateNtfNum(this.getCurrentNtfCount());
      TraceUtil.endTrace(DomainName.SYS_UI, `onNotificationPost:${request.hashCode}`);
    } catch (err) {
      new ParseNotificationMaintenance(false).reportParseFailed(postData?.request, err, this.currentUserId);
      log.showError(`onNotificationPost handle failed, err: ${err}`);
    }
  }

  private handlePostAfterCreate(ntfEntry: NotificationEntry, request: notificationManager.NotificationRequest): void {
    this.playAudio(ntfEntry, request.sound);
    let isUpdate = this.saveNtfEntry(ntfEntry);
    log.showInfo(`onNotificationPost isUpdate: ${isUpdate}, isDisplayAtTop: ${ntfEntry.isDisplayAtTop}`);
    let addList: NotificationEntry[] = [];
    let updateList: NotificationEntry[] = [];
    let liveAddList: NotificationEntry[] = [];
    let liveUpdateList: NotificationEntry[] = [];
    if (isUpdate) {
      updateList.push(ntfEntry);
      if (ntfEntry?.isLiveType()) {
        liveUpdateList.push(ntfEntry);
      }
    } else {
      addList.push(ntfEntry);
      if (ntfEntry?.isLiveType()) {
        liveAddList.push(ntfEntry);
      }
    }
    this.postEvent(addList, updateList, liveAddList, liveUpdateList);
    // 通知总数限制检测，可滞后
    setTimeout(() => this.checkLimit());
  }

  private postEvent(addList: NotificationEntry[],
    updateList: NotificationEntry[], liveAddList: NotificationEntry[],
    liveUpdateList: NotificationEntry[]): void {
    if (!ArrayUtils.isEmpty(liveAddList)) {
      this.postLiveViewEntryEvent(NotificationEntryEvent.EVENT_TYPE_POST_ADD, liveAddList);
    }
    if (!ArrayUtils.isEmpty(liveUpdateList)) {
      this.postLiveViewEntryEvent(NotificationEntryEvent.EVENT_TYPE_POST_UPDATE, liveUpdateList);
    }
    if (!ArrayUtils.isEmpty(addList)) {
      this.postImmersiveEvent(NotificationEntryEvent.EVENT_TYPE_POST_ADD, addList);
      this.postNtfEntryEvent(NotificationEntryEvent.EVENT_TYPE_POST_ADD, addList);
    }
    if (!ArrayUtils.isEmpty(updateList)) {
      this.postImmersiveEvent(NotificationEntryEvent.EVENT_TYPE_POST_UPDATE, updateList);
      this.postNtfEntryEvent(NotificationEntryEvent.EVENT_TYPE_POST_UPDATE, updateList);
    }
  }

  private async playAudio(ntfEntry: NotificationEntry, sound?: string): Promise<void> {
    if (!EmergencyThermalSafeManager.instance.isShowNotification(ntfEntry?.creatorBundleName)) {
      return;
    }
    const isNewNtf = !this.isContainNtf(ntfEntry);
    const isNormalCanAlert: boolean = (isNewNtf || !ntfEntry?.isAlertOnce) && !ntfEntry?.isLiveType(); // 普通通知是否提醒
    // 全场景协同 从remindConfig读取
    const isLiveCanAlert: boolean =
      ntfEntry?.isLiveType() && ntfEntry.remindConfig.isSoundEnable() && ntfEntry.remindConfig.isVibrationEnable();
    // 普通的通知更新需要打断当前铃声播放
    if (!isNewNtf && !ntfEntry?.isLiveType()) {
      log.showWarn('start stop player due to notification update.');
      RemindPlayManager.instance.stop(StopReason.NOTIFICATION_UPDATE, [{
        hashCode: ntfEntry.hashCode,
        bundleName: ntfEntry.creatorBundleName,
        appIndex: ntfEntry.appIndex,
        classification: ntfEntry.classification
      }]);
    }
    // MissCall消息打断
    if (ntfEntry?.classification === Classification.MISS_CALL) {
      log.showWarn('try stop player due to MissCall.');
      RemindPlayManager.instance.stop(StopReason.MISS_CALL, [{
        bundleName: ntfEntry.creatorBundleName,
        classification: ntfEntry.classification,
        appIndex: ntfEntry.appIndex
      }]);
    }
    if (!(isNormalCanAlert || isLiveCanAlert)) {
      log.showWarn('do not need to playAudio, neither NormalNewNtf nor LiveVoiceNtf');
      return;
    }
    // 通知更新和实况通知mute场景下，不会有铃声和振动
    if (DeviceHelper.isPC()) {
      this.handlePcPlayAudio(ntfEntry);
    } else {
      this.handleNonPcPlayAudio(ntfEntry, sound);
    }
  }

  private handlePcPlayAudio(ntfEntry: NotificationEntry): void {
    if (this.isSysTonePlayAllow && ntfEntry.isSoundEnable) {
      const isNotificationSoundEnabled = sSettingsUtil.getSystemValue(SettingsKeyConstants.NOTIFICATION_TONE_ENABLE,
        SettingsConstants.SWITCH_OPEN.toString());
      log.showInfo(`notification sound enabled: ${isNotificationSoundEnabled}`);
      const bannerNotDisturb = sSettingsUtil.getSystemValue(SettingsKeyConstants.BANNER_NO_DISTURB, 'false') === 'true';
      if (isNotificationSoundEnabled === SettingsConstants.SWITCH_OPEN.toString() && !bannerNotDisturb) {
        // PC设置-声音页面已支持铃声选择&&未开启横幅通知免打扰
        AudioUtil.playToneAndVibration({
          isAudioMute: false,
          isHapticsMute: true,
          systemToneType: systemSoundManager.SystemToneType.SYSTEM_TONE_TYPE_NOTIFICATION,
        });
      }
    }
  }

  private handleNonPcPlayAudio(ntfEntry: NotificationEntry, sound?: string, isWeak?: boolean): void {
    let isTonePlayAllow: boolean = false;
    let isVibrationAllow: boolean = false;
    if (ntfEntry.isLiveType()) {
      isTonePlayAllow = this.isSysTonePlayAllow;
      isVibrationAllow = this.isSysVibrationAllow;
    } else {
      isTonePlayAllow = ntfEntry.isSoundEnable && this.isSysTonePlayAllow;
      isVibrationAllow = ntfEntry.isVibrationEnable && this.isSysVibrationAllow;
    }
    const context: common.Context = GlobalContext.getContext();
    RemindPlayManager.instance.play({
      context,
      isTonePlayAllow,
      isVibrationAllow,
      soundDescriptor: ntfEntry?.soundDescriptor,
      sound: sound,
      systemToneType: ntfEntry.systemToneType,
      bundleName: ntfEntry.creatorBundleName,
      slotType: ntfEntry.slotType,
      ntfId: ntfEntry.id,
      creatorUid: ntfEntry.creatorUid,
      hashCode: ntfEntry?.hashCode,
      isWeak: isWeak,
      isCustomVibration: ntfEntry.controlConfig.isCustomVibration(),
      isNtfTonePlayAllow: ntfEntry.isSoundEnable,
      soundDuration: ntfEntry.soundDuration,
      isSysTonePlayAllow: this.isSysTonePlayAllow,
      channelId: ntfEntry.channelId,
      appIndex: ntfEntry.appIndex,
    }, ntfEntry.classification ?? '');
  }

  /**
   * 检测通知个数
   *
   * @param ntfEntry 通知数据
   */
  private checkLimit(): void {
    if (this.currentUserId === undefined) {
      return;
    }
    // 将要删除的普通通知和实况通知
    let deleteItems: NotificationEntry[] =
      this.ntfListLimiter.limit([this.allNtfList.get(this.currentUserId) ?? new Map(),
        this.allNtfList.get(USER_ALL) ?? new Map()]);
    let delLiveItems: NotificationEntry[] = [];
    log.showInfo('checkLimit deleteItems length:' + deleteItems.length);
    if (!ArrayUtils.isEmpty(deleteItems)) {
      deleteItems.forEach((entry: NotificationEntry) => {
        log.showInfo(`checkLimit deleteItem: ${entry.hashCode}, isLiveType: ${entry.isLiveType()}`);
        HiDfxEventUtil.reportDeleteNtfOverLimit(entry.creatorBundleName, entry.id, entry.hashCode);
        if (entry.isLiveType()) {
          delLiveItems.push(entry);
        }
      });
      let eventCancel = NotificationEntryEvent.EVENT_TYPE_POST_CANCEL;

      // 系统移除
      DeleteNotificationMaintenance.addNtfMap(deleteItems, DeleteNotificationType.EXCEED_MAX_NUMBER_DELETE, false);
      NotificationManager.batchRemoveNtf(deleteItems);
      this.postLiveViewEntryEvent(eventCancel, delLiveItems);
      this.postNtfEntryEvent(eventCancel, deleteItems);
    }
  }

  /**
   * 原有通知里面是否包含新通知
   *
   * @param newEntry 新通知
   */
  private isContainNtf(newEntry?: NotificationEntry): boolean {
    if (ArrayUtils.isEmpty(this.allNtfList)) {
      log.showInfo('isContainNtf allNtfList is empty');
      return false;
    }
    let listMap = this.allNtfList.get(newEntry?.creatorUserId ?? 0);
    if (CommonUtils.isInvalid(listMap) || ArrayUtils.isEmpty(listMap)) {
      log.showInfo('isContainNtf listMap isInvalid');
      return false;
    }
    let isContain: boolean = false;
    // 遍历当前显示的所有通知
    listMap?.forEach((entry) => {
      if (!entry) {
        return;
      }
      if (entry.isGroup) {
        // 组通知检查其中子通知
        let children = entry.childrenEntry;
        children?.forEach((child) => {
          if (child?.hashCode === newEntry?.hashCode) {
            isContain = true;
            return;
          }
        });
      } else if (entry.hashCode === newEntry?.hashCode) {
        isContain = true;
        return;
      }
    });
    return isContain;
  }

  /**
   * 多条通知删除回调
   *
   * @param cancelData 通知数据列表
   */
  public onNotificationBatchCancel(cancelData: Array<Ntf.SubscribeCallbackData>): void {
    log.showInfo('do onNotificationBatchCancel');
    if (CommonUtils.isInvalid(cancelData)) {
      log.showInfo('onNotificationBatchCancel has not data');
      return;
    }
    let delList: NotificationEntry[] = [];
    let delLiveList: NotificationEntry[] = [];
    cancelData.forEach((callbackData: Ntf.SubscribeCallbackData) => {
      this.cancelData(callbackData, delList, delLiveList);
    });
    // 发送删除通知事件
    let eventType = NotificationEntryEvent.EVENT_TYPE_POST_CANCEL;
    // 发送实况删除事件
    this.postLiveViewEntryEvent(eventType, delLiveList);
    this.postImmersiveEvent(eventType, delList);
    this.postNtfEntryEvent(eventType, delList);
    SystemUIStateEventReporter.get().updateNtfNum(this.getCurrentNtfCount());
  }

  private cancelData(callbackData: Ntf.SubscribeCallbackData,
    delList: NotificationEntry[], delLiveList: NotificationEntry[]): void {
    let id = callbackData.request?.id ?? 0;
    let hashCode = callbackData.request?.hashCode ?? '';
    let userId = callbackData.request?.creatorUserId ?? 0;
    let bundle = callbackData.request?.creatorBundleName ?? '';
    let listMap = this.allNtfList.get(userId);
    if (this.handleNotificationMap.has(hashCode)) {
      this.handleNotificationMap.delete(hashCode);
    }
    let ntfEntry: NotificationEntry | undefined = undefined;
    if (ArrayUtils.isEmpty(listMap) || !listMap) {
      log.showInfo('onNotificationBatchCancel user no data: %{public}d, %{public}s, %{public}s, %{public}d', userId, hashCode, bundle, id);
    } else {
      ntfEntry = listMap.get(hashCode);
      listMap.delete(hashCode);
    }
    if (CommonUtils.isInvalid(ntfEntry) || !ntfEntry) {
      log.showInfo('onNotificationBatchCancel has not ntf: %{public}d, %{public}s, %{public}s, %{public}d', userId, hashCode, bundle, id);
      ntfEntry = this.buildDeleteEntry(callbackData?.request);
    }
    if (ntfEntry?.isLiveType()) {
      delLiveList.push(ntfEntry);
    }
    delList.push(ntfEntry);
    let reason = callbackData.reason;
    ntfEntry.reason = reason ?? 0;
    log.showInfo('onNotificationBatchCancel cancel ntf: %{public}d, %{public}s, %{public}s, %{public}d, %{public}d',
      userId, hashCode, bundle, id, reason);
    NotificationApiUtil.appDeadNtfCancelHandle(bundle, reason);
  }

  /**
   * 单条通知删除回调
   *
   * @param cancelData 通知数据
   */
  private onNotificationCancel(cancelData: Ntf.SubscribeCallbackData): void {
    log.showInfo('do onNotificationCancel');
    if (CommonUtils.isInvalid(cancelData)) {
      log.showInfo('onNotificationCancel has not data');
      return;
    }
    let id = cancelData.request?.id ?? 0;
    let hashCode = cancelData.request?.hashCode ?? '';
    let userId = cancelData.request?.creatorUserId ?? 0;
    let bundle = cancelData.request?.creatorBundleName ?? '';
    let listMap = this.allNtfList.get(userId);
    if (this.handleNotificationMap.has(hashCode)) {
      this.handleNotificationMap.delete(hashCode);
    }
    let ntfEntry: NotificationEntry | undefined = undefined;
    if (ArrayUtils.isEmpty(listMap) || !listMap) {
      log.showInfo(`onNotificationCancel user no data: ${userId}, ${hashCode}, ${bundle}, ${id}`);
    } else {
      ntfEntry = listMap.get(hashCode);
      listMap.delete(hashCode);
    }
    if (CommonUtils.isInvalid(ntfEntry) || !ntfEntry) {
      log.showInfo(`onNotificationCancel has not ntf: ${userId}, ${hashCode}, ${bundle}, ${id}`);
      ntfEntry = this.buildDeleteEntry(cancelData?.request);
    }
    let reason = cancelData.reason;
    if (ntfEntry) {
      ntfEntry.reason = reason;
    }
    log.showInfo(`onNotificationCancel cancel ntf: ${userId}, ${hashCode}, ${bundle}, ${id}, ${reason}`);
    NotificationApiUtil.appDeadNtfCancelHandle(bundle, reason);

    // 发送删除通知事件
    let eventType = NotificationEntryEvent.EVENT_TYPE_POST_CANCEL;
    let delList = this.getSingleNtfList(ntfEntry);

    // 发送实况删除事件
    if (ntfEntry?.isLiveType()) {
      this.postLiveViewEntryEvent(eventType, delList ?? []);
    }
    this.postImmersiveEvent(eventType, delList ?? []);
    this.postNtfEntryEvent(eventType, delList ?? []);
    SystemUIStateEventReporter.get().updateNtfNum(this.getCurrentNtfCount());
  }

  private buildDeleteEntry(data: NtfMgr.NotificationRequest | undefined): NotificationEntry {
    let ntfEntry = new NotificationEntry();
    ntfEntry.id = data?.id ?? 0;
    ntfEntry.hashCode = data?.hashCode ?? '';
    ntfEntry.creatorUserId = data?.creatorUserId ?? 0;
    ntfEntry.creatorBundleName = data?.creatorBundleName ?? '';
    ntfEntry.slotType = data?.notificationSlotType ?? notificationManager.SlotType.UNKNOWN_TYPE;
    return ntfEntry;
  }

  private setHeadsUpStick(request: notificationManager.NotificationRequest, baseNotification?: BaseNotification): void {
    if (baseNotification) {
      baseNotification.isHeadsUpStick =
        (request.extraInfo?.openharmony_keep_headsup_sticky === true && baseNotification.isFromSystemApp) ?? false;
    }
  }


  private onNotificationListenerEntryCancelEvent = (event: NotificationListenerEntryCancelEvent): void => {
    const hashCode = event.hashCode;
    const userId = event.userId ?? this.currentUserId;
    const ntfEntry = this.allNtfList.get(userId)?.get(hashCode);
    if (ntfEntry) {
      NotificationManager.removeNotificationByCancel(ntfEntry)
    } else {
      log.showWarn('get ntfEntry is failed');
    }
  }
}

// 单例
export let ntfListener: NotificationListener = SingletonHelper.getInstance(NotificationListener, TAG);