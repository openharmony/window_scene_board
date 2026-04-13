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

import { DomainName, LogDomain, LogHelper, SingletonHelper } from '../common/BasicCommon';
import { NotificationConfigEvent, NotificationConfigEventType } from '../common/BasicCommon';
import { NotificationConfigEntity } from '../common/BasicCommon';
import { notificationSettingManager } from '../manager/NotificationSettingManager';
import { notificationManager } from '@kit.NotificationKit';
import { RemindLabelsParser } from '../common/RemindLabelsParser';
import sSettingsUtil from '../common/SettingsUtil';
import { SettingsKeyConstants } from '../common/constants';
import { commonEventManager } from '@kit.BasicServicesKit';
import { bundleManager } from '@kit.AbilityKit';

const TAG = 'ManagementComponent-AppLstComponentViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 通知配置应用项
 */
@Observed
export class AppItem {
  public key?: number = undefined;
  public appTitle: string = '';
  public appVersion: string = '';
  public appBundleName: string = '';
  public appUid: number = 0;
  public systemApp: boolean = false;
  public appIcon: string = '';
  public appIndex: number = 0;
  public itemDescribeText: string = '';
  public appSwitch?: boolean = undefined;
  public appSlot?: number = undefined;
  public language?: string = undefined;
  public isBadgeOn?: boolean = undefined;
  public showDesktopBadge?: boolean = undefined;
  public appLiveViewSwitch?: StateValue = undefined;
  public isMetaService: boolean = false;
  public sortTag?: string = '';
}

@Observed
export class StateValue {
  private value?: boolean;

  constructor(state?: boolean) {
    this.value = state ?? false;
  }

  public isOn(): boolean {
    return this.value ?? false;
  }

  public setState(state: boolean): void {
    this.value = state;
  }

  public isInitialized(): boolean {
    return this.value !== undefined;
  }
}

export class AppLstComponentViewModel {
  public static get = SingletonHelper.createFactory(() => new AppLstComponentViewModel());
  private callback?: (appList: AppItem[]) => void;
  private liveViewAppCallback?: (appList: AppItem[]) => Promise<void>;
  private bundleInfoList: AppItem[] = []; // 通知管理列表
  private liveViewInfoList: AppItem[] = []; // 实况窗列表单独维护
  private itemKey: number = 0;
  private commonEventSubscriber?: commonEventManager.CommonEventSubscriber;
  private initCount: number = 0;

  init(): void {
    try {
      this.refresh();
      this.subscribeSlotChangeEvent();
      notificationSettingManager.subscribeChangeEvent(this.onNotificationConfigChange);
      sSettingsUtil.registerKeyObserverSecure(SettingsKeyConstants.APP_NTF_CONFIG_SHOW_DESKTOP_BADGES,
        this.refreshSlotAndBadgeInfo);
    } catch (error) {
      log.error(`AppLstComponentViewModel init error`, error);
    }
  }

  appListInit(callback: (bundleInfoList: AppItem[]) => void): void {
    // 未初始化就执行初始化、否则执行回调给出需要显示的APP列表
    this.callback = callback;
    if (this.initCount === 0) {
      this.init();
    } else {
      this.callback?.(this.bundleInfoList);
    }
    this.initCount++;
    log.showInfo(`updateAppList applistInit size:${this.bundleInfoList.length} initCount:${this.initCount}`);
  }

  async liveViewListInit(callback: (liveViewInfoList: AppItem[]) => Promise<void>): Promise<void> {
    this.liveViewAppCallback = callback;
    if (this.initCount === 0) {
      this.init();
    } else {
      await this.liveViewAppCallback?.(this.liveViewInfoList);
    }
    log.showInfo(`updateAppList liveViewList size:${this.liveViewInfoList.length} initCount:${this.initCount}`);
    this.initCount++;
  }

  applistDestroy(): void {
    this.initCount--;
    if (this.initCount !== 0) {
      return;
    }
    this.callback = undefined;
    this.destroy();
    log.showInfo(`applistDestroy size:${this.initCount}`);
  }

  liveviewlistDestroy(): void {
    this.initCount--;
    if (this.initCount !== 0) {
      return;
    }
    this.liveViewAppCallback = undefined;
    this.destroy();
    log.showInfo(`liveviewlistDestroy size:${this.initCount}`);
  }

