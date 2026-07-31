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

import { bundleManager, launcherBundleManager } from '@kit.AbilityKit';
import { notificationManager } from '@kit.NotificationKit';
import { i18n } from '@kit.LocalizationKit';
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { NotificationConfigBaseManager } from '@ohos/systemuicommon/src/main/ets/manager/NotificationConfigBaseManager';
import { NotificationConfigEntity } from '@ohos/systemuicommon/src/main/ets/model/NotificationConfigEntity';
import {
  NotificationConfigAddEvent,
  NotificationConfigChangeIgnoreEvent,
  NotificationConfigUpdateResourceEvent,
  NotificationConfigDeleteEvent,
  NotificationConfigUpdateConfigEvent,
  NotificationShowingUpdateEvent,
  ResourceUpdateType,
} from '@ohos/systemuicommon/src/main/ets/model/NotificationConfigEvent';
import { DeviceHelper,
  EvtBus, GlobalContext,
  IconResourceManager,
  PackageCommonEvent } from '@ohos/frameworkwrapper';
import {
  ExtAppConstants,
  SCBConstants,
  SettingsConstants,
  SettingsKeyConstants,
  UpdateType
} from '@ohos/commonconstants';
import {
  IconChangeEventParam,
  handleIconChangeEvent,
  NotificationConfigSyncTaskParam, syncNotificationConfig,
  syncNotificationIcon } from './NotificationConfigSyncTask';
import { taskpool } from '@kit.ArkTS';
import { notificationCcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/NotificationCcmConfig';
import { deliverSystemBundleVerity, bundleVerity } from '@ohos/systemuicommon/src/main/ets/utils/BundleVerityUtil';
import {
  BasicStatementAgreedEvent, BasicStatementAgreedSecureEvent
} from '@ohos/systemuicommon/src/main/ets/datasharemanager/SysUIDataShareEvent';
import sSettingsUtil from '@ohos/frameworkwrapper/src/main/ets/setting/SettingsUtil';
import { InnerEventUtil } from '@ohos/systemuicommon/src/main/ets/utils/InnerEventUtil';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { NotificationExceptionCode } from '../maintenance/NotificationExceptionCode';
import { commonEventManager } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';
import { NotificationUtil } from '@ohos/systemuicommon/newTsIndex';
import { ReceiveEventInfo } from '@ohos/launchercommon/src/main/ets/bean/ReceiveEventInfo';
import { LocalEventManagerAdapter } from '@ohos/systemuicommon/src/main/ets/adapter/LocalEventManagerAdapter';
import { Pinyin } from '@ohos/frameworkpinyin/src/main/ets/utils/Pinyin';
import { TablePredicates } from '@ohos/systemuicommon/src/main/ets/database/TablePredicates';
import { OutdoorVm } from '@ohos/systemuicommon/src/main/ets/vm/OutdoorVm';

interface BundleDroResource {
  label: string;
  pixelMap?: image.PixelMap;
}

const TAG = 'NotificationConfigManager';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);
const BUNDLE_FLAG = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION;

const MAX_CACHE_NUM = 10;

const DELIVER_CODE_PATH_LIST = ['1', '2'];

/**
 * 0用户ID，在所有用户下都需要显示通知设置
 */
const ZERO_USER_ID = 0;

/**
 * 默认打开通知开关的包名
 */
const NOTIFICATION_ENABLE_BUNDLES: string[] = [
  ExtAppConstants.PKG_CLOCK,
  ExtAppConstants.PKG_BETACLUB,
  'com.ohos.ouc',
  'com.ohos.callui',
];

const PKG_DELIVER_TONG: string = 'com.deliver.tong';
const DELIVER_TONG_BUNDLE_NAME: string = 'com.deliver.appstore.lite';

/**
 * 更新配置并发任务数
 */
const SYNC_CONFIG_PARALLEL_TASKS = 4;

/**
 * 通知配置管理类
 */
class NotificationConfigManager extends NotificationConfigBaseManager {
  private eventMgr = EvtBus.createEventManager();
  /**
   * 有桌面启动页的应用UID列表
   */
  private launcherUidSet: Set<number> = new Set();
  private language: string = '';

  private hiddenBundleList: string[] = [];
  private deliverSystemBundleList: string[] = [];

  /**
   * SA默认包名
   */
  private saDefaultName: string = '';

  private getAllNtf?: () => Set<number>;

  private deliverTongRes: BundleDroResource = {
    label: '',
    pixelMap: undefined
  };

  /**
   * 初始化通知配置
   * @returns
   */
  public async init(getAllNtf: () => Set<number>): Promise<void> {
    log.showInfo(`Init notification config begin`);
    try {
      this.getAllNtf = getAllNtf;
      this.language = i18n.System.getSystemLanguage();
      this.initUserId();

      await NotificationConfigEntity.initTable();
      //暂时屏蔽，因为OOBE协议目前没有，所以一直是未同意，导致这里一直卡死
      // await this.waitForAgreement();
      await this.enableAppNotification();
      await this.enableAppLiveView();
      await this.enableHiddenAppNotification();
      await this.refreshLauncherSet();
      this.subscribeIconChangeEvent();
      await taskpool.execute(syncNotificationConfig, GlobalContext.getContext(), {
        launcherUidSet: this.launcherUidSet,
        userId: this.userId,
        language: this.language,
        hiddenBundleList: notificationCcmConfig.getHiddenList(),
        deliverSystemBundleList: notificationCcmConfig.getDeliverSystemBundleList(),
      } as NotificationConfigSyncTaskParam);
      await taskpool.execute(syncNotificationIcon, GlobalContext.getContext(), []);
      this.subscribeBundleResourceChangeEvent();
      this.subscribeSlotChangeEvent();
      this.eventMgr.on(PackageCommonEvent, this.onPackageChange);
      log.showInfo(`Init notification config end`);
    } catch (e) {
      LogWithHa.error(log, `Init failed: ${e}`, NotificationExceptionCode.INIT_CONFIG_FAIL, e, 'config');
    }
  }

