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
import { CommonUtils } from '@ohos/basicutils';
import { WantAgent } from '@kit.AbilityKit';
import { LiveExtendType, LiveType, LivePositionName, LiveIconName, LayoutStyle } from '../../common/LiveConstants';
import { LiveTimerData } from '../extend/LiveTimerData';
import { LiveBaseTemplate } from './LiveBaseTemplate';
import { LiveOtherExtendData } from '../extend/LiveOtherExtendData';
import { NotificationAction } from '../../../model/NotificationContent';

export interface HandleServiceButtonClickAction {
  id: number;
  packageName: string;
  templateType: number;
  handleServiceButtonClick: (data?: OtherBaseTemplate, buttonWantAgent?: WantAgent,
    clickCount?: number, notificationType?: number, uid?: number) => void;
}

/**
 * 三方应用模板基类
 */
@Observed
export class OtherBaseTemplate extends LiveBaseTemplate {
  /**
   * 模板类型
   */
  layoutType: LiveType = LiveType.NO_LAYOUT;

  /**
   * 模板子类型
   */
  style?: LayoutStyle;

  /**
   * 实况场景
   */
  event: string;

  /**
   * 关联服务按钮数组
   */
  serviceButtons: Array<NotificationAction> = [];

  /**
   * 关联服务按钮点击事件回调
   */
  clickAction?: HandleServiceButtonClickAction;

  /**
   * 更新时是否清空图片（图片资源路径错误的场景）
   */
  clearImgForUpdate: Record<LiveIconName, boolean> = {
    [LiveIconName.PIC_NAME]: false,
    [LiveIconName.DESC_PIC_NAME]: false,
    [LiveIconName.SPACE_ICON_NAME]: false,
    [LiveIconName.HOST_ICON_NAME]: false,
    [LiveIconName.GUEST_ICON_NAME]: false,
    [LiveIconName.CURRNAVDIRECTION_ICON_NAME]: false,
    [LiveIconName.INDICATOR_ICON_NAME]: false
  };

  constructor() {
    super();
    this.extendPosition.set(LiveExtendType.TYPE_OTHER_EXTEND, LivePositionName.OTHER_EXTEND);
  }

  /**
   * 复写接口ILiveUpdatable
   *
   * @param other 更新源数据
   * @param forceRefresh 是否强制刷新
   */
  update(other: object, forceRefresh?: boolean): void {
    super.update(other, forceRefresh);
    if (!(other instanceof OtherBaseTemplate)) {
      return;
    }
    let otherTemplate = other as OtherBaseTemplate;
    this.setLayoutType(otherTemplate.layoutType, forceRefresh);
    this.setStyle(otherTemplate.style, forceRefresh);
    this.setServiceButtons(otherTemplate.serviceButtons, forceRefresh);
    this.setClickAction(otherTemplate.clickAction, forceRefresh);
  }

  /**
   * 设置LiveType
   *
   * @param type LiveType
   * @param forceRefresh 是否强制刷新
   */
  setLayoutType(type: LiveType, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(type)) {
      this.layoutType = type;
    }
  }

  /**
   * 设置模板子类型
   */
  setStyle(style?: LayoutStyle, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(style)) {
      this.style = style;
    }
  }

  setServiceButtons(serviceButtons?: Array<NotificationAction>, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(serviceButtons)) {
      this.serviceButtons = serviceButtons;
    }
  }

  setClickAction(clickAction: HandleServiceButtonClickAction, forceRefresh?: boolean): void {
    if (forceRefresh || !CommonUtils.isInvalid(clickAction)) {
      this.clickAction = clickAction;
    }
  }

  isShowServiceButton(): boolean {
    return this.serviceButtons.length !== 0;
  }

  /**
   * 设置实况场景
   */
  setLiveEvent(event: string): void {
    this.event = event;
  }

  /**
   * 设置是否为时间模板
   */
  setIsTimeTemplate(isTimeTemplate: boolean): void {
    this.isTimeTemplate = isTimeTemplate;
  }

  /**
   * 设置实况倒计时
   */
  setLiveTimer(timer: LiveTimerData): void {
    this.timer = timer;
  }

  /**
   * 更新实况倒计时
   */
  updateLiveTimer(timer: LiveTimerData): void {
    if (!this.timer) {
      this.timer = timer;
      return;
    }
    this.timer.setIsUpdateTimer(timer.isUpdateTimer);
    if (!CommonUtils.isInvalid(timer.initialTime)) {
      this.timer.setInitialTime(timer.initialTime);
    }
    if (!CommonUtils.isInvalid(timer.isCountDown)) {
      this.timer.setCountDown(timer.isCountDown);
    }
    if (!CommonUtils.isInvalid(timer.isPause)) {
      this.timer.setPause(timer.isPause);
    }
  }

  /**
   * 释放PixelMap对象
   */
  releaseImages(): void {
    // 只有三方实况辅助区才有图片资源要释放
    const extendData = this.getExtendData(LiveExtendType.TYPE_OTHER_EXTEND) as LiveOtherExtendData;
    extendData?.releaseImages();
  }
}