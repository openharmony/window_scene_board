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

import { AggregateContent, NotificationEntry, UnifiedGroupEventEntry, UnifiedGroupStatus } from './NotificationEntry';
import { ntfMgr } from './NotificationManager';
import { NotificationPanelManager } from './NotificationPanelManager';
import {
  NotificationEntryEvent,
  NtfStatusIconEvent,
  NtfUnreadEvent,
  UnifiedGroupRemindEvent,
} from '../common/event/NotificationEvent';
import { NotificationType } from '../common/NotificationType';
import { NotificationListAdapter, NtfDataChangeType } from '../model/NotificationListAdapter';
import {
  LogDomain,
  LogHelper,
  ArrayUtils,
  CommonUtils,
  AppStorageUtil,
  DataProperty
} from '@ohos/basicutils';
import { WindowConstants, DeviceModeEnum } from '@ohos/commonconstants';
import { RectInfo } from '@ohos/basicutils';
import {
  DisplayEvent,
  DisplayMgr,
  ResUtils,
  SCBPropertyChangeReason,
  SCBScreenProperty,
  SCBScreenSessionManager,
  windowMgr
} from '@ohos/windowscene';
import {
  CustomPromise,
  CutoutEvent,
  DeviceHelper,
  EventConstants,
  EvtBus,
  EventManager,
  GlobalContext,
  obtainLocalEvent,
  sEventManager,
  unsubscribe,
  IconRedHotEvent,
  PluginSlot,
  WindowEvent,
  ViewManagerPolicy,
  ViewType,
  ScreenLockEvent
} from '@ohos/frameworkwrapper';
import screenSessionManager from '@ohos.screenSessionManager';
import Display from '@ohos.display';
import { LiveViewHelper } from '@ohos/systemuicommon/Index';
import { DeviceState } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { CommonConstants } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { GridConstants } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { AppLockManager } from '@ohos/launchercommon/src/main/ets/manager/AppLockManager';
import { AppLockStatusEnum } from '@ohos/launchercommon/src/main/ets/manager/AppLockManager';
import { NotificationListStyle } from '../vm/style/NotificationListStyle';
import { UnifiedGroupEnableEvent } from '@ohos/systemuicommon/src/main/ets/datasharemanager/SysUIDataShareEvent';
import { DropDownPanelConstants } from '@ohos/systemuicommon/Index';
import { ntfListener } from './NotificationListener';
import { notificationManager } from '@kit.NotificationKit';
import { process } from '@kit.ArkTS';
import {
  getIsInEmergencyOrThermalSafeMode,
  NotificationConfigEntity,
  NotificationConfigEvent,
  NotificationConfigEventType,
  NotificationSysEventReporter,
  HeadsUpChangeEvent,
  NtfHideContentEvent,
  notificationCcmConfig,
  NotificationCreatorType,
  ImmersiveSysEventUtils,
  OverlayIconStyle,
  ResourceUpdateType,
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { PowerUtils } from '@ohos/screenlockcommon/src/main/ets/utils/PowerUtils';
import { notificationConfigManager } from '../manager/NotificationConfigManager';
import { ntfViewConfigManager } from '../vm/config/NtfViewConfigManager';
import { DropdownController } from '@ohos/systemuicommon/src/main/ets/template/DropdownController';
import { NtfListContentConfig } from '../vm/config/NtfViewConfig';
import sDropDownPanelManager from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import { DeleteNotificationMaintenance } from '@ohos/systemuicommon/src/main/ets/maintenance/DeleteNotificationMaintenance';
import { DeleteNotificationType } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { HdsIconTaskUtil, IconInfo } from '@ohos/systemuicommon/src/main/ets/utils/HdsIconTaskUtil';
import { RefreshStatusNotification, REFRESH_STATUS_BAR_NTF } from '../vm/phone/PhoneNtfHeadsUpVM';
import { systemDateTime } from '@kit.BasicServicesKit';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import display from '@ohos.display';
import LockScreenNtfAppLockUtils from '../utils/LockScreenNtfAppLockUtils';
import { NotificationExceptionCode } from '../maintenance/NotificationExceptionCode';
import { SystemUICcmConfig } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICcmConfig';
import { image } from '@kit.ImageKit';
import { EmergencyThermalSafeManager } from '@ohos/systemuicommon/src/main/ets/manager/EmergencyThermalSafeManager';
import { WakeUpUtils } from '../common/WakeUpUtils';
import { InnerEventUtil, LiveViewShowAuthEvent } from '@ohos/systemuicommon/newTsIndex';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';

const TAG = 'SysUI_NtfListVm';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);
const UNKNOWN_DELETED_NUMBER = 65535;
/**
 * 中线误差
 */
const MID_LINE_ERROR = 10;

/**
 * 锁屏窗口名
 */
const WINDOW_NAME_KEYGUARD = WindowConstants.WINDOW_NAME_LOCK_SCREEN;

/**
 * PC通知面板窗口名
 */
const WINDOW_NAME_PC_NTF_PANEL = PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL;

/**
 * TV通知面板窗口名
 */
const WINDOW_NAME_TV_NTF_PANEL = 'status_bar_notification_panel_tv';

/**
 * 通知面板类型和窗口名映射关系
 */
const NTF_TYPE_MAP_WINDOW_NAME: Map<number, string> = new Map([
  [NotificationType.TYPE_PC, WINDOW_NAME_PC_NTF_PANEL],
  [NotificationType.TYPE_TV, WINDOW_NAME_TV_NTF_PANEL],
  [NotificationType.TYPE_PHONE_KEYGUARD, WINDOW_NAME_KEYGUARD],
  [NotificationType.TYPE_PHONE_DROPDOWN, WindowConstants.WINDOW_NAME_DROPDOWN]
]);

/**
 * 通知中心排序权重 置顶通知不涉及SlotType，预留权重3。
 * 1、紧急通知 2、实况 3、置顶 4、用增上半区置顶 5、社交服务客服 999、其他类型按时间
 */
const NTF_SLOT_SORT_WEIGHT: Map<notificationManager.SlotType, number> = new Map([
  [notificationManager.SlotType.EMERGENCY_INFORMATION, 1],
  [notificationManager.SlotType.LIVE_VIEW, 2],
  [notificationManager.SlotType.SOCIAL_COMMUNICATION, 5],
  [notificationManager.SlotType.SERVICE_INFORMATION, 5],
  [notificationManager.SlotType.CUSTOMER_SERVICE, 5]
]);

/**
 * 置顶通知不涉及SlotType，预留权重3。
 */
const DISPLAY_AT_TOP_SORT_WEIGHT: number = 3;

/**
 * 其他消息权重
 */
const OTHER_TYPES_SORT_WEIGHT: number = 999;

/**
 * 下拉控制中心面板，通知列表刷新时延
 */
const DELAY_DROP_CONTROL_CENTER: number = 200;

/**
 * PAD、折叠屏宽度固定值vp
 */
const LAND_PAD_OR_FOLD_NTF_WIDTH: number = 532;
/**
 * 面板收起，延迟冻结通知列表刷新，保证组件删除
 */
const DELAY_PANEL_DISMISS_FREEZE: number = 200;

/**
 * 通知列表数据处理
 *
 * @since 2022-12-09
 */
export class NtfListVm {
  /**
   * List容器形状参数
   */
  public listContainerRect?: RectInfo;

  /**
   * 通知数据列表
   * 通知分组名 => 分组通知
   */
  private ntfAllList: Map<string, NotificationEntry> = new Map();

  /**
   * 可一键清除通知数据列表，用于通知中心面板
   * 通知hashCode => 通知数据
   */
  protected ntfClearMap: Map<string, NotificationEntry> = new Map();

  /**
   * 状态栏通知图标列表，用于Phone下拉面板
   */
  private ntfSbIconEvent: NtfStatusIconEvent | undefined = undefined;

  /**
   * 通知未读列表，用于PC通知面板
   * 通知hashCode => 通知数据
   */
  private ntfUnreadList: Map<string, NotificationEntry> = new Map();

  /**
   * 组件变化回调
   */
  protected ntfListChangeCallback: Set<NtfListChangeCallback> = new Set();

  /**
   * 显示改变回调
   */
  private displayCallback: Set<DisplayCallback> = new Set();

  /**
   * 通知未读列表，用于PC通知面板
   */
  private ntfUnreadEvent: NtfUnreadEvent = {
    ntfUnreadCount : 0
  };

  /**
   * 状态栏通知图标小红点，用于PC通知面板
   */
  private ntfIconRedHotEvent: IconRedHotEvent | undefined = undefined;

  /**
   * 通知适配器数据列表
   */
  protected ntfAdapterList: NotificationEntry[] = [];

  /**
   * 消息组字典，key为通知hashcode，value为所在组
   */
  private ntfDictMap: Map<string, NotificationEntry> = new Map();

  /**
   * 待更新的聚合数据
   */
  private underUpdatingUnified: Map<string, AggregateContent> = new Map();

  /**
   * 是否满足聚合场景
   */
  private isUnifiedSceneAllowed: boolean = false;

  /**
   * 聚合生效
   */
  private unifiedEnable: boolean = false;

  /**
   * 聚合设置开关
   */
  private unifiedSettingOn: boolean = false;

  /**
   * 待面板收起刷新的聚合组信息
   */
  private waitForUpdateGroups: Set<NotificationEntry> = new Set();

  /**
   * 通知更新冻结的promise
   */
  public freezeMap: Map<string, CustomPromise<void>> = new Map()

  // 当前冻结的promise
  private currentPromise?: CustomPromise<void>;
  /**
   * 通知列表适配器
   */
  private ntfAdapter: NotificationListAdapter = new NotificationListAdapter();

  /**
   * 通知列表属性样式
   */
  private ntfStyle: NotificationListStyle = new NotificationListStyle();

  /**
   * 多事件统一管理
   */
  protected eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 默认竖屏
   */
  private isLandDisplay: boolean = false;

  /**
   * 当前是否亮屏
   */
  protected isScreenOn: boolean = false;

  /**
   * 收到通知是否自动亮屏
   */
  protected isNtfAutoScreenOn: boolean = false;

  /**
   * 当前是否应该隐藏通知内容
   */
  protected shouldHideNtfContent: boolean = false;

  /**
   * 当前是否应该隐藏实况通知内容
   */
  protected shouldHideLiveViewContent: boolean = false;

  /**
   * 组件通信
   */
  protected callback: NtfListCallback | null = null;

  /**
   * 屏幕高度
   */
  private screenHeight: number = 0;

  private foldStatus: DeviceState = DeviceState.DEFAULT_STATE;
  /**
   * 记录当前屏幕的宽度，折叠屏折叠展开时会更新
   */
  private displayWidth: number = 0;

  private isHeadsUpAdd: boolean = false;

  /**
   * 是否含有右孔垂直居中
   */
  private isRightMidCutout: boolean = false;

  /**
   * 订阅下拉面板
   */
  private unsubscribeDropdown?: unsubscribe = undefined;

  /**
   * 刷新列表项的zIndex
   */
  public refreshItemZIndex: () => void = () => log.showWarn('RefreshItemZIndex is empty.');

  /**
   * 将指定Item抬升到最上层
   */
  public raiseItemToTop: (key: string) => void = (_: string) => log.showWarn('RaiseToTop is empty.');

  private listContentConfig: NtfListContentConfig = ntfViewConfigManager.getListContentConfig();

  private panelDismissDelayTimerId: number = 0;

  private isFilterNtfAfterScreenLock: boolean = false;

  private isLastHeadsUpEventNull:boolean = false;
  /**
   * 是否密码锁定状态
   */
  protected isSecureAndLocked: boolean = false;

