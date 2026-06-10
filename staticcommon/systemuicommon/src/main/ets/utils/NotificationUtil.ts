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

import lazy { LiveNotification } from '../live/model/LiveNotification';
import notificationManager from '@ohos.notificationManager';
import type { NotificationBase } from '../model/NotificationBase';
import { NotificationWantAgentInfo } from '../model/NotificationAppInfo';
import { Want } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { notificationSubscribe } from '@kit.NotificationKit';
import { LiveType } from '../live/model/LiveCommonModel';
import { SystemuiConstants } from '../constants/SystemuiConstants';
import { systemParameterEnhance } from '@kit.BasicServicesKit';
import { RdbStoreManager } from '@ohos/launchercommon/src/main/ets/db/RdbStoreManager';
import { SCBConstants } from '@ohos/commonconstants';
import { phoneAppMgr } from '../plugin/PhoneAppManager';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'NotificationUtil');
const KEY_NOT_FOUND_ERROR_CODE = 14700101;

/**
 * 实况数据排序优先级
 */
enum LiveSortPriority {
  /**
   * 录屏类
   */
  SCREEN_RECORDER = 0,
  /**
   * 通话
   */
  PHONE = 1,
  /**
   * 普通进度类
   */
  NORMAL = 2,
}

enum LiveCapsulePriority {
  /**
   * 录屏类
   */
  SCREEN_RECORDER = 0,
  /**
   * 通话
   */
  PHONE = 1,
  /**
   * 普通进度类
   */
  NORMAL = 2,
}

/**
 * 数据数据未更新清理的超时时间
 */
const LIVE_DATA_TIMEOUT = 2 * 60 * 60 * 1000;

/**
 * 数据数据未更新清理的加长超时时间，用于航班/高铁
 */
const LIVE_DATA_TIMEOUT_LONG = 3 * 60 * 60 * 1000;

/**
 * 拉起应用失败，返回push的code
 */
const TRIGGER_WANTAGENT_FAIL = 2003;

type BasePriority = (notification: NotificationBase) => number;
type LivePriority = (live: LiveNotification) => LiveSortPriority;
type CapPriority = (live: LiveNotification) => LiveCapsulePriority;

export class NotificationUtil {
  /**
   * 获取实况通知排序优先级
   *
   * @param live 实况数据
   * @returns 排序优先级
   */
  public static getLivePriority(live: LiveNotification): LiveSortPriority {
    if (live.isPhoneCall()) {
      return LiveSortPriority.PHONE;
    }
    if (live.isScreenRecorder()) {
      return LiveSortPriority.SCREEN_RECORDER;
    }
    return LiveSortPriority.NORMAL;
  }

  public static getCapsuleListPriority(live: LiveNotification): LiveCapsulePriority {
    if (live.isPhoneCall()) {
      return LiveCapsulePriority.PHONE;
    }
    if (live.isScreenRecorder()) {
      return LiveCapsulePriority.SCREEN_RECORDER;
    }
    return LiveCapsulePriority.NORMAL;
  }

  /**
   * 通知排序比较器
   */
  public static sortComparer = (a: NotificationBase, b: NotificationBase,
    getPriority: BasePriority | LivePriority | CapPriority): number => {
      // 分类不同，则分类值小的排前面
      if (a.category !== b.category) {
        return a.category - b.category;
      }
      // 实况通知判断数据优先级
      if (a.isLiveView() && b.isLiveView()) {
        const priorityA = getPriority(a);
        const priorityB = getPriority(b);
        if (priorityA !== priorityB) {
          return priorityA - priorityB;
        }
        // 优先级一致，则比较实况创建时间，时间越晚越靠前
        return (b.createTime ?? 0) - (a.createTime ?? 0);
      }
      // 优先级一致，则比较通知发送时间，时间越晚越靠前
      return (b.deliveryTime ?? 0) - (a.deliveryTime ?? 0);
    };

  /**
   * 排序通知列表
   * @param ntfList 通知列表
   */
  public static sortNtfList(ntfList: NotificationBase[]): void {
    ntfList.sort((a, b) => NotificationUtil.sortComparer(a, b, NotificationUtil.getLivePriority));
  }

  /**
   * 检测通知是否为系统实况
   *
   * @param request 通知请求体
   * @returns true表示系统实况
   */
  public static isSystemLiveView(request: notificationManager.NotificationRequest): boolean {
    let contentType = request?.content?.notificationContentType;
    let systemLiveView = request?.content?.systemLiveView;
    return contentType === notificationManager.ContentType.NOTIFICATION_CONTENT_SYSTEM_LIVE_VIEW &&
      Boolean(systemLiveView);
  }

  /**
   * 检测通知是否为三方实况
   *
   * @param request 通知请求体
   * @returns true表示三方实况
   */
  public static isOtherLiveView(request: notificationManager.NotificationRequest): boolean {
    const contentType = request?.content?.notificationContentType;
    const extraInfo = request?.content?.liveView?.extraInfo;
    return contentType === notificationManager.ContentType.NOTIFICATION_CONTENT_LIVE_VIEW &&
      Boolean(extraInfo);
  }

