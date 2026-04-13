/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import List from '@ohos.util.List';
import {
  NotificationSubscriber,
  EnabledNotificationCallbackData,
  BadgeNumberCallbackData,
  SubscribeCallbackData,
} from 'notification/notificationSubscriber';
import { AppModel, BadgeManager, CommonConstants } from '@ohos/launchercommon';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import notificationManager from '@ohos.notificationManager';
import BundleManager from '@ohos.bundle.bundleManager';
import { BaseBundleInfo } from '@ohos/launchercommon/src/main/ets/bean/BaseBundleInfo';
import { notificationSubscribe } from '@kit.NotificationKit';
import { AsyncCallback, BusinessError, commonEventManager } from '@kit.BasicServicesKit';

const TAG = 'NumBadgeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);
const MSG_TYPE_PUSH: number = 1;
const MSG_TYPE_NMS: number = 2;

interface BadgeChangeData {
  bundleName: string;
  badgeNumber: number;
  appInstanceKey: string;
}

export class NumBadgeManager {
  private readonly mRegisterNumBadgeCallback: AsyncCallback<void>;
  private readonly mUnRegisterNumBadgeCallback: AsyncCallback<void>;
  private readonly mBadgeManager: BadgeManager;
  private subscriber?: commonEventManager.CommonEventSubscriber;

  /**
   * 角标变化任务处理队列
   * 1. 队列长度始终为2，queue[0]: 正在处理的数据, queue[1]: 待处理的数据
   * 2. onBadgeChangedCallBack只往队列中塞数据，不处理业务
   * 3. 每一个uid都有一个队列
   */
  private readonly badgeChangeQueue: Map<number, List<BadgeChangeData>> = new Map();

  private mSubscriber: NotificationSubscriber = {
    onConsume: this.onConsumeCallback.bind(this),
    onCancel: this.onCancelCallback.bind(this),
    onUpdate: this.onUpdateCallback.bind(this),
    onConnect: this.onConnectCallback.bind(this),
    onDisconnect: this.onDisconnectCallback.bind(this),
    onDestroy: this.onDestroyCallback.bind(this),
    onEnabledNotificationChanged: this.onEnabledNotificationChangedCallback.bind(this),
    onBadgeChanged: this.onBadgeChangedCallBack.bind(this),
    onBadgeEnabledChanged: this.onBadgeEnabledChangedCallback.bind(this)
  }

  private constructor() {
    this.mRegisterNumBadgeCallback = this.registerNumBadgeCallback.bind(this);
    this.mUnRegisterNumBadgeCallback = this.unRegisterNumBadgeCallback.bind(this);
    this.mBadgeManager = BadgeManager.getInstance();
  }

  /**
   * 角标add场景
   *
   * @param data 回调通知消息
   */
  private onConsumeCallback(data: SubscribeCallbackData): void {
    log.showInfo('onConsumeCallback called !!');
    this.handleSubscribeCallbackData(data);
  }

  private onCancelCallback(): void {
    log.showInfo('onCancelCallback called !!');
  }

  private onUpdateCallback(): void {
    log.showInfo('onUpdateCallback called !!');
  }

  private onConnectCallback(): void {
    log.showInfo('onConnectCallback called !!');
  }

  private onDisconnectCallback(): void {
    log.showInfo('onDisconnectCallback called !!');
  }

  private onDestroyCallback(): void {
    log.showInfo('onDestroyCallback called !!');
  }

  private async getAppIndexFromUid(uid: number): Promise<number> {
    let appIndex: number = 0;

    try {
      let identity = await BundleManager.getAppCloneIdentity(uid);
      appIndex = identity.appIndex ?? 0;
    } catch (err) {
      log.showError(`getAppCloneIdentity uid: ${uid}, error: ${err.message}`);
    }
    return appIndex;
  }