  /**
   * 锁屏通知是否隐藏通知内容
   */
  protected isNtfHideContent: boolean = false;

  /**
   * 标识当前实况通知中是否有加锁的应用发送
   */
  protected hasAppLocked: boolean = true;

  private progressValueMap: Map<string, number> = new Map();

  /**
   * 锁屏隐藏通知内容开关事件
   *
   * @param event 事件
   */
  private onNtfHideContentEvent = (event: NtfHideContentEvent): void => {
    this.isNtfHideContent = event.isNtfHideContentEnable();
    this.checkShouldHideNtfContent();
  }

  /**
   * 锁定状态事件
   *
   * @param event 事件
   */
  private onScreenLockEvent = (event: ScreenLockEvent): void => {
    this.handleScreenLockEvent((event));
  }

  protected handleScreenLockEvent(event: ScreenLockEvent) {
      return;
  }

  /**
   * 检测是否需要隐藏通知内容
   */
  protected checkShouldHideNtfContent(): void {
      return;
  }

  protected updateEntry() {
    this.ntfAdapterList.forEach((entry: NotificationEntry) => {
      if (entry.isLiveType()) {
        return;
      }
      this.setEntryHideContent(entry, this.shouldHideNtfContent);
      entry.notifyDataChanged();
      entry.childrenEntry?.forEach((childEntry: NotificationEntry) => {
        childEntry?.notifyDataChanged();
      });
    });
  }

  /**
   * 初始化
   *
   * @param callback 回调器
   */
  init(callback: NtfListCallback): void {
    this.callback = callback;
    // 横竖屏不同窗口尺寸，初始设置
    DisplayMgr.getCurrentDisplay().then((dis: screenSessionManager.RRect) => this.screenHeight = dis?.height);
    this.initProp();
    this.isUnifiedSceneAllowed = callback?.getUnifiedAllowed?.() ?? false;
    // 监听通知事件
    this.eventMgr.on(NotificationEntryEvent, this.onNotificationEntryEvent);
    // 锁屏面板根据面板可见性控制通知是否显示，PC通知面板可见性来标示通知未读，所有面板隐藏时重置条目展开状态
    this.eventMgr.on(WindowEvent, this.onWindowEvent);
    // 下拉面板、锁屏面板适配横竖屏
    if (this.isDropdown() || this.isKeyguard()) {
      this.eventMgr.on(DisplayEvent, this.onDisplayEvent);
    }
    // 监听折叠屏展开状态
    this.initFoldDisplay();
    // 监听XT屏幕显示事件
    this.handleDisplayModeEvent();
    // 下拉面板控制通知状态栏图标
    if (this.isDropdown()) {
      this.eventMgr.produceOn(NtfStatusIconEvent, this.onProduceNtfSbIconEvent);
      // 挖孔事件
      this.eventMgr.on(CutoutEvent, this.onCutoutEvent);
      // 下拉通知，使能冻结视图开关，防止视图冗余绘制，待下拉通知中心时，统一更新视图。
      this.ntfAdapter.setFreezeViewEnable(true);
      this.subscribeDropdownEvent();
    }
    // PC面板，通知未读消息事件
    if (this.isPc()) {
      this.eventMgr.produceOn(NtfUnreadEvent, this.onProduceNtfUnreadEvent);
    }
    notificationConfigManager.subscribeChangeEvent(this.onNotificationConfigChange);

    this.eventMgr.on(HeadsUpChangeEvent, this.onHeadsUpChangeEvent.bind(this))
      .on(NtfHideContentEvent, this.onNtfHideContentEvent)
      .on(ScreenLockEvent, this.onScreenLockEvent);
    if (SystemUICcmConfig.instance.isEnabledLive2) {
      InnerEventUtil.on(LiveViewShowAuthEvent, this.onLiveViewAuthChange);
    }
    sEventManager.subscribe(REFRESH_STATUS_BAR_NTF, this.onRefreshStatusBarNtf);
  }

  private onRefreshStatusBarNtf = (event: RefreshStatusNotification) => {
    this.postNtfSbIconEvent();
  }

  private onLiveViewAuthChange = (event: LiveViewShowAuthEvent) => {
      // 实况授权变化事件
      let hashCode = event.hashCode;
      if (this.isNtfExists(hashCode)) {
        for (const groupEntry of this.ntfAdapterList) {
          const entry = groupEntry.getFirstChildEntry();
          if (entry?.hashCode === hashCode && entry?.isLiveType()) {
            log.showInfo(`onLiveViewAuthChange entry: ${entry.hashCode}`);
            entry.liveViewData?.updateShowAuth();
            entry.notifyDataChanged();
          }
        }
      }
  }

  getNtfAdapterList(): Array<NotificationEntry> {
    return this.ntfAdapterList;
  }

