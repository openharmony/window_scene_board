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
import type image from '@ohos.multimedia.image';
import { CommonUtils } from '@ohos/basicutils';
import { LiveExtendType, LiveType,
  LiveViewCommonConstants,
  PhoneSimStatus,
  LivePositionName
} from '../../common/LiveConstants';
import { LiveBaseTemplate } from './LiveBaseTemplate';
import type { DrawableDescriptor } from '@ohos.arkui.drawableDescriptor';
import { OverlayIconStyle } from '../../../model/NotificationContent';

/**
 * 实况卡片模板，系统模板
 */
@Observed
export class LiveSystemTemplate extends LiveBaseTemplate {
  /**
   * 头像图标，系统应用允许头像+应用图标叠加
   */
  overlayIcon?: image.PixelMap;

  /**
   * 来电卡片SIM卡图标，默认不显示图标
   */
  simIconStatus: PhoneSimStatus = PhoneSimStatus.STATUS_NONE;

  /**
   * 扩展数据类型集，默认无扩展数据
   * 内部参数，系统模板计时器、按钮、进度扩展可以同时存在
   */
  extendType: LiveExtendType = 0;

  constructor() {
    super();
    this.extendPosition.set(LiveExtendType.TYPE_COMMON_BUTTON, LivePositionName.EXTEND_BUTTON);
    this.extendPosition.set(LiveExtendType.TYPE_COMMON_TIMER, LivePositionName.EXTEND_TIMER);
    this.extendPosition.set(LiveExtendType.TYPE_COMMON_PROGRESS, LivePositionName.EXTEND_PROGRESS);
  }

  /**
   * 复写接口ILiveTemplateData
   *
   * @returns 实况类型
   */
  getLiveType(): LiveType {
    return LiveType.TYPE_SYSTEM;
  }

  /**
   * 复写接口ILiveUpdatable
   *
   * @param other 更新源数据
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    super.update(other, forceRefresh);
    if (!(other instanceof LiveSystemTemplate)) {
      return;
    }
    let otherTemplate = other as LiveSystemTemplate;
    this.setOverlayIcon(otherTemplate.overlayIcon);
    this.setSimIconStatus(otherTemplate.simIconStatus, forceRefresh);
  }

  /**
   * 设置左侧大图（头像）
   *
   * @param overlayIcon 左侧大图
   * @param forceRefresh 是否强制刷新
   */
  setOverlayIcon(overlayIcon?: image.PixelMap): void {
      this.overlayIcon = overlayIcon;
  }

  /**
   * 设置来电SIM卡图标状态
   *
   * @param simStatus SIM卡状态
   * @param forceRefresh 是否强制刷新
   */
  setSimIconStatus(simStatus?: PhoneSimStatus, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(simStatus)) {
      this.simIconStatus = simStatus;
    }
  }

  /**
   * 是否存在SIM卡图标
   *
   * @returns true存在SIM卡图标
   */
  hasSimIcon(): boolean {
    return this.simIconStatus !== PhoneSimStatus.STATUS_NONE;
  }

  /**
   * 获取SIM卡图标
   *
   * @returns SIM卡图标
   */
  getSimIcon(): ResourceStr {
    let sim1 = LiveViewCommonConstants.sim1Icon;
    let sim2 = LiveViewCommonConstants.sim2Icon;
    if (CommonUtils.isInvalid(sim1) || CommonUtils.isInvalid(sim2)) {
      return '';
    }
    switch (this.simIconStatus) {
      case PhoneSimStatus.STATUS_SIM_1:
        return sim1 as Resource;
      case PhoneSimStatus.STATUS_SIM_2:
        return sim2 as Resource;
      default:
        return '';
    }
  }


  /**
   * 是否存在头像叠加场景
   *
   * @returns true叠加场景
   */
  hasOverlayIcon(): boolean {
    return !CommonUtils.isInvalid(this.overlayIcon);
  }

  /**
   * 获取左侧大图
   *
   * @returns 左侧大图
   */
  getLeftLargeIcon(): image.PixelMap | string | DrawableDescriptor {
    // 存在头像优先使用头像
    if (this.hasOverlayIcon()) {
      return this.overlayIcon;
    }

    // 不存在头像，使用应用图标
    return this.getSmallIcon() ?? this.getAppIcon();
  }

  /**
   * 获取左侧小图
   *
   * @returns 左侧小图
   */
  getLeftSmallIcon(): image.PixelMap | string | undefined | DrawableDescriptor {
    if (this.getOverlayIconStyle() === OverlayIconStyle.REVERSE) {
      return this.overlayIcon;
    }
    // 存在头像叠加时，小图标取应用图标
    if (this.hasOverlayIcon()) {
      return this.getSmallIcon() ?? this.getAppIcon();
    }
    return undefined;
  }
}