  /**
   * 用户同意协议与声明之后再进行应用初始化操作
   * @returns
   */
  private async waitForAgreement(): Promise<void> {
    const isAgreed = await this.getBasicStatementAgreedValue();
    log.showInfo('current agreement status:%{public}s', isAgreed);
    if (isAgreed) {
      return undefined;
    }
    let basicStatementAgreedEventClass =
      DeviceHelper.isPC() ? BasicStatementAgreedSecureEvent : BasicStatementAgreedEvent;
    return new Promise((resolve) => {
      // 每30s自行检查一次开关状态，增强健壮性。
      const intervalId = setInterval(async () => {
        const isAgreed = await this.getBasicStatementAgreedValue();
        log.showInfo('interval check agreement status:%{public}s', isAgreed);
        if (isAgreed) {
          resolve();
          InnerEventUtil.off(basicStatementAgreedEventClass, fn);
          clearInterval(intervalId);
        }
      }, 30 * 1000);

      const fn = (event: BasicStatementAgreedEvent | BasicStatementAgreedSecureEvent): void => {
        const isAgreed: boolean = event.isBasicStatementAgreedEnable();
        log.showInfo('onBasicStatementAgreedEvent, agreed status changed to: %{public}s', isAgreed);
        if (isAgreed) {
          clearInterval(intervalId);
          resolve();
          InnerEventUtil.off(basicStatementAgreedEventClass, fn);
        }
      };

      InnerEventUtil.on(basicStatementAgreedEventClass, fn);
    });
  }

  /**
   * 同意OOBE的协议与声明 PC每个用户都有独立的配置，移动设备只有一个配置
   *
   * @returns 同意OOBE的协议与声明
   */
  private async getBasicStatementAgreedValue(): Promise<boolean> {
    if (DeviceHelper.isPC()) {
      return sSettingsUtil.getSecureValue(SettingsKeyConstants.BASIC_STATEMENT_AGREED,
        SettingsConstants.OOBE_STATUS_OFF) === SettingsConstants.OOBE_STATUS_ON;
    }
    const isAgreed = await sSettingsUtil.getValueAsync(SettingsKeyConstants.BASIC_STATEMENT_AGREED,
      SettingsConstants.OOBE_STATUS_OFF);
    return isAgreed === SettingsConstants.OOBE_STATUS_ON;
  }

  public initUserId(): void {
    this.userId = this.getUserIdFromUid(GlobalContext.getContext().applicationInfo.uid);
  }

  /**
   * 销毁
   */
  public destroy(): void {
    this.eventMgr.offAll();
    this.unsubscribeCommonEvent();
  }

  /**
   * 获取通知配置
   * @param uid
   * @param bundleName 包名
   * @returns
   */
  public async getConfig(uid: number, bundleName?: string, isDeliver?: boolean):
    Promise<NotificationConfigEntity | undefined> {
    log.showInfo(`start get config for uid ${bundleName}_${uid}`);
    let config = await this.queryConfig(uid, bundleName);
    log.showInfo(`get config ${config} finish for uid ${bundleName}_${uid}`);
    if (!config) {
      LogWithHa.info(log, `db not has config, get it from bms (${bundleName}_${uid})`);
      try {
        const bundleInfo = await this.getBundleInfo(bundleName ?? '', undefined, uid);
        config = await this.createNotificationConfig(bundleInfo);
        await config?.save();
      } catch (e) {
        LogWithHa.error(log, `get config failed from bms (${bundleName}_${uid})`,
          NotificationExceptionCode.CREAT_CONFIG_FAIL, e, bundleName);
        if (bundleName && isDeliver) {
          return this.getFallbackDeliverConfig(uid, bundleName);
        }
        return undefined;
      }
    }
    if (config) {
      await this.makeSureIconIsValid(config, uid, bundleName);
    }
    return config;
  }

  private async queryConfig(uid: number, bundle?: string): Promise<NotificationConfigEntity | undefined> {
    const props: Partial<NotificationConfigEntity> = { uid } as NotificationConfigEntity;
    if (bundle) {
      props.bundle = bundle;
    }
    let config: NotificationConfigEntity | undefined = undefined;
    try {
      config = await NotificationConfigEntity.queryByProps(props);
    } catch (error) {
      LogWithHa.warn(log, `QueryConfig for ${uid}_${bundle}, error: ${error?.message}`);
    }
    return config;
  }

  private async getFallbackDeliverConfig(uid: number, bundleName: string): Promise<NotificationConfigEntity | undefined> {
    try {
      const config = await this.createDeliverNotificationConfig(bundleName, uid);
      log.showInfo(`createDeliverNotificationConfig (${bundleName}_${uid})`);
      return config;
    } catch (err) {
      log.error('fallback createDeliverNotificationConfig error', err);
    }
    return undefined;
  }

  public async isSystem(bundleName?: string): Promise<boolean> {
    if (!bundleName) {
      return false;
    }
    let config: NotificationConfigEntity | undefined;
    try {
      config = await NotificationConfigEntity.queryByProps({
        userId: this.userId,
        bundle: bundleName
      });
    } catch (e) {
      log.error(`Query config  error:`, e);
      return false;
    }
    return config?.systemApp ?? false;
  }

  /**
   * 新增一个通知配置
   * @param bundleName 包名
   * @param userId 用户ID
   * @param uid 应用uid
   * @returns
   */
  public async addConfig(bundleName: string, uid: number): Promise<NotificationConfigEntity | undefined> {
    try {
      const bundle = await this.getBundleInfo(bundleName, undefined, uid);
      const config = await this.saveNotificationConfig(bundle);
      await this.setIcon(config!, true);
      this.publishChangeEvent(new NotificationConfigAddEvent(config));
      this.checkRepeatConfig(config?.uid ?? 0);
      return config;
    } catch (e) {
      LogWithHa.error(log, `Add config for ${bundleName}_${uid} error: ${e}`,
        NotificationExceptionCode.ADD_CONFIG_FAIL, e, bundleName);
      return undefined;
    }
  }