  private async onEnabledNotificationChangedCallback(callbackData: EnabledNotificationCallbackData): Promise<void> {
    if (!callbackData) {
      log.showError('onEnabledNotificationChangedCallback callbackData is null');
      return;
    }

    let eventUid: number = callbackData.uid;
    let bundleName: string = callbackData.bundle;
    let display: boolean = callbackData.enable;
    let isBadgeOn: boolean = true;
    log.showWarn(`onEnabledNotificationChangedCallback bundleName: ${bundleName}, uid: ${eventUid} enable: ${display}`);
    // 应用通知和角标权限同时开启时展示角标
    if (display) {
      try {
        const option: notificationManager.BundleOption = { bundle: bundleName, uid: eventUid };
        isBadgeOn = await notificationManager.isBadgeDisplayed(option);
        log.showWarn(`get badge display succeed, bundleName: ${bundleName}, uid: ${eventUid} value: ${isBadgeOn}`);
      } catch (err) {
        log.showError(`get badge display error, bundleName: ${bundleName}, uid: ${eventUid} error: ${err?.message}}`);
      }
    }

    this.handleEnabledNotificationChanged({
      bundle: bundleName,
      uid: eventUid,
      enable: display && isBadgeOn
    } as EnabledNotificationCallbackData);
  }

  private async onBadgeEnabledChangedCallback(callbackData: EnabledNotificationCallbackData): Promise<void> {
    if (!callbackData) {
      log.showError('onBadgeEnabledChangedCallback callbackData is null');
      return;
    }

    let eventUid: number = callbackData.uid;
    let bundleName: string = callbackData.bundle;
    let display: boolean = callbackData.enable;
    let isNtfOn: boolean = true;
    log.showWarn(`onBadgeEnabledChangedCallback bundleName: ${bundleName}, uid: ${eventUid}, enable: ${display}`);
    // 应用通知和角标权限同时开启时展示角标
    if (display) {
      try {
        const option: notificationManager.BundleOption = { bundle: bundleName, uid: eventUid };
        isNtfOn = await notificationManager.isNotificationEnabled(option);
        log.showWarn(`get notification enable, bundleName: ${bundleName}, uid: ${eventUid}, value: ${isNtfOn}`);
      } catch (err) {
        log.showError(`get notification enable error, bundleName: ${bundleName}, uid: ${eventUid}, error: ${err?.message}}`);
      }
    }

    this.handleEnabledNotificationChanged({
      bundle: bundleName,
      uid: eventUid,
      enable: display && isNtfOn
    } as EnabledNotificationCallbackData);
  }

  private async onBadgeChangedTask(uid: number): Promise<void> {
    let queue: List<BadgeChangeData> | undefined = this.badgeChangeQueue.get(uid);
    let appIndex: number = await this.getAppIndexFromUid(uid);
    while (queue && queue.length) {
      let data: BadgeChangeData = queue.get(0);
      let bundleInfo: BaseBundleInfo = { bundleName: data.bundleName, appIndex: appIndex,
        appInstanceKey: data?.appInstanceKey};
      let lastBadgeNumber = await this.mBadgeManager.getCacheBundleBadge(bundleInfo);

      log.showWarn(`onBadgeChangedTask, badgeNumber:${data.badgeNumber}, bundleName:${data.bundleName} uid: ${uid} appIndex:${appIndex}`);
      if (lastBadgeNumber !== data.badgeNumber) {
        this.handleBadgeChangedCallBackData(bundleInfo, data.badgeNumber);
      } else {
        log.showInfo(`badge is not change! lastBadgeNumber: ${lastBadgeNumber}, bundleName:${data.bundleName} uid: ${uid} appIndex:${appIndex}`);
      }
      // pop
      queue.removeByIndex(0);
    }
    // 处理完删除队列
    this.badgeChangeQueue.delete(uid);
  }

