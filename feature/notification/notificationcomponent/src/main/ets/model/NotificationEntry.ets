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

import { NotificationEntryEvent, UnifiedGroupUpdateEvent } from '../common/event/NotificationEvent';
import NtfMgr from '@ohos.notificationManager';
import {
  ArrayUtils,
  CommonUtils,
  Equality,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import { DeviceHelper, EvtBus } from '@ohos/frameworkwrapper';
// import { MemoryUtils } from '@ohos/basicutils';
import { BaseNotification,
  getIsInEmergencyOrThermalSafeMode,
  IComponentData,
  IImmersiveData,
  ImmersiveKgParserCtrlType,
  LiveBaseTemplate,
  LiveSystemTemplate,
  LiveType,
  LiveViewCommonConstants,
  NotificationAction, NotificationBaseContent,
  notificationCcmConfig,
  NotificationCreatorType,
  NtfLongTextContent,
  NtfMultiLineContent,
  NtfPictureContent,
  NtfReminderConfig,
  ObservedItem,
  OtherBaseTemplate,
  OverlayIconStyle,
  ParserController,
  parserCtrlMgr,
  SystemuiConstants,
  SysTypeCode} from '@ohos/systemuicommon';
import { SINGLE_APP_LIMIT } from './NotificationListLimiter';
import { image } from '@kit.ImageKit';
import { Context } from '@kit.AbilityKit';
import resourceManager from '@ohos.resourceManager';
import notificationManager from '@ohos.notificationManager';
import dataParserController from '@ohos/systemuicommon/src/main/ets/liveview/parse/DataParserController';
import { bundleManager } from '@kit.AbilityKit';
import { DeviceModeEnum } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { NotificationType } from '../common/NotificationType';
import { LiveFlightTemplate } from '@ohos/systemuicommon/src/main/ets/liveview/data/template/LiveFlightTemplate';
import { deliverSystemBundleVerity } from '@ohos/systemuicommon/src/main/ets/utils/BundleVerityUtil';

const TAG = 'SysUI_NotificationEntry';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 社交通道类型
 */
const SLOT_TYPE_SOCIAL_COMMUNICATION: number = 1;

/**
 * 服务通道类型
 */
const SLOT_TYPE_SERVICE_INFORMATION = 2;

/**
 * 客服通道类型
 */
const SLOT_TYPE_CUSTOMER_INFORMATION = 5;

const HI_BOARD = 'com.ohos.intelligent';
const CHINA_RAIL = '12306';

/**
 * 通知数据变化监听
 */
export interface NtfDataUpdateListener {
  /**
   * 通知数据变化回调
   *
   * @param newEntry 新通知对象
   */
  onNtfDataUpdate: (newEntry: NotificationEntry) => void;
}

/**
 * 通知退场监听
 */
export interface NtfOutListener {
  /**
   * 通知退场变化回调
   *
   */
  onNtfOutUpdate(): void;
}

function getUid() : string {
  return Date.now().toString(36) + Math.random().toString(36).substring(2);
}

/**
 * 通知数据
 *
 * @since 2022-12-07
 */
export class NotificationEntry extends BaseNotification implements Equality {
  /**
   * 通知对象唯一标识符
   */
  public uid: string = getUid();

  /**
   * 通知删除原因
   */
  public reason?: number;

  /**
   * 当前条目是否展开
   */
  public isItemExpanded: boolean = false;

  /**
   * 标记是否为组通知数据
   */
  public isGroup: boolean = false;

  /**
   * 该通知数据所属分组的组通知数据
   * 非组通知时赋值
   */
  public groupEntry?: NotificationEntry;

  /**
   * 组通知中的子通知集
   * 组通知时赋值
   */
  public childrenEntry?: Array<NotificationEntry>;

  /**
   * 通知内容类型
   */
  public style: string = '';

  /**
   * 通知按钮集
   */
  public actionButtons: Array<NotificationAction> = [];

  /**
   * 是否聚合态
   */
  public isInAggregate = false;

  /**
   * 聚合信息
   */
  public aggregateContent?: AggregateContent;

  public updateUnifiedInfoOnly = false;

  /**
   * 是否横滑展开
   */
  public isItemSwipeExpand: boolean = false;

  /**
   * 构建组件flag，新增时：强制重建，使用通知uid赋值，更新时：不重建，使用上次buildFlag赋值
   */
  public buildFlag: string = this.uid;

  /**
   * 数据变化监听器
   */
  private dataUpdateListeners: Set<NtfDataUpdateListener> = new Set();

  /**
   * 是否被其它通知挤掉退场
   */
  private ntfOutListener: NtfOutListener | undefined = undefined;

  /**
   * 获取数组类型状态值定义
   *   0位其他类型，1未实况，2为置顶，3为社交、通信、客服消息
   */
  private static readonly STATE_VALUE_OTHER: number = 0;
  private static readonly STATE_VALUE_LIVE: number = 1;
  private static readonly STATE_VALUE_STICKY: number = 2;
  private static readonly STATE_VALUE_MESSAGE: number = 3;
  private static readonly STATE_VALUE_EMERGENCY: number = 4;

  /**
   * 包名-索引标签
   * 用来查询创建通知的应用是否处于保护状态
   */
  public bundleIdxTag = '';

  constructor(postData?: BaseNotification) {
    super(postData);
    if (postData) {
      this.remindConfig = new NtfReminderConfig(this.remindConfig.flags);
      this.appName = new ObservedItem(this.appLabel);
      this.setNotificationContent(this.request?.content);
      this.setActionButtons(this.request?.actionButtons);
      this.setUnifiedGroup(this.request);
      this.setImmersiveData();
      this.request = undefined;
      this.slot = undefined;
      this.bundleIdxTag = `${this.creatorBundleName}_${this.appIndex}`;
    }
  }

  private setNotificationContent(oriContent?: notificationManager.NotificationContent): void {
    switch (oriContent?.notificationContentType) {
      // 基础类型
      case notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT:
        this.notificationContent = new NotificationBaseContent(oriContent.normal!);
        this.style = 'basicText';
        break;
      // 长文本类型
      case notificationManager.ContentType.NOTIFICATION_CONTENT_LONG_TEXT:
        this.isExpandable = true;
        this.notificationContent = new NtfLongTextContent(oriContent.longText!);
        this.style = 'longText';
        break;
      // 多行文本类型
      case notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE:
        this.isExpandable = true;
        this.notificationContent = new NtfMultiLineContent(oriContent.multiLine!);
        this.style = 'multiLine';
        break;
      // 大图片类型
      case notificationManager.ContentType.NOTIFICATION_CONTENT_PICTURE:
        this.isExpandable = true;
        this.notificationContent = new NtfPictureContent(oriContent.picture!);
        this.style = 'picture';
        break;
      default:
        this.style = 'other';
        break;
    }
    // PC长时任务实况通知短期适配方案:以普通通知显示。后续通过PC支持实况窗适配。
    if (DeviceHelper.isPC() &&
      oriContent?.notificationContentType === notificationManager.ContentType.NOTIFICATION_CONTENT_SYSTEM_LIVE_VIEW) {
      this.notificationContent = new NotificationBaseContent(oriContent.systemLiveView!);
      this.style = 'basicText';
    }
  }

  private setActionButtons(actions?: notificationManager.NotificationActionButton[]): void {
    this.actionButtons = actions?.map((action) => new NotificationAction(action)) ?? [];

    // 有action按钮，允许展开
    if (!this.isHeadsUp() && this.actionButtons.length) {
      this.isExpandable = true;
    }
  }

  /**
   * 设置聚合组
   */
  private setUnifiedGroup(request?: notificationManager.NotificationRequest): void {
    if (request?.unifiedGroupInfo) {
      log.showInfo(`unifiedGroup need update`);
      let extraInfo: Record<string, Object> | undefined = request.unifiedGroupInfo?.extraInfo;
      let memberList = extraInfo?.summary_member as string[] ?? [];
      let status = extraInfo?.summary_status as number ?? 0;
      this.aggregateContent = {
        key: request.unifiedGroupInfo?.key,
        title: request.unifiedGroupInfo?.title,
        content: request.unifiedGroupInfo?.content,
        memberList: memberList,
        sceneName: request.unifiedGroupInfo?.sceneName,
        status: status
      };
      EvtBus.post(UnifiedGroupUpdateEvent, {
        key: this.aggregateContent.key,
        unified: this.aggregateContent
      });
    }
  }

  /**
   * 沉浸锁屏数据解析
   */
  private setImmersiveData(): void {
    let parser: ParserController<BaseNotification, IImmersiveData> | undefined =
      parserCtrlMgr.getParserController(ImmersiveKgParserCtrlType.TYPE_IMMERSIVE_NTF_DATA);
    this.immersiveNtfData = parser?.parse(this)!;

    let parserCtrl: ParserController<notificationManager.NotificationRequest, IComponentData> | undefined =
      parserCtrlMgr.getParserController(ImmersiveKgParserCtrlType.TYPE_IMMERSIVE_KG);
    this.immersiveKgData = parserCtrl?.parse(this.request);
  }

  private isEditSwitchAllowed(): boolean {
    // SA发送时不允许编辑
    if (this.creatorType === NotificationCreatorType.SA) {
      return false;
    }
    // 应用代理发送时，使用代理者的包名判断权限，否则使用应用自己的包名
    const bundleName = this.agentBundle?.bundle ?? this.creatorBundleName;
    return !notificationCcmConfig.isHiddenSwitch(bundleName);
  }

  private isShowAuthorization(): boolean {
    if (this.slot && !this.isConvertFromNormal && this.liveViewData?.isEditSwitchAllowed) {
      // ANS的SDK还没上库，看不到authorizedStatus字段，因此使用Reflect的方式来获取值
      return Reflect.get(this.slot, 'authorizedStatus') === 1;
    }
    return false;
  }

  /**
   * 注册数据变化监听
   *
   * @param listener 监听器
   * @return 快速注销
   */
  registerDataUpdateListener(listener: NtfDataUpdateListener): () => void {
    this.dataUpdateListeners.add(listener);
    return () => this.unregisterDataUpdateListener(listener);
  }

  /**
   * 注销数据变化监听
   *
   * @param listener 监听器
   */
  unregisterDataUpdateListener(listener: NtfDataUpdateListener): void {
    this.dataUpdateListeners.delete(listener);
  }

  /**
   * 注册通知退场监听
   *
   * @param listener 监听器
   * @return 快速注销
   */
  registerNtfOutListener(listener: NtfOutListener): void {
    this.ntfOutListener = listener;
  }

  /**
   * 注销通知退场监听
   *
   * @param listener 监听器
   */
  unregisterNtfOutListener(listener: NtfOutListener): void {
    this.ntfOutListener = undefined;
  }

  /**
   * 通知数据变化
   */
  notifyDataChanged(): void {
    this.dataUpdateListeners.forEach((listener) => {
      listener.onNtfDataUpdate(this);
    });
  }

  /**
   *退场变化
   */
  notifyOutChanged(): void {
    this.ntfOutListener?.onNtfOutUpdate();
  }

  /**
   * 复制原有通知数据中的监听器
   *
   * @param ntfEntry 原通知数据
   */
  copyDataUpdateListeners(ntfEntry?: NotificationEntry): void {
    this.dataUpdateListeners = ntfEntry?.dataUpdateListeners ?? new Set();
  }

  /**
   * 重置条目展开状态
   */
  resetItemExpandState(): void {
    this.isItemExpanded = false;
    if (this.isGroup) {
      this.childrenEntry?.forEach((entry) => {
        entry.resetItemExpandState();
      });
    }
  }

  /**
   * 设置是否隐藏通知内容
   *
   * @param shouldHideContent true隐藏
   * @param isAppLocked true 应用处于加锁状态
   */
  setShouldHideContent(shouldHideContent: boolean, isAppLocked?: boolean): void {
    log.showInfo(`setShouldHideContent ${shouldHideContent}， isAppLocked ${isAppLocked}`);
    this.isAppLocked = isAppLocked ?? false;
    this.isHideContent = (shouldHideContent && !this.isMediaPlayerCenter()) || this.isAppLocked;
    if (this.isGroup) {
      this.childrenEntry?.forEach((entry) => {
        entry.setShouldHideContent(shouldHideContent, isAppLocked);
      });
    }
  }

  /**
   * 通知是否允许清空按钮清除
   *
   * @return true 允许清除
   */
  canClear(): boolean {
    // 分组通知以子通知为准
    if (this.isGroup) {
      if (ArrayUtils.isEmpty(this.childrenEntry)) {
        return true;
      }
      // 有一个不允许删除，则组通知不允许删除
      let canDelete = true;
      for (let entry of this.childrenEntry ?? []) {
        if (!entry.canClear()) {
          canDelete = false;
          break;
        }
      }
      return canDelete;
    }
    // 系统通知不允许全部清除
    if (!this.isRemoveAllowed) {
      return false;
    }
    // 实况通知不允许全部清除
    if (this.isLiveType()) {
      return false;
    }
    // 普通通知
    return !this.isNoClear;
  }

  /**
   * 通知是否允许删除
   *
   * @return true 允许删除
   */
  canDelete(): boolean {
    // 组通知以子通知为准
    if (this.isGroup) {
      if (ArrayUtils.isEmpty(this.childrenEntry)) {
        return true;
      }
      // 有一个不允许删除，则组通知不允许删除
      let canDelete = true;
      for (let entry of this.childrenEntry ?? []) {
        if (!entry.canDelete()) {
          canDelete = false;
          break;
        }
      }
      return canDelete;
    }
    // 单通知，除不允许删除的系统通知，其他通知均允许删除
    return this.isRemoveAllowed;
  }



  /**
   * 以当前通知为模板创建一个组通知
   *
   * @return 组通知
   */
  createGroup(): NotificationEntry | undefined {
    if (this.isGroup) {
      return undefined;
    }
    let groupEntry = new NotificationEntry();
    groupEntry.isGroup = true;
    groupEntry.isExpandable = true;
    groupEntry.smallIcon = this.smallIcon;
    groupEntry.smallIconOrigin = this.smallIconOrigin;
    groupEntry.creatorBundleName = this.creatorBundleName;
    groupEntry.creatorUserId = this.creatorUserId;
    groupEntry.creatorUid = this.creatorUid;
    groupEntry.groupName = this.groupName;
    groupEntry.agentBundle = this.agentBundle;
    groupEntry.slotLevel = this.slotLevel;
    groupEntry.isConvertFromNormal = this.isConvertFromNormal;
    groupEntry.bundleType = this.bundleType;
    groupEntry.remindConfig = this.remindConfig;
    groupEntry.updateGroup(this);
    groupEntry.addUpdateChildEntry(this);
    groupEntry.isDeliverNotification = this.isDeliverNotification;
    groupEntry.isSettingIgnore = this.isSettingIgnore;
    groupEntry.appName = this.appName;
    groupEntry.appIcon = this.appIcon;
    groupEntry.appIndex = this.appIndex;
    groupEntry.appLabel = this.appLabel;
    groupEntry.useCustomAppname = this.useCustomAppname;
    groupEntry.creatorType = this.creatorType;
    groupEntry.overlayIconStyle = this.overlayIconStyle;
    groupEntry.isCollaNotification = this.isCollaNotification;
    if (this.isDeliverNotification) {
      groupEntry.deliverNotificationKey = this.deliverNotificationKey;
    }

    // 组通知添加字段用于判断元服务通知
    groupEntry.isFromPush = this.isFromPush;
    groupEntry.bundleType = this.bundleType;
    return groupEntry;
  }

  /**
   * 创建聚合组
   *
   * @param unifiedGroup 聚合组信息
   * @returns 聚合组
   */
  createAggregateGroup(unifiedGroup: AggregateContent): NotificationEntry | undefined {
    if (this.isGroup) {
      return undefined;
    }
    let groupEntry = new NotificationEntry();
    groupEntry.isGroup = true;
    groupEntry.isExpandable = true;
    groupEntry.isInAggregate = true;
    groupEntry.aggregateContent = unifiedGroup;
    groupEntry.remindConfig = this.remindConfig;
    groupEntry.addUpdateChildEntry(this);
    return groupEntry;
  }

  updateAggregateContent(unifiedGroup: AggregateContent): void {
    if (!this.isInAggregate) {
      return;
    }
    this.aggregateContent = unifiedGroup;
  }

  updateAggregateGroup(): void {
    if (!this.isInAggregate || !this.getFirstChildEntry()) {
      return;
    }
    this.deliveryTime = this.getLatestChildEntry()?.deliveryTime ?? 0;
    this.slotType = this.getLatestChildEntry()?.slotType ?? notificationManager.SlotType.UNKNOWN_TYPE;
    this.setUnifiedPinTop();
  }

  /**
   * 新来通知，更新分组数据
   *
   * @param ntfEntry 新通知
   */
  updateGroup(ntfEntry: NotificationEntry): void {
    if (!this.isGroup) {
      return;
    }
    if (CommonUtils.isInvalid(ntfEntry)) {
      return;
    }
    this.isOngoing = ntfEntry.isOngoing;
    this.isHiddenInKg = ntfEntry.isHiddenInKg;
    this.isDisplayAtTop = ntfEntry.isDisplayAtTop;
    this.sortWeight = ntfEntry.sortWeight;
    this.deliveryTime = ntfEntry.deliveryTime;
    this.slotType = ntfEntry.slotType;
    this.isFloatingIcon = ntfEntry.isFloatingIcon;
    this.overlayIconStyle = ntfEntry.overlayIconStyle;
  }

  /**
   * 刷新Group的slot level，group的slot level应该是所有子entry中等级最高的那个
   */
  updateGroupSlotLevel(): void {
    let slotLevel = NtfMgr.SlotLevel.LEVEL_NONE;
    this.childrenEntry?.forEach((entry: NotificationEntry) => {
      if (entry.slotLevel > slotLevel) {
        slotLevel = entry.slotLevel;
      }
    });
    this.slotLevel = slotLevel;
  }

  /**
   * 普通通知设置组通知
   *
   * @param groupEntry 组通知
   */
  setGroupEntry(groupEntry?: NotificationEntry): void {
    if (this.isGroup) {
      return;
    }
    this.groupEntry = groupEntry;
  }

  /**
   * 组通知中添加更新child通知
   *
   * @param ntfEntry child通知
   */
  addUpdateChildEntry(ntfEntry: NotificationEntry): void {
    if (!this.isGroup) {
      return;
    }
    if (CommonUtils.isInvalid(this.childrenEntry)) {
      this.childrenEntry = [];
    }
    if (this.isLiveType()) {
      ArrayUtils.clearArr(this.childrenEntry);
    }
    let oldNtfEntry = ArrayUtils.update(this.childrenEntry, ntfEntry);
    ntfEntry?.setGroupEntry(this);

    // 刷新通知组的RemindConfig
    this.remindConfig = ntfEntry.remindConfig;
    // 更新，原图标被释放，重新赋值最新图标
    this.smallIcon = ntfEntry.smallIcon;
    this.smallIconOrigin = ntfEntry.smallIconOrigin;
  }

  /**
   * 组通知中移除child通知
   *
   * @param ntfEntry child通知
   */
  removeChildEntry(ntfEntry: NotificationEntry): boolean {
    if (!this.isGroup) {
      return false;
    }
    let findIndex = this.childrenEntry?.findIndex((child) => child.hashCode === ntfEntry.hashCode);
    if (findIndex === -1) {
      return false;
    }
    let deleteEntry: NotificationEntry | undefined = this.childrenEntry?.splice(findIndex ?? 0, 1)[0];
    if (this.getChildrenSize() > 0) {
      this.deliveryTime = this.childrenEntry?.[0].deliveryTime ?? 0;
    }
    if (!CommonUtils.isInvalid(deleteEntry)) {
      ntfEntry?.setGroupEntry(undefined);
      return true;
    }
    return false;
  }

  /**
   * 分组通知子通知集排序
   */
  sortChildren(): void {
    // 分组不会包含ongoing，以时间顺序排序
    if (!this.isGroup) {
      return;
    }
    if (ArrayUtils.isEmpty(this.childrenEntry)) {
      return;
    }
    this.childrenEntry?.sort((entryA, entryB): number => {
      if (entryA.isDisplayAtTop || entryB.isDisplayAtTop) {
        if (entryA.isDisplayAtTop !== entryB.isDisplayAtTop) {
          return entryA.isDisplayAtTop ? -1 : 1;
        }
      }
      return entryB.deliveryTime - entryA.deliveryTime;
    });
  }

  /**
   * 限制组通知下子通知数量
   */
  limitGroupNtfCount(): void {
    if (!this.isGroup || ArrayUtils.getSize(this.childrenEntry) <= SINGLE_APP_LIMIT) {
      return;
    }
    this.childrenEntry?.splice(SINGLE_APP_LIMIT, this.childrenEntry?.length ?? 0 - SINGLE_APP_LIMIT);
  }

  /**
   * 获取分组通知中子通知个数
   *
   * @return 子通知个数
   */
  getChildrenSize(): number {
    if (!this.isGroup) {
      return 0;
    }
    return ArrayUtils.getSize(this.childrenEntry);
  }

  /**
   * 获取分组通知中第一个子通知
   *
   * @return 第一个子通知
   */
  getFirstChildEntry(): NotificationEntry | undefined {
    if (!this.isGroup) {
      return undefined;
    }
    if (ArrayUtils.isEmpty(this.childrenEntry)) {
      return undefined;
    }
    return this.childrenEntry?.[0];
  }

  /**
   * 获取分组通知中最新子通知
   *
   * @return 最新子通知
   */
  getLatestChildEntry(): NotificationEntry | undefined {
    if (!this.isGroup) {
      return undefined;
    }
    if (ArrayUtils.isEmpty(this.childrenEntry)) {
      return undefined;
    }
    let pinTopList = this.childrenEntry?.filter((entry) => entry.isDisplayAtTop);
    let normalList = this.childrenEntry?.filter((entry) =>!entry.isDisplayAtTop);
    if (ArrayUtils.isEmpty(pinTopList)) {
      return normalList?.[0];
    }
    if (ArrayUtils.isEmpty(normalList)) {
      return pinTopList?.[0];
    }
    return (pinTopList?.[0].deliveryTime ?? 0) > (normalList?.[0].deliveryTime ?? 0) ? pinTopList?.[0] :
      normalList?.[0];
  }

  /**
   * 获取通知分组标识
   *
   * @return 分组标识
   */
  getGroupKey(): string {
    // 包名 + 分组名 + 是否实况 + 是否置顶 + 是否社交消息
    return this.getGroupTypeKey();
  }

  /**
   * 获取通知分组分类标识
   *
   * @return 分组分类标识
   */
  getGroupTypeKey(): string {
    // 聚合组通知已聚合key为准
    if (this.isInAggregate) {
      return this.aggregateContent?.key ?? '';
    }

    // 包名 + 分组名 + 是否实况 + 是否置顶 + 是否社交消息 + 是否分身
    return this.creatorBundleName + this.groupName + this.getGroupType() + '_' + this.appIndex.toString();
  }

  /**
   * 是否为横幅通知
   *
   * @return true横幅
   */
  isHeadsUp(): boolean {
    // 实况由自身控制
    if (this.isLiveType()) {
      return this.isShowHeadsUp;
    }
    return this.remindConfig.isBannerEnable();
  }

  /**
   * 是否在锁屏隐藏通知
   *
   * @return true 隐藏通知
   */
  isHiddenInKeyGuard(): boolean {
    let isFromSysApp = this.isGroup ? this.getFirstChildEntry()?.isFromSystemApp : this.isFromSystemApp;
    if (isFromSysApp && this.isHiddenInKg) {
      log.showWarn('hide on the keyguard');
      return true;
    }
    return false;
  }

  /**
   * 是否为静默通知
   *
   * @return true 静默通知
   */
  isSilence(): boolean {
    return !this.remindConfig.isBannerEnable() && !this.remindConfig.isSoundEnable();
  }

  /**
   * 通知是否允许在锁屏显示
   *
   * @return true 允许显示
   */
  isShowInLockScreen(): boolean {
    return this.isLockScreenEnable;
  }

  /**
   * 是否为锁屏ongoing通知
   *
   * @return true 锁屏ongoing通知
   */
  isOngoingLockScreen(): boolean {
    return this.isOngoing && this.isLockScreenEnable;
  }

  /**
   * 是否在状态栏显示图标
   *
   * @return true 状态栏显示图标
   */
  isShowStatusBarIcon(): boolean {
    // 非静默通知，允许状态栏显示（后续放开）
    return this.remindConfig.isStatusBarIconEnable(); /*&& this.isFloatingIcon*/
  }

  /**
   * 相等
   *
   * @param other 比较对象
   */
  equals(other: object): boolean {
    if (CommonUtils.isInvalid(other)) {
      return false;
    }
    if (other instanceof NotificationEntry) {
      if (other.isGroup !== this.isGroup || other.creatorBundleName !== this.creatorBundleName) {
        return false;
      }
      if (this.getGroupTypeKey() !== other.getGroupTypeKey()) {
        return false;
      }
      // 组通知
      if (this.isGroup) {
        return this.groupName === other.groupName;
      }
      // child通知
      return this.hashCode === other.hashCode;
    }
    return false;
  }

  /**
   * 打印简单属性
   *
   * @return 打印信息
   */
  toSimpleString(): string {
    return ('group: ' + this.groupName + ', ' + this.isGroup + ', bundle: ' +
    this.creatorBundleName + ', hash: ' + this.hashCode + ', appIndex: ' + this.appIndex + ',creatorUid' + this.creatorUid);
  }

  isSocialOrServiceType(): boolean {
    let socialAndServiceType =
      [SLOT_TYPE_SOCIAL_COMMUNICATION, SLOT_TYPE_SERVICE_INFORMATION, SLOT_TYPE_CUSTOMER_INFORMATION];
    return socialAndServiceType.includes(this.slotType);
  }

  isExtraContentType(): boolean {
    if (this.controlConfig) {
      return !this.isSocialOrServiceType() && !this.isLiveType() && !this.isDisplayAtTop && !this.isEmergencyNtf() &&
        !this.controlConfig.isMainTopCampaignNtf();
    }
    return !this.isSocialOrServiceType() && !this.isLiveType() && !this.isDisplayAtTop && !this.isEmergencyNtf();
  }

  /**
   * 通知更新时更新entry中的数据
   *
   * @param ntfEntry 旧通知数据
   */
  updateDataWhenUpdate(ntfEntry: NotificationEntry | undefined): void {
    this.copyDataUpdateListeners(ntfEntry);
    this.updateActionButtonCount(ntfEntry);
    this.buildFlag = ntfEntry?.buildFlag ?? '';
  }

  /**
   * 通知更新时更新actionButton的计数值
   *
   * @param ntfEntry 旧通知数据
   */
  updateActionButtonCount(ntfEntry?: NotificationEntry): void {
    if (ArrayUtils.isEmpty(this.actionButtons) || ArrayUtils.isEmpty(ntfEntry?.actionButtons) || DeviceHelper.isPC()) {
      return;
    }
    this.actionButtons?.forEach((action) => {
      for (const oldAction of ntfEntry?.actionButtons ?? []) {
        if (action?.actionTitle === oldAction?.actionTitle) {
          action?.setUpdateCount((oldAction?.getUpdateCount() ?? -1) + 1);
          break;
        }
      }
    });
  }

  /**
   * 发送通知事件
   *
   * @param eventType 事件类型
   * @param ntfList 通知集
   */
  private postNtfEntryEvent(eventType: number, ntfList: Array<NotificationEntry>): void {
    let event = this.createNtfEntryEvent(eventType, ntfList);
    if (CommonUtils.isInvalid(event)) {
      return;
    }
    EvtBus.post(NotificationEntryEvent, event);
    log.showInfo(`postNtfEntryEvent:  ${eventType}, ${ntfList.length}`);
  }

  /**
   * 创建通知事件
   *
   * @param eventType 事件类型
   * @param ntfList 通知集
   */
  private createNtfEntryEvent(eventType: number,
    ntfList: Array<NotificationEntry>): NotificationEntryEvent | undefined {
    if (ArrayUtils.isEmpty(ntfList)) {
      return undefined;
    }
    let event = new NotificationEntryEvent();
    event.eventType = eventType;
    event.notificationList = ntfList;
    return event;
  }

  private getGroupType(): number {
    // 0位其他类型，1未实况，2为置顶，3为社交、通信、客服消息，4紧急通知
    if (this.isEmergencyNtf()) {
      return NotificationEntry.STATE_VALUE_EMERGENCY;
    }
    if (this.isLiveType()) {
      return NotificationEntry.STATE_VALUE_LIVE;
    }
    if (this.isDisplayAtTop) {
      return NotificationEntry.STATE_VALUE_STICKY;
    }
    if (this.isSocialOrServiceType()) {
      return NotificationEntry.STATE_VALUE_MESSAGE;
    }
    return NotificationEntry.STATE_VALUE_OTHER;
  }

  setUnifiedPinTop(): void {
    if (this.isInAggregate) {
      let isDisplayAtTop = (this.childrenEntry?.findIndex((entry) => entry.isDisplayAtTop) ?? -1) > -1;
      log.showInfo(`setUnifiedPinTop, key: ${this.aggregateContent?.key}, isAtTop: ${isDisplayAtTop}`);
      this.isDisplayAtTop = isDisplayAtTop;
    }
  }

  getAppIcon(isOnlyUseAppIcon: boolean, isProtected: boolean = false): image.PixelMap | string | Resource | undefined {
    // 应用锁保护状态下，固定使用应用图标
    if (isProtected && this.appIcon) {
      log.showInfo('getAppIcon, isProtected == true, return appIcon');
      return this.appIcon;
    }
    // 优先级最高
    const deliverNotificationIcon = this.getDeliverNotificationIcon();
    if (deliverNotificationIcon) {
      return deliverNotificationIcon;
    }
    // 系统应用支持自定义图标，使用小图标代替应用图标
    if (this.isFromSystemApp && !CommonUtils.isInvalid(this.smallIcon)) {
      log.showInfo('getAppIcon, isFromSystemApp == true, return smallIcon');
      return this.smallIcon;
    }
    if (isOnlyUseAppIcon && this.appIcon) {
      log.showInfo('getAppIcon, isOnlyUseAppIcon == true, return appIcon');
      return this.appIcon;
    }
    if (this.smallIcon) {
      log.showInfo('getAppIcon, smallIcon exist, return smallIcon');
      return this.smallIcon;
    }
    const iconCheckResult = this.isAppIconInValid();
    log.showInfo(`getAppIcon, other, return appIcon, appIcon is invalid: ${iconCheckResult}`);
    if (iconCheckResult) {
      log.showError(`AppIcon is invalid, load default icon`);
      return $r('app.media.icon');
    }
    return this.appIcon;
  }

  private getDeliverNotificationIcon(): image.PixelMap | string | undefined {
    if (!this.isDeliverNotification) {
      return undefined;
    }
    if (this.checkIsDeliverSystemNotification() && this.smallIcon) {
      // 系统应用支持自定义图标，使用小图标代替应用图标
      log.showInfo('getAppIcon, isDeliverSystemNotification == true, return smallIcon');
      return this.smallIcon;
    }
    if (this.appIcon) {
      log.showInfo('getAppIcon, isDeliverNotification == true, return appIcon');
      return this.appIcon;
    }
    return undefined;
  }

  private isAppIconInValid(): boolean {
    if (!this.appIcon) {
      return true;
    }
    if (typeof this.appIcon === 'string') {
      return CommonUtils.isEmpty(this.appIcon);
    }
    return false;
  }

  isMediaPlayerCenter(): boolean {
    const entry = this.getFirstChildEntry() ?? this;
    return entry.liveViewData?.sysTypeCode === SysTypeCode.BROADCASTING_CENTER;
  }

  getSysTypeCode(): SysTypeCode | undefined {
    const entry = this.getFirstChildEntry() ?? this;
    return entry.liveViewData?.sysTypeCode;
  }

  /**
   * 获取卡片会拉起的应用名
   * 1. 如果是push的消息，取creatorBundleName
   * 2. 如果want里有数据，取want里的数据
   * 3. 取wantAgent的数据
   * @returns
   */
  getLauncherBundleName(): string | undefined {
    let bundleName: string | undefined;
    if (this.isFromPush && this.creatorBundleName?.length > 0) {
      bundleName = this.creatorBundleName;
      log.showInfo('GetLauncherTargetBundleName for %{public}s is %{public}s by creator', this.hashCode, bundleName);
    } else if (this.wantAgentInfo?.want?.bundleName?.length ?? 0 > 0) {
      bundleName = this.wantAgentInfo?.want?.bundleName ?? '';
      log.showInfo('GetLauncherTargetBundleName for %{public}s is %{public}s by want', this.hashCode, bundleName);
    } else {
      bundleName = this.wantAgentInfo?.bundleName;
      log.showInfo('GetLauncherTargetBundleName for %{public}s is %{public}s by aAgent', this.hashCode, bundleName);
    }
    return bundleName;
  }

  /**
   * 当前通知是否可以显示设置按钮
   * @param notificationType 面板类型
   * @param isInGroup 是否处在组通知当中
   * @param isOuterHome 是否小外屏
   * @returns
   */
  canShowSetting(notificationType: number, isInGroup: boolean, isOuterHome: boolean): boolean {
    const deviceModeState: DeviceModeEnum = AppStorage.get('deviceModeState') ?? DeviceModeEnum.BASE_MODE;
    const isEditSwitchAllowed =
      (!this.isLiveType() && !this.isSettingIgnore && !this.checkIsDeliverSystemNotification()) ||
      Boolean(this.isLiveType() && !this.isConvertFromNormal && this.liveViewData?.isEditSwitchAllowed &&
        !this.liveViewData?.isLiveSystem());
    const isInEmergency = getIsInEmergencyOrThermalSafeMode(deviceModeState);
    const isSaCreator = this.creatorType === NotificationCreatorType.SA;
    const isOuterHomeFold: boolean = isOuterHome ? DeviceHelper.isFoldExpanded() : true;
    const isNeedSetting =
      !NotificationType.isPc(notificationType) && isEditSwitchAllowed && !isInEmergency &&
        !isInGroup &&
        !isSaCreator && isOuterHomeFold;
    return isNeedSetting;
  }

  /**
   * 校验是否为系统通知
   * @returns
   */
  public checkIsDeliverSystemNotification(): boolean {
    if (!this.isDeliverNotification) {
      return false;
    }
    const isSystemApp = notificationCcmConfig.getDeliverSystemBundleList().some(item => item === this.creatorBundleName);
    return isSystemApp && deliverSystemBundleVerity(this.creatorUid);
  }

  /**
   * 是否应该亮屏
   * @param   isNtfAutoScreenOn   通知中心接收到通知是否自动亮屏
   * @param   isContain           原有通知里面是否包含新到通知
   * @return  返回是否应当亮屏
   */
  public shouldScreenOn(isNtfAutoScreenOn: boolean, isContain: boolean = false): boolean {
    const isScreenOn = this.remindConfig?.isOnScreenEnable() as boolean;
    if (!isScreenOn) {
      return false;
    }
    const isExtraScreenOn = this.controlConfig.isExtraScreenOn();
    const isRemindLiveType = (this.isLiveType() && this.liveViewData?.capsule?.isExpandRemind()) as boolean;
    return ((isNtfAutoScreenOn || isExtraScreenOn) && !isContain) || isRemindLiveType;
  }
}

function getAppName(context: Context, res: resourceManager.Resource): string {
  'use concurrent';
  let resManager: resourceManager.ResourceManager;
  // 如果有resource有值且带了moduleName，则使用模块级的resourceManager，在多模块时速度会比createBundleContext快
  if (res?.moduleName) {
    resManager = context.createModuleContext(res.bundleName, res.moduleName).resourceManager;
  } else {
    resManager = context.createBundleContext(res.bundleName).resourceManager;
  }
  const appName = resManager.getStringSync(res.id);
  // MemoryUtils.removeNapiWrap(resManager, false);
  return appName;
}

/**
 * 聚合信息上下文
 */
export class AggregateContent {
  public key?: string;
  public title?: string;
  public content?: string;
  public status?: number;
  public sceneName?: string;
  public memberList: Array<string> = [];
}

/**
 * 聚合组事件实例
 */
export class UnifiedGroupEventEntry {
  public dictMap?: Map<string, NotificationEntry>;
  public ntfAllListMap?: Map<string, NotificationEntry>;
}

export enum UnifiedSceneType {
  PAY = 'pay',
  FLIGHT = 'flight'
}

/**
 * 聚合组状态
 */
export enum UnifiedGroupStatus {
  UNIFIED_DELETE,
  UNIFIED_SYNC,
  UNIFIED_ASYNC
}