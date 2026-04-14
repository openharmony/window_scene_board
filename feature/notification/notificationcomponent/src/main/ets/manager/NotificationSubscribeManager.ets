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

import notificationSubscribe from '@ohos.notificationSubscribe';
import notificationManager from '@ohos.notificationManager';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import {
  LogDomain,
  LogHelper,
  SingletonHelper,
} from '@ohos/basicutils';
import { ConfigurationEvent, GlobalContext, HiDfxEventUtil } from '@ohos/frameworkwrapper';
import {
  DeleteNotificationMaintenance,
  DeleteNotificationType,
  LiveOtherExtendData,
  NotificationConfigEntity,
  NotificationConfigEvent,
  NotificationConfigEventType,
  NotificationConfigPinTopEvent,
  NotificationCreatorType,
  ResourceUpdateType,
  SystemUICommonUtil,
  TaskItem,
  TaskQueue
} from '@ohos/systemuicommon';
import {
  InnerEventUtil,
  LiveCardOtherModel,
  LiveNotification,
  NotificationBase,
  NotificationDataManager,
  NotificationEvent,
  NotificationUtil
} from '@ohos/systemuicommon/newTsIndex';
import { NotificationParserFactory } from '../parser/NotificationParserFactory';
import { NotificationRemindManager } from './NotificationRemindManager';
import NotificationListLimiter from '../model/NotificationListLimiter';
import { notificationConfigManager } from './NotificationConfigManager';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { NotificationExceptionCode } from '../maintenance/NotificationExceptionCode';
import { HdsIconTaskUtil, IconInfo } from '@ohos/systemuicommon/src/main/ets/utils/HdsIconTaskUtil';
import { LiveType } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCommonModel';
import { ParseNewNotificationMaintenance } from '../maintenance/ParseNewNotificationMaintenance';
import { LiveHiSysEvent } from '@ohos/systemuicommon/src/main/ets/live/sysEvent/LiveHiSysEvent';
import { StatisticsMaintenance } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsMaintenance';
import { NotificationMaintenanceEvent } from '../maintenance/event/NotificationMaintenanceEvent';
import { process } from '@kit.ArkTS';
import { SystemUIStateEventReporter } from '@ohos/systemuicommon/src/main/ets/reporter/SystemUIStateReporter';
import wantAgent, { WantAgent } from '@ohos.app.ability.wantAgent';
import { NotificationApiUtil } from '../utils/NotificationApiUtil';
import { CampaignNotificationFilter } from '../common/CampaignNotificationFilter';


const TAG = 'NotificationSubscribeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

class NotificationTaskItem extends TaskItem<void> {
  public hashCodes?: (string | undefined)[];
}

/**
 * 通知订阅管理
 */
export class NotificationSubscribeManager {
  /**
   * 获取单例
   */
  public static get = SingletonHelper.createFactory(() => new NotificationSubscribeManager());

  /**
   * 最大重试时间
   */
  private static readonly MAX_RETRY_INTERVAL = 30000;

  /**
   * 解析通知超时时间
   */
  private static readonly CONSUME_NOTIFICATION_TIMEOUT = 120000;

  /**
   * 初始化解析通知超时时间
   */
  private static readonly INIT_NOTIFICATION_TIMEOUT = 600000;

  /**
   * 通知列表数量限制
   */
  private listLimiter = new NotificationListLimiter<NotificationBase>();

  /**
   * 是否已注册订阅，避免重复订阅
   */
  private registered: boolean = false;

  /**
   * 通知处理队列，设置并发数为1个
   */
  private handleQueue: TaskQueue = new TaskQueue(TAG, 1);

  /**
   * 当前颜色模式，用来判断是否深浅色切换
   */
  private colorMode?: number;

  /**
   * 当前字体大小缩放比例，用来判断是否开启大字体或改变其档位
   */
  private fontSizeScale?: number;

  /**
   * 是否工程模式
   */
  private isFactoryMode: boolean = false;