  private subscribeIconChangeEvent(): void {
    const localEventListener: ReceiveEventInfo = {
      onReceiveEvent: (event: string, params: IconChangeEventParam) => {
        log.showInfo(`subscribeIconChangeEvent, ${event}`);
        taskpool.execute(handleIconChangeEvent, GlobalContext.getContext(), event, params, this.getAllNtf?.());
      }
    };
    LocalEventManagerAdapter.subscribeIconChangeEvent(localEventListener, TAG + '_subscribeIconChangeEvent');
  }

  public async handleIconChangeEvent(event: string, params: IconChangeEventParam,
    displayBundle?: Set<number>): Promise<void> {
    log.showInfo(`handleIconChangeEvent, ${event}, ${params?.type}, ${params?.bundleNames}`);
    if (params?.type === UpdateType.UPDATE && params?.bundleNames?.length! > 0) {
      await this.syncNotificationIcon(params.bundleNames ?? []);
      params.bundleNames?.forEach(async (bundleName) => {
        const configList = await NotificationConfigEntity.queryListByProps({ bundle: bundleName });
        configList.forEach((config) => {
          this.publishChangeEvent(new NotificationConfigUpdateConfigEvent(config));
        });
      });
    } else if (params?.type === UpdateType.FULL) {
      await this.syncNotificationIcon([], displayBundle);
      this.publishChangeEvent(new NotificationConfigUpdateResourceEvent(ResourceUpdateType.ICON_CHANGE, displayBundle));
    }
  }

  private async setIcon(config: NotificationConfigEntity, isSave: boolean = false): Promise<void> {
    if (config.bundleType === bundleManager.BundleType.ATOMIC_SERVICE) {
      return;
    }
    const icon = await IconResourceManager.getInstance()
      .getIconBase64Batch([config?.bundle], config?.isDeliver, OutdoorVm.instance.isEnabledOutdoorMode());
    if (icon?.hasKey(config?.bundle)) {
      config.icon = icon.get(config?.bundle);
      log.showInfo(`get icon from iconResourceManager success, isSave: ${isSave}, ${config?.bundle}, ${config.icon}`);
      if (isSave) {
        await config.save();
      }
      return;
    }
    log.showInfo(`get icon from iconResourceManager fail`);
  }

  public async syncNotificationIcon(bundleList: Array<string>, displayUid?: Set<number>): Promise<void> {
    const lowPriorityCommonBundles: string[] = [];
    const lowPriorityDeliverBundles: string[] = [];
    const highPriorityCommonBundles: string[] = [];
    const highPriorityDeliverBundles: string[] = [];
    let predicates: TablePredicates<NotificationConfigEntity>;
    if (!bundleList || bundleList.length === 0) {
      log.showInfo(`Sync all bundle icon.`);
      predicates = NotificationConfigEntity.getPredicates()
        .inCondition({ userId: [this.userId, 0] });

    } else {
      predicates = NotificationConfigEntity.getPredicates()
        .inCondition({ bundle: bundleList });
    }
    const configList = await NotificationConfigEntity.queryList(predicates);
    log.showInfo(`get bundle, ${configList.length}`);
    configList.filter(config => config.bundleType !== bundleManager.BundleType.ATOMIC_SERVICE)
      .forEach(config => {
        if (displayUid?.has(config.uid)) {
          config.isDeliver ? highPriorityDeliverBundles.push(config.bundle) : highPriorityCommonBundles.push(config.bundle);
        } else {
          config.isDeliver ? lowPriorityDeliverBundles.push(config.bundle) : lowPriorityCommonBundles.push(config.bundle);
        }
      });
    if (displayUid?.size! > 0) {
      await this.syncIconFromIconResourceManager(highPriorityCommonBundles);
      await this.syncIconFromIconResourceManager(highPriorityDeliverBundles, true);
      this.syncDisplayFinish();
    }
    await this.syncIconFromIconResourceManager(lowPriorityCommonBundles);
    await this.syncIconFromIconResourceManager(lowPriorityDeliverBundles, true);
  }

  private async syncIconFromIconResourceManager(bundleList: Array<string>, isDeliver: boolean = false): Promise<void> {
    log.showInfo(`get icon start, ${bundleList.length}`);
    bundleList = bundleList.filter((bundle, index) => bundleList.indexOf(bundle) === index);
    try {
      const iconMap = await IconResourceManager.getInstance()
        .getIconBase64Batch(bundleList, isDeliver, OutdoorVm.instance.isEnabledOutdoorMode());
      log.showInfo(`get icon end, ${iconMap?.length}`);
      await Promise.allSettled(bundleList.map(async (bundle) => {
        const icon = iconMap.get(bundle);
        if (icon?.length > 0) {
          const predicates = NotificationConfigEntity.getPredicates()
            .equalTo({ bundle: bundle });
          await NotificationConfigEntity.update({ icon: icon }, predicates);
          log.showInfo(`update icon result: ${bundle}, ${icon?.length}`);
          return;
        }
        log.showInfo(`update icon failed, ${bundle}`);
      }));
    } catch (e) {
      LogWithHa.error(log, `get iconMap failed from IconResourceManager, error: ${e}`);
    }
  }