  /**
   * 角标set场景
   *
   * @param data 角标变更通知
   */
  private onBadgeChangedCallBack(data: BadgeNumberCallbackData): void {
    if (!data) {
      log.showError('onBadgeChangedCallBack callbackData is null');
      return;
    }

    log.showWarn(`onBadgeChangedCallBack, badgeNumber: ${data.badgeNumber}, bundleName:${data.bundle}, uid: ${data.uid} ,appInstanceKey:${data?.appInstanceKey}`);
    let badgeChangeData: BadgeChangeData = {
      bundleName: data.bundle,
      badgeNumber: data.badgeNumber,
      appInstanceKey: data.appInstanceKey ?? '',
    };

    let queue: List<BadgeChangeData> | undefined = this.badgeChangeQueue.get(data.uid);
    if (!queue) {
      queue = new List<BadgeChangeData>();
      this.badgeChangeQueue.set(data.uid, queue);
    }
    if (queue.length <= 1) {
      // 队列有空余追加任务
      log.showInfo(`add task, bundleName:${data.bundle}, uid: ${data.uid}, badgeNumber: ${data.badgeNumber}, ,appInstanceKey:${data?.appInstanceKey}`);
      queue.add(badgeChangeData);
    } else {
      // 队列满了，直接替换第二个任务
      log.showInfo(`replaces queu[1], bundleName:${data.bundle}, uid: ${data.uid}, badgeNumber: ${data.badgeNumber} ,appInstanceKey:${data?.appInstanceKey}`);
      queue[1] = badgeChangeData;
    }
    // 首次新增任务时开始执行
    if (queue.length === 1) {
      this.onBadgeChangedTask(data.uid);
    }
  }

  private handleBadgeChangedCallBackData(bundleInfo: BaseBundleInfo, badgeNumber: number): void {
    if (badgeNumber < 0) {
      badgeNumber = 0;
    }
    log.showWarn(`handleBadgeChanged badgeNumber: ${badgeNumber},  bundle: ${JSON.stringify(bundleInfo)}`);
    // 查询是否有角标更新状态
    let badgeUpdateTask = this.mBadgeManager.getBadgeUpdateTask(bundleInfo);
    // 更新角标缓存，刷新桌面角标
    this.mBadgeManager.setCacheBundleBadge(bundleInfo, badgeNumber, badgeUpdateTask);
    if (!badgeUpdateTask) {
      this.updateDBBadgeNumber(bundleInfo, badgeNumber);
    }
  }

  private async updateDBBadgeNumber(bundleInfo: BaseBundleInfo, badgeNumber: number): Promise<void> {
    log.showWarn(`updateDBBadgeNumber bundleName: ${bundleInfo.bundleName} appIndex: ${bundleInfo.appIndex}, badgeNumber: ${badgeNumber}`);
    // 更新角标插入DB状态
    this.mBadgeManager.setBadgeUpdateTask(bundleInfo, true);
    let result = await this.mBadgeManager.updateBadgeNumber(bundleInfo, badgeNumber);
    log.showWarn(`updateBadgeByBundle result: ${result}, bundleName: ${bundleInfo.bundleName} appIndex: ${bundleInfo.appIndex}, badgeNumber: ${badgeNumber}`);
    // 数据库更新完成后刷新桌面ui显示
    await this.mBadgeManager.refreshDesktopBadge(bundleInfo);
    this.mBadgeManager.setBadgeUpdateTask(bundleInfo, false);
    setTimeout(async () => {
      let lastBadgeNumber = await this.mBadgeManager.getCacheBundleBadge(bundleInfo);
      // 数据库更新的角标值不等于缓存里的角标值，取缓存数据更新DB
      if (lastBadgeNumber !== badgeNumber) {
        log.showInfo(`updateDBBadgeNumber bundleName: ${bundleInfo.bundleName} appIndex: ${bundleInfo.appIndex}, ` +
        `lastBadgeNumber: ${lastBadgeNumber} is not equal to ${badgeNumber}`);
        this.updateDBBadgeNumber(bundleInfo, lastBadgeNumber);
      }
    }, 500);
  }