  /**
   * 通知监听注册
   */
  private subscriber: notificationSubscribe.NotificationSubscriber = {
    onConnect: () => {
      log.showInfo('onConnect begin');
      const task: NotificationTaskItem = new NotificationTaskItem('onConnect', () => this.onConnect(task));
      task.timeout = NotificationSubscribeManager.INIT_NOTIFICATION_TIMEOUT;
      this.handleQueue.add(task);
      task.resultPromise.catch((e: Error) => {
        new ParseNewNotificationMaintenance(false).reportParseFailed(undefined, e, notificationConfigManager.userId);
      });
    },
    onConsume: (postData: notificationSubscribe.SubscribeCallbackData) => {
      log.showInfo(`onConsume begin, hashCode: ${postData?.request?.hashCode}`);
      const task: NotificationTaskItem =
        new NotificationTaskItem('onConsume', (times) => this.onConsume(postData, task, times));
      task.timeout = NotificationSubscribeManager.CONSUME_NOTIFICATION_TIMEOUT;
      task.timeoutRetryTimes = 1;
      task.hashCodes = [postData?.request?.hashCode as string];
      if (this.isNeedDeleteRedundantTask(postData)) {
        this.deleteRedundantTask(task);
      }
      this.handleQueue.add(task);
      task.resultPromise.catch((e: Error) => {
        log.error(`ntf ${postData?.request?.hashCode} consume fail, ${e}`);
        new ParseNewNotificationMaintenance(false).reportParseFailed(postData?.request, e,
          notificationConfigManager.userId);
      });
      StatisticsMaintenance.get().listenerReceiveNtf(postData?.request);
    },
    onCancel: (postData: notificationSubscribe.SubscribeCallbackData) => {
      log.showInfo(`onCancel begin, hashCode: ${postData?.request?.hashCode}`);
      const task = new NotificationTaskItem('onCancel', () => this.onCancel([postData]));
      task.hashCodes = [postData?.request?.hashCode as string];
      this.handleQueue.add(task);
      DeleteNotificationMaintenance.cancelCallback(postData);
    },
    onBatchCancel: (cancelData: Array<notificationSubscribe.SubscribeCallbackData>) => {
      const hashCodes = cancelData?.map((postData) => postData?.request?.hashCode);
      log.showInfo(`onBatchCancel begin, hashCode: ${hashCodes}`);
      const task = new NotificationTaskItem('onBatchCancel', () => this.onCancel(cancelData));
      task.hashCodes = hashCodes;
      this.handleQueue.add(task);
      DeleteNotificationMaintenance.cancelCallbackBatch(cancelData);
    },
    onDisconnect: this.onDisconnect,
    onDestroy: this.onDestroy,
  };

  /**
   * 初始化通知订阅
   * @returns
   */
  public async init(): Promise<void> {
    log.showInfo('Init notification subscriber begin');
    this.isFactoryMode = systemParameterEnhance.getSync('const.runmode', 'normal') === 'factory';
    CampaignNotificationFilter.instance.init();
    NotificationDataManager.instance.init();
    await this.registerNtf();
    notificationConfigManager.subscribeChangeEvent((event) => {
      log.showInfo(`onNotificationConfigChange begin, type: ${event.type}`);
      const task = new TaskItem('onNotificationConfigChange', () => this.onNotificationConfigChange(event));
      this.handleQueue.add(task);
    });
    InnerEventUtil.on(ConfigurationEvent, (event) => {
      if (this.colorMode !== undefined && this.colorMode !== event.config?.colorMode) {
        log.showInfo(`onDarkModeEvent begin, isDarkMode: ${this.colorMode}`);
        const task = new TaskItem('onDarkModeChange', this.onDarkModeChange);
        this.handleQueue.add(task);
      }
      if (this.fontSizeScale !== undefined && this.fontSizeScale !== event.config?.fontSizeScale) {
        const task = new TaskItem('onFontSizeScaleChange', this.onFontSizeScaleChange);
        this.handleQueue.add(task);
      }
      this.colorMode = event.config?.colorMode;
      this.fontSizeScale = event.config?.fontSizeScale;
    });
    // 通知事件订阅
    NotificationMaintenanceEvent.instance.subscribeCastConnectState();
    log.showInfo('Init notification subscriber end');
  }

  /**
   * 是否需要删除冗余的任务，当前仅处理普通通知，实况通知可能存在计时器导致删除冗余任务后出现功能问题
   */
  private isNeedDeleteRedundantTask(postData?: notificationSubscribe.SubscribeCallbackData): boolean {
    if (!postData?.request?.hashCode) {
      return false;
    }
    if (postData?.request?.template?.name === 'downloadTemplate') {
      return true;
    }
    if (NotificationUtil.isSystemLiveView(postData.request) || NotificationUtil.isOtherLiveView(postData.request)) {
      return false;
    }
    return true;
  }