  /**
   * 同步通知配置信息：
   * 1、从BMS查询所有包信息
   * 2、查询图标和名称信息
   * 3、存入本地数据库
   *
   * 注意：该方法仅提供给taskpool使用
   */
  public async syncNotificationConfig(param: NotificationConfigSyncTaskParam): Promise<void> {
    this.launcherUidSet = param.launcherUidSet;
    this.userId = param.userId;
    this.language = param.language;
    this.hiddenBundleList = param.hiddenBundleList;
    this.deliverSystemBundleList = param.deliverSystemBundleList;
    log.showInfo(`Sync notification config with userid ${this.userId} begin, displayBundle ${param.displayUid?.size}`);

    // 开始批量处理, 避免重复打开关闭数据库, 即使开启失败也不会影响后续的正常处理
    const beginBatchSuccess = await NotificationConfigEntity.beginBatch();
    try {
      const predicates = NotificationConfigEntity.getPredicates();
      predicates.inCondition({ userId: [this.userId, ZERO_USER_ID] });
      const configList = await NotificationConfigEntity.queryList(predicates);
      const bundleList = await bundleManager.getAllBundleInfo(BUNDLE_FLAG, this.userId);
      const bundleSet = new Set<number>();
      // 正在展示的通知，优先查询配置并更新
      const highPriorityBundles: bundleManager.BundleInfo[] = [];
      const lowPriorityBundles: bundleManager.BundleInfo[] = [];
      const highPriorityConfigs: NotificationConfigEntity[] = [];
      const lowPriorityConfigs: NotificationConfigEntity[] = [];
      // 应用识别到到高、低优先级列表中
      this.identifyPriorityBundles(bundleList, highPriorityBundles, lowPriorityBundles, param.displayUid);
      this.identifyPriorityConfigs(configList, highPriorityConfigs, lowPriorityConfigs, param.displayUid);

      // 处理高优先级应用列表
      TraceUtil.startTrace(DomainName.SYS_UI, 'syncHighPriorityBundles');
      await this.syncBundleConfigs(highPriorityBundles, highPriorityConfigs, bundleSet, param.eventType,
        (param.displayUid?.size ?? 0) > 0);
      TraceUtil.endTrace(DomainName.SYS_UI, 'syncHighPriorityBundles');

      // 处理低优先级应用列表
      TraceUtil.startTrace(DomainName.SYS_UI, 'syncLowPriorityBundles');
      await this.syncBundleConfigs(lowPriorityBundles, lowPriorityConfigs, bundleSet, param.eventType);
      TraceUtil.endTrace(DomainName.SYS_UI, 'syncLowPriorityBundles');

      // 删除本地数据库中不存在包管理的应用配置
      const deleteConfigList = configList.filter((c) => !bundleSet.has(c.uid));
      if (deleteConfigList.length) {
        let lastBundle = deleteConfigList[deleteConfigList.length - 1];
        log.showInfo(`Delete notification latest: userId=${this.userId}, bundle=${lastBundle.bundle}_${lastBundle.uid}}`);
        const deletePredicates = NotificationConfigEntity.getPredicates();
        deletePredicates.inCondition({ id: deleteConfigList.map((c) => c.id) });
        await NotificationConfigEntity.delete(deletePredicates);
        log.showInfo(`Delete notification config uids: ${deleteConfigList.map((c) => c.uid)}`);
      }
      let resultCount = await NotificationConfigEntity.queryCount(predicates);
      log.showInfo(`Sync notification config with userid ${this.userId} end, config list: ${configList?.
      length}, deleteConfigList: ${deleteConfigList?.length}, result count: ${resultCount}`);
    } catch (e) {
      LogWithHa.error(log, `Sync notification config with userid ${this.userId}, error: ${e}`,
        NotificationExceptionCode.SYNC_CONFIG_FAIL, e, 'config');
    } finally {
      // 结束批量处理, 释放数据库连接
      if (beginBatchSuccess) {
        await NotificationConfigEntity.endBatch();
      }
    }
  }

  /**
   * 根据优先级识别出待解析的应用列表
   * @param bundleList          待处理查询的应用列表
   * @param highPriorityBundles 高优先级待处理应用列表
   * @param lowPriorityBundles  低优先级待处理应用列表
   * @param displayUid          通知中心当前展示的应用UID集合
   */
  private identifyPriorityBundles(bundleList: bundleManager.BundleInfo[],
    highPriorityBundles: bundleManager.BundleInfo[], lowPriorityBundles: bundleManager.BundleInfo[],
    displayUid?: Set<number>): void {
    bundleList.forEach((bundle) => {
      if (displayUid?.has(bundle.appInfo.uid)) {
        highPriorityBundles.push(bundle);
      } else {
        lowPriorityBundles.push(bundle);
      }
    });
  }

  /**
   * 根据优先级识别出待解析的配置列表
   * @param configList          数据库中查询的配置列表
   * @param highPriorityConfigs 高优先级待处理配置列表
   * @param lowPriorityConfigs  低优先级待处理配置列表
   * @param displayUid          通知中心当前展示的应用UID集合
   */
  private identifyPriorityConfigs(configList: NotificationConfigEntity[],
    highPriorityConfigs: NotificationConfigEntity[], lowPriorityConfigs: NotificationConfigEntity[],
    displayUid?: Set<number>): void {
    // 应用列表: 环境未启动bundleList中没有应用,需同步应用通知
    if (NotificationUtil.isDeliverNotStarted()) {
      configList.forEach((config) => {
        if (!config.isDeliver) {
          return;
        }
        if (displayUid?.has(config.uid)) {
          highPriorityConfigs.push(config);
        } else {
          lowPriorityConfigs.push(config);
        }
      });
    }
  }

  /**
   * 同步应用列表的配置信息
   * @param bundleList      待处理的应用列表
   * @param configList      待处理的配置列表
   * @param bundleSet       应用ID集合
   * @param eventType       事件类型
   * @param sendData        数据处理完后是否发送事件
   */
  private async syncBundleConfigs(bundleList: bundleManager.BundleInfo[], configList: NotificationConfigEntity[],
    bundleSet: Set<number>, eventType?: number, sendData?: boolean): Promise<void> {

    // 1.处理应用列表
    await this.parallelSyncConfigs(bundleList, async (bundle): Promise<void> => {
      bundleSet.add(bundle.appInfo.uid);
      const props: Partial<NotificationConfigEntity> = { uid: bundle.appInfo.uid } as NotificationConfigEntity;
      if (bundle.appInfo.name) {
        props.bundle = bundle.appInfo.name;
      }
      const config = await NotificationConfigEntity.queryByProps(props);
      await this.saveNotificationConfig(bundle, config, eventType);
    });

    // 2.处理配置列表
    await this.parallelSyncConfigs(configList, async (config): Promise<void> => {
      bundleSet.add(config.uid);
      await this.saveNotificationConfig(undefined, config);
    });
    log.showInfo(`syncBundleConfigs bundleList: ${bundleList.length} configList: ${configList.length} finished!`);

    // 处理完成后是否需要使用taskpool发送事件
    if (sendData) {
      try {
        log.showInfo(`syncBundleConfigs taskpool.Task.sendData`);
        taskpool.Task.sendData(eventType);
      } catch (e) {
        log.showError(`syncBundleConfigs taskpool.Task.sendData err, code:${e?.code}, msg:${e?.message}`);
      }
    }
  }

