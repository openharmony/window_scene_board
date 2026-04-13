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
import { LogDomain, LogHelper, CommonUtils } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import notificationManager from '@ohos.notificationManager';
import bundleManager from '@ohos.bundle.bundleManager';
import {
  BaseNotification,
  SystemuiConstants,
  NtfReminderConfig,
  phoneAppMgr,
  NotificationCreatorType,
  ObservedItem,
  OverlayIconStyle,
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import taskpool from '@ohos.taskpool';
import { Context, wantAgent } from '@kit.AbilityKit';
import {
  NotificationAppInfo,
  NotificationAppInfoParseParam,
} from '@ohos/systemuicommon/src/main/ets/model/NotificationAppInfo';
import transResToPicHelper from '@ohos/systemuicommon/src/main/ets/liveview/parse/utils/TransResToPicHelper';
import type ResourceManager from '@ohos.resourceManager';
import { notificationConfigManager } from '../../manager/NotificationConfigManager';
import { BaseIconResource, IconResource } from '@ohos/systemuicommon/src/main/ets/liveview/data/IconResource';
import application from '@ohos.app.ability.application';
import { NtfControlConfig } from '@ohos/systemuicommon/src/main/ets/model/NtfControlFlags';
import { HdsIconTaskUtil } from '@ohos/systemuicommon/src/main/ets/utils/HdsIconTaskUtil';
import { image } from '@kit.ImageKit';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { NotificationExceptionCode } from '../../maintenance/NotificationExceptionCode';
import { RdbStoreManager } from '@ohos/launchercommon/src/main/ets/db/RdbStoreManager';
import { NotificationCategory } from '@ohos/systemuicommon/src/main/ets/model/NotificationContent';
import { WantAgentUtil } from '@ohos/systemuicommon/newTsIndex';

const log = LogHelper.getLogHelper(LogDomain.NC, 'BaseNotificationParser');
/**
 * 自动分组组名
 */
const AUTO_GROUP_KEY = 'rank_group';

const LIVE_IMAGE_KEYS = [
  'ScoreLayout.hostIcon.res',
  'ScoreLayout.guestIcon.res',
  'FlightLayout.spaceIcon.res',
  'NavigationLayout.currentNavigationIcon.res',
  'NavigationLayout.navigationIcons.res',
  'PickupLayout.descPic.res',
  'ProgressLayout.indicatorIcon.res',
  'ProgressLayout.nodeIcons.res',
  'ExtendData.pic.res',
  'CapsuleData.icon.res',
];

const appIndexResourceMap: Map<number, ResourceManager.Resource> = new Map([
  [1, $r('app.media.ic_clone_label_1')],
  [2, $r('app.media.ic_clone_label_2')],
  [3, $r('app.media.ic_clone_label_3')],
  [4, $r('app.media.ic_clone_label_4')],
  [5, $r('app.media.ic_clone_label_5')],
]);

const CALL_BUNDLE_NAME: string = 'com.ohos.callui';
const TASK_TIMEOUT_DURATION = 60000;

interface NotificationExtendInfo extends Record<string, ESObject>{
  notification_collaboration_app_name?: string;
  notification_collaboration_app_label?: string;
  notification_collaboration_app_index?: number;
  notification_collaboration_flag?: boolean;
  autoServiceIntallStatus?: number;
}

interface NotificationRequest extends notificationManager.NotificationRequest {
  extendInfo?: NotificationExtendInfo;
}

/**
 * 用增上半区置顶 通知1.0流程中的值
 */
const CAMPAIGN_MAIN_TOP_NTF_OLD = 4;

export class BaseNotificationParser<T extends BaseNotification> {
  protected entry: T;
  private getAppInfoTimerId: number | undefined = undefined;

  constructor(entry: T = new BaseNotification() as T) {
    this.entry = entry;
  }

  public async parse(postData: notificationSubscribe.SubscribeCallbackData, needUpdate?: boolean): Promise<T> {
    const request = postData.request as NotificationRequest;
    this.entry.request = request;
    this.entry.slot = postData?.sortingMap?.sortings?.[request?.hashCode ?? 0]?.slot;

    this.setBasicInfo(request);
    this.setCreatorInfo(request);
    await Promise.all([
      this.setAppInfo(request, needUpdate),
      this.setAppConfig(request, needUpdate),
      this.setWantAgentInfo(request),
      this.parseCollaborationData(request)
    ]);
    const liveImages = request.content.liveView?.extraInfo?.liveImages as Record<string, Object>;
    // 解析出的胶囊图标无效时使用应用图标
    if (liveImages) {
      liveImages['Capsule.iconFallback'] = [this.entry.appIcon];
    }
    this.setRemindInfo(postData);
    this.setCustomAppname(request);
    this.setControlInfo(postData);

    return this.entry;
  }

  private setCustomAppname(request: notificationManager.NotificationRequest): void {
    const hwCustomAppname: string = request?.extraInfo?.openharmony_custom_appname;
    if (hwCustomAppname && this.entry?.isFromSystemApp) {
      log.showInfo(`setCustomAppname hwCustomAppname: ${hwCustomAppname}`);
      this.entry.appLabel = hwCustomAppname;
      this.entry.appName = new ObservedItem(hwCustomAppname);
      this.entry.groupName = this.entry.groupName + '_' + hwCustomAppname;
      this.entry.useCustomAppname = true;
    }
  }

  private setBasicInfo(request: NotificationRequest): void {
    this.entry.id = request.id ?? 0;
    this.entry.hashCode = request.hashCode ?? '';
    this.entry.slotType = request.notificationSlotType ?? notificationManager.SlotType.UNKNOWN_TYPE;
    this.entry.isOngoing = request.isOngoing ?? false;
    this.entry.isAutoDelete = request.tapDismissed ?? true;
    this.entry.isHiddenInKg = request.extraInfo?.openharmony_live_view_hidden_when_keyguard === true;
    this.entry.isNoClear = request.isUnremovable ?? false;
    this.entry.isRemoveAllowed = request.isRemoveAllowed ?? true;
    this.entry.isAlertOnce = request.isAlertOnce ?? false;
    this.entry.isFloatingIcon = request.isFloatingIcon ?? true;
    this.fillExtraInfo(request);
    this.entry.largeIcon = request.content.picture?.picture ?? request.largeIcon;
    this.entry.smallIconOrigin = request.smallIcon;
    this.entry.overlayIcon = request.overlayIcon;
    this.entry.overlayIconStyle = request.extraInfo?.openharmony_overlay_style ?? OverlayIconStyle.CIRCLE;
    this.entry.wantAgent = request.wantAgent!;
    this.entry.removalWantAgent = request.removalWantAgent;
    this.entry.contentType = request.content.notificationContentType;
    this.entry.deliveryTime = request.deliveryTime ?? 0;
    this.entry.autoDeletedTime = request.autoDeletedTime;
  }

  /**
   * 填充extra信息
   */
  private fillExtraInfo(request: NotificationRequest): void {
    log.showInfo(`_oh_ans_sys_traceid accquired from ANS: ${request.extraInfo?._oh_ans_sys_traceid}`);
    this.entry.traceId = request.extraInfo?._oh_ans_sys_traceid;
    this.entry.isCollaNotification = request.extendInfo?.notification_collaboration_flag === true;
  }

  private setCreatorInfo(request: notificationManager.NotificationRequest): void {
    this.entry.creatorBundleName = request.creatorBundleName ?? '';
    this.entry.creatorUid = request.creatorUid ?? 0;
    this.entry.creatorUserId = request.creatorUserId;
    this.entry.agentBundle = request.agentBundle;
    this.entry.isFromPush = request.agentBundle?.bundle === SystemuiConstants.PUSH_BUNDLE_NAME;
    this.entry.bundleType = request.extraInfo?.bundleType === bundleManager.BundleType.ATOMIC_SERVICE ?
      bundleManager.BundleType.ATOMIC_SERVICE : bundleManager.BundleType.APP;
    this.entry.groupName = this.getGroupName(request.groupName);
  }

  private async setAppInfo(request: notificationManager.NotificationRequest, needUpdate?: boolean): Promise<void> {
    if (!needUpdate) {
      await this.setSmallIcon();
      log.showInfo('No need to update app info.');
      return;
    }

    // allui代理场景(如钉钉),接听挂断等按钮资源存放在callui内,无法从被代理应用Context中获取资源
    let bundle = request.creatorBundleName;
    if (request.agentBundle?.bundle === CALL_BUNDLE_NAME) {
      bundle = CALL_BUNDLE_NAME;
    }

    const appInfoParam: NotificationAppInfoParseParam = {
      bundleName: bundle ?? '',
      liveImagesRes: this.getLiveImagesRes(request.content.liveView?.extraInfo),
      sound: request?.sound
    };
    let iconRes: IconResource[] = this.getIconResCache(request);
    const parseParam: AppInfoParseParam = {
      appInfoParam: appInfoParam,
      iconResParam: this.getNeedParseIconRes(iconRes),
      smallIcon: this.entry.smallIconOrigin,
    };
    if (!Object.keys(appInfoParam.liveImagesRes ?? {}).length && !iconRes.length && !appInfoParam.sound) {
      await this.setSmallIcon();
      log.showInfo('No need to parse app info.');
      return;
    }

    const appInfoParseResult = await this.getAppInfoParseResult(parseParam);
    if (appInfoParseResult?.appInfo) {
      this.entry.soundDescriptor = appInfoParseResult.appInfo.soundDescriptor;
      this.entry.smallIcon = appInfoParseResult.smallIcon;
      if (!CommonUtils.isInvalid(this.entry.request?.content.liveView?.extraInfo) &&
        request?.content.liveView?.extraInfo) {
        request.content.liveView.extraInfo.liveImages = appInfoParseResult.appInfo.liveImages;
      }
      if (iconRes.length > 0) {
        log.showInfo(`set icons from button.iconResource`);
        if (this.getNeedParseIconRes(iconRes).length > 0) {
          IconResource.handleResult(appInfoParseResult?.iconRes);
        }
        let icons: image.PixelMap[] = [];
        iconRes.forEach(res => {
          if (res.icon) {
            icons.push(res.icon);
          }
        })
        if (request.content.systemLiveView?.button) {
          request.content.systemLiveView.button.icons = icons;
        }
      }
    }
  }

  private async setSmallIcon(): Promise<void> {
    if (this.entry.smallIconOrigin) {
      this.entry.smallIcon =
        await HdsIconTaskUtil.getHdsIcon(GlobalContext.getContext(), 'custom', this.entry.smallIconOrigin);
    }
  }

  /**
   * 获取图标资源缓存实例
   * @param request 请求
   * @returns 资源实例数据
   */
  private getIconResCache(request: notificationManager.NotificationRequest): IconResource[] {
    let iconRes: IconResource[] = [];
    if (!request.content.systemLiveView?.button) {
      log.showInfo(`getIconResCache button is Invalid`);
      return iconRes;
    }
    let iconResource: Resource[] = Reflect.get(request.content.systemLiveView?.button, 'iconsResource') ?? [];
    if (iconResource?.length) {
      iconResource.forEach(res => {
        iconRes.push(IconResource.get(res, request.hashCode));
      });
    }
    return iconRes;
  }

  private async getAppInfoParseResult(parseParam: AppInfoParseParam): Promise<AppInfoParseResult> {
    this.getAppInfoTimerId = setTimeout(() => {
      // 如果taskpool超时，则上报异常打点
      LogWithHa.warn(log, `Get app info task timeout`, NotificationExceptionCode.GET_APP_INFO_TASK_TIMEOUT, undefined,
        parseParam?.appInfoParam?.bundleName);
      this.getAppInfoTimerId = undefined;
    }, TASK_TIMEOUT_DURATION);
    // 获取应用信息
    const context = GlobalContext.getContext();
    const appInfoParseResult = await taskpool.execute(getAppInfo, context, parseParam) as AppInfoParseResult;
    // 取消定时任务
    if (this.getAppInfoTimerId) {
      clearTimeout(this.getAppInfoTimerId);
      this.getAppInfoTimerId = undefined;
    }
    return appInfoParseResult;
  }

  /**
   * 获取需要解析的图标资源
   *
   * @param iconRes 图标资源
   * @returns 需要解析的图标资源
   */
  private getNeedParseIconRes(iconRes: IconResource[]): BaseIconResource[] {
    let needParse: BaseIconResource[] = [];
    for (let iconResOne of iconRes) {
      if (!iconResOne.icon) {
        needParse.push(new BaseIconResource(iconResOne.iconResource));
      }
    }
    return needParse;
  }

  private async setAppConfig(request: notificationManager.NotificationRequest, needUpdate?: boolean): Promise<void> {
    if (!needUpdate) {
      return;
    }

    const uid = request.creatorUid;
    const agentUid = request.agentBundle?.uid;

    let config =
      await notificationConfigManager.getConfig(uid ?? 0, request?.creatorBundleName);
    if (!config) {
      log.showInfo(`Add notification config for ${request?.creatorBundleName}`);
      config = await notificationConfigManager.addConfig(request.creatorBundleName ?? '', uid ?? 0);
    }
    if (config) {
      this.entry.isDisplayAtTop = config.pinTop;
      this.entry.bannerHideContentMode = config.hideBannerContent;
      this.entry.appLabel = config.label;
      this.entry.appIcon = config.icon;
      this.entry.appIndex = config.appIndex;
      if (this.entry.appIndex > 0) {
        this.entry.cloneLabelRes = appIndexResourceMap.get(this.entry.appIndex);
      }

      // 收通知时将通知配置标记为显示状态
      await notificationConfigManager.showConfig(config);
      this.entry.isSettingIgnore = config.settingIgnore;
    }

    // 判断通知来源是否为系统APP，代理发送场景使用代理者的uid判断，非代理发送使用创建者的uid判断
    if (agentUid !== undefined) {
      const agentConfig = await notificationConfigManager.getConfig(agentUid);
      if (agentConfig) {
        this.entry.isFromSystemApp = agentConfig.systemApp;
        this.entry.creatorType = NotificationCreatorType.PROXY_APP;
      } else if (await this.isSa(agentUid)) {
        this.entry.isFromSystemApp = true;
        this.entry.creatorType = NotificationCreatorType.SA;
      }
    } else if (config) {
      this.entry.isFromSystemApp = config.systemApp;
    } else if (await this.isSa(uid ?? 0)) {
      this.entry.isFromSystemApp = true;
      this.entry.creatorType = NotificationCreatorType.SA;
    }

    // 全场景协同的通知都是SA消息, 应用名称由ANS传递
    if (this.entry.isCollaNotification) {
      return;
    }

    // 来源SA没有包名，赋值默认包名
    if (this.entry.creatorType === NotificationCreatorType.SA && !config) {
      this.entry.appLabel = notificationConfigManager.getSADefaultName();
    }
  }

  private async setWantAgentInfo(request: notificationManager.NotificationRequest): Promise<void> {
    const wantAgentInfo = await WantAgentUtil.parseWantAgentInfo(request.wantAgent);
    if (!wantAgentInfo) {
      return;
    }
  }

  /**
   * 处理协同通知数据
   * @returns
   */
  private async parseCollaborationData(request: NotificationRequest): Promise<void> {
    if (!this.entry.isCollaNotification) {
      return;
    }

    // 解析协同通知的额外信息
    const appName = request.extendInfo?.notification_collaboration_app_name ?? '';
    this.entry.appLabel = request.extendInfo?.notification_collaboration_app_label ?? '';
    this.entry.appIndex = request.extendInfo?.notification_collaboration_app_index ?? 0;
    // 全场景协同通知应用图标放置在smallIcon中
    this.entry.collaAppIconOrigin = request.smallIcon;
    this.entry.appIcon = this.entry.collaAppIconOrigin ? await HdsIconTaskUtil.getHdsIcon(GlobalContext.getContext(),
      this.entry.hashCode, this.entry.collaAppIconOrigin) : undefined;
    log.showInfo(`entry collaboration info: appName ${appName} appLabel: ${this.entry.appLabel},
      appIndex: ${this.entry.appIndex}`);
  }

  private setRemindInfo(postData: notificationSubscribe.SubscribeCallbackData): void {
    const request = postData.request;
    const slot = this.entry.slot;

    this.entry.slotLevel = slot?.level ?? notificationManager.SlotLevel.LEVEL_MIN;
    this.entry.remindConfig = this.getRemindConfig(postData);
    this.entry.systemToneType = typeof request.extraInfo?.SystemToneType === 'number' ?
      request.extraInfo?.SystemToneType : this.entry.systemToneType;
    this.entry.sound = postData.sound ?? slot?.sound;
    this.entry.isSoundEnable = this.entry.remindConfig.isSoundEnable();
    this.entry.vibration = postData.vibrationValues ?? slot?.vibrationValues;
    this.entry.isVibrationEnable = this.entry.remindConfig.isVibrationEnable();
    this.entry.isLockScreenEnable = this.entry.remindConfig.isLockScreenEnable();
    this.entry.isBypassDnd = slot?.bypassDnd ?? false;
    this.entry.soundDuration = typeof request.extraInfo?.soundDuration === 'number' ?
      request.extraInfo?.soundDuration : undefined;
    this.entry.isShowHeadsUp = this.isShowHeadsUp(request);
    this.entry.classification = request?.classification;
  }

  private setControlInfo(postData: notificationSubscribe.SubscribeCallbackData): void {
    this.entry.controlConfig = new NtfControlConfig(postData.request.notificationControlFlags ?? 0);
    if (this.entry.isFromPush) {
      this.entry.pushData = postData.request.unifiedGroupInfo?.extraInfo?.pushData;
    }
    if (this.entry.controlConfig.isMainTopCampaignNtf()) {
      this.entry.sortWeight = CAMPAIGN_MAIN_TOP_NTF_OLD;
    }
    if (this.entry.controlConfig.isMoreTopCampaignNtf()) {
      this.entry.sortWeight = NotificationCategory.CAMPAIGN_MORE_TOP;
    }
  }

  private isShowHeadsUp(request: notificationManager.NotificationRequest): boolean {
    if (request.extraInfo?.openharmony_heads_up_enable === true) {
      return true;
    }

    // Push云端推送的实况允许单独配置是否显示横幅
    if (request.agentBundle?.bundle === SystemuiConstants.PUSH_BUNDLE_NAME &&
      request.content.liveView?.extraInfo?.['CapsuleData.remind'] === 'EXPAND' &&
      !phoneAppMgr.isForegroundApp(request.creatorUid)) {
      return true;
    }
    return false;
  }

  /**
   * 设置通知分组组名
   *
   * @param groupName 原组名
   */
  private getGroupName(groupName?: string): string {
    // 实况通知数据，紧急通知数据独立分组
    if (this.entry.isLiveType() || this.entry.isEmergencyNtf()) {
      return AUTO_GROUP_KEY + this.entry.hashCode;
    }
    // 有设置group，直接使用
    if (groupName) {
      return groupName;
    }
    // 其他通知，统一自动普通group
    return AUTO_GROUP_KEY;
  }

  private getRemindConfig(postData: notificationSubscribe.SubscribeCallbackData): NtfReminderConfig {
    return new NtfReminderConfig(postData.request.notificationFlags?.reminderFlags ?? 0);
  }

  private getLiveImagesRes(extraInfo?: Record<string, Object>): Record<string, string[]> {
    if (!extraInfo) {
      return {};
    }
    const iconUpdateKey = extraInfo.ExtraInfoUpdateKey as Array<string>;
    const liveImagesRes: Record<string, string[]> = {};
    for (const imageKey of LIVE_IMAGE_KEYS) {
      if (CommonUtils.isInvalid(extraInfo[imageKey]) || !transResToPicHelper.needParsePic(iconUpdateKey, imageKey)) {
        continue;
      }
      if (extraInfo[imageKey] instanceof Array) {
        liveImagesRes[imageKey] = extraInfo[imageKey] as string[];
      } else if (extraInfo[imageKey]) { // 空串不做解析
        liveImagesRes[imageKey] = [extraInfo[imageKey] as string];
      }
    }
    log.info('need parse live images:', liveImagesRes);
    return liveImagesRes;
  }

  /**
   * 是否为SA
   * @param uid
   * @returns
   */
  private async isSa(uid: number): Promise<boolean> {
    try {
      await bundleManager.getBundleNameByUid(uid);
      return false;
    } catch (e) {
      // 抛出找不到包名异常(17700001、17700021)时为SA
      // 17700001 - bundleManager.getBundleInfo error code
      // 17700021 - bundleManager.getAppCloneIdentity error code
      if (e.code === 17700001 || e.code === 17700021) {
        return true;
      }
      log.error(`Check is sa for ${uid} error:`, e);
      return false;
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
}

interface AppInfoParseParam {
  appInfoParam: NotificationAppInfoParseParam;
  iconResParam: BaseIconResource[];
  smallIcon?: image.PixelMap;
}

interface AppInfoParseResult {
  /**
   * 待解析的app信息
   */
  appInfo: NotificationAppInfo;

  /**
   * 待解析的图标资源
   */
  iconRes?: BaseIconResource[];

  /**
   * hds处理过的smallIcon
   */
  smallIcon?: image.PixelMap
}

export async function getAppInfo(context: Context, param: AppInfoParseParam):
  Promise<AppInfoParseResult | undefined> {
  'use concurrent';
  const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'getAppInfo');

  try {
    // 分别解析appInfo和图标资源信息
    let bundleContext: Context = await application.createBundleContext(context, param.appInfoParam.bundleName);
    let resManager = bundleContext?.resourceManager;
    let appInfo = await NotificationAppInfo.parse(resManager, param.appInfoParam);
    let iconRes = await IconResource.parse(resManager, param.iconResParam);
    let smallIcon = param.smallIcon ? await HdsIconTaskUtil.getHdsIcon(context, 'custom', param.smallIcon) : undefined;
    // MemoryUtils.removeNapiWrap(resManager, false);
    return {
      appInfo: appInfo,
      iconRes: iconRes,
      smallIcon: smallIcon,
    };
  } catch (err) {
    const bundleName = param?.appInfoParam?.bundleName;
    LogWithHa.error(log, `GetAppInfo failed for ${bundleName}, message is : ${err?.message}`,
      NotificationExceptionCode.NOTIFICATION_ICON_ERROR, err, bundleName);
  }
  return undefined;
}