  /**
   * 删除冗余的任务
   */
  private deleteRedundantTask(newTask: NotificationTaskItem): void {
    let redundantTask: NotificationTaskItem | undefined;
    for (const task of this.handleQueue.tasks) {
      if (!(task instanceof NotificationTaskItem)) {
        continue;
      }
      // 跳过和当前任务无关的任务
      if (task.hashCodes?.every((hashCode) => !newTask.hashCodes?.includes(hashCode))) {
        continue;
      }
      // 如果找到同hashCode的创建/更新任务则标记为需要删除的冗余任务
      if (task.taskName === 'onConsume') {
        redundantTask = task;
      } else {
        // 如果碰到同hashCode待删除的任务，则清空之前匹配到的冗余任务
        redundantTask = undefined;
      }
    }
    if (redundantTask) {
      this.handleQueue.removeTask(redundantTask);
    }
  }

  /**
   * 注册订阅,失败延迟重试,延迟时间指数递增:1->2->4->8....,最大延迟30s
   */
  private async registerNtf(): Promise<void> {
    let retryTimes = 0;
    let retryInterval = 1000;
    while (!this.registered) {
      try {
        await notificationSubscribe.subscribe(this.subscriber);
        this.registered = true;
        log.showInfo('Subscribe notification successful, retryTimes: ' + retryTimes);
      } catch (error) {
        log.error(`Subscribe notification error: ${error}, retryTimes: ${retryTimes}`);
        await SystemUICommonUtil.sleep(retryInterval);
        retryInterval = Math.min(retryInterval * 2, NotificationSubscribeManager.MAX_RETRY_INTERVAL);
        retryTimes++;
      }
    }
  }

  /**
   * 通知监听器连接回调
   */
  private async onConnect(task: TaskItem): Promise<void> {
    try {
      // 获取全量通知
      const requestList = await notificationManager.getAllActiveNotifications();
      log.showInfo('onConnect notification length: ' + requestList.length);
      const requestNtfMap: Map<NotificationBase, notificationManager.NotificationRequest> = new Map();
      for (const request of requestList) {
        if (!CampaignNotificationFilter.instance.filter(request)) {
          continue;
        }
        if (NotificationUtil.isInstantLiveView(request)) {
          log.showInfo(`Skip instant live view ${request.hashCode} when onConnect`);
          continue;
        }
        const ntf = await NotificationParserFactory.parse({
          request: request,
          sortingMap: await NotificationUtil.getSortingMap(request),
        });
        if (!ntf) {
          continue;
        }
        if (task.isTimeout) {
          LogWithHa.error(log, `onConnect init timeout`, NotificationExceptionCode.INIT_NTF_FAIL);
          return;
        }
        requestNtfMap.set(ntf, request);
      }
      requestNtfMap.forEach((request, ntf) => {
        const isUpdate = NotificationDataManager.instance.saveNtf(ntf);
        new ParseNewNotificationMaintenance(isUpdate).init(ntf, request).report();
      });
      await NotificationDataManager.instance.postInitNtfEvent();
      this.checkLimit();
      log.showInfo('onConnect end');
    } catch (error) {
      LogWithHa.error(log, `onConnect error ${error}`, NotificationExceptionCode.INIT_NTF_FAIL, error);
    }
  }