  /**
   * 使用并行异步任务同步相关配置
   * @param list          待处理的配置列表
   * @param handle        处理函数
   * @returns
   */
  private async parallelSyncConfigs<T>(list: Array<T>, handle: (item: T) => Promise<void>): Promise<void> {
    if (!list.length) {
      return;
    }

    // 判断list是否小于等于并行任务数量
    if (list.length <= SYNC_CONFIG_PARALLEL_TASKS) {
      // 遍历每一个包，检查是否需要同步到本地数据库
      await Promise.allSettled(list.map(async (item) => {
        await handle(item);
      }));
    } else {
      // 将list拆分成多个子数组, 使用SYNC_CONFIG_PARALLEL_TASKS个并发任务来更新配置信息
      const len = Math.ceil(list.length / SYNC_CONFIG_PARALLEL_TASKS);
      const subLists: T[][] = [];
      for (let i = 0; i < SYNC_CONFIG_PARALLEL_TASKS; i++) {
        subLists.push(list.slice(i * len, (i + 1) * len));
      }
      await Promise.allSettled(subLists.map(async (subList) => {
        for (const item of subList) {
          await handle(item);
        }
      }));
    }
  }

  /**
   * 设置通知配置为显示状态
   * @param config
   * @returns
   */
  public async showConfig(config: NotificationConfigEntity): Promise<void> {
    if (config.settingIgnore && !await this.isSettingIgnore(config)) {
      config.settingIgnore = false;
      await config.save();
      this.publishChangeEvent(new NotificationConfigChangeIgnoreEvent(config));
    }
  }

  /**
   * 刷新启动页列表
   * @returns
   */
  private async refreshLauncherSet(): Promise<void> {
    try {
      this.launcherUidSet.clear();
      const currentUserLaunchers = await launcherBundleManager.getAllLauncherAbilityInfo(this.userId);
      const zeroUserLaunchers = await launcherBundleManager.getAllLauncherAbilityInfo(ZERO_USER_ID);
      currentUserLaunchers.concat(zeroUserLaunchers).forEach((v) => this.launcherUidSet.add(v.applicationInfo.uid));
    } catch (e) {
      log.error(`Refresh launcher list error:`, e);
    }
  }

  /**
   * 创建通知配置
   */
  private async createNotificationConfig(bundle: bundleManager.BundleInfo):
    Promise<NotificationConfigEntity | undefined> {
    const config = new NotificationConfigEntity();
    config.bundle = bundle.name;
    config.userId = this.getUserIdFromUid(bundle.appInfo.uid);
    config.uid = bundle.appInfo.uid;
    config.bundleType = bundle.appInfo.bundleType;
    config.versionName = bundle.versionName;
    config.language = this.language;
    config.systemApp = bundle.appInfo.systemApp;
    config.isDeliver = DELIVER_CODE_PATH_LIST.includes(bundle.appInfo.codePath);
    config.isdeliverApp = bundle.appInfo.installSource === DELIVER_TONG_BUNDLE_NAME;
    config.settingIgnore = await this.isSettingIgnore(config);
     if (bundle.name === ExtAppConstants.PKG_BETACLUB) {
      config.pinTop = true;
    }
    if (!config.isDeliver) {
      const appIndex = await this.getAppIndex(bundle.appInfo.uid);
      if (appIndex === -1) {
        return undefined;
      }
      config.appIndex = appIndex;
    }
    await this.setIconAndLabel(config);
    await this.setIcon(config);
    return config;
  }

  /**
   * 创建临时通知配置
   */
  private async createDeliverNotificationConfig(bundleName: string, uid: number): Promise<NotificationConfigEntity> {
    const config = new NotificationConfigEntity();
    config.bundle = bundleName;
    config.userId = this.getUserIdFromUid(uid);
    config.uid = uid;
    config.bundleType = 0;
    config.versionName = '';
    config.language = this.language;
    config.systemApp = false;
    config.isDeliver = true;
    config.settingIgnore = true;
    config.pinTop = false;
    config.appIndex = 0;
    await this.setIconAndLabel(config);
    await this.setIcon(config);
    return config;
  }

  /**
   * 保存通知配置,环境未启动没有包信息只能更新配置
   */
  private async saveNotificationConfig(
    bundle?: bundleManager.BundleInfo,
    config?: NotificationConfigEntity,
    eventType?: number,
  ): Promise<NotificationConfigEntity | undefined> {
    const bundleName = bundle ? bundle.name : config?.bundle;
    const uid = bundle ? bundle.appInfo.uid : config?.uid;
    try {
      if (!config) {
        if (bundle) {
          config = await this.createNotificationConfig(bundle);
          // 直接保存
          await config?.save();
          log.showInfo(`Save insert ${bundleName}_${uid} notificatication config success`);
        }
      } else {
        // 复制应用配置
        const oldConfig = ObjectCopyUtil.deepClone(config, new NotificationConfigEntity());

        config.versionName = bundle?.versionName ?? config.versionName;
        config.language = this.language;
        config.settingIgnore = await this.isSettingIgnore(config);
        if (bundle) {
          config.isdeliverApp = bundle.appInfo?.installSource === DELIVER_TONG_BUNDLE_NAME;
        }
        await this.setIconAndLabel(config, eventType);
        // 比较数据是否发生变化
        if (!config.equals(oldConfig)) {
          // 更新应用配置,不更新图标
          await NotificationConfigEntity.updateByProps(config, { id: config.id },
            ['versionName', 'language', 'settingIgnore', 'label', 'isdeliverApp', 'sortTag']);
          log.showInfo(`Save update ${config.bundle}_${config.uid} notificatication config success`);
        }
      }
    } catch (e) {
      LogWithHa.error(log, `Save ${bundleName}_${uid} notificatication config error: ${e}`,
        NotificationExceptionCode.SAVE_CONFIG_FAIL, e, bundleName);
    }
    return config;
  }

