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
import bundleManager from '@ohos.bundle.bundleManager';
import { systemSoundManager } from '@kit.AudioKit';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import {
  SystemuiConstants,
  NtfReminderConfig,
  NotificationCreatorType,
  NotificationAction,
  SysTypeCode,
  OverlayIconStyle,
} from '@ohos/systemuicommon';
import { notificationConfigManager } from '../manager/NotificationConfigManager';
import { NtfControlConfig } from '@ohos/systemuicommon/src/main/ets/model/NtfControlFlags';
import { BundleResourceParser, NotificationBase, NotificationUtil } from '@ohos/systemuicommon/newTsIndex';
import { HdsIconTaskUtil } from '@ohos/systemuicommon/src/main/ets/utils/HdsIconTaskUtil';
import { wantAgent } from '@kit.AbilityKit';
import { process } from '@kit.ArkTS';
import { RdbStoreManager } from '@ohos/launchercommon/src/main/ets/db/RdbStoreManager';
import { WantAgentUtil } from '@ohos/systemuicommon/src/main/ets/utils/WantAgentUtil';

const log = LogHelper.getLogHelper(LogDomain.NC, 'NotificationBaseParser');

let wantId = 0;
function getNextId(): number {
  if (wantId >= Number.MAX_SAFE_INTEGER) {
    wantId = 0;
  }
  return wantId++;
}

interface NotificationExtendInfo extends Record<string, ESObject>{
  notification_collaboration_app_uid?: number;
  notification_collaboration_app_name?: string;
  notification_collaboration_app_label?: string;
  notification_collaboration_app_index?: number;
  notification_collaboration_flag?: boolean;
  autoServiceInstallStatus?: number;
  appName?: string;
  notification_publish_by_sa?: string;
}

interface NotificationRequest extends notificationManager.NotificationRequest {
  extendInfo?: NotificationExtendInfo;
}

/**
 * 通知解析基类
 */
export abstract class NotificationBaseParser<T extends NotificationBase = NotificationBase> {
  protected request: NotificationRequest;
  protected slot?: notificationManager.NotificationSlot;
  protected bundleResourceParser: BundleResourceParser;
  protected oldNtf?: NotificationBase;
  protected postData: notificationSubscribe.SubscribeCallbackData;
  protected ntf: T;

  constructor(postData: notificationSubscribe.SubscribeCallbackData, ntf: T) {
    this.postData = postData;
    this.ntf = ntf;
    this.request = postData.request as NotificationRequest;
    if (this.request.hashCode) {
      this.slot = this.postData.sortingMap?.sortings?.[this.request?.hashCode]?.slot;
    }

    this.bundleResourceParser = new BundleResourceParser(this.request.creatorBundleName ?? '',
      GlobalContext.getContext(), postData.request.hashCode ?? '');
  }

  /**
   * 解析通知数据，在主线程运行，不能在其中做耗时操作
   */
  public async parseData(): Promise<void> {
    this.parseBasicInfo();
    this.parseCreatorInfo();
    await Promise.all([
      this.parseAppConfig(this.oldNtf),
      this.parseSmallIcon(),
      this.parseCollaborationData(),
    ]);
    this.parseRemindInfo();
    this.parseControlInfo();
    this.parseCustomAppName();
    this.parseActionButtons();
    this.setHeadsUpStick();
    this.ntf.updateKey(this.oldNtf?.key);
  }

  /**
   * 解析通知资源，在taskpool中运行，避免阻塞主线程。
   * 该函数需要在parseData后调用，因为待解析的资源需要在parseData中设置
   */
  public async parseResource(): Promise<void> {
    await this.bundleResourceParser.parse();
  }

  /**
   * 获取通知解析结果
   * @returns
   */
  public getParseResult(): T | undefined {
    return this.ntf;
  }