  /**
   * 接收通知回调
   *
   * @param postData 通知数据
   */
  private async onConsume(postData: notificationSubscribe.SubscribeCallbackData, task: TaskItem,
    times: number): Promise<void> {
    try {
      if (!postData || !postData.request) {
        LogWithHa.warn(log, 'onConsume data is invalid', NotificationExceptionCode.NO_POST_DATA);
        return;
      }
      if (this.isFactoryMode) {
        log.showWarn('DFM factory mode disabled notification message');
        new ParseNewNotificationMaintenance(false).reportParseFailed(postData.request, new Error('DFM factory mode'),
          notificationConfigManager.userId);
        return;
      }
      if (!CampaignNotificationFilter.instance.filter(postData.request)) {
        return;
      }
      log.showInfo('onConsume hashCode: [%{public}s]', postData.request.hashCode);
      const oldNtf = NotificationDataManager.instance.ntfMap.get(postData.request.hashCode ?? '');
      const ntf = await NotificationParserFactory.parse(postData, oldNtf);
      if (!ntf) {
        log.showWarn('onConsume parse failed');
        LiveHiSysEvent.reportInvalidParamEvent(postData.request);
        return;
      }
      if (task.isTimeout || times !== task.currentTimes) {
        // 整体超时会打点解析失败详细信息，这里记录日志上报
        LogWithHa.warn(log, `Notification ${postData.request.hashCode} is timeout, consume times ${times}, task time ${task.currentTimes}`,
          NotificationExceptionCode.PARSE_NTF_TIMEOUT);
        return;
      }

      const isUpdate = NotificationDataManager.instance.saveNtf(ntf);
      if (isUpdate) {
        this.tryCancelOldWantAgent(ntf, oldNtf);
        await NotificationDataManager.instance.postUpdateNtfEvent(ntf);
      } else {
        await NotificationDataManager.instance.postAddNtfEvent(ntf);
      }
      new ParseNewNotificationMaintenance(isUpdate).init(ntf, postData.request).report();
      NotificationRemindManager.get().remind(ntf, isUpdate, postData.request?.sound);
      this.checkLimit();
      log.showInfo(`onConsume end, hashCode: ${postData?.request.hashCode}`);
      SystemUIStateEventReporter.get().updateNtfNum(NotificationDataManager.instance.ntfMap.size);
    } catch (err) {
      log.showError(`onConsume error, err: ${err}`);
      new ParseNewNotificationMaintenance(false).reportParseFailed(postData?.request, err,
        notificationConfigManager.userId);
    }
  }

  /**
   * 通知删除回调
   *
   * @param cancelData 通知数据
   */
  private async onCancel(cancelData: notificationSubscribe.SubscribeCallbackData[]): Promise<void> {
    log.showWarn('On notification cancel');
    if (!cancelData.length) {
      log.showError('No data');
      return;
    }
    await NotificationDataManager.instance.removeLocalNtf(this.getDelList(cancelData));
    log.showWarn(`onCancel end, hashCode: ${cancelData?.map((postData) => postData?.request?.hashCode)}`);
    SystemUIStateEventReporter.get().updateNtfNum(NotificationDataManager.instance.ntfMap.size);
    cancelData?.forEach((callbackData: notificationSubscribe.SubscribeCallbackData) => {
      let bundle = callbackData?.request?.creatorBundleName;
      let reason = callbackData?.reason;
      NotificationApiUtil.appDeadNtfCancelHandle(bundle, reason);
    });
  }

  /**
   * 检测通知个数
   *
   * @param ntfEntry 通知数据
   */
  private checkLimit(): void {
    const limitNtfMap: Map<string, NotificationBase> = new Map();
    for (const ntf of NotificationDataManager.instance.ntfMap.values()) {
      // 即时类实况类型不参与通知个数限制
      if (ntf.isLiveView() && (ntf.type === LiveType.INSTANT || ntf.type === LiveType.INSTANT_BANNER)) {
        continue;
      }
      limitNtfMap.set(ntf.hashCode, ntf);
    }

    // 将要删除的通知
    const deleteNtfList: NotificationBase[] = this.listLimiter.limit([limitNtfMap]);
    log.showInfo('checkLimit deleteItems length:' + deleteNtfList.length);
    if (deleteNtfList.length) {
      // 提前删除本地数据
      for (const ntf of deleteNtfList) {
        NotificationDataManager.instance.ntfMap.delete(ntf.hashCode);
      }
      setTimeout(() => {
        deleteNtfList.forEach((entry: NotificationBase) => {
          log.showInfo(`CheckLimit deleteItem: ${entry.hashCode}, isLiveType: ${entry.isLiveView()}`);
          HiDfxEventUtil.reportDeleteNtfOverLimit(entry.creatorBundleName, entry.id, entry.hashCode);
        });
        DeleteNotificationMaintenance.addNtfMap(deleteNtfList, DeleteNotificationType.EXCEED_MAX_NUMBER_DELETE, false);
        log.showInfo('Remove ntfList by limit');
        NotificationDataManager.instance.removeLiveView(deleteNtfList, false, false);
      });
    }
  }