  private async setIconAndLabel(config: NotificationConfigEntity, eventType?: number): Promise<void> {
    const bundleName = config.bundle;
    const bundleType = config.bundleType;
    const isDeliver = config.isDeliver;
    // 语言更新不用刷新图标，非元服务应用从三缓获取图标不从bundleResource获取
    const parseIcon = eventType !== ResourceUpdateType.LANGUAGE_CHANGE &&
      bundleType === bundleManager.BundleType.ATOMIC_SERVICE;
    let iconAndLabel = await this.getAppResource(GlobalContext.getContext(), bundleName, bundleType, isDeliver, parseIcon);
    config.label = iconAndLabel.label;
    if (parseIcon) {
      config.icon = iconAndLabel.icon;
    }
    config.sortTag = this.getSortTag(config.label, config.appIndex);
  }

  private getSortTag(label: string, appIndex: number): string {
    const isZh = this.language.includes('zh');
    const pinyinUtil: Pinyin = new Pinyin();

    let pinyin: string = pinyinUtil.getFullChars(label);
    if (label.charCodeAt(0) > 255) {
      // 拼音中间用空格分开
      pinyin = pinyin.replace(/[A-Z]/g, ' $&').trim();
    }

    let sortTag = pinyin;
    // 中文排序下，将英文排在中文后面（通过添加在Z字母后面的[字符来实现）
    if (isZh && label.charCodeAt(0) <= 255) {
      sortTag = `${sortTag[0]}[${sortTag.slice(1)}`;
    } else if (!isZh && label.charCodeAt(0) > 255) { // 非中文排序下，中文排序到前面（通过添加空格字在前面来实现）
      sortTag = ` ${sortTag}`;
    }
    return sortTag.toUpperCase() + ' ' + appIndex;
  }

  /**
   * 是否忽略在通知管理列表中显示
   * @param config
   * @returns
   */
  private async isSettingIgnore(config: NotificationConfigEntity): Promise<boolean> {
    // 隐藏通知设置入口白名单
    if (this.hiddenBundleList.includes(config.bundle) && await bundleVerity(config.bundle)) {
      log.showInfo(`Bundle ${config.bundle}_${config.uid} has hide entrance privilege, ignore setting.`);
      return true;
    }

    // 没有桌面图标或者没发送过通知，则隐藏通知设置入口
    if (!await this.hasLauncherOrSlot(config.bundle, config.uid)) {
      log.showInfo(`Bundle ${config.bundle}_${config.uid} has no launcher or slot, ignore setting.`);
      return true;
    }

    // 隐藏系统应用的设置入口。通过uid进行系统校验，uid % 100000 < 10000的是系统应用
    if (this.deliverSystemBundleList.includes(config.bundle) && deliverSystemBundleVerity(config.uid)) {
      log.showInfo(`Deliver system app, ignore setting.`);
      return true;
    }

    return false;
  }

  /**
   * 检查应用是否有桌面图标或者设置过通知渠道(排除实况，实况开关不在通知管理页面)
   */
  private async hasLauncherOrSlot(bundleName: string, uid: number): Promise<boolean> {
    if (this.launcherUidSet.has(uid)) {
      return true;
    }
    const slots = await notificationManager.getSlotsByBundle({ bundle: bundleName, uid: uid });
    const slotNum = slots.filter((slot) => slot.notificationType !== notificationManager.SlotType.LIVE_VIEW).length;
    return slotNum > 0;
  }

  /**
   * 检查数据库中是否有重复的数据，有则删除老的数据
   */
  private async checkRepeatConfig(uid: number): Promise<void> {
    try {
      const predicates = NotificationConfigEntity.getPredicates();
      predicates.equalTo({ uid: uid });
      predicates.orderByAsc('id');
      const list = await NotificationConfigEntity.queryList(predicates, {
        columns: ['id'],
      });
      const deleteConfigList = list.filter((config) => config.id);
      if (deleteConfigList.length > 1) {
        for (const deleteConfig of list.slice(0, deleteConfigList.length - 1)) {
          await deleteConfig.delete();
          log.showInfo(`Delete repeat config for ${uid}, id: ${deleteConfig.id}`);
        }
      }
    } catch (e) {
      LogWithHa.error(log, `Check repeat config for ${uid} error: ${e}`,
        NotificationExceptionCode.CHECK_REPEAT_FAIL, e, 'config');
    }
  }

  /**
   * 订阅包资源更新事件，更新应用名称
   */
  private async subscribeBundleResourceChangeEvent(): Promise<void> {
    this.subscribeCommonEvent({
      events: ['usual.event.BUNDLE_RESOURCES_CHANGED'],
      publisherPermission: 'ohos.permission.GET_BUNDLE_RESOURCES',
    }, async (event) => {
      log.info(`Receive bundle resouce change event, params:`, event);
      if (!this.isUpdateConfig(event)) {
        return;
      }
      this.language = i18n.System.getSystemLanguage();
      this.refreshSADefaultName();
      const displayBundle = this.getAllNtf?.();
      const task: taskpool.Task = new taskpool.Task(syncNotificationConfig, GlobalContext.getContext(), {
        launcherUidSet: this.launcherUidSet,
        userId: this.userId,
        language: this.language,
        hiddenBundleList: notificationCcmConfig.getHiddenList(),
        deliverSystemBundleList: notificationCcmConfig.getDeliverSystemBundleList(),
        displayUid: displayBundle,
        eventType: event?.parameters?.bundleResourceChangeType,
      } as NotificationConfigSyncTaskParam);
      task.onReceiveData(this.syncDisplayFinish);
      await taskpool.execute(task);
      // 正在展示的包已经处理过，发送全量update事件时标志重复uid
      this.publishChangeEvent(new NotificationConfigUpdateResourceEvent(event?.parameters?.bundleResourceChangeType ??
      ResourceUpdateType.UNKNOWN, displayBundle));
    });
  }