  /**
   * 销毁
   */
  onDestroy(): void {
    if (!this.callback) {
      return;
    }
    this.eventMgr.offAll();
    log.showInfo(`destroy entry, list size: ${this.ntfAdapterList?.length}`);
    this.callback = null;
    if (this.unsubscribeDropdown) {
      this.unsubscribeDropdown();
      this.unsubscribeDropdown = undefined;
    }
    notificationConfigManager.unsubscribeChangeEvent(this.onNotificationConfigChange);
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropertyChangeCB,
      undefined, true, DropdownController.getInstance().getId());
    // 取消监听XT屏幕显示事件
    this.handleDisplayModeEvent(false);
    sEventManager.off(REFRESH_STATUS_BAR_NTF, this.onRefreshStatusBarNtf);
    if (SystemUICcmConfig.instance.isEnabledLive2) {
      InnerEventUtil.off(LiveViewShowAuthEvent, this.onLiveViewAuthChange);
    }
  }

  registerDisplayListener(callback: DisplayCallback): void {
    this.displayCallback.add(callback);
    callback?.onNtfStyleChange(this.ntfStyle);
  }

  unregisterDisplayListener(callback: DisplayCallback): void {
    this.displayCallback.delete(callback);
  }

  registerNtfListChangeListener(callback: NtfListChangeCallback): void {
    this.ntfListChangeCallback.add(callback);
  }

  unregisterNtfListChangeListener(callback: NtfListChangeCallback): void {
    this.ntfListChangeCallback.delete(callback);
  }

  /**
   * 判断某个hashcode的通知是否存在
   */
  isNtfExists(hashCode: string): boolean {
    return this.ntfDictMap.has(hashCode);
  }

  /**
   * 获取通知列表适配器
   *
   * @return 适配器
   */
  getNtfListAdapter(): NotificationListAdapter {
    return this.ntfAdapter;
  }

  private subscribeDropdownEvent(): void {
    this.unsubscribeDropdown = sEventManager.subscribe('DropdownEvent', (isShow: boolean) => {
      // 下拉面板收起时重新计算组通知和聚合通知
      if (isShow) {
        clearTimeout(this.panelDismissDelayTimerId);
        let isNtfPanel = sDropDownPanelManager.getIsNtfPanel();
        if (!isNtfPanel) {
          setTimeout(() => {
            this.ntfAdapter.setFreezeViewEnable(false);
            this.ntfAdapter.update(NtfDataChangeType.BATCH_UPDATE);
          }, DELAY_DROP_CONTROL_CENTER);
        } else {
          this.ntfAdapter.setFreezeViewEnable(false);
          this.ntfAdapter.update(NtfDataChangeType.BATCH_UPDATE);
        }
      } else {
        this.panelDismissDelayTimerId = setTimeout(() => {
          this.ntfAdapter.setFreezeViewEnable(true);
        }, DELAY_PANEL_DISMISS_FREEZE);
        this.refreshGroupData();
      }
    });
  }

  /**
   * 通知配置变化事件
   */
  private onNotificationConfigChange = async (event: NotificationConfigEvent): Promise<void> => {
    if (event.type === NotificationConfigEventType.UPDATE_RESOURCE ||
      event.type === NotificationConfigEventType.SHOWING_NOTIFICATION_UPDATE) {
      try {
        const duplicateUid =
          event.type === NotificationConfigEventType.UPDATE_RESOURCE ? event.duplicateUid : undefined;
        log.showInfo('Update notification resource begin');
        await this.updateNotificationResource(duplicateUid, event.resourceUpdateType);
        log.showInfo('Update notification resource end');
      } catch (e) {
        LogWithHa.error(log, `Update notification resource error: ${e}`, NotificationExceptionCode.UPDATE_CONFIG_FAIL, e);
      }
    } else if (event.type === NotificationConfigEventType.PINTOP_ITEM) {
      log.showInfo(`Change pinTop for ${event.uid} to ${event.enabled}.`);
      for (const entry of this.ntfAdapterList) {
        if (entry?.creatorUid !== event.uid) {
          continue;
        }
        if (entry.childrenEntry?.length) {
          for (const childEntry of entry.childrenEntry) {
            childEntry.isDisplayAtTop = event.enabled;
            childEntry.notifyDataChanged();
          }
        }
        entry.isDisplayAtTop = event.enabled;
        entry.notifyDataChanged();
      }
      this.resortNtfList();
    } else if (event.type === NotificationConfigEventType.UPDATE_ITEM) {
      await this.updateConfig(event.config);
    }
  };

  private async updateNotificationResource(duplicateUid?: Set<number>,
    resourceUpdateType?: ResourceUpdateType): Promise<void> {
    const uidSet: Set<number> = new Set();
    for (const entry of this.ntfAdapterList) {
      if (duplicateUid?.has(entry.creatorUid)) {
        log.showInfo(`uid ${entry.creatorUid} has been handeled, ignore`);
        continue;
      }
      uidSet.add(entry.creatorUid);
    }
    if (!uidSet.size) {
      log.showInfo('no uid to handle');
      return;
    }
    const predicates = NotificationConfigEntity.getPredicates();
    predicates.inCondition({ uid: Array.from(uidSet.values()) });
    const configList = await NotificationConfigEntity.queryList(predicates, {
      columns: ['uid', 'icon', 'label', 'bundle'],
    });
    for (const entry of this.ntfAdapterList) {
      const config = configList.find((c) => this.findConfigForEntry(c, entry));
      if (config) {
        await this.updateNotificationEach(entry, config.label, config.icon);
      } else if (entry.creatorType === NotificationCreatorType.SA) {
        await this.updateNotificationEach(entry, notificationConfigManager.getSADefaultName());
      }
    }
    await this.updateNtfCollaAppIcons();
    // 切换语言不更新状态栏通知图标
    if (resourceUpdateType === ResourceUpdateType.LANGUAGE_CHANGE) {
      log.showInfo(`update for language change, do not post NtfSbIconEvent`);
      return;
    }
    this.postNtfSbIconEvent(true);
  }

  /**
   * 更新全场景通知应用图标
   * @param updateNtfList
   * @returns
   */
  private async updateNtfCollaAppIcons(): Promise<void> {
    // 协同通知处理
    const collaIconInfos: IconInfo[] = [];
    this.ntfAdapterList.filter(ntf => ntf.collaAppIconOrigin !== undefined).forEach((ntf) => {
      collaIconInfos.push({ hashCode: ntf.hashCode, icon: ntf.collaAppIconOrigin as image.PixelMap });
    });

    if (!collaIconInfos.length) {
      return;
    }
    const hdsIconInfos = await HdsIconTaskUtil.getHdsIconBatch(GlobalContext.getContext(), collaIconInfos, process.tid);
    this.ntfAdapterList.filter(ntf => ntf.collaAppIconOrigin !== undefined).forEach((ntf) => {
      ntf.appIcon = hdsIconInfos.get(ntf.hashCode);
    });
  }

  /**
   * 单个应用配置变化，更新通知
   * @param event
   */
  private async updateConfig(config: NotificationConfigEntity): Promise<void> {
    log.showInfo(`Update config for ${config.uid}, label: ${config.label}.`);
    let oldAppIcon: image.PixelMap | string | undefined;
    for (const entry of this.ntfAdapterList) {
      if (entry?.creatorUid !== config.uid) {
        continue;
      }
      if (!oldAppIcon) {
        oldAppIcon = entry.appIcon;
      }
      await this.updateNotificationEach(entry, config.label, config.icon, false);
    }
    // 应用有通知且应用图标有更新，更新状态栏图标
    if (oldAppIcon && config.icon !== oldAppIcon) {
      this.postNtfSbIconEvent(true);
    }
  }

  private async updateNotificationEach(entry: NotificationEntry, appName: string, appIcon?: image.PixelMap | string,
    updateSmallIcon: boolean = true) {
    if (entry.childrenEntry?.length) {
      for (const childEntry of entry.childrenEntry) {
        await this.updateNotificationEach(childEntry, appName, appIcon, updateSmallIcon);
      }
    }
    if (!entry.useCustomAppname) {
      entry.appLabel = appName;
      entry.appName.value = appName;
      entry.immersiveNtfData?.setAppName(appName);
    }
    if (appIcon) {
      entry.appIcon = appIcon;
      entry.immersiveNtfData?.setAppIcon(appIcon);
    }
    if (updateSmallIcon) {
      await this.setSmallIcon(entry);
    }
    entry.notifyDataChanged();
  }

  private findConfigForEntry(ntfConfig: NotificationConfigEntity, ntfEntry: NotificationEntry): boolean {
    return ntfConfig.bundle === ntfEntry.creatorBundleName && ntfConfig.uid === ntfEntry.creatorUid;
  }

  private async setSmallIcon(entry: NotificationEntry): Promise<void> {
    if (!entry.smallIconOrigin) {
      return;
    }
    entry.smallIcon = await HdsIconTaskUtil.getHdsIcon(GlobalContext.getContext(), 'custom', entry.smallIconOrigin);
  }

  private refreshGroupData(): void {
    log.showInfo(`refreshGroupData, waitForUpdateGroups size: ${this.waitForUpdateGroups.size}`);
    if (this.waitForUpdateGroups.size === 0) {
      return;
    }
    this.waitForUpdateGroups.forEach((group) => {
      const currGroup = this.ntfAllList.get(group.getGroupTypeKey());
      if (currGroup && currGroup.uid === group.uid) {
        this.updateGroupInfo(currGroup);
        if (currGroup.isInAggregate) {
          this.checkIfNeedUnifiedRelease(currGroup);
          return;
        }
      }
    });
    this.waitForUpdateGroups.clear();
    this.sortAdapterList();
    this.updateAdapter();
    // 刷新
    this.refreshDataState();
    this.postNtfUnreadEvent();
    this.postUnifiedGroupRemindEvent();
  }

  /**
   * 获取通知列表属性样式
   *
   * @return 属性样式
   */
  getNtfListStyle(): NotificationListStyle {
    return this.ntfStyle;
  }

  /**
   * 跳转通知管理首页
   */
  startNtfManagerMain(): void {
    if (DeviceHelper.isPC()) {
      // 收起面板
      NotificationPanelManager.collapseNtfPanel(this.getNtfType(), true);
      // 延迟100ms触发页面跳转，与动效并行
      setTimeout(() => { ntfMgr.startPcNtfMgrMainAbility(); }, 100)
    }
  }

  /**
   * 一键删除通知时收起面板
   */
  hidePanelByClearNtf(delay: number) {
    this.setUpdateFreeze('clearAll');
    if (delay === 0) {
      NotificationPanelManager.collapseNtfPanel(this.getNtfType(), true);
    } else {
      NotificationPanelManager.collapseNtfPanelWithDelay(this.getNtfType(), delay);
    }
  }

  /**
   * 清除所有通知
   */
  clearAllNtf(delay: number, hidePanel: boolean = true): void {
    // 无可清除通知
    if (ArrayUtils.isEmpty(this.ntfClearMap)) {
      log.showInfo('clearAllNtf no ntf: ' + this.getNtfType());
      return;
    }
    // 收起面板
    if (hidePanel) {
      this.hidePanelByClearNtf(delay);
    }
    let entries: NotificationEntry[] = [];

    this.ntfClearMap?.forEach((entry: NotificationEntry) => {
      if (this.isClearCurrentNtf(entry)) {
        entries.push(entry);
      }
    });
    // 保证全部删除动画执行成功完成。
    if (!hidePanel) {
      ntfMgr.batchRemoveNtf(entries);
      DeleteNotificationMaintenance.addNtfMap(entries, DeleteNotificationType.CLICK_ALL_BUTTON_DELETE, false);
    } else {
      setTimeout(() => {
        DeleteNotificationMaintenance.addNtfMap(entries, DeleteNotificationType.CLICK_ALL_BUTTON_DELETE, false);
        ntfMgr.batchRemoveNtf(entries);
      }, delay);
    }
    log.showInfo('clearAllNtf size: ' + ArrayUtils.getSize(this.ntfClearMap) + ', ' + this.getNtfType());
  }

  private isClearCurrentNtf(entry: NotificationEntry): boolean {
    if (!EmergencyThermalSafeManager.instance.isInEmergencyMode()) {
      return true;
    }
    if (EmergencyThermalSafeManager.instance.isInWhiteList(entry?.creatorBundleName)) {
      return true;
    }
    return false;
  }

  /**
   * 是否PC面板
   *
   * @return true PC面板
   */
  isPc(): boolean {
    return NotificationType.isPc(this.getNtfType());
  }

  /**
   * 是否Pad布局
   *
   * @return true Pad面板
   */
  isPadLayout(): boolean {
    return LayoutUtils.isPadLayout();
  }

  /**
   * 是否手机下拉面板
   *
   * @return true 下拉面板
   */
  isDropdown(): boolean {
    return NotificationType.isDropdown(this.getNtfType());
  }

  /**
   * 是否锁屏面板
   *
   * @return true 锁屏面板
   */
  isKeyguard(): boolean {
    return NotificationType.isKeyguard(this.getNtfType());
  }

  /**
   * 当前是否为横屏
   */
  isLand(): boolean {
    return this.isLandDisplay;
  }

  /**
   * 获取通知列表标示
   *
   * @return 标示
   */
  getSlot(): string {
    return TAG + '_' + this.getNtfType();
  }

  /**
   * 锁屏窗口是否可见
   *
   * @return true可见
   */
  isKeyguardShow(): boolean {
    return ViewManagerPolicy.isViewShowing(ViewType.KEYGUARD);
  }

  /**
   * PC通知面板是否可见
   *
   * @return true可见
   */
  isPcNtfPanelShow(): boolean {
    return windowMgr.isShowing(WINDOW_NAME_PC_NTF_PANEL);
  }

  /**
   * 获取屏幕高度
   */
  getScreenHeight(): number {
    return this.screenHeight;
  }

  /**
   * 初始化特有属性
   */
  private initProp(): void {
    // 通知中心面板需要clear列表
    if (this.isPc() || this.isDropdown()) {
      this.ntfClearMap = new Map();
    }
    // 下拉面板，通知状态栏图标集
    if (this.isDropdown()) {
      this.ntfSbIconEvent = NtfStatusIconEvent.create([]);
    }
    // PC面板，未读通知集
    if (this.isPc()) {
      this.ntfUnreadList = new Map();
      this.ntfUnreadEvent = new NtfUnreadEvent();
      this.ntfIconRedHotEvent = IconRedHotEvent.create(PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL, false);
    }
    this.updateUnifiedEnable();
    // 适配器数据保持一致
    this.ntfAdapter.setDataSource(this.ntfAdapterList);
    this.postUnifiedGroupRemindEvent();
  }

  private updateUnifiedEnable(): void {
    if (this.unifiedEnable !== (this.unifiedSettingOn && this.isUnifiedSceneAllowed)) {
      this.unifiedEnable = !this.unifiedEnable;
      if (this.unifiedEnable) {
        return;
      }
      log.showInfo(`unified group feature close`);
      this.underUpdatingUnified.clear();
      this.ntfAllList.forEach((entry, key) => {
        if (entry.isInAggregate) {
          this.deleteUnifiedGroup(key, entry);
        }
      });
      this.sortAdapterList();
      // 适配器数据保持一致
      this.ntfAdapterList.forEach((group) => {
        log.showInfo(`group: ${group.getGroupTypeKey()}, size : ${group.getChildrenSize()}`);
      });
      this.ntfAdapter.setDataSource(this.ntfAdapterList);
      this.postUnifiedGroupRemindEvent();
    }
  }

  private deleteUnifiedGroup(key: string, group: NotificationEntry): void {
    let childList = group.childrenEntry;
    childList?.forEach((child) => {
      let group = this.addNtfEntry(child, false);
      if (group) {
        this.updateGroupInfo(group);
      }
      this.notifyChange(child);
    });
    this.ntfAllList.delete(key);
    ArrayUtils.deleteArr(this.ntfAdapterList, group);
  }

  private updateAdapter(type?: NtfDataChangeType): void {
    if (this.freezeMap.get('clearAll')) {
      this.freezeMap.get('clearAll')?.then(() => {
        this.ntfAdapter.update(type);
      });
    } else {
      this.ntfAdapter.update(type);
    }
  }

  private notifyChange(entry: NotificationEntry): void {
    if (!entry) {
      return;
    }
    if (this.freezeMap.get('clearAll')) {
      this.freezeMap.get('clearAll')?.then(() => {
        entry.notifyDataChanged();
      });
    } else {
      entry.notifyDataChanged();
    }
  }

  /**
   * 获取面板类型
   *
   * @return 面板类型
   */
  protected getNtfType(): number {
    return this.callback?.getNtfType()!;
  }

  /**
   * 通知状态栏图标事件生产者
   *
   * @return 事件
   */
  private onProduceNtfSbIconEvent = (): NtfStatusIconEvent => {
    return this.ntfSbIconEvent!;
  }

  /**
   * 通知未读消息事件生产者
   *
   * @return 事件
   */
  private onProduceNtfUnreadEvent = (): NtfUnreadEvent => {
    return this.ntfUnreadEvent;
  }

  /**
   * 通知列表数据事件
   *
   * @param event 事件
   */
  private onNotificationEntryEvent = (event: NotificationEntryEvent): void => {
    if (this.currentPromise) {
      log.showWarn('Wait freeze promise for %{public}d', event.eventType);
      this.currentPromise.then(() => this.doNotificationEntryEvent(event));
    } else {
      this.doNotificationEntryEvent(event);
    }
    // 发送锁屏通知变化事件，进度类通知且更新进度值小于10时，AOD下不进行更新
    if (this.isKeyguard() && this.isNeedUpdate(event.notificationList!, event.eventType)) {
      sEventManager.publish(obtainLocalEvent(EventConstants.SCREEN_LOCK_NOTIFICATION_CHANGE, event));
    }
  }

  private isNeedUpdate(ntfList: Array<NotificationEntry>, eventType?: number): boolean {
    // 亮屏或者Map容量超过100时清除Map
    if (this.isScreenOn || this.progressValueMap.size >= 100) {
      this.progressValueMap.clear();
      return true;
    }
    // 通知删除场景，直接返回true
    if (eventType === NotificationEntryEvent.EVENT_TYPE_POST_CANCEL) {
      return true;
    }
    // 如果列表为空或长度大于1，直接返回 true
    if (ntfList.length !== 1) {
      return true;
    }
    const entry = ntfList[0];
    const notificationId = entry.hashCode;
    const progressValue = entry.liveViewData?.getProgressData()?.currentValue;
    // 非进度值类，直接返回 true
    if (progressValue === undefined) {
      return true;
    }
    const lastProgressValue = this.progressValueMap.get(notificationId);
    // 如果上一次值进度值存在且当前值比上一次值小于10，返回 false（不需要刷新）
    if (lastProgressValue !== undefined && progressValue - lastProgressValue < 10 &&
      progressValue >= lastProgressValue) {
      return false;
    }
    // 刷新上一次进度值
    this.progressValueMap.set(notificationId, progressValue);
    return true;
  }

  private filterNtfList(list: NotificationEntry[]): NotificationEntry[] {
    if (!this.listContentConfig?.isNtfPanelShowLiveType) {
      list = list.filter(entry => !entry?.isLiveType());
    }
    return list;
  }

  private doNotificationEntryEvent = (event: NotificationEntryEvent): void => {
    log.showInfo('DoNotificationEvent. %{public}d', event.eventType);
    const list = this.filterNtfList(event.notificationList!);
    this.updateUnifiedGroup(list);
    if (event.eventType === NotificationEntryEvent.EVENT_TYPE_INIT) {
      this.handleNtfInit(list);
    } else if (event.eventType === NotificationEntryEvent.EVENT_TYPE_POST_ADD) {
      this.handleNtfAddUpdate(list, false, event.eventType);
    } else if (event.eventType === NotificationEntryEvent.EVENT_TYPE_POST_UPDATE) {
      this.handleNtfAddUpdate(list, true);
    } else if (event.eventType === NotificationEntryEvent.EVENT_TYPE_POST_CANCEL) {
      this.handleNtfRemove(list);
    }
  }

  /**
   * 通知聚合开关变化
   *
   * @param event 事件
   */
  private onUnifiedGroupEnableEvent = (event: UnifiedGroupEnableEvent): void =>{
    log.showInfo('onUnifiedGroupEnableEvent type: ' + event?.isUnifiedGroupEnable());
    if (event) {
      this.unifiedSettingOn = event.isUnifiedGroupEnable();
      this.updateUnifiedEnable();
    }
  }
  /**
   * 锁屏界面是否过滤通知状态改变
   * isFilterNtfAfterScreenLock为true标志着只显示锁屏后来的通知的通知图标
   */
  private onIsFilterNtfAfterScreenLockChange: (isFilterNtfAfterScreenLock: boolean) => void =
    (isFilterNtfAfterScreenLock: boolean) => {
      if (this.isFilterNtfAfterScreenLock != isFilterNtfAfterScreenLock) {
        this.isFilterNtfAfterScreenLock = isFilterNtfAfterScreenLock;
        this.postNtfSbIconEvent(true);
        log.showInfo(`isFilterNtfAfterScreenLock change to ${this.isFilterNtfAfterScreenLock}`);
      }
    }

  private resortNtfList() {
    this.deleteWrongGroupNtf();
    this.sortAdapterList();

    // 刷新
    this.refreshDataState();
    this.ntfAdapter.setDataSource(this.ntfAdapterList);
    this.postUnifiedGroupRemindEvent();
  }

  /**
   * 通知列表初始化
   *
   * @param ntfList 初始化通知列表
   */
  private handleNtfInit(ntfList: Array<NotificationEntry>): void {
    log.showInfo('handleNtfInit size: ' + ArrayUtils.getSize(ntfList) + ', type: ' + this.getNtfType());
    this.ntfAllList.clear();
    this.ntfDictMap.clear();
    this.ntfClearMap?.clear();
    ArrayUtils.clearArr(this.ntfAdapterList);
    // 无数据
    if (ArrayUtils.isEmpty(ntfList)) {
      this.refreshDataState();
      this.ntfAdapter.setDataSource(this.ntfAdapterList);
      this.postUnifiedGroupRemindEvent();
      return;
    }
    // 有数据，组通知包装集
    ntfList.forEach((entry) => {
      if (this.isAddNtf(entry)) {
        let group = this.addNtfEntry(entry, false);
        ArrayUtils.update(this.ntfAdapterList, group);
        if (entry?.hashCode && group) {
          this.ntfDictMap.set(entry.hashCode, group);
        }
      }
    });
    // 组通知内children排序，更新组通知信息
    this.ntfAdapterList.forEach((groupEntry: NotificationEntry) => {
      groupEntry.sortChildren();
      groupEntry.updateGroup(groupEntry.getFirstChildEntry()!);
      groupEntry.updateGroupSlotLevel();
    });
    this.reGroupAndResort();
  }

  private updateGroupInfo(group: NotificationEntry, isNotUpdate?: boolean): void {
    group?.sortChildren();
    // 聚合通知不限制子通知数量
    if (!group?.isInAggregate) {
      group?.updateGroup(group?.getFirstChildEntry()!);
    }
    group?.updateAggregateGroup();
    group?.updateGroupSlotLevel();
    // 列表区分新增/更新
    let oldIndex = ArrayUtils.updateArr(this.ntfAdapterList, group);
    log.showInfo(`updateGroupInfo oldIndex: ${oldIndex}`);
    // 通知数据变化
    if (!isNotUpdate) {
      this.notifyChange(group);
    }
  }

  private checkUnifiedMemberLimit(needUnifiedMembers: string[], unifiedGroupKey: string): boolean {
    // 聚合内容少于两条则不形成聚合
    log.showInfo(`checkUnifiedMemberLimit, set size: ${needUnifiedMembers?.length}, ${this.ntfAllList.get(unifiedGroupKey)?.childrenEntry?.length}`);
    return (needUnifiedMembers?.length ?? 0) + (this.ntfAllList.get(unifiedGroupKey)?.childrenEntry?.length ?? 0) < 2;
  }

  private unifiedRelease(entry: NotificationEntry): void {
    log.showInfo(`unified release , hashcode: ${entry.hashCode}`);
    let unifiedGroup = this.ntfDictMap.get(entry?.hashCode);
    if (unifiedGroup?.childrenEntry) {
      let entryIndex = unifiedGroup.childrenEntry.findIndex((child) => child.hashCode === entry?.hashCode);
      if (entryIndex != -1) {
        log.showInfo(`find ntf to unified release, hashcode: ${entry.hashCode}, origin group: ${unifiedGroup.getGroupTypeKey()}`);
        unifiedGroup.childrenEntry.splice(entryIndex, 1);
        this.deleteGroupIfEmpty(unifiedGroup);
        if (unifiedGroup.getFirstChildEntry()) {
          this.updateGroupInfo(unifiedGroup);
        }
        let group = this.addNtfEntry(entry, false);
        if (group) {
          this.updateGroupInfo(group);
        }
        // 子通知数据变化
        this.notifyChange(entry);
      }
    }
  }

  private updateUnifiedGroupMember(unifiedGroup: AggregateContent, key: string, hashcode: string): void {
    log.showInfo(`unified create , hashcode: ${hashcode}`);
    let oriUnified = this.ntfAllList.get(key);
    let group = this.ntfDictMap.get(hashcode);
    if (group?.childrenEntry) {
      let entryIndex = group.childrenEntry.findIndex((child) => child.hashCode === hashcode);
      log.showInfo(`find ntf to unified, hashcode: ${hashcode}, origin group: ${group.getGroupTypeKey()}, index: ${entryIndex}`);
      if (entryIndex != -1) {
        let entry = group.childrenEntry[entryIndex];
        group.childrenEntry.forEach((child) => log.showInfo(`child: ${child.hashCode}`));
        let deleteItem = group.childrenEntry.splice(entryIndex, 1);
        deleteItem?.forEach((item) => log.showInfo(`deleteItem: ${item.hashCode}`));
        this.deleteGroupIfEmpty(group);
        if (group.getFirstChildEntry()) {
          this.updateGroupInfo(group);
        }
        if (!oriUnified) {
          oriUnified = entry.createAggregateGroup(unifiedGroup)!
          this.ntfAllList.set(key, oriUnified);
        } else {
          oriUnified.addUpdateChildEntry(entry);
        }
        this.ntfDictMap.set(hashcode, oriUnified);
      }
      log.showInfo(`unified end , group size: ${group?.childrenEntry.length ?? 0}, ` +
        `unified size: ${oriUnified?.childrenEntry?.length ?? 0}`);
    }
  }

  private reGroupAndResort(eventType?: number): void {
    log.showInfo('reGroupAndResort');
    this.underUpdatingUnified.forEach((unifiedGroup, key) => {
      log.showInfo('underUpdatingUnified, unifiedGroup: ' + unifiedGroup?.key + '_' + unifiedGroup?.title +
        '_' + unifiedGroup?.content + '_' + unifiedGroup?.status + '_' + unifiedGroup?.memberList?.toString());
      let values = (unifiedGroup.status === UnifiedGroupStatus.UNIFIED_DELETE) ? [] : unifiedGroup.memberList;

      // 原非聚合通知存在，待聚合列表存在，则为需要新增聚合通知
      let newUnified = values?.filter((hashcode) => {
        let group = this.ntfDictMap.get(hashcode);
        if (group) {
          return !group.isInAggregate;
        }
        return false;
      });
      if (this.checkUnifiedMemberLimit(newUnified, unifiedGroup.key ?? '')) {
        log.showInfo('unified member limit.');
        return;
      }

      // 原聚合通知存在，待聚合列表不存在，则为需要释放的聚合通知
      let needRelease = this.ntfAllList.get(key)?.childrenEntry?.filter((entry) =>!(values?.find((value) =>
      entry.hashCode === value)));
      newUnified?.forEach((hashcode) => this.updateUnifiedGroupMember(unifiedGroup, key, hashcode));
      let oriUnified = this.ntfAllList.get(key);
      if (oriUnified) {
        oriUnified.updateAggregateContent(unifiedGroup);
        this.updateGroupInfo(oriUnified);
      }
      needRelease?.forEach((entry) => {
        this.unifiedRelease(entry);
      });
      if (oriUnified?.isInAggregate && oriUnified.getChildrenSize() == 1) {
        oriUnified.childrenEntry?.forEach((child) => this.unifiedRelease(child));
      }
    });
    this.sortAdapterList();
    this.refreshDataState(eventType);
    this.ntfAdapter.setDataSource(this.ntfAdapterList);
    this.underUpdatingUnified.clear();
    this.postUnifiedGroupRemindEvent();
  }

  protected handleNtfAddUpdateKeyGuard(isExtraScreenOn: boolean): void {
    WakeUpUtils.wakeUpScreen(isExtraScreenOn);
  }

  /**
   * 通知列表添加或更新数据
   *
   * @param ntfList 添加/更新集
   * @param isUpdate 是否是更新的通知
   */
  private handleNtfAddUpdate(ntfList: Array<NotificationEntry>, isUpdate: boolean, eventType?: number): void {
    if (ArrayUtils.isEmpty(ntfList)) {
      return;
    }
    ntfList.forEach((entry: NotificationEntry) => {
      if (entry.updateUnifiedInfoOnly) {
        return;
      }

      // 检测未读通知
      this.checkNtfUnreadState(entry);

      let isContain = false;
      if (this.isKeyguard()) {
          isContain = this.isContainNtf(entry);
      }
      // 是否需要更新分组
      let isGroupUpdate = false;
      if (isUpdate) {
        // 更新的通知，如果有相同的hashCode的通知在其他组，需要从其他组删除，避免出现2个相同hashCode的通知
        isGroupUpdate = this.deleteSameHashCodeNtf(entry);
      }

      // 添加更新场景，锁屏面板可见时的锁屏通知，通知中心全部
      let canAdd = this.canAddNtf(entry);
      const isExtraScreenOn = entry.controlConfig.isExtraScreenOn();
      const ntfType = this.getNtfType();
      log.showWarn(`handleNtfAddUpdate hash: ${entry.hashCode}, canAdd: ${canAdd}, NtfType: ${ntfType},` +
        ` slotLevel: ${entry.slotLevel}, isScreenOn: ${this.isScreenOn}, isNtfAutoScreenOn: ${this.isNtfAutoScreenOn},` +
        ` creatorBundleName: ${entry.creatorBundleName}, ntf isExtraScreenOn: ${isExtraScreenOn}, ` +
        ` titleLength: ${entry.notificationContent?.contentTitle?.length},` +
        ` contentLength: ${entry.notificationContent?.contentText?.length}, appIndex: ${entry.appIndex},` +
        ` notificationFlags:${entry.remindConfig.flags}, controlFlags: ${entry.controlConfig.flags}`);
      if (ntfType === NotificationType.TYPE_PHONE_KEYGUARD) {
        this.reportNtfReceivedEvent(entry, canAdd, this.isNtfAutoScreenOn, entry.remindConfig.flags);
      }

      if (canAdd) {
        const isScreenOff = this.isKeyguard() && !this.isScreenOn;
        const shouldScreenOn = entry.shouldScreenOn(this.isNtfAutoScreenOn, isContain);
        const isOuterHomeFold = !DeviceHelper.isFoldExpandedOrHalf();
        // 非可扩展设备外屏锁屏场景，自动亮屏
        if (isScreenOff && shouldScreenOn && !isOuterHomeFold) {
          this.handleNtfAddUpdateKeyGuard(isExtraScreenOn);
        }
        let group = this.addNtfEntry(entry, isUpdate, isGroupUpdate);
        if (group) {
          this.updateGroupInfo(group);
        }
        // 子通知数据变化
        this.notifyChange(entry);
      } else {
        log.showWarn(`handleNtfAddUpdate canAdd false, NtfType: ${this.getNtfType()}, ntfDeliveryTime: ${entry.deliveryTime} ntfIsShowInLockScreen: ${entry.isShowInLockScreen()}`);
      }
    });
    this.reGroupAndResort(eventType);
  }

  private isContainInGroup(group: NotificationEntry, newEntry: NotificationEntry): boolean {
    let isContain: boolean = false;
    for (const child of group.childrenEntry!) {
      if (child.hashCode === newEntry.hashCode) {
        isContain = true;
        break;
      }
    }

    return isContain;
  }
  /**
   * 原有通知里面是否包含新到通知
   *
   * @param newEntry 刚收到的新通知
   */
  private isContainNtf(newEntry: NotificationEntry): boolean {
    let isContain: boolean = false;

    // 遍历当前显示的所有通知
    this.ntfAdapterList.forEach((entry: NotificationEntry) => {
      if (entry?.isGroup) {
        // 组通知检查其中子通知
        if (this.isContainInGroup(entry, newEntry)) {
          isContain = true;
        }
      } else if (entry?.hashCode === newEntry.hashCode) {
        isContain = true;
      }
    })
    return isContain;
  }

  /**
   * 是否可以添加通知
   * 1、锁屏面板
   *  1.1、ongoing通知：通知允许在锁屏显示，则添加
   *  1.2、其他通知：在锁屏界面；非静默通知；通知允许在锁屏显示，则添加
   * 2、通知中心全部添加
   */
  private canAddNtf(entry: NotificationEntry): boolean {
    if (!this.isKeyguard()) {
      return true;
    }

    // 实况超时数据，锁屏不显示
    if (entry.liveViewData?.isDataTimeout()) {
      log.showWarn('liveViewData is timeout.');
      return false;
    }

    // 锁屏场景
    if (entry.isOngoingLockScreen()) {
      return true;
    }

    let lockTime = Number.MAX_VALUE;
    if (this.callback?.getLockScreenTime) {
      lockTime = this.callback.getLockScreenTime() ?? Number.MAX_VALUE;
    }
    if ((entry.deliveryTime > lockTime) && this.isKeyguardShow() && entry.isShowInLockScreen()) {
      return true
    }

    return false;
  }

  private isAddNtf(entry: NotificationEntry): boolean {
    if (!this.isKeyguard()) {
      return true;
    }

    // 实况超时数据，锁屏不显示
    if (entry.liveViewData?.isDataTimeout()) {
      return false;
    }

    // 锁屏场景
    if (entry.isOngoingLockScreen()) {
      return true;
    }

    return false;
  }

  /**
   * 是否需要释放组
   * @param group
   */
  private checkIfNeedUnifiedRelease(group: NotificationEntry): void {
    if (group.childrenEntry?.length == 1) {
      group.childrenEntry.forEach((child) => this.unifiedRelease(child));
      return;
    }
    this.updateGroupInfo(group);
  }

  private reportNtfReceivedEvent(entry: NotificationEntry, canAdd: boolean, isScreenOn: boolean, flags: number): void {
    ImmersiveSysEventUtils.reportImmersiveKgNotificationReceivedEvent({
      USER_PACKAGE_NAME: entry.creatorBundleName,
      NOTIFICATION_ID: String(entry.id),
      NTF_HASHCODE: entry.hashCode,
      IS_PUSH: entry.isFromPush ? 0 : 1,
      IS_ONGOING: entry.isOngoing ? 0 : 1,
      IS_LIVE: entry.isLiveType() ? 0 : 1,
      CAN_ADD: canAdd,
      IS_NTF_AUTO_SCREEN_ON: isScreenOn,
      NOTIFICATION_FLAGS: flags
    });
  }

  /**
   * 通知列表删除数据
   *
   * @param ntfList 删除集
   */
  handleNtfRemove(ntfList: Array<NotificationEntry>): void {
    if (ArrayUtils.isEmpty(ntfList)) {
      return;
    }
    log.showInfo('do handleNtfRemove');
    let isNeedRefreshData: boolean = false;
    let batchUpdateGroupSet: Set<NotificationEntry> = new Set();
    ntfList.forEach((entry: NotificationEntry) => {
      log.showInfo('handleNtfRemove hash: ' + entry.hashCode + ', reason: ' + entry.reason + ', ' + this.getNtfType());
      // 清空数据集
      this.ntfClearMap?.delete(entry.hashCode);
      // 未读数据集
      this.ntfUnreadList?.delete(entry.hashCode);
      // 列表集
      let groupEntry = this.ntfDictMap.get(entry.hashCode);
      if (CommonUtils.isInvalid(groupEntry)) {
        // 如果没有找到，则全局搜索一下
        groupEntry = this.ntfAdapter.findGroupEntryByHashCode(entry?.hashCode);
        log.showError(`Group entry is invalid, find by hash code. Group type key is ${groupEntry?.getGroupTypeKey()}`);
      }
      this.ntfDictMap.delete(entry.hashCode);
      if (groupEntry?.removeChildEntry(entry)) {
        if (groupEntry.isItemExpanded && groupEntry.getChildrenSize() > 0) {
          log.showInfo(`group is showing expanded, delay update group info, ${groupEntry.creatorBundleName}`);
          this.notifyChange(groupEntry);
          this.ntfAdapter.addOrUpdateDataNoNeedUpdate(groupEntry);
          isNeedRefreshData = true;
          this.waitForUpdateGroups.add(groupEntry);
          return;
        }
        if (groupEntry.isInAggregate && groupEntry.getChildrenSize() > 0) {
          this.checkIfNeedUnifiedRelease(groupEntry);
          this.sortAdapterList();
          isNeedRefreshData = true;
          return;
        }

        this.deleteGroupIfEmpty(groupEntry);
        if (this.ntfAllList.get(groupEntry.getGroupTypeKey())) {
          this.updateGroupInfo(groupEntry, ntfList.length > 1);
          this.sortAdapterList();
          this.ntfAdapter.addOrUpdateDataNoNeedUpdate(groupEntry);
        }
        isNeedRefreshData = true;
        // 添加到批量更新集合中
        batchUpdateGroupSet.add(groupEntry);
      }
    });

    if (ntfList.length　>　1)　{
      // 批量更新相应的通知组
      batchUpdateGroupSet.forEach((group) => {
        // 只有组通知剩余通知数量大于0时才进行更新
        if (group.getChildrenSize() > 0) {
          this.notifyChange(group);
        }
      });
    }
    batchUpdateGroupSet.clear();

    if (isNeedRefreshData) {
      log.showInfo('do isNeedRefreshData update');
      this.updateAdapter(NtfDataChangeType.REMOVE);
    }

    this.refreshDataState();
    this.postNtfUnreadEvent();
    this.postUnifiedGroupRemindEvent();
  }

  updateClearButtonState(): void {
  }

  private initFoldDisplay(): void {
    try {
      if (!Display.isFoldable()) {
        log.info('current device is not foldable');
        return;
      }
    } catch (err) {
      log.error('call isFoldable failed', err);
      return;
    }

    this.foldStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus() ?
      DeviceState.EXPAND_STATE : DeviceState.FOLDED_STATE;
    SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropertyChangeCB,
    undefined, true, DropdownController.getInstance().getId());
    this.displayWidth = SCBScreenSessionManager.getInstance().getMainScreenSession().scbScreenProperty.width;
    log.showInfo(`initFoldDisplay type:${this.getNtfType()}, foldStatus:${this.foldStatus},` +
      `screenWidth:${this.displayWidth}`);
    this.onFoldDisplayChanged(this.displayWidth);
  }

  /**
   * 注册显示模式事件
   * @param isRegister 是否为注册操作
   */
  private handleDisplayModeEvent(isRegister: boolean = true) {
    if (LayoutUtils.isXTProductType()) {
      try {
        if (isRegister) {
          display.on('foldDisplayModeChange', this.onFoldDisplayModeCallback);
        } else {
          display.off('foldDisplayModeChange', this.onFoldDisplayModeCallback);
        }
      } catch (error) {
        log.showError(`handleDisplayModeEvent ${isRegister} on error ${error}`);
      }
    }
  }

  private onFoldDisplayModeCallback = (data: display.FoldDisplayMode): void => {
    log.showInfo(`XT displaymode changed to: ${data}`);
    this.onFoldDisplayChanged(SCBScreenSessionManager.getInstance().getMainScreenSession().scbScreenProperty.width);
  }

  private screenPropertyChangeCB = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void => {
    let foldStatus: DeviceState = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus() ?
    DeviceState.EXPAND_STATE : DeviceState.FOLDED_STATE;

    if (this.foldStatus === foldStatus && this.displayWidth === screenProperty.width) {
      log.showInfo(`screenPropertyChangeCB type:${this.getNtfType()}, foldStatus:${foldStatus},` +
        `screenWidth:${screenProperty.width}, foldStatus and screenWidth has not changed, ignore this event.`);
      return;
    }
    log.showInfo(`screenPropertyChangeCB type:${this.getNtfType()}, foldStatus:${foldStatus},` +
      `screenWidth:${screenProperty.width}`);
    this.foldStatus = foldStatus;
    this.displayWidth = screenProperty.width;
    this.onFoldDisplayChanged(screenProperty.width);
  }

  /**
   * 控制一键删除按钮是否显示
   */
  protected isShowClearBtn(): boolean {
    return !ArrayUtils.isEmpty(this.ntfClearMap);
  }

  /**
   * 折叠屏切换
   *
   * @param foldDisplayMode 折叠屏显示模式
   */
  private onFoldDisplayChanged = async (width: number): Promise<void> => {
    log.showInfo(`foldDisplayModeChange callback displayMode: ${this.foldStatus}, width: ${width}`);
    const displayInfo = Display.getDefaultDisplaySync();
    let isLand: boolean = displayInfo.orientation === Display.Orientation.LANDSCAPE ||
      displayInfo.orientation === Display.Orientation.LANDSCAPE_INVERTED;
    if (LayoutUtils.isXTProductType()) {
      // XT设备根据宽高判断横竖屏
      isLand = displayInfo.width > displayInfo.height;
    }

    let isFullDisplay = this.foldStatus === DeviceState.EXPAND_STATE;
    this.listContentConfig.changeFoldConfig(this.foldStatus);
    this.callback?.onFoldDisplayModeChange(isFullDisplay);
    this.notifyDisplayChanged(width,
      (isFullDisplay && !this.isSmallFold() && !LayoutUtils.isMatchXTFoldMode(XTLayoutType.F)) || isLand);
    this.postNtfSbIconEvent();
    this.callback?.onClearButtonStateChange(this.isShowClearBtn());
  }

  /**
   * 是否小折叠类产品 扩展新形态小折叠产品、pocket
   *
   * @returns 小折叠类产品
   */
  isSmallFold(): boolean {
    return DeviceHelper.isSmallFoldProduct();
  }

  /**
   * 挖孔位置切换事件
   */
  private onCutoutEvent = (event: CutoutEvent): void => {
    let isRightMid = false;
    if (event?.cutoutPosition === CutoutEvent.CUTOUT_RIGHT && !CommonUtils.isInvalid(event.cutoutRect)) {
      // 中心点误差MID_LINE_ERROR
      let midCut = (event.cutoutRect?.top ?? 0) + (event.cutoutRect.height) / 2;
      let midScreen = ArkUIAdapter.px2vp(this.screenHeight / 2);
      isRightMid = (midCut > (midScreen - MID_LINE_ERROR)) && (midCut < (midScreen + MID_LINE_ERROR));
    }

    // 挖孔位置切换
    if (this.isRightMidCutout !== isRightMid) {
      log.showInfo('onCutoutEvent change isRightMid: ' + isRightMid);
      this.isRightMidCutout = isRightMid;
      this.callback?.onUpdateClearPadding?.(isRightMid);
    }
  };

  /**
   * 屏幕横竖屏切换
   *
   * @param event 事件
   */
  private onDisplayEvent = (event: DisplayEvent): void => {
    this.screenHeight = event?.display?.bounds?.height!;
    let isLand = event.isLand();
    let disWidth = event.display?.bounds.width!;
    log.showInfo(`onDisplayEvent dis width [%{public}d], dis height [%{public}d], is land [%{public}s]`,
      disWidth, this.screenHeight, isLand);

    if (DeviceHelper.isPad()) {
      this.handleDisplayEventIsPad();
    } else if (this.isLandDisplay != isLand) {
      this.handleDisplayEvent(isLand, disWidth);
    }
  }

  private handleDisplayEventIsPad(): void {
    const orientation = Display.getDefaultDisplaySync().orientation;
    const isLand = orientation === Display.Orientation.LANDSCAPE ||
      orientation === Display.Orientation.LANDSCAPE_INVERTED;

    this.isLandDisplay = isLand;
    this.callback?.onDisplayLandStateChange(isLand);
    // PAD设备disWidth数据从Display接口获取
    let display = Display.getDefaultDisplaySync();
    let disWidth = display?.width;
    this.notifyDisplayChanged(disWidth, isLand);
  }

  public refreshFoldNtfWidth(): void {
    try {
      const displayInfo = Display.getDefaultDisplaySync();
      let isLand: boolean = displayInfo.orientation === Display.Orientation.LANDSCAPE ||
        displayInfo.orientation === Display.Orientation.LANDSCAPE_INVERTED;
      if (LayoutUtils.isXTProductType()) {
        // XT设备根据宽高判断横竖屏
        isLand = displayInfo.width > displayInfo.height;
      }
      const isFullDisplay = this.foldStatus === DeviceState.EXPAND_STATE;
      this.notifyDisplayChanged(displayInfo.width,
        (isFullDisplay && !this.isSmallFold() && !LayoutUtils.isMatchXTFoldMode(XTLayoutType.F)) || isLand, false);
    } catch (e) {
      log.error('refresh fold ntf width error: ', e);
    }
  }

  private handleDisplayEvent(isLand: boolean, disWidth: number): void {
    this.isLandDisplay = isLand;
    this.callback?.onDisplayLandStateChange(isLand);
    // 下拉面板、锁屏面板 横竖屏切换需变换宽度
    if (!this.isDropdown() && !this.isKeyguard()) {
      return;
    }
    this.notifyDisplayChanged(disWidth, isLand);
  }

  /**
   * 下发屏幕状态发生变化通知
   *
   * @param disWidth 屏幕宽度
   * @param isLand 是否为横屏
   */
  private notifyDisplayChanged(disWidth: number, isLand: boolean, forceRefresh: boolean = true): void {
    if (DeviceHelper.isPC()) {
      return;
    }
    ArkUIAdapter.runWithScope(() => {
      let contentWidth: number = this.getContentWidth(disWidth, isLand);
      // 锁屏面板12栅格占6栅格
      if (this.isKeyguard() && ArkUIAdapter.px2vp(disWidth) >= GridConstants.RESPECT_VP_MAX) {
        const gutter = ArkUIAdapter.vp2px(GridConstants.RESPECT_NUM_MAX);
        const aveWidth = (disWidth - gutter * (GridConstants.RESPECT_NUM_MAX + 1)) / GridConstants.RESPECT_NUM_MAX;
        contentWidth = aveWidth * CommonConstants.DEFAULT_ROW + gutter * (CommonConstants.DEFAULT_ROW - 1);
      }

      const margin = CommonUtils.splicePx((disWidth - contentWidth) / 2);
      const width = CommonUtils.splicePx(contentWidth);
      if (!forceRefresh && this.ntfStyle.ntfListWidth === width && this.ntfStyle.ntfRootLeftPadding === margin) {
        log.showInfo(`ntf style no change, width: ${width}, margin: ${margin}`);
        return;
      }
      log.showInfo('Display changed. Input: dis width [%{public}d], is land [%{public}s]. ' +
        'Output: margin [%{public}s], width [%{public}s]', disWidth, isLand, margin, width);
      this.updateNtfStyle(margin, width);
      this.callback?.onNtfStyleChange(this.ntfStyle);
      this.displayCallback.forEach((callback) => callback?.onNtfStyleChange(this.ntfStyle));
    })
  }

  /**
   * 根据屏幕宽度及屏幕状态计算内容宽度
   * 1、PAD、折叠屏展开态固定宽度，有margin
   * 2、直板机、折叠屏折叠态横屏状态下取值采用栅格方式计算，有margin
   * 3、其他（平板手机竖屏、折叠态竖屏）：宽度占满全屏，无margin
   *
   * @param disWidth 屏幕宽高
   * @param isLand 是否为横屏状态
   * @returns 内容宽度
   */
  private getContentWidth(disWidth: number, isLand: boolean): number {
    if (this.isPadLayout() ||
      (this.isFoldExpanded() && !this.isSmallFold() && !LayoutUtils.isMatchXTFoldMode(XTLayoutType.F))) {
      return ArkUIAdapter.vp2px(LAND_PAD_OR_FOLD_NTF_WIDTH);
    }
    // 直板机、折叠屏折叠态横屏状态下取值
    if (isLand) {
      return ResUtils.getTimeStartWidthByLandScreenWidth(disWidth);
    }
    return disWidth;
  }

  private updateNtfStyle(horizontalMargin: string, width: string) {
    this.ntfStyle.ntfRootLeftPadding = horizontalMargin;
    this.ntfStyle.ntfRootRightPadding = horizontalMargin;
    this.ntfStyle.ntfListWidth = width;
  }

  /**
   * 是否为折叠屏展开态
   *
   * @returns true/false
   */
  private isFoldExpanded(): boolean {
    return Display.isFoldable() && this.foldStatus === DeviceState.EXPAND_STATE;
  }

  /**
   * 窗口可见性事件
   *
   * @param event 事件
   */
  private onWindowEvent = (event: WindowEvent): void => {
    // 锁屏窗口不可见时，清除锁屏非ongoing通知
    if (this.isKeyguard() && event.isMatchName(WINDOW_NAME_KEYGUARD) && event.isWindowEndHide()) {
      this.removeAllKeyguardNtf();
    }
    // PC面板可见时，清空未读
    if (this.isPc() && event.isMatchName(WINDOW_NAME_PC_NTF_PANEL)) {
      this.ntfUnreadList?.clear();
      this.postNtfUnreadEvent();
    }
    // 当前通知面板窗口隐藏，重置条目展开状态
    let windowName = NTF_TYPE_MAP_WINDOW_NAME.get(this.getNtfType()) as string;
    if (event.isMatchName(windowName) && event.isWindowEndHide()) {
      this.resetAllNtfItemExpand();
    }
    // 回调窗口状态
    if (event.isMatchName(windowName)) {
      if (event.isWindowStartShow()) {
        this.callback?.onWindowStateChange(true);
      } else if (event.isWindowEndHide() || event.isWindowStartHide()) {
        // 面板隐藏后延迟解除清理通知冻结标志，避免动效结尾画面跳变
        setTimeout(() => {
          this.releaseUpdateFreeze('clearAll');
        }, 100);
        // 面板隐藏结束时，重置条目展开状态
        this.resetAllNtfItemExpand();
        this.callback?.onWindowStateChange(false);
      }
    }
  }

  /**
   * 重置所有条目展开状态
   */
  private resetAllNtfItemExpand(): void {
    // 所有条目重置
    this.ntfAdapterList?.forEach((entry: NotificationEntry) => {
      entry?.resetItemExpandState();
    });
  }

  /**
   * 锁屏通知，清除所有非ongoing通知
   */
  private removeAllKeyguardNtf(): void {
    if (!this.isKeyguard()) {
      return;
    }
    if (ArrayUtils.isEmpty(this.ntfAdapterList)) {
      return;
    }
    let len = ArrayUtils.getSize(this.ntfAdapterList);
    for (let i = len - 1; i >= 0; i--) {
      let groupEntry = this.ntfAdapterList[i];
      if (!groupEntry.isOngoingLockScreen()) {
        this.ntfAdapterList.splice(i, 1);
        this.ntfAllList.delete(groupEntry.getGroupTypeKey());
      }
    }
    // 刷新
    this.refreshDataState();
    this.ntfAdapter.setDataSource(this.ntfAdapterList);
  }

  /**
   * 添加通知数据到集合
   * 会封装一层组通知
   *
   * @param ntfEntry 通知数据
   * @param isUpdate 是否是更新的通知
   * @param isGroupUpdate 是否需要更新分组
   * @return 组通知数据
   */
  private addNtfEntry(ntfEntry: NotificationEntry,
                      isUpdate: boolean,
                      isGroupUpdate: boolean = false): NotificationEntry {
    log.showInfo(`addNtfEntry: ${ntfEntry.hashCode}`);
    if (this.isKeyguard()) {
      // 隐藏通知内容
      this.setEntryHideContent(ntfEntry, ntfEntry.isLiveType() ? this.shouldHideLiveViewContent :
        this.shouldHideNtfContent);
    }
    let groupKey = ntfEntry.getGroupTypeKey();

    // 是否有分组. 如果通知更新了slot type，传入isGroupUpdate, 重新分组
    let group = !isUpdate || isGroupUpdate ? this.getGroupEntry(groupKey) : this.ntfDictMap.get(ntfEntry.hashCode)!;
    if (!group && this.getGroupEntry(groupKey)) {
      group = this.getGroupEntry(groupKey);
    }
    if (CommonUtils.isInvalid(group)) {
      group = ntfEntry.createGroup()!;
      if (this.isKeyguard()) {
        // 隐藏通知内容
        this.setEntryHideContent(group, ntfEntry.isLiveType() ? this.shouldHideLiveViewContent :
          this.shouldHideNtfContent);
      }
      this.ntfAllList.set(groupKey, group);
    } else {
      if (group.isLiveType()) {
        // 解决按压实况卡片过程中数据更新不及时问题
        this.updateLiveViewCreator(group, ntfEntry);
      }
      group.addUpdateChildEntry(ntfEntry);
      group.appName.value = ntfEntry.appName.value;
    }
    this.ntfDictMap.set(ntfEntry.hashCode, group);

    // 一键清除
    this.checkClearState(ntfEntry);
    return group;
  }

  /**
   * 更新实况窗创建时间
   */
  private updateLiveViewCreator(group: NotificationEntry, ntfEntry: NotificationEntry) {
    const oldEntry = group.childrenEntry?.find((child) => child.equals(ntfEntry));
    const createTime = oldEntry?.liveViewData?.createTime;
    if (createTime && ntfEntry.liveViewData) {
      if (SystemUICcmConfig.instance.isEnabledLive2 &&
        (ntfEntry.remindConfig.isCapsuleFlip() || ntfEntry.remindConfig.isBannerEnable())) {
        // 强提醒更新实况同时更新createTime,保持排序与2.0卡片列表一致
        ntfEntry.liveViewData.createTime = ntfEntry?.liveViewData?.deliveryTime ?? createTime
        return;
      }
      ntfEntry.liveViewData.createTime = createTime;
    }
  }

  /**
   * 遍历所有通知组，删除相同hashCode的通知
   *
   * @param ntfEntry 通知数据
   * @return void
   */
  private deleteSameHashCodeNtf(ntfEntry: NotificationEntry): boolean {
    // find：是否找到了相同ID的通知
    let find: boolean = false;
    // findGroup: 找到的相同ID的通知所在的通知组
    let findGroup: NotificationEntry = new NotificationEntry();
    log.showInfo(`deleteSameHashCodeNtf:${ntfEntry.hashCode} ntfAllList.size=${this.ntfAllList.size}`);
    this.ntfAllList.forEach((group: NotificationEntry) => {
      if (!group.childrenEntry || find) {
        return;
      }
      if (group.creatorUid !== ntfEntry.creatorUid) {
        return;
      }

      for (let i = 0; i < group.childrenEntry.length; i++) {
        if (find) {
          return;
        }
        let entry = group.childrenEntry[i];
        // 同组的不删除，否则会导致新通知无法拷贝原通知的数据监听listener，进而导致新通知不显示
        if (entry.hashCode === ntfEntry.hashCode && entry.getGroupTypeKey() !== ntfEntry.getGroupTypeKey()) {
          find = true;

          group.childrenEntry.splice(i, 1);
          log.showInfo(`delete from child:${i} after size:${group.childrenEntry.length}`);
          // 如果通知更新了slot type，需要单独更新分组，从字典中删除，避免整组更新
          this.ntfDictMap.delete(ntfEntry.hashCode);
          findGroup = group;
          break;
        }
      }
    });
    if (find) {
      this.deleteGroupIfEmpty(findGroup);
      findGroup?.updateGroup(findGroup?.getFirstChildEntry()!);
      this.notifyChange(findGroup);
    }
    if (find && findGroup?.childrenEntry?.length === 0) {
      // 如果删除通知后，组通知的子通知个数为0，需要删除组通知
      log.showWarn(`find, no child, delete group`);
      this.ntfAllList?.delete(findGroup?.getGroupTypeKey());
      ArrayUtils.delete(this.ntfAdapterList, findGroup);
    }

    if (find && !ntfEntry.canClear()) {
      // 如果新通知是不可删除的通知，需要从 ntfClearMap 里删除之前的通知，避免新通知被删除
      log.showInfo(`find, new ntf can't clear, delete old in clearList`);
      this.ntfClearMap?.delete(ntfEntry.hashCode);
    }
    return find;
  }

  private postUnifiedGroupRemindEvent(): void {
    log.showInfo(`postUnifiedGroupRemindEvent.`);
    if (!NotificationType.isDropdown(this.getNtfType())) {
      log.showInfo(`do not post unified group event`);
      return;
    }
    let unifiedGroupEventEntry: UnifiedGroupEventEntry = {
      dictMap: this.ntfDictMap,
      ntfAllListMap: this.ntfAllList
    };
    EvtBus.post(UnifiedGroupRemindEvent, {
      unified: unifiedGroupEventEntry
    });
  }

  private deleteGroupIfEmpty(group: NotificationEntry): void {
    if (group.getChildrenSize() === 0) {
      log.showInfo(`find, no child, delete group: ${group?.getGroupTypeKey()}`);
      this.ntfAllList?.delete(group?.getGroupTypeKey());
      ArrayUtils.delete(this.ntfAdapterList, group);
      this.ntfAdapter.deleteDataNoNeedUpdate(group);
    }
  }

  /**
   * 检测是否可一键清除
   *
   * @param ntfEntry 通知数据
   */
  private checkClearState(ntfEntry: NotificationEntry): void {
    if (CommonUtils.isInvalid(ntfEntry)) {
      return;
    }
    // 可一键清除，锁屏面板不涉及
    if (ntfEntry.canClear() && !this.isKeyguard()) {
      this.ntfClearMap?.set(ntfEntry.hashCode, ntfEntry);
    }
  }

  /**
   * 检测是否为未读通知
   *
   * @param ntfEntry 通知数据
   */
  private checkNtfUnreadState(ntfEntry: NotificationEntry): void {
    if (CommonUtils.isInvalid(ntfEntry)) {
      return;
    }
    // 只有PC、TV面板需要未读通知
    if (!this.isPc()) {
      return;
    }
    // 面板可见，已读
    if (this.isPcNtfPanelShow()) {
      return;
    }
    this.ntfUnreadList?.set(ntfEntry.hashCode, ntfEntry);
    this.postNtfUnreadEvent();
  }

  /**
   * 适配器通知列表排序
   */
  private sortAdapterList(): void {
    this.ntfAdapterList.sort((entryA: NotificationEntry, entryB: NotificationEntry): number => {
      // 1、紧急通知 2、实况 3、置顶 4、社交服务客服 5、时间
      // 获取权重，没有定义的类型默认999
      let entryAWeight = this.getWeight(entryA);
      let entryBWeight = this.getWeight(entryB);
      // 权重不等，按权重排序
      if (entryAWeight !== entryBWeight) {
        return entryAWeight - entryBWeight;
      }
      // 权重相等，有特殊情况
      if (entryA.isLiveType()) {
        return LiveViewHelper.sortLiveEntry(entryA.getFirstChildEntry()!.liveViewData, entryB.getFirstChildEntry()!
          .liveViewData);
      }
      // 其他一律时间排序
      return entryB.deliveryTime - entryA.deliveryTime;
    });
  }

  /**
   * 刷新数据状态
   */
  private refreshDataState(eventType?: number): void {
    // 数据集是否为空
    this.callback?.onNtfListEmptyStateChange(ArrayUtils.isEmpty(this.ntfAdapterList));
    // 是否显示清空按钮
    this.callback?.onClearButtonStateChange(this.isShowClearBtn());
    if (this.isRefreshDataState(eventType)) {
      this.postNtfSbIconEvent();
    }
  }

  private isRefreshDataState(eventType?: number): boolean {
    // 不需要横幅消失后再显示 刷新
    if (!this.listContentConfig.isRefreshStatusBarIconDelay) {
      log.showInfo(`post ntfIcon, isRefreshStatusBarIconDelay
      is ${this.listContentConfig.isRefreshStatusBarIconDelay}`);
      return true;
    }
    // 当前没有横幅显示 刷新
    if (!this.isHeadsUpAdd) {
      log.showInfo(`post ntfIcon, this.isHeadsUpAdd is ${this.isHeadsUpAdd}`);
      return true;
    }
    log.showInfo(`not post ntfIcon`);
    return false;
  }

  /**
   * 发送通知状态栏图标列表变更事件
   */
  private postNtfSbIconEvent(forceRefresh: boolean = false): void {
    // 状态栏图标由下拉面板提供
    if (!this.isDropdown()) {
      return;
    }
    if (!this.ntfSbIconEvent?.ntfSbIconList) {
      return;
    }
    let iconList: NotificationEntry[] = [];
    // 列表中找出前6个可显示状态栏图标的通知
    for (let entry of this.ntfAdapterList) {
      if (this.listContentConfig.isFilterNtfAfterScreenLock && (
        (entry.childrenEntry && entry.childrenEntry?.length > 0 && !entry.childrenEntry[0].isLockScreenEnable) ||
        entry.deliveryTime <= this.listContentConfig.screenLockTime)) {
        log.showInfo('isFilterNtfAfterScreenLock ' + this.listContentConfig.isFilterNtfAfterScreenLock +
          'screenLockTime' + this.listContentConfig.screenLockTime);
        continue;
      }
      // 取最新子通知为状态栏图标数据源
      if (entry?.isGroup) {
        entry.childrenEntry?.forEach((entryChild) => {
          this.addIconList(iconList, entryChild);
        });
        continue;
      }
      this.addIconList(iconList, entry);
    }
    log.showInfo('postNtfSbIconEvent sb icon size: ' + ArrayUtils.getSize(iconList));
    if (this.ntfSbIconEvent != undefined && this.isIconListUpdate(this.ntfSbIconEvent?.ntfSbIconList ?? [], iconList) ||
      forceRefresh) {
      log.showInfo('need ntfSbIcon refresh');
      this.ntfSbIconEvent.forceRefresh = forceRefresh;
      this.ntfSbIconEvent.ntfSbIconList = iconList;
      if (!EmergencyThermalSafeManager.instance.isEmergencyOrThermalSafeMode()) {
        EvtBus.post(NtfStatusIconEvent, this.ntfSbIconEvent);
      } else {
        this.postEmergencyWhiteIcons(iconList);
      }
    }
  }

  private postEmergencyWhiteIcons(iconList: NotificationEntry[] | undefined): void {
    if (!iconList) {
      return;
    }
    let emergencyIconList: NotificationEntry[] = [];
    for (let i = 0; i < iconList.length; i++) {
      if (EmergencyThermalSafeManager.instance.isInWhiteList(iconList[i]?.creatorBundleName)) {
        emergencyIconList.push(iconList[i])
      }
    }
    let emergencyIconEvent = NtfStatusIconEvent.create([]);
    emergencyIconEvent.ntfSbIconList = emergencyIconList;
    EvtBus.post(NtfStatusIconEvent, emergencyIconEvent);
  }

  exitEmergencyMode(): void {
    EvtBus.post(NtfStatusIconEvent, this.ntfSbIconEvent);
  }

  postEmergencyNtfStatusIcon(): void {
    this.postEmergencyWhiteIcons(this.ntfSbIconEvent?.ntfSbIconList);
  }

  private isIconListUpdate(oldIconList: Array<NotificationEntry>, newIconList: Array<NotificationEntry>): boolean {
    if (oldIconList.length !== newIconList.length ||
      oldIconList.findIndex((icon, index) => this.getSbIconUniKey(newIconList[index]) !== this.getSbIconUniKey(icon) ||
        newIconList[index].smallIcon !== icon.smallIcon) > -1) {
      return true;
    }
    return false;
  }

  private addIconList(iconList: Array<NotificationEntry>, entry: NotificationEntry): void {
    let isShowStatusBarIcon: boolean = entry.isShowStatusBarIcon();
    entry.childrenEntry?.forEach((entryChild) => {
      isShowStatusBarIcon = isShowStatusBarIcon || entryChild.isShowStatusBarIcon();
    });
    // 图标基于uid进行聚合处理，实况与非实况作区分
    if (isShowStatusBarIcon && !iconList?.find((icon) =>
    this.getSbIconUniKey(icon) === this.getSbIconUniKey(entry) && icon.isLiveType() === entry.isLiveType())) {
      iconList?.push(entry);
    }
  }

  /**
   * 获取状态栏图标唯一值
   * @param entry 通知实例
   * @returns 状态栏图标唯一值
   */
  private getSbIconUniKey(entry: NotificationEntry): string {
    if (!entry) {
      log.showInfo(`getSbIconUniKey empty entry`);
      return '';
    }

    if (entry.creatorBundleName && entry.creatorBundleName != '') {
      return `${entry.creatorBundleName}_${entry.creatorUid}`;
    }

    log.showInfo(`getSbIconUniKey empty creatorBundleName`);
    return `${entry.creatorUid}`;
  }

  /**
   * 发送未读通知数量变化事件
   */
  private postNtfUnreadEvent(): void {
    if (!this.isPc()) {
      return;
    }
    if (CommonUtils.isInvalid(this.ntfUnreadEvent)) {
      return;
    }
    let curCount = ArrayUtils.getSize(this.ntfUnreadList);
    if (this.ntfUnreadEvent.ntfUnreadCount != curCount) {
      this.ntfUnreadEvent.ntfUnreadCount = curCount;
      log.showInfo('postNtfUnreadEvent unread size: ' + curCount);
      EvtBus.post(NtfUnreadEvent, this.ntfUnreadEvent);
    }
    // 小红点是否可见
    if (this.ntfIconRedHotEvent != undefined) {
      this.ntfIconRedHotEvent.isShowRedHot = curCount > 0;
    }
    EvtBus.post<IconRedHotEvent>(IconRedHotEvent, this.ntfIconRedHotEvent);
  }

  private deleteWrongGroupNtf(): void {
    let tempList: Map<string, NotificationEntry> = new Map();
    this.ntfAllList.forEach((value, key) => {
      tempList.set(key, value);
    })
    let deleteKey: string[] = [];
    let deleteValue: NotificationEntry[] = [];
    this.ntfAllList.forEach((value, key) => {
      if (value?.isInAggregate) {
        value?.sortChildren();
        value?.updateAggregateGroup();
        value?.updateGroupSlotLevel();
        this.notifyChange(value);
      } else if (key !== value.getGroupTypeKey()) {
        log.showInfo('delete group key: ' + key + ', correct key : ' + value.getGroupTypeKey());
        deleteKey.push(key);
        deleteValue.push(value);
        value.childrenEntry?.forEach(entry => {
          let group = this.addNtfEntry(entry, false);
          group?.sortChildren();
          group?.updateGroup(group?.getFirstChildEntry()!);
          group?.updateGroupSlotLevel();
          // 列表区分新增/更新
          let oldIndex = ArrayUtils.updateArr(this.ntfAdapterList, group);
          let curIndex = ArrayUtils.findIndex(this.ntfAdapterList, group);
          log.showInfo('deleteWrongGroupNtf oldIndex: ' + oldIndex + ', curIndex: ' + curIndex);
          // 通知数据变化
          this.notifyChange(group);
          // 子通知数据变化
          this.notifyChange(entry);
        })
      }
    });
    deleteKey.forEach(key => this.ntfAllList.delete(key));
    deleteValue.forEach(value => {
      ArrayUtils.deleteArr(this.ntfAdapterList, value);
      const updateEntry = this.ntfAllList.get(value.getGroupTypeKey());
      if (updateEntry === undefined) {
        log.showWarn('deleteWrongGroupNtf updateEntry === undefined, getGroupTypeKey: ' + value.getGroupTypeKey());
        return;
      }
      ArrayUtils.updateArr(this.ntfAdapterList, updateEntry);
    });
  }

  private updateUnifiedGroup(entryList: Array<NotificationEntry>): void {
    log.showDebug(`updateUnifiedGroup, size: ${entryList?.length}, enable: ${this
      .unifiedEnable}, settingOn: ${this.unifiedSettingOn}`);
    if (entryList && this.unifiedEnable) {
      entryList.forEach((entry) => {
        if (entry?.aggregateContent?.key) {
          this.underUpdatingUnified.set(entry.aggregateContent.key, entry?.aggregateContent);
        }
        if (entry?.aggregateContent?.status === UnifiedGroupStatus.UNIFIED_ASYNC) {
          entry.updateUnifiedInfoOnly = true;
        }
      })
    }
  }

  /**
   * 冻结通知更新，避免通知更新影响UI渲染
   */
  public setUpdateFreeze(key: string, timeout = 1000): void {
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
        this.currentPromise = undefined
      }
    })
  }

  /**
   * 解除通知更新冻结
   */
  public releaseUpdateFreeze(key: string): void {
    log.showInfo('Release update freeze');
    this.freezeMap.get(key)?.resolve();
  }

  /**
   * 获取组通知实例
   *
   * @param groupKey 组通知标识
   */
  getGroupEntry(groupKey: string): NotificationEntry {
    return this.ntfAllList.get(groupKey)!;
  }

  getClearNtfMap(): Map<string, NotificationEntry> {
    return this.ntfClearMap;
  }

  /**
   * 获取一键删除时各类通知被删除数量
   */
  getAllCanClearCount(): NtfCanClear {
    let clearCount: NtfCanClear = {
      unknownNtfCount: 0,
      socialNtfCount: 0,
      serviceNtfCount: 0,
      contentNtfCount: 0,
      allNtfCount: 0
    };
    this.ntfClearMap.forEach((entry: NotificationEntry) => {
      if (entry === undefined) {
        return;
      }
      clearCount.allNtfCount += 1;
      switch (entry.slotType) {
        case UNKNOWN_DELETED_NUMBER:
          clearCount.unknownNtfCount += 1;
          break;
        case 1:
          clearCount.socialNtfCount += 1;
          break;
        case 2:
          clearCount.serviceNtfCount += 1;
          break;
        case 3:
          clearCount.contentNtfCount += 1;
          break;
        default:
          break;
      }
    })
    return clearCount;
  }

  /**
   * 数据重加载
   */
  protected onDataReloaded(): void {
    this.ntfAdapter?.onDataReloaded();
  }

  /**
   * 设置通知隐藏内容
   * @param entry 通知条目
   * @param isHideContent 是否隐藏内容
   */
  protected setEntryHideContent(entry: NotificationEntry, isHideContent: boolean): void {
    let isAppLocked: boolean = LockScreenNtfAppLockUtils.checkEntryAddAppLock(entry);
    // 加锁实况通知是否隐藏跟随人脸解锁状态，普通通知没有，为了避免实况通知频繁引起刷新，这里通过hasAppLocked进行控制
    this.hasAppLocked = this.hasAppLocked || (isAppLocked && entry.isLiveType());
    // 校验应用是否在豁免名单中
    isAppLocked = LockScreenNtfAppLockUtils.IsNtfNeedLock(entry, this.isSecureAndLocked, isAppLocked);
    entry.setShouldHideContent(isHideContent, isAppLocked);
    entry.immersiveNtfData?.setNtfHide(entry.isHideContent);
    entry.immersiveNtfData?.setAppLocked(isAppLocked);
  }

  private getWeight(entry: NotificationEntry): number {
    if (entry.slotType === notificationManager.SlotType.LIVE_VIEW ||
      entry.slotType === notificationManager.SlotType.EMERGENCY_INFORMATION) {
      return NTF_SLOT_SORT_WEIGHT.get(entry.slotType) ?? OTHER_TYPES_SORT_WEIGHT;
    }
    if (entry.isDisplayAtTop) {
      return DISPLAY_AT_TOP_SORT_WEIGHT;
    }
    if (entry.sortWeight) {
      return entry.sortWeight;
    }
    return NTF_SLOT_SORT_WEIGHT.get(entry.slotType) ?? OTHER_TYPES_SORT_WEIGHT;
  }

  private onHeadsUpChangeEvent(event?: HeadsUpChangeEvent): void {
    if (this.isHeadsUpAdd) {
      if (this.listContentConfig.isRefreshStatusBarIconDelay) {
        this.postNtfSbIconEvent();
      }
      this.isHeadsUpAdd =
        !this.isLastHeadsUpEventNull && Boolean(event?.hashCode) && this.listContentConfig.isRefreshStatusBarIconDelay;
      this.isLastHeadsUpEventNull = event ? false : true;
      return;
    }
    if (event?.hashCode) {
      this.isHeadsUpAdd = true;
      this.isLastHeadsUpEventNull = event ? false : true;
    }
  }

  /**
   * 是否是更多通知
   * @param hashCode 通知hashCode
   * @returns 是否是更多通知
   */
  public isExtraNtf(hashCode: string): boolean {
    return this.ntfDictMap.get(hashCode)?.isExtraContentType() ?? false;
  }
}