  /**
   * 获取需要删除的通知列表
   *
   * @param cancelDataList
   * @returns
   */
  private getDelList(cancelDataList: notificationSubscribe.SubscribeCallbackData[]): NotificationBase[] {
    const delList: NotificationBase[] = [];
    cancelDataList.forEach((cancelData) => {
      if (!cancelData) {
        return;
      }
      const id = cancelData.request?.id;
      const hashCode = cancelData.request?.hashCode ?? '';
      const userId = cancelData.request?.creatorUserId;
      const bundle = cancelData.request?.creatorBundleName;
      const ntfEntry = NotificationDataManager.instance.ntfMap.get(hashCode);
      if (!ntfEntry) {
        log.showWarn('NotificationCancel has not ntf: %{public}d, %{public}s, %{public}s, %{public}d', userId,
          hashCode, bundle, id);
        return;
      }
      delList.push(ntfEntry);
    });
    log.showWarn(`need delList length: ${delList.length}`);
    return delList;
  }

  /**
   * 通知监听器断开连接回调
   */
  private onDisconnect(): void {
    log.showInfo('onListenerDisconnect');
  }

  /**
   * 通知监听器销毁回调
   */
  private onDestroy(): void {
    log.showInfo('onListenerDestroy');
  }

  /**
   * 通知配置变化事件
   */
  private async onNotificationConfigChange(event: NotificationConfigEvent): Promise<void> {
    try {
      const updateNtfList: NotificationBase[] = [];
      let updateType = NotificationEvent.UPDATE_TYPE_CONFIG;
      if (event.type === NotificationConfigEventType.PINTOP_ITEM) {
        this.pinTop(updateNtfList, event);
        updateType = NotificationEvent.UPDATE_TYPE_PIN_TOP;
      } else if (event.type === NotificationConfigEventType.UPDATE_RESOURCE ||
        event.type === NotificationConfigEventType.SHOWING_NOTIFICATION_UPDATE) {
        const duplicateUid =
          event.type === NotificationConfigEventType.UPDATE_RESOURCE ? event.duplicateUid : undefined;
        await this.updateResource(updateNtfList, event.resourceUpdateType, duplicateUid);
      } else if (event.type === NotificationConfigEventType.UPDATE_ITEM) {
        this.updateConfig(updateNtfList, event.config);
      } else if (event.type === NotificationConfigEventType.CHANGE_IGNORE) {
        this.updateConfig(updateNtfList, event.config);
      }
      if (updateNtfList.length) {
        await NotificationDataManager.instance.updateExistNtf(updateNtfList, updateType);
      }
      log.showInfo(`onNotificationConfigChange end, type: ${event.type}`);
    } catch (e) {
      log.error(`onNotificationConfigChange for ${event.type} error:`, e);
    }
  }

  /**
   * 抑制声音/震动/横幅/胶囊提醒方式
   * @param ntf
   */
  private depressRemind(ntf: NotificationBase): void {
    ntf.remindConfig.setSound(false);
    ntf.remindConfig.setVibration(false);
    ntf.remindConfig.setBanner(false);
    if (ntf.isLiveView()) {
      ntf.enableHeadsUp(false);
    }
  }

  /**
   * 置顶应用，更新该应用的通知
   * @param updateNtfList
   * @param event
   */
  private pinTop(updateNtfList: NotificationBase[], event: NotificationConfigPinTopEvent): void {
    log.showInfo(`Change pinTop for ${event.uid} to ${event.enabled}.`);
    NotificationDataManager.instance.ntfMap.forEach(ntf => {
      if (ntf.creatorUid === event.uid && !ntf.isLiveView()) {
        ntf.isDisplayAtTop = event.enabled;
        this.depressRemind(ntf);
        updateNtfList.push(ntf);
      }
    });
  }