  /**
   * 检测通知是否为即时类系统实况
   *
   * @param request 通知请求体
   * @returns true表示系统实况
   */
  public static isInstantLiveView(request: notificationManager.NotificationRequest): boolean {
    const liveViewType = request?.content?.systemLiveView?.liveViewType as number;
    return liveViewType === LiveType.INSTANT || liveViewType === LiveType.INSTANT_BANNER;
  }

  /**
   * 获取三方实况超时结束时间
   * @param live 实况数据
   * @returns 超时时间
   */
  public static getOtherLiveTimeout(live: LiveNotification): number {
    if (live.card?.isOtherCard() && (live.card.event === 'FLIGHT' || live.card.event === 'TRAIN')) {
      return LIVE_DATA_TIMEOUT_LONG;
    }
    return LIVE_DATA_TIMEOUT;
  }

  /**
   * 获取通知的Sorting信息
   * @param request
   * @returns
   */
  public static async getSortingMap(request: notificationManager.NotificationRequest):
    Promise<notificationSubscribe.SubscribeCallbackData['sortingMap'] | undefined> {
    try {
      if (!NotificationUtil.isOtherLiveView(request)) {
        return undefined;
      }
      if (!request.creatorBundleName || request.creatorUid === undefined) {
        return undefined;
      }
      const slots = await notificationManager.getSlotsByBundle({
        bundle: request.creatorBundleName,
        uid: request.creatorUid
      });
      const slot = slots.find((slot) => slot.notificationType === request.notificationSlotType);
      if (slot) {
        return {
          sortings: {
            [request.hashCode]: {
              hashCode: request.hashCode,
              slot,
              ranking: 0
            }
          },
          sortedHashCode: []
        };
      }
    } catch (e) {
      log.error(`getSortingMap for ${request.hashCode} error:`, e);
    }
    return undefined;
  }

  /**
   * 获取应用主页信息
   * @param bundleName
   */
  public static async getAbilityName(bundleName: string): Promise<string> {
    try {
      const abilityInfos = await RdbStoreManager.getInstance().queryGridLayoutItemsByBundleName(bundleName);
      return abilityInfos.find(e => e.abilityName).abilityName ?? '';
    } catch (e) {
      log.error('getAbilityName err', e);
      return '';
    }
  }

  public static isTargetAppForeground(callerBundle: string, callerIndex: number, want?: Want): boolean {
    const targetAppBundle = want?.bundleName ?? '';
    const targetAppIndex = want?.parameters?.[SCBConstants.START_APP_CLONE_INDEX];

    let appIndexToCheck = 0;
    if (targetAppIndex !== undefined) {
      // 设置了目标索引, 根据包名+目标索引判断目标应用是否在前台
      log.showWarn('targetAppCloneIndex set as %{public}d', targetAppIndex as number);
      appIndexToCheck = targetAppIndex as number;
    } else if (targetAppBundle === callerBundle) {
      // 没有设置目标索引, 且目标包名与发送方包名一致, 该通知拉起发送方自己, 使用包名+发送方索引判断是否在前台
      log.showWarn('targetAppCloneIndex not set, check caller app is foreground');
      appIndexToCheck = callerIndex;
    } else {
      // 没有设置目标索引, 且目标包名与发送方包名不一致, 该通知为系统应用代理发送, 默认拉起主应用, 使用包名+0判断是否在前台
      log.showWarn('targetAppCloneIndex not set, check target main app is foreground');
      appIndexToCheck = 0;
    }
    const isTargetAppForeground = phoneAppMgr.isExistsForegroundApp(app => app.bundleName === targetAppBundle &&
      app.appCloneIndex === appIndexToCheck);
    log.showWarn('isTargetForegroundApp: %{public}s', isTargetAppForeground);
    return isTargetAppForeground;
  }

  /**
   * 全场景通知点击拉起应用
   * @param hashCode        通知hashcode
   * @param operationType   操作类型
   * @param buttonIndex     点击按钮索引
   * @param actionName      点击按钮名称
   * @param userInput       用户输入内容
   */
  public static async distributeOperation(hashCode: string, operationType: number,
    buttonIndex?: number, actionName?: string, userInput?: string): Promise<void> {
    const operInfo: notificationSubscribe.OperationInfo = {
      actionName: actionName ?? '',
      userInput: userInput ?? '',
      // @ts-ignore
      operationType: operationType,
      // @ts-ignore
      buttonIndex: buttonIndex ?? -1
    };
    // @ts-ignore
    return notificationSubscribe.distributeOperation(hashCode, operInfo);
  }

  public static isMiddleScene(): boolean {
    let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList();
    let curSession = containerSessionList.getTopActiveSession();
    return !!curSession?.isMidScene;
  }
}