  /**
   * 解析基础信息
   */
  private parseBasicInfo(): void {
    this.ntf.id = this.request.id ?? 0;
    this.ntf.hashCode = this.request.hashCode ?? '';
    this.ntf.slotType = this.request.notificationSlotType ?? notificationManager.SlotType.UNKNOWN_TYPE;
    if (this.slot?.level !== undefined) {
      this.ntf.slotLevel = this.slot.level;
    }
    this.ntf.isOngoing = this.request.isOngoing ?? false;
    this.ntf.isAutoDelete = this.request.tapDismissed ?? true;
    this.ntf.isRemoveAllowed = this.request.isRemoveAllowed !== false;
    this.ntf.isClearAllowed = this.ntf.isRemoveAllowed && this.request.isUnremovable !== true;
    this.ntf.isAlertOnce = this.request.isAlertOnce ?? false;
    this.fillExtraInfo();
    this.ntf.largeIcon = this.request.content.picture?.picture ?? this.request.largeIcon;
    this.ntf.smallIcon = this.request.smallIcon;
    this.ntf.overlayIconStyle = this.parseOverlayIconStyle();
    this.ntf.smallIconOrigin = this.request.smallIcon;
    this.ntf.overlayIcon = this.request.overlayIcon;
    this.ntf.wantAgent = this.request.wantAgent!;
    this.ntf.removalWantAgent = this.request.removalWantAgent;
    this.ntf.deliveryTime = this.request.deliveryTime ?? 0;
    this.ntf.groupName = this.request.groupName ?? '';
    this.ntf.contentType = this.request.content?.notificationContentType;
    this.ntf.classification = this.request.classification;
    // 仅用于兼容重构后的子线程通知中心向主线程的横幅和锁屏传递数据场景，需要使用原始的request对象，主线程完全重构为新数据结构后 可删除此字段。
    Reflect.set(this.ntf, 'innerRequest', this.request);
    // 设置wantAgent标志，用于定位want清理异常问题
    this.setWantAgentKey();
  }

  private setHeadsUpStick(): void {
    this.ntf.isHeadsUpStick =
      this.request.extraInfo?.openharmony_keep_headsup_sticky && this.request.extraInfo?.openharmony_keep_headsup_sticky === true &&
      this.ntf.isFromSystemApp;
  }

  /**
   * 设置wantAgent标志
   * @param wantAgent
   */
  private setWantAgentKey(): void {
    if (this.ntf.wantAgent) {
      Reflect.set(this.ntf.wantAgent, 'innerKey', getNextId());
    }
  }

  /**
   * 填充extra信息
   */
  private fillExtraInfo(): void {
    this.ntf.isHiddenInKg = this.request.extraInfo?.openharmony_live_view_hidden_when_keyguard === true;
    this.ntf.isCollaNotification = this.request.extendInfo?.notification_collaboration_flag === true;
    log.showInfo(`_oh_ans_sys_traceid accquired from ANS: ${this.request.extraInfo?._oh_ans_sys_traceid}`);
    this.ntf.traceId = this.request.extraInfo?._oh_ans_sys_traceid;
  }

  /**
   * 解析Overlay图标样式
   * 1、听歌识曲场景需要通知 openharmony_overlay_style 解析
   * 2、其他场景不解析此字段（变向做权限管控）
   *
   * @returns
   */
  private parseOverlayIconStyle(): OverlayIconStyle {
    if (this.request.content.systemLiveView?.typeCode === SysTypeCode.NAME_THAT_TUNE ||
      this.ntf.isCollaNotification) {
      return this.request.extraInfo?.openharmony_overlay_style ?? OverlayIconStyle.CIRCLE;
    }
    return OverlayIconStyle.CIRCLE;
  }

  /**
   * 解析通知创建者信息
   */
  private parseCreatorInfo(): void {
    this.ntf.creatorBundleName = this.request.creatorBundleName ?? '';
    this.ntf.creatorUid = this.request.creatorUid ?? -1;
    this.ntf.creatorUserId = this.request.creatorUserId ?? -1;
    this.ntf.agentBundle = this.request.agentBundle;
    this.ntf.isFromPush = this.request.agentBundle?.bundle === SystemuiConstants.PUSH_BUNDLE_NAME;
    this.ntf.bundleType = this.request.extraInfo?.bundleType === bundleManager.BundleType.ATOMIC_SERVICE ?
      bundleManager.BundleType.ATOMIC_SERVICE : bundleManager.BundleType.APP;
    if (this.ntf.isFromPush) {
      this.ntf.pushData = this.request.unifiedGroupInfo?.extraInfo?.pushData;
    }
  }