  /**
   * 所有应用资源变化（如切换语言），更新全部通知
   * @param updateNtfList
   * @param duplicateUid
   * @returns
   */
  private async updateResource(updateNtfList: NotificationBase[], resourceUpdateType: ResourceUpdateType,
    duplicateUid?: Set<number>): Promise<void> {
    log.showInfo('Update resource');
    const creatorUidSet: Set<number> = new Set();
    NotificationDataManager.instance.ntfMap.forEach((ntf) => {
      if (duplicateUid?.has(ntf.creatorUid ?? 0)) {
        log.showInfo(`uid ${ntf.creatorUid} has been handeled, ignore`);
        return;
      }
      creatorUidSet.add(ntf.creatorUid ?? 0);
    });
    if (!creatorUidSet.size) {
      log.showInfo('no uid to handle');
      return;
    }
    const predicates = NotificationConfigEntity.getPredicates();
    predicates.inCondition({ uid: Array.from(creatorUidSet) });
    const configList = await NotificationConfigEntity.queryList(predicates, {
      columns: ['uid', 'icon', 'label', 'bundle'],
    });
    NotificationDataManager.instance.ntfMap.forEach(ntf => {
      const config = configList.find((config) => config.bundle === ntf.creatorBundleName && config.uid === ntf.creatorUid);
      if (config) {
        if (!ntf.useCustomAppname) {
          ntf.appLabel = config.label;
        }
        if (!ntf.useCustomAppIcon) {
          ntf.appIcon = config.icon;
        }
        this.depressRemind(ntf);
        updateNtfList.push(ntf);
      } else if (ntf.creatorType === NotificationCreatorType.SA) {
        if (!ntf.useCustomAppname) {
          ntf.appLabel = notificationConfigManager.getSADefaultName();
        }
        updateNtfList.push(ntf);
      }
    });

    if (!updateNtfList.length) {
      return;
    }
    // 切换语言不用处理图标
    if (resourceUpdateType === ResourceUpdateType.LANGUAGE_CHANGE) {
      return;
    }
    // 更新smallIcon
    await this.updateNtfSmallIcons(updateNtfList);
    // 更新全场景通知图标
    await this.updateNtfCollaAppIcons(updateNtfList);
  }

  /**
   * 更新smallIcon
   * @param updateNtfList
   * @returns
   */
  private async updateNtfSmallIcons(updateNtfList: NotificationBase[]): Promise<void> {
    const iconInfos: IconInfo[] = [];
    updateNtfList.filter(ntf => ntf.smallIconOrigin !== undefined).forEach((ntf) => {
      iconInfos.push({ hashCode: ntf.hashCode ?? '', icon: ntf.smallIconOrigin! });
    });
    if (!iconInfos.length) {
      return;
    }
    const hdsIconInfos = await HdsIconTaskUtil.getHdsIconBatch(GlobalContext.getContext(), iconInfos, process.tid);
    updateNtfList.filter(ntf => ntf.smallIconOrigin !== undefined).forEach((ntf) => {
      ntf.smallIcon = hdsIconInfos.get(ntf.hashCode ?? '');
    });
  }

  /**
   * 更新全场景通知应用图标
   * @param updateNtfList
   * @returns
   */
  private async updateNtfCollaAppIcons(updateNtfList: NotificationBase[]): Promise<void> {
    // 协同通知处理
    const collaIconInfos: IconInfo[] = [];
    updateNtfList.filter(ntf => ntf.collaAppIconOrigin !== undefined).forEach((ntf) => {
      collaIconInfos.push({ hashCode: ntf.hashCode, icon: ntf.collaAppIconOrigin! });
    });

    if (!collaIconInfos.length) {
      return;
    }
    const hdsIconInfos = await HdsIconTaskUtil.getHdsIconBatch(GlobalContext.getContext(), collaIconInfos, process.tid);
    updateNtfList.filter(ntf => ntf.collaAppIconOrigin !== undefined).forEach((ntf) => {
      ntf.appIcon = hdsIconInfos.get(ntf.hashCode);
    });
  }

  /**
   * 单个应用配置变化，更新通知
   * @param updateNtfList
   * @param event
   */
  private updateConfig(updateNtfList: NotificationBase[], config: NotificationConfigEntity): void {
    log.showInfo(`Update config for ${config?.uid}, label: ${config?.label}.`);
    NotificationDataManager.instance.ntfMap.forEach(ntf => {
      if (ntf.creatorUid !== config.uid) {
        return;
      }
      if (!ntf.useCustomAppname && config.label !== undefined) {
        ntf.appLabel = config.label;
      }
      if (!ntf.useCustomAppIcon && config.icon !== undefined) {
        ntf.appIcon = config.icon;
      }
      if (config.settingIgnore !== undefined) {
        ntf.isSettingIgnore = config.settingIgnore;
      }
      this.depressRemind(ntf);
      updateNtfList.push(ntf);
    });
  }

