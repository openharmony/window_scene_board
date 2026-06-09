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

import { NotificationBase } from '../../model/NotificationBase';
import { NotificationRole } from '../../model/NotificationContent';
import { SysTypeCode } from '../../liveview/common/LiveConstants';
import { LiveCapsuleModel } from './LiveCapsuleModel';
import { LiveCardModel } from './LiveCardModel';
import { LiveType } from './LiveCommonModel';
import { resourceManager } from '@kit.LocalizationKit';
import { LiveCardSystemModel } from './LiveCardSystemModel';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';

/**
 * 实况通知
 */
export class LiveNotification extends NotificationBase {
  readonly role: NotificationRole = NotificationRole.LIVE_VIEW;
  /**
   * 实况类型(0-进度类，1-即时，2-长时（已废弃），3-即时横幅)
   */
  type?: LiveType;
  /**
   * 系统实况业务类型
   */
  typeCode: SysTypeCode;
  /**
   * 卡片数据
   */
  card: LiveCardModel;
  /**
   * 胶囊数据
   */
  capsule?: LiveCapsuleModel;
  /**
   * 实况数据是否已结束，结束后不在胶囊和锁屏上显示
   */
  isEnd: boolean = false;
  /**
   * 是否是普通通知转成的实况通知
   */
  isConvertFromNormal: boolean = false;
  /**
   * 是否来自Push推送的元服务实况，服务动态实况
   */
  isAtomicServiceFromPush: boolean = false;
  /**
   * 实况通知创建时间，实况更新时不改变该值，用于排序
   */
  createTime: number;
  /**
   * 是否显示授权提示框
   */
  authorization: boolean = false;
  /**
   * 分身图标资源
   */
  cloneLabelRes?: resourceManager.Resource;
  /**
   * 应用名称，应用自定义无障碍朗读文本
   */
  customerAccessibilityText?: string;
  /**
   * 实况持续时间
   */
  duration?: number;

  stage?: number;

  /**
   * 更新删除次数
   */
  updateToDeleteCount: number = 0;

  /**
   * 是否为安装元服务
   */
  isInstallMetaSer: boolean = true;

  /**
   * 未安装元服务应用名
   */
  unstallMetaSerBoundName: string = '';

  /**
   * VOIP通话状态
   */
  public sysVOIPStatus?: number;

  /**
   * 是否为即时类
   */
  public isInstant(): boolean {
    return this.type === LiveType.INSTANT;
  }

  /**
   * 是否为即时类实况横幅
   */
  public isInstantBanner(): boolean {
    return this.type === LiveType.INSTANT_BANNER;
  }

  /**
   * 是否胶囊FLIP更新
   */
  public isFlip(): boolean {
    return this.remindConfig.isCapsuleFlip();
  }

  /**
   * 是否胶囊EXPAND更新
   */
  public isExpand(): boolean {
    return this.remindConfig.isBannerEnable();
  }

  /**
   * 是否为播控通知
   * @returns 播控通知返回true
   */
  public isMediaPlayer(): boolean {
    return this.typeCode === SysTypeCode.BROADCASTING_CENTER;
  }

  /**
   * 是否为手电筒
   * @returns 手电筒返回true
   */
  public isFlashLight(): boolean {
    return this.typeCode === SysTypeCode.FLASH_LIGHT;
  }

  /**
   * 是否为录屏
   * @returns
   */
  public isScreenRecorder(): boolean {
    return this.typeCode === SysTypeCode.SCREEN_RECORDING;
  }

  /**
   * 是否为通话实况
   * @returns
   */
  public isPhoneCall(): boolean {
    return this.typeCode === SysTypeCode.PHONE;
  }

  /**
   * 是否为钱包实况
   * @returns
   */
  public isWallet(): boolean {
    return this.typeCode === SysTypeCode.WALLET;
  }

  /**
   * 是否为人脸解锁
   * @returns
   */
  public isFaceLock(): boolean {
    return this.typeCode === SysTypeCode.FACE_LOCK;
  }

  /**
   * 是否为充电实况
   * @returns
   */
  public isCharge(): boolean {
    return this.typeCode === SysTypeCode.CHARGE;
  }

  /**
   * 是否为耳机实况
   * @returns
   */
  public isEarphone(): boolean {
    return this.typeCode === SysTypeCode.EARPHONE;
  }

  public isScenario(): boolean {
    return this.typeCode === SysTypeCode.SCENARIO_MODE;
  }

  /**
   * 是否支持沉浸式
   * @returns
   */
  public isSupportImmersive(): boolean {
    if (this.isMediaPlayer()) {
      return true;
    }
    if (Boolean(this.card?.immersivePic || this.card?.immersiveWant) &&
      (this.card?.immersiveCardAuthLevel === 1 || this.card?.immersiveCardAuthLevel === 3)) {
      return true;
    }
    return false;
  }

  /**
   * 获取无障碍应用名称
   * @returns
   */
  public getAccessibilityAppName(): string {
    return this.customerAccessibilityText || this.appLabel;
  }

  /**
   * 克隆一个实况对象
   * @returns 新的实况对象
   */
  public clone(): LiveNotification {
    const live = super.clone() as LiveNotification;
    if (this.capsule?.button) {
      live.capsule = SystemUICommonUtil.shadowCopy(this.capsule);
      live.capsule.button = SystemUICommonUtil.shadowCopy(this.capsule.button);
    }
    if (this.card.isSystemCard() && this.card.buttons) {
      live.card = SystemUICommonUtil.shadowCopy(this.card);
      (live.card as LiveCardSystemModel).buttons = this.card.buttons.map(
        (button) => SystemUICommonUtil.shadowCopy(button));
    } else if (this.card.isOtherCard()) {
      live.card = SystemUICommonUtil.shadowCopy(this.card);
    }
    return live;
  }

  public releaseImages(newNtf?: LiveNotification): void {
    super.releaseImages(newNtf);
    this.releaseCapsuleImages(newNtf?.capsule);

    if (this.card.cardType === newNtf?.card?.cardType) {
      this.card.releaseImages(newNtf.card);
    } else {
      this.card.releaseImages();
    }
  }

  private releaseCapsuleImages(ntfCapsule?: LiveCapsuleModel): void {
    if (this.capsule) {
      SystemUICommonUtil.releaseImage(this.capsule.icon, ntfCapsule?.icon);
      SystemUICommonUtil.releaseImage(this.capsule.button?.lightIcon, ntfCapsule?.button?.lightIcon);
      SystemUICommonUtil.releaseImage(this.capsule.button?.darkIcon, ntfCapsule?.button?.darkIcon);
    }
  }

  public isShowCapsule(): boolean {
    // 无胶囊
    if (!this.capsule) {
      return false;
    }
    // 实况生命周期结束
    if (this.isEnd) {
      return false;
    }
    return true;
  }
}