  private syncDisplayFinish = (resourceUpdateType?: ResourceUpdateType): void => {
    log.showInfo(`sync high priority config finish`);
    this.publishChangeEvent(new NotificationShowingUpdateEvent(resourceUpdateType ?? ResourceUpdateType.UNKNOWN));
  };

  private isUpdateConfig(event: commonEventManager.CommonEventData): boolean {
    if (!event?.parameters) {
      return false;
    }
    // 切换语言（type = 1）时，不区分用户，都刷新配置。
    if (event.parameters.bundleResourceChangeType === 1) {
      return true;
    }
    // 不是当前用户，不刷新配置
    if (event.parameters.userId !== this.userId) {
      return false;
    }
    // 切换主题（type = 16）才刷新配置
    if (event.parameters.bundleResourceChangeType === 16) {
      return true;
    }
    return false;
  }

  /**
   * 订阅通知渠道变化事件，需要新增配置
   */
  private async subscribeSlotChangeEvent(): Promise<void> {
    this.subscribeCommonEvent({
      events: ['usual.event.SLOT_CHANGE'],
    }, async (event): Promise<void> => {
      const uid: number | undefined = event.parameters?.uid;
      if (typeof uid !== 'number') {
        log.error(`Handle slot change event error cause uid is invalid:`, event);
        return;
      }
      log.showInfo(`Handle slot change event for ${event.bundleName}_${uid} begin`);
      try {
        const config = await NotificationConfigEntity.queryByProps({ uid });
        // 如果本地库没有该应用的通知配置需要入库，有则检测是否需要更新配置忽略
        if (!config) {
          await this.addConfig(event.bundleName ?? '', uid);
        } else {
          await this.showConfig(config);
        }
        log.showInfo(`Handle slot change event for ${event.bundleName}_${uid} end`);
      } catch (e) {
        LogWithHa.error(log, `Handle slot change event for ${event.bundleName}_${event.parameters?.uid} error: ${e}`,
          NotificationExceptionCode.SLOT_CHANGE_FAIL, e, event.bundleName);
      }
    });
  }

  /**
   * 应用包变化时,更新启动页列表
   * 1. 安装时,如果应用配置了启动页信息,将应用的uid添加到launcherUidSet
   * 2. 应用升级时,如果可以查询到配置的启动页信息,添加uid到launcherUidSet, 否则尝试删除. (应用升级有可能变更启动页配置,导致桌面入口发生变化)
   * @param event 包变化事件
   */
  private updateAppLauncherInfo(event: PackageCommonEvent): void {
    if (event.uid === undefined) {
      log.showInfo(`uid is undefined, refresh launcher info of ${event.bundleName}`);
      return;
    }
    try {
      const launcherInfos = launcherBundleManager.getLauncherAbilityInfoSync(event.bundleName, this.userId);
      if (launcherInfos.length > 0) {
        this.launcherUidSet.add(event.uid);
      } else {
        this.launcherUidSet.delete(event.uid);
      }
    } catch (e) {
      log.showError(`refresh launcher info of ${event.bundleName} err, code:${e?.code}, msg:${e?.message}`);
    }
  }

  /**
   * 应用包变化事件
   */
  private onPackageChange = async (event: PackageCommonEvent): Promise<void> => {
    if (event.uid === undefined) {
      log.showInfo(`uid is undefined, Handle package event ${event.event} for ${event.bundleName}`);
      return;
    }
    try {
      log.showInfo(`Handle package event ${event.event} for ${event.bundleName}_${event.uid}`);
      switch (event.event) {
        // 包安装
        case PackageCommonEvent.EVENT_PACKAGE_ADD:
          this.updateAppLauncherInfo(event);
          await this.addConfig(event.bundleName ?? '', event.uid);
          break;
        // 包更新
        case PackageCommonEvent.EVENT_PACKAGE_REPLACED:
        case PackageCommonEvent.EVENT_PACKAGE_CHANGED:
        case PackageCommonEvent.EVENT_DYNAMIC_ICON_CHANGED:
          this.updateAppLauncherInfo(event);
          await this.updateConfigs(event.bundleName ?? '', event.uid);
          break;
        // 包删除
        case PackageCommonEvent.EVENT_PACKAGE_REMOVED:
        case PackageCommonEvent.EVENT_PACKAGE_FULL_REMOVED:
          this.launcherUidSet.delete(event.uid);
          const result = await NotificationConfigEntity.deleteByProps({ uid: event.uid });
          this.publishChangeEvent(new NotificationConfigDeleteEvent(event.uid));
          log.showInfo(`Delete notification config for ${event.bundleName}_${event.uid} result: ${result}`);
          break;
        default:
          break;
      }
    } catch (e) {
      LogWithHa.error(log, `Handle package event ${event.event} for ${event.bundleName}_${event.uid} error: ${e}`,
        NotificationExceptionCode.PACKAGE_CHANGE_FAIL, e, event.bundleName);
    }
  };

  /**
   * 打开默认应用通知开关
   */
  private async enableAppNotification(): Promise<void> {
    await Promise.all(NOTIFICATION_ENABLE_BUNDLES.map(async (bundle) => {
      if (!await bundleVerity(bundle)) {
        log.showInfo(`Enable notification for ${bundle} verity failed`);
        return;
      }
      notificationManager.setNotificationEnable({ bundle }, true).then(() => {
        log.showInfo(`Enable notification for ${bundle} success`);
      }, (err: Error) => {
        LogWithHa.error(log, `Enable notification for ${bundle} error: ${err}`,
          NotificationExceptionCode.SET_ENABLE_FAIL, err, bundle);
      });
    }));
  }