  destroy(): void {
    if (this.callback || this.liveViewAppCallback) {
      return;
    }
    this.unsubscribeCommonEvent();
    notificationSettingManager.unsubscribeChangeEvent(this.onNotificationConfigChange);
    sSettingsUtil.unregisterKeyObserverSecure(SettingsKeyConstants.APP_NTF_CONFIG_SHOW_DESKTOP_BADGES);
  }

  async querySlotAndBadgeInfo(uid: number): Promise<void> {
    const item = this.bundleInfoList.find((item) => item.appUid === uid);
    if (!item) {
      return;
    }
    await this.itemQuerySlotAndBadgeInfo(item);
  }

  async itemQuerySlotAndBadgeInfo(item: AppItem): Promise<void> {
    try {
      log.showInfo(`Query slot info for ${item.appBundleName}_${item.appUid}`);
      const bundleOption: notificationManager.BundleOption = { bundle: item.appBundleName, uid: item.appUid };
      const result = await Promise.all([
        notificationManager.isNotificationEnabled(bundleOption),
        notificationManager.getSlotFlagsByBundle(bundleOption),
        notificationManager.isBadgeDisplayed(bundleOption),
      ]);
      if (result[0] !== item.appSwitch) {
        item.appSwitch = result[0];
      }
      if (result[1] !== item.appSlot) {
        item.appSlot = result[1];
        item.itemDescribeText = RemindLabelsParser.parse(item.appSlot);
      }

      if (result[2] !== item.isBadgeOn) {
        item.isBadgeOn = result[2];
      }
      if (await notificationSettingManager.hasLauncher(item.appBundleName, item.appUid)) {
        item.showDesktopBadge =
          sSettingsUtil.getSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_SHOW_DESKTOP_BADGES) ===
            'true' ? true : false;
      }
      item.itemDescribeText = RemindLabelsParser.parse(item.appSlot, item.isBadgeOn && item.showDesktopBadge);
    } catch (e) {
      log.error(`Query slot info for ${item.appBundleName}_${item.appUid} error
      code:` + e?.code + ',message:' + e?.message);
    }
  }

  private async refresh(): Promise<void> {
    let liveViewList: NotificationConfigEntity[] = await notificationSettingManager.getOriginAppList(true);
    let appList: NotificationConfigEntity[] = liveViewList.filter((config) => config.settingIgnore === false);
    appList = appList.filter((item) => item.bundleType !== bundleManager.BundleType.ATOMIC_SERVICE);
    liveViewList = liveViewList.filter((item) => item.bundleType !== bundleManager.BundleType.ATOMIC_SERVICE);
    this.bundleInfoList = appList.map((app) => this.convertItem(app));
    this.liveViewInfoList = liveViewList.map((app) => this.convertItem(app));
    this.callback?.(this.bundleInfoList);
    await this.liveViewAppCallback?.(this.liveViewInfoList);
  }

  private refreshSlotAndBadgeInfo = async (): Promise<void> => {
    for (let item of this.bundleInfoList) {
      await this.itemQuerySlotAndBadgeInfo(item);
    }
    this.callback?.(this.bundleInfoList);
    await this.liveViewAppCallback?.(this.liveViewInfoList);
  };

  private async refreshAddItem(): Promise<void> {
    const liveViewList: NotificationConfigEntity[] = await notificationSettingManager.getOriginAppList(true);
    const appList: NotificationConfigEntity[] = liveViewList.filter((config) => config.settingIgnore === false);
    this.bundleInfoList = appList.map((app) => this.convertItemAdd(app, this.bundleInfoList));
    this.liveViewInfoList = liveViewList.map((app) => this.convertItemAdd(app, this.liveViewInfoList));
    this.callback?.(this.bundleInfoList);
    await this.liveViewAppCallback?.(this.liveViewInfoList);
  }

  private async refreshItem(uid: number): Promise<void> {
    const bundleIndex = this.bundleInfoList.findIndex((item) => item.appUid === uid);
    const liveViewIndex = this.liveViewInfoList.findIndex((item) => item.appUid === uid);
    if (bundleIndex > -1) {
      const app = await notificationSettingManager.getAppItem(uid);
      if (app) {
        this.bundleInfoList[bundleIndex] = this.convertItem(app);
        this.callback?.(this.bundleInfoList);
      }
    }
    if (liveViewIndex > -1) {
      const liveViewApp = await notificationSettingManager.getAppItem(uid);
      if (liveViewApp) {
        this.liveViewInfoList[liveViewIndex] = this.convertItem(liveViewApp);
        this.liveViewAppCallback?.(this.liveViewInfoList);
      }
    }
  }

  private onNotificationConfigChange = (event: NotificationConfigEvent): void => {
    if (!this.callback) {
      return;
    }
    if (event.type === NotificationConfigEventType.DELETE_ITEM) {
      log.showInfo(`Recieve delete item event for ${event.uid}`);
      this.bundleInfoList = this.bundleInfoList.filter((item) => item.appUid !== event.uid);
      this.liveViewInfoList = this.liveViewInfoList.filter((item) => item.appUid !== event.uid);
      this.callback?.(this.bundleInfoList);
      this.liveViewAppCallback?.(this.liveViewInfoList);
    } else if (event.type === NotificationConfigEventType.UPDATE_RESOURCE ||
      event.type === NotificationConfigEventType.CHANGE_IGNORE) {
      log.showInfo(`Recieve event ${event.type}, refresh all`);
      this.refresh();
    } else if (event.type === NotificationConfigEventType.ADD_ITEM) {
      log.showInfo(`Recieve event ${event.type}, refreshAdd`);
      this.refreshAddItem();
    } else if (event.type === NotificationConfigEventType.UPDATE_ITEM) {
      log.showInfo(`Recieve update item event, uid: ${event.config.uid}`);
      this.refreshItem(event.config.uid);
    } else if (event.type === NotificationConfigEventType.SLOT_CHANGE) {
      log.showInfo(`Recieve slot change event, uid: ${event.uid}`);
      this.querySlotAndBadgeInfo(event.uid);
    } else if (event.type === NotificationConfigEventType.BADGE_CHANGE) {
      log.showInfo(`Recieve badge change event, uid: ${event.uid}`);
      this.querySlotAndBadgeInfo(event.uid);
    } else if (event.type === NotificationConfigEventType.SILENT_NOTIFICATION) {
      log.showInfo(`Recieve silence change event, uid: ${event.uid}`);
      this.querySlotAndBadgeInfo(event.uid);
    }
  };

  private async subscribeSlotChangeEvent(): Promise<void> {
    try {
      this.commonEventSubscriber = await commonEventManager.createSubscriber({
        events: ['usual.event.SLOT_CHANGE']
      });
      commonEventManager.subscribe(this.commonEventSubscriber, async (err, event) => {
        if (err) {
          log.error(`Receive usual.event.SLOT_CHANGE error: ${err?.code} ${err?.message}`);
          return;
        }
        // 收到实况通知广播时，若实况开关未显示，则需要刷新界面显示开关，如果已显示，则刷新开关状态
        if (!event.bundleName) {
          return;
        }
        let status = await notificationManager.isNotificationSlotEnabled(
          { bundle: event.bundleName, uid: event?.parameters?.uid },
          notificationManager.SlotType.LIVE_VIEW
        );
        const uid: number | undefined = event.parameters?.uid;
        let item = this.liveViewInfoList.find((item) => item.appUid === uid);
        if (!item) {
          return;
        }
        item.appLiveViewSwitch = new StateValue(status);
        log.showInfo(`Receive usual.event.SLOT_CHANGE ${event.bundleName} ${status}`);
        await this.liveViewAppCallback?.(this.liveViewInfoList);
      });
      log.info(`Subscribe usual.event.SLOT_CHANGE success`);
    } catch (e) {
      log.error(`Subscribe usual.event.SLOT_CHANGE error: ${e?.message}`);
    }
  }

  /**
   * 销毁公共事件订阅
   */
  protected unsubscribeCommonEvent(): void {
    if (!this.commonEventSubscriber) {
      return;
    }

    try {
      commonEventManager.unsubscribe(this.commonEventSubscriber);
      this.commonEventSubscriber = undefined;
      log.info(`Unsubscribe usual.event.SLOT_CHANGE success`);
    } catch (e) {
      log.error(`Unsubscribe usual.event.SLOT_CHANGE error: ${e?.message}`);
    }
  }

  convertItem(config: NotificationConfigEntity): AppItem {
    const item = new AppItem();
    item.key = this.itemKey++;
    item.appTitle = config.label;
    item.appIcon = config.icon;
    item.appVersion = config.versionName;
    item.appBundleName = config.bundle;
    item.appUid = config.uid;
    item.systemApp = config.systemApp;
    item.appIndex = config.appIndex;
    return item;
  }

  convertItemAdd(config: NotificationConfigEntity, infoList: AppItem[]): AppItem {
    for (let item of infoList) {
      if (item.appBundleName === config.bundle && item.appUid === config.uid) {
        return item;
      }
    }
    return this.convertItem(config);
  }
}