  private async handleSubscribeCallbackData(data: SubscribeCallbackData): Promise<void> {
    if (!data) {
      log.showError('handleSubscribeCallbackData callbackData is null');
      return;
    }

    let creatorUserId: number = data.request?.creatorUserId ?? -1;
    let creatorBundleName: string = data.request?.creatorBundleName ?? '';
    let creatorUid: number = data.request?.creatorUid ?? -1;

    let userId: number = AppModel.getInstance().getUserId();
    if (creatorUserId !== 0 && userId !== creatorUserId) {
      log.showError(`handleSubscribeCallbackData userid is diff ${userId}, creatorUserId is ${creatorUserId}`);
      return;
    }

    let badgeNumber: number = data.request?.badgeNumber ?? 0;

    if (badgeNumber === 0) {
      log.showWarn(`handleSubscribeCallbackData bundleName: ${creatorBundleName}, uid: ${creatorUid} badge change number is 0`);
      return;
    }

    let appIndex: number = await this.getAppIndexFromUid(creatorUid);
    let bundleInfo: BaseBundleInfo = { bundleName: creatorBundleName, appIndex: appIndex };
    log.showInfo(`handleSubscribeCallbackData: bundleName: ${creatorBundleName}, uid: ${creatorUid}, appIndex: ${appIndex}, badgeNumber: ${badgeNumber}`);
    let lastBadgeNumber = await this.mBadgeManager.getCacheBundleBadge(bundleInfo);
    let newBadgeNumber: number = 0;
    newBadgeNumber = badgeNumber + lastBadgeNumber;
    this.handleBadgeChangedCallBackData(bundleInfo, newBadgeNumber);
  }

  private async handleEnabledNotificationChanged(callbackData: EnabledNotificationCallbackData): Promise<void> {
    if (!callbackData) {
      log.showError('handleEnabledNotificationChanged callbackData is null');
      return;
    }

    let eventUid: number = callbackData.uid;
    let bundleName: string = callbackData.bundle;
    let display: boolean = callbackData.enable;

    log.showInfo(`handleEnabledNotificationChanged uid: ${eventUid}, bundleName: ${bundleName}`);
    let userId: number = AppModel.getInstance().getUserId();
    let appIndex: number = await this.getAppIndexFromUid(callbackData?.uid);
    let bundleInfo: BaseBundleInfo = { bundleName: bundleName, appIndex: appIndex };

    log.showWarn(`handleEnabledNotificationChanged uid: ${eventUid}, bundleName: ${bundleName} appIndex: ${appIndex}, display: ${display}`);
    let lastDisplay = await this.mBadgeManager.getBadgeDisplayByBundleSync(bundleInfo);
    if (lastDisplay === display) {
      log.showInfo(`no need update display, uid: ${eventUid}, userId: ${userId}, bundleName: ${bundleName} appIndex: ${appIndex}, display: ${display}`);
      return;
    }

    this.mBadgeManager.updateBadgeDisplay(bundleInfo, display)
      .then((result) => {
        log.showInfo(`updateBadgeDisplay, bundleName: ${bundleName} appIndex: ${appIndex}, display: ${display}, result: ${result}`);
      })
      .catch((error: Error) => {
        log.showError(`updateBadgeDisplay failed, bundleName: ${bundleName} appIndex: ${appIndex}, display: ${display} error: ${error.message}`);
      });
  }

  private registerNumBadgeCallback(err: BusinessError, data: Object): void {
    log.info('registerNumBadgeCallback return ', err);
  }

  private unRegisterNumBadgeCallback(err: BusinessError, data: Object): void {
    log.info('unRegisterNumBadgeCallback return ', err);
  }

  static getInstance(): NumBadgeManager {
    if (globalThis.sNumBadgeManager == null) {
      globalThis.sNumBadgeManager = new NumBadgeManager();
    }
    return globalThis.sNumBadgeManager;
  }

  registerNumBadge(): void {
    log.showInfo('registerNumBadge called ');
    notificationSubscribe.subscribe(this.mSubscriber, this.mRegisterNumBadgeCallback);
  }

  unRegisterNumBadge(): void {
    log.showInfo('unRegisterNumBadge called ');
    notificationSubscribe.unsubscribe(this.mSubscriber, this.mUnRegisterNumBadgeCallback);
  }
}

export class SubscribeInfo {
  public events: string[] = [];
  public publisherPermission: string = ''
}