  /**
   * 隐藏实况开关的应用要默认打开实况开关
   */
  private async enableAppLiveView(): Promise<void> {
    await notificationCcmConfig.initFinished;
    await Promise.all(notificationCcmConfig.getLiveViewHiddenSwitchList().map((bundle) => {
      return notificationManager.setNotificationEnableSlot(
        { bundle: bundle },
        notificationManager.SlotType.LIVE_VIEW,
        true,
        true,
      ).then(() => {
        log.showInfo(`Enable AppLiveView for ${bundle} success`);
      }, (err: Error) => {
        LogWithHa.error(log, `Enable AppLiveView for ${bundle} error: ${err}`,
          NotificationExceptionCode.SET_HIDDEN_ENABLE_LIVE_FAIL, err, bundle);
      });
    }));
  }

  /**
   * 隐藏通知入口的应用要默认打开通知开关
   */
  private async enableHiddenAppNotification(): Promise<void> {
    await notificationCcmConfig.initFinished;
    this.hiddenBundleList = notificationCcmConfig.getHiddenList();
    this.deliverSystemBundleList = notificationCcmConfig.getDeliverSystemBundleList();
    await Promise.all(notificationCcmConfig.getHiddenList().map((bundle) => {
      return notificationManager.setNotificationEnable({ bundle: bundle }, true).then(() => {
        log.showInfo('Enable AppNotification for %{public}s success.', bundle);
      }, (err: Error) => {
        LogWithHa.error(log, `${TAG} --> Enable AppNotification for ${bundle} error: ${err}`,
          NotificationExceptionCode.SET_HIDDEN_ENABLE_FAIL, err, bundle);
      });
    }));
  }

  public async getBundleInfo(bundle: string, appIndex?: number, uid?: number): Promise<bundleManager.BundleInfo> {
    if (appIndex === undefined && uid !== undefined) {
      appIndex = await this.getAppIndex(uid);
    }
    if ((appIndex ?? 0) > 0) {
      return bundleManager.getAppCloneBundleInfo(bundle, appIndex, BUNDLE_FLAG);
    } else {
      return bundleManager.getBundleInfo(bundle, BUNDLE_FLAG);
    }
  }

  /**
   * 更新应用时，只会发送主应用的更新事件，需要根据包名连锁更新分身应用的应用信息
   * @param bundle 包名
   * @returns
   */
  private async updateConfigs(bundle: string, uid: number): Promise<void> {
    let appConfigs = await NotificationConfigEntity.queryListByProps({ bundle: bundle });
    log.showInfo('update appConfigs.length:%{public}d', appConfigs.length);
    // BMS安装已卸载的预置应用时，需要先恢复预置版本的安装，然后继续安装应用；
    // 会导致安装的时候查询不到应用信息，需要在应用更新的时候再查询一次
    if (appConfigs.length === 0) {
      log.showInfo(`add config again, bundle: ${bundle} uid: ${uid}`);
      await this.addConfig(bundle, uid);
      return;
    }
    for (let config of appConfigs) {
      this.updateConfig(config);
    }
  }

  private async updateConfig(config: NotificationConfigEntity): Promise<void> {
    let bundle: bundleManager.BundleInfo | undefined;
    try {
      if (config.appIndex > 0) {
        bundle = await bundleManager.getAppCloneBundleInfo(config.bundle, config.appIndex, BUNDLE_FLAG);
      } else {
        bundle = await bundleManager.getBundleInfo(config.bundle, BUNDLE_FLAG);
      }
    } catch (e) {
      LogWithHa.error(log, `NotificationConfigManager --> get bundle info err: ${e}`,
        NotificationExceptionCode.GET_BUNDLE_FAIL, e, 'config');
    }

    if (bundle) {
      log.showInfo('update %{public}s(index:%{public}d) from [versionName:%{public}s, language:%{public}s] to [versionName:%{public}s, language:%{public}s]',
        config.bundle, config.appIndex, config.versionName, config.language, bundle.versionName, this.language);
      config.versionName = bundle.versionName;
      config.language = this.language;
      config.settingIgnore = await this.isSettingIgnore(config);
      config.isdeliverApp = bundle.appInfo.installSource === DELIVER_TONG_BUNDLE_NAME;
      await this.setIconAndLabel(config);
      await this.setIcon(config);
      await config.save();
      this.publishChangeEvent(new NotificationConfigUpdateConfigEvent(config));
    }
  }

  /**
   * 获取应用分身索引号
   */
  private async getAppIndex(uid: number): Promise<number> {
    try {
      return (await bundleManager.getAppCloneIdentity(uid))?.appIndex ?? 0;
    } catch (e) {
      LogWithHa.error(log, `Get app index for ${uid} error: ${e}`, NotificationExceptionCode.GET_APP_INDEX_FAIL, e, 'config');
      return -1;
    }
  }

  private async makeSureIconIsValid(config: NotificationConfigEntity, uid: number, bundleName?: string): Promise<void> {
    log.showInfo(`start make sure IconIsValid for ${bundleName}_${uid}, icon ${config.icon}`);
    if (bundleName && !config.icon) {
      try {
        await this.setIconAndLabel(config);
        await this.setIcon(config);
        await config.save();
        log.showInfo(`Add config for ${bundleName}_${uid} success, icon is valid:${Boolean(config.icon)}`);
      } catch (e) {
        LogWithHa.error(log, `Add config for ${bundleName}_${uid} error: ${e}`,
          NotificationExceptionCode.ICON_CONFIG_FAIL, e, bundleName);
      }
    }
  }

  private refreshSADefaultName(): void {
    try {
      this.saDefaultName = GlobalContext.getContext().resourceManager.getStringSync($r('app.string.sa_default_name'));
    } catch (e) {
      log.showError('refresh SA default name error');
    }
  }

  public getSADefaultName(): string {
    if (!this.saDefaultName) {
      this.refreshSADefaultName();
    }
    return this.saDefaultName;
  }
}

export const notificationConfigManager = new NotificationConfigManager();