  /**
   * 解析应用的通知配置信息
   */
  private async parseAppConfig(oldNtf?: NotificationBase): Promise<void> {
    const uid = this.request.creatorUid as number;
    const agentUid = this.request.agentBundle?.uid;

    if (this.canUseOldAppConfig(this.request, oldNtf)) {
      log.showInfo(`get app config by old ntf uid ${uid}`);
      this.ntf.isDisplayAtTop = oldNtf?.isDisplayAtTop as boolean;
      this.ntf.appLabel = oldNtf?.appLabel as string;
      this.ntf.appVersionName = oldNtf?.appVersionName as string;
      this.ntf.appIcon = oldNtf?.appIcon;
      this.ntf.isSettingIgnore = oldNtf?.isSettingIgnore as boolean;
      this.ntf.appIndex = oldNtf?.appIndex as number;
      this.ntf.isFromSystemApp = oldNtf?.isFromSystemApp;
      this.ntf.creatorType = oldNtf?.creatorType as NotificationCreatorType;
      return;
    }

    log.showInfo(`start get app config for uid ${uid}, isSA: ${this.request.extendInfo?.notification_publish_by_sa}`);
    const config =
      await notificationConfigManager.getConfig(uid, this.request.creatorBundleName);
    const isSa = this.request.extendInfo?.notification_publish_by_sa === '1';
    log.showInfo(`get app config finish, config ${config}, bundle ${config?.bundle} agentUid ${agentUid}, uid ${uid}`);

    if (config) {
      this.ntf.isDisplayAtTop = config.pinTop;
      this.ntf.appLabel = config.label;
      this.ntf.appVersionName = config.versionName;
      this.ntf.appIcon = config.icon;
      this.ntf.isSettingIgnore = config.settingIgnore;
      this.ntf.appIndex = config.appIndex;
      // 收通知时将通知配置标记为显示状态
      await notificationConfigManager.showConfig(config);
      this.ntf.isSettingIgnore = config.settingIgnore;
    }

    // 判断通知来源是否为系统APP，代理发送场景使用代理者的uid判断，非代理发送使用创建者的uid判断
    if (agentUid !== undefined) {
      this.ntf.isFromSystemApp = true;
      this.ntf.creatorType = isSa ? NotificationCreatorType.SA : NotificationCreatorType.PROXY_APP;
    } else if (config) {
      this.ntf.isFromSystemApp = config.systemApp;
    } else if (isSa) {
      this.ntf.isFromSystemApp = true;
      this.ntf.creatorType = NotificationCreatorType.SA;
    }

    // 全场景协同的通知都是SA消息, 应用名称由ANS传递
    if (this.ntf.isCollaNotification) {
      return;
    }

    // 来源SA没有包名，赋值默认包名
    if (this.ntf.creatorType === NotificationCreatorType.SA && !config) {
      this.ntf.appLabel = notificationConfigManager.getSADefaultName();
    }
  }

  /**
   * 获取应用主页信息
   * @param bundleName
   */
  private async getAbilityName(bundleName: string): Promise<string> {
    try {
      const abilityInfos = await RdbStoreManager.getInstance().queryGridLayoutItemsByBundleName(bundleName);
      return abilityInfos.find(e => !CommonUtils.isInvalid(e.abilityName))?.abilityName ?? '';
    } catch (e) {
      log.showError('getAbilityName err, code:%{public}d, msg:%{public}s', e?.code, e?.message);
      return '';
    }
  }

  /**
   * 处理通知smallIcon
   * @returns
   */
  private async parseSmallIcon(): Promise<void> {
    if (this.ntf.smallIconOrigin) {
      if (this.request.content.systemLiveView?.typeCode === SysTypeCode.WALLET) {
        this.ntf.smallIconOrigin = undefined;
        this.ntf.smallIcon = this.request.smallIcon;
        return;
      }
      this.ntf.smallIcon =this.ntf.smallIconOrigin
    }
  }