  private onDarkModeChange = async (): Promise<void> => {
    const updatedNtfList: NotificationBase[] = [];

    try {
      for (const ntf of NotificationDataManager.instance.ntfMap.values()) {
        if (!ntf.isLiveView() || !ntf.card?.isSystemCard()) {
          continue;
        }
        if (ntf.capsule?.button?.lightIcon !== ntf.capsule?.button?.darkIcon) {
          updatedNtfList.push(ntf);
        } else if (ntf.card.buttons?.some((button) => button.lightIcon !== button.darkIcon)) {
          updatedNtfList.push(ntf);
        }
      }
      if (updatedNtfList.length) {
        await NotificationDataManager.instance.updateExistNtf(updatedNtfList, NotificationEvent.UPDATE_TYPE_CONFIG);
      }
      log.showInfo(`onDarkModeEvent end, updatedNtfList.length: ${updatedNtfList.length}`);
    } catch (e) {
      log.error('onDarkModeEvent error:', e);
    }
  };

  private onFontSizeScaleChange = async (): Promise<void> => {
    const updatedNtfList: NotificationBase[] = [];

    try {
      for (const ntf of NotificationDataManager.instance.ntfMap.values()) {
        if (!ntf.isLiveView()) {
          continue;
        }
        updatedNtfList.push(ntf);
      }
      if (updatedNtfList.length) {
        await SystemUICommonUtil.sleep(300);
        await NotificationDataManager.instance.updateExistNtf(updatedNtfList, NotificationEvent.UPDATE_TYPE_CONFIG);
      }
      log.showInfo(`onFontSizeScaleEvent end, updatedNtfList.length: ${updatedNtfList.length}`);
    } catch (e) {
      log.error('onFontSizeScaleEvent error:', e);
    }
  };

  /**
   * push通知更新时，旧通知的wantAgent就不用了。如果旧通知的wantAgent与新通知不一致，需要业务层主动删除，为底层wantAgent兜底，避免wantAgent积压导致内存泄露
   * @param newNtf 新通知
   * @param oldNtf 旧通知
   * @returns
   */
  private async tryCancelOldWantAgent(newNtf: NotificationBase, oldNtf: NotificationBase | undefined): Promise<void> {
    if (!oldNtf) {
      log.showInfo('newNtf: %{public}s does not have a response oldNtf', newNtf.hashCode);
      return;
    }

    if (!oldNtf.isFromPush) {
      log.showInfo('oldNtf: %{public}s is not a push ntf', oldNtf.hashCode);
      return;
    }

    log.showInfo('updating notification, cancel wantAgent for oldNtf:%{public}s', oldNtf.hashCode);
    const oldWantAgents = this.collectWantAgent(oldNtf);
    const newWantAgents = this.collectWantAgent(newNtf);
    oldWantAgents.forEach((oldAgent) => this.cancelIfNotExistInNewNtf(oldAgent, newWantAgents, newNtf));
  }

  private collectWantAgent(ntf: NotificationBase): WantAgent[] {
    const wantAgents: WantAgent[] = [];
    if (ntf.wantAgent) {
      wantAgents.push(ntf.wantAgent);
    }
    if (ntf.removalWantAgent) {
      wantAgents.push(ntf.removalWantAgent);
    }
    for (const button of ntf.actionButtons ?? []) {
      wantAgents.push(button.wantAgent);
    }
    const extensionWantAgent = this.getLiveExtensionWantAgent(ntf);
    if (extensionWantAgent) {
      wantAgents.push(extensionWantAgent);
    }
    return wantAgents;
  }

  /**
   * 6.0版本中，实况的extensionWantAgent从actionButtons中单摘出来，因此此处需要单独添加
   * 5.0/5.1/5.1.1版本包含在actionButtons中，不需要单独取
   *
   * @param ntf 通知对象
   * @returns 若存在extensionWantAgent则返回，没有时返回undefined
   */
  private getLiveExtensionWantAgent(ntf: NotificationBase): WantAgent | undefined {
    if (ntf instanceof LiveNotification && ntf.card instanceof LiveCardOtherModel) {
      return ntf.card.extensionWantAgent;
    } else {
      return undefined;
    }
  }

  private async cancelIfNotExistInNewNtf(oldAgent: WantAgent, wantAgents: WantAgent[],
    ntf: NotificationBase): Promise<void> {
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
    const key: number = Reflect.get(oldAgent, 'innerKey');
    const current: number = Reflect.get(ntf.wantAgent ?? {}, 'innerKey');
    if (key !== undefined) {
      log.showWarn(`cancel wantAgent: ${key}, current: ${ntf.hashCode} (${current})`);
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

}