/**
 * 显示切换交互接口
 */
export interface DisplayCallback {
  /**
   * 显示类型修改
   *
   * @param ntfStyle
   */
  onNtfStyleChange(ntfStyle: NotificationListStyle): void;
}

/**
 * 组件交互接口
 */
export interface NtfListCallback {
  getLockScreenTime?: () => number;
  /**
   * 获取通知列表类型
   *
   * @return NotificationType
   */
  getNtfType(): number;

  /**
   * 窗口面板可见性变化回调
   *
   * @param isWindowShow 窗口是否可见
   */
  onWindowStateChange(isWindowShow: boolean): void;

  /**
   * 横竖屏切换状态回调
   *
   * @param isLand 是否横屏
   */
  onDisplayLandStateChange(isLand: boolean): void;

  /**
   * 面板样式属性变换回调
   *
   * @param ntfStyle 样式属性
   */
  onNtfStyleChange(ntfStyle: NotificationListStyle): void;

  /**
   * 通知列表是否为空状态切换
   *
   * @param isNtfListEmpty true无数据
   */
  onNtfListEmptyStateChange(isNtfListEmpty: boolean): void;

  /**
   * 通知列表清空按钮状态切换
   *
   * @param isShowClearButton true显示清空按钮
   */
  onClearButtonStateChange(isShowClearButton: boolean): void;

  /**
   * 折叠屏显示状态发生变化回调
   *
   * @param isFullDisplay 是否全屏显示
   */
  onFoldDisplayModeChange(isFullDisplay: boolean): void;

  /**
   * 全部清除按钮间距更新
   *
   * @param isRightMidCutout 当前是否右孔垂直居中
   */
  onUpdateClearPadding?(isRightMidCutout: boolean): void;

  /**
   * 锁屏加锁状态变化回调
   *
   * @param isKeyguardLock 锁屏是否在加锁状态
   */
  onKgLockStateChange?(isKeyguardLock: boolean): void;

  /**
   * 是否支持展示聚合
   *
   * @returns isAllowed
   */
  getUnifiedAllowed?(): boolean;
}

/**
 * 可删除通知数量
 */
export interface NtfCanClear {
  unknownNtfCount: number,
  socialNtfCount: number,
  serviceNtfCount: number,
  contentNtfCount: number,
  allNtfCount: number,
}

/**
 * 组件变化交互接口
 */
export interface NtfListChangeCallback {
  /**
   * 是否正在清除全部通知状态回调
   *
   * @param isClearingAll 是否正在清除所有通知
   */
  onClearingAllChange(isClearingAll: boolean): void;
}