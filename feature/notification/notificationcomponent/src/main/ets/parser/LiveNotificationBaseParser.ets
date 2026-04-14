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

import { notificationSubscribe } from '@kit.NotificationKit';
import { bundleManager } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  notificationCcmConfig,
  NotificationCreatorType,
  SystemuiConstants,
} from '@ohos/systemuicommon';
import { NotificationBaseParser } from './NotificationBaseParser';
import { LiveCapsuleModel, LiveCardModel, LiveNotification,
  LiveType,
  NotificationBase } from '@ohos/systemuicommon/newTsIndex';

const log = LogHelper.getLogHelper(LogDomain.NC, 'LiveNotificationBaseParser');
/**
 * 实况数据解析基类
 */
export abstract class LiveNotificationBaseParser extends NotificationBaseParser<LiveNotification> {
  /**
   * 即时类/强提醒实况最大持续时间
   */
  protected static readonly MAX_DURATION = 10000;
  /**
   * 即时类/强提醒实况默认持续时间
   */
  protected static readonly DEFAULT_DURATION = 3500;

  protected oldNtf?: LiveNotification;

  constructor(postData: notificationSubscribe.SubscribeCallbackData, oldNtf?: NotificationBase) {
    super(postData, new LiveNotification());
    if (oldNtf?.isLiveView()) {
      this.oldNtf = oldNtf;
    }
  }

  /**
   * 解析三方卡片数据
   * @returns 卡片数据，如果数据不合法则返回空
   */
  public async parseData(): Promise<void> {
    await super.parseData();

    this.parseLiveViewCommonData();
    this.ntf.card = this.parseCardData()!;
    this.ntf.capsule = this.parseCapsuleData();
    this.parseLiveViewExpandedData?.();
    if (this.oldNtf) {
      this.ntf.updateToDeleteCount = !this.oldNtf.isShowCapsule() && this.ntf.isShowCapsule() ?
        this.oldNtf.updateToDeleteCount + 1 : this.oldNtf.updateToDeleteCount;
      log.showInfo(`live key: ${this.oldNtf.key}, updateToDeleteCount: ${this.ntf.updateToDeleteCount}`);
    }
  }

  /**
   * 解析实况公共数据，如提醒方式、特权字段等
   */
  protected parseLiveViewCommonData(): void {
    this.ntf.isOngoing = true;
    this.ntf.isAutoDelete = false;
    this.ntf.isClearAllowed = false;
    this.ntf.isSettingIgnore = this.isSettingIgnore();
    this.ntf.isAtomicServiceFromPush = this.ntf.bundleType === bundleManager.BundleType.ATOMIC_SERVICE &&
      this.ntf.agentBundle?.bundle === SystemuiConstants.PUSH_BUNDLE_NAME;
    // 如果已有老通知则使用其创建时间，避免更新实况时排序错乱
    this.ntf.createTime = this.oldNtf?.createTime ?? this.ntf.deliveryTime;
    this.ntf.type = this.request.content.systemLiveView?.liveViewType as number as LiveType;
    this.ntf.duration = this.getDuration();
    this.parseRemindFlag();
    // 实况横幅标记需重新设置一下
    this.ntf.isHeadsUp = this.isHeadsUp();
  }

  /**
   * 解析实况拓展数据，如实况数据是否已结束等
   */
  protected parseLiveViewExpandedData?(): void;

  /**
   * 解析实况卡片数据
   * @returns 卡片数据
   */
  protected abstract parseCardData(): LiveCardModel;

  /**
   * 解析实况胶囊数据
   * @returns 胶囊数据
   */
  protected abstract parseCapsuleData(): LiveCapsuleModel | undefined;

  /**
   * 获取实况持续时间
   * @returns
   */
  protected abstract getDuration(): number | undefined;

  /**
   * 解析设置RemindFlag
   */
  protected abstract parseRemindFlag(): void;

  private isSettingIgnore(): boolean {
    // SA发送时需要忽略设置
    if (this.ntf.creatorType === NotificationCreatorType.SA) {
      return true;
    }
    // 应用代理发送时，使用代理者的包名判断权限，否则使用应用自己的包名
    const bundleName = this.ntf.agentBundle?.bundle ?? this.ntf.creatorBundleName;
    return notificationCcmConfig.isHiddenSwitch(bundleName);
  }
}