  /**
   * 处理协同通知数据
   * @returns
   */
  private async parseCollaborationData(): Promise<void> {
    if (!this.ntf.isCollaNotification) {
      return;
    }

    // 解析协同通知的额外信息
    const appName: string = this.request.extendInfo?.notification_collaboration_app_name ?? '';
    this.ntf.appLabel = this.request.extendInfo?.notification_collaboration_app_label ?? '';
    this.ntf.appIndex = this.request.extendInfo?.notification_collaboration_app_index ?? 0;
    // 全场景协同通知应用图标放置在smallIcon中
    this.ntf.collaAppIconOrigin = this.request.smallIcon;
    this.ntf.appIcon = this.ntf.collaAppIconOrigin ? await HdsIconTaskUtil.getHdsIcon(GlobalContext.getContext(),
      this.ntf.hashCode, this.ntf.collaAppIconOrigin, process.tid) : undefined;
    // 全场景协同通知creatorUid需要取extendInfo中的值, request中的creatorUid为ANS的uid
    this.ntf.creatorUid = this.request.extendInfo?.notification_collaboration_app_uid ?? -1;
    log.showInfo(`ntf collaboration info:${appName},${this.ntf.appLabel},${this.ntf.appIndex},${this.ntf.creatorUid}`);
  }

  /**
   * 解析通知提醒信息
   */
  private parseRemindInfo(): void {
    log.showInfo(`reminderFlags: ${this.request.notificationFlags?.reminderFlags}`);

    this.ntf.systemToneType = typeof this.request.extraInfo?.SystemToneType === 'number' ?
      this.request.extraInfo?.SystemToneType : systemSoundManager?.SystemToneType?.SYSTEM_TONE_TYPE_NOTIFICATION;
    this.ntf.sound = this.postData.sound ?? this.slot?.sound;
    this.ntf.remindConfig = new NtfReminderConfig(this.request.notificationFlags?.reminderFlags ?? 0);
    this.ntf.isSoundEnable = this.ntf.remindConfig.isSoundEnable();
    this.ntf.vibration = this.postData.vibrationValues ?? this.slot?.vibrationValues;
    this.ntf.isVibrationEnable = this.ntf.remindConfig.isVibrationEnable();
    this.ntf.isLockScreenEnable = this.ntf.remindConfig.isLockScreenEnable();
    this.ntf.isHeadsUp = this.isHeadsUp();
    this.ntf.isShowStatusBarIcon = this.ntf.remindConfig.isStatusBarIconEnable();
    if (this.request.sound) {
      this.bundleResourceParser.addRawfileFd([this.request.sound], (result) => {
        this.ntf.customSound = result[0];
      });
    }
    this.ntf.soundDuration = typeof this.request.extraInfo?.soundDuration === 'number' ?
      this.request.extraInfo?.soundDuration : undefined;
  }

  private parseControlInfo(): void {
    this.ntf.controlConfig = new NtfControlConfig(this.request.notificationControlFlags ?? 0);
  }

  /**
   * 检查通知是否显示横幅
   * @returns 如果显示则返回true
   */
  protected abstract isHeadsUp(): boolean;

  /**
   * 解析自定义应用名称
   */
  private parseCustomAppName(): void {
    const hwCustomAppname: string = this.request?.extraInfo?.openharmony_custom_appname;
    if (hwCustomAppname && this.ntf?.isFromSystemApp) {
      log.showInfo(`parseCustomAppName: ${hwCustomAppname}`);
      this.ntf.appLabel = hwCustomAppname;
      this.ntf.groupName = this.ntf.groupName + '_' + hwCustomAppname;
      this.ntf.useCustomAppname = true;
    }
  }

  /**
   * 解析通知下方的按钮
   */
  private parseActionButtons(): void {
    this.ntf.actionButtons = this.request.actionButtons?.map((action) => new NotificationAction(action)) ?? [];
  }

  private canUseOldAppConfig(request: notificationManager.NotificationRequest, oldNtf?: NotificationBase): boolean {
    if (oldNtf && request.creatorUid === oldNtf.creatorUid &&
      request.agentBundle?.uid === oldNtf.agentBundle?.uid) {
      return true;
    }
    return false;
  }
}