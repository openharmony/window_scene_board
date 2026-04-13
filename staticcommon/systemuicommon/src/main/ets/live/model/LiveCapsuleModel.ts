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

import {
  LiveButtonModel, LiveCapsuleIconAnimationType,
  LiveCapsuleRemindType, LiveCapsuleStatus, LiveCapsuleType } from './LiveCommonModel';
import type { image } from '@kit.ImageKit';
import type { LiveCapsuleTextModel } from './LiveCapsuleTextModel';
import type { LiveCapsuleTimerModel } from './LiveCapsuleTimerModel';
import type { LiveCapsuleProgressModel } from './LiveCapsuleProgressModel';

/**
 * 实况胶囊数据
 */
export abstract class LiveCapsuleModel {
  abstract readonly capsuleType: LiveCapsuleType;

  /**
   * 胶囊的标题
   */
  title: string;
  /*
   * 胶囊图标
   */
  icon?: image.PixelMap;
  /**
   * 胶囊显示状态
   */
  status: LiveCapsuleStatus = LiveCapsuleStatus.SHOW;
  /**
   * 胶囊背景色
   */
  backgroundColor?: string;
  /**
   * 胶囊内容是否显示
   */
  isContentDisplayed: boolean = true;
  /**
   * 是否常驻显示不消失
   */
  sticky: boolean = false;
  /**
   * 当Ability销毁时是否隐藏胶囊
   */
  hideWhenRemoveSession = false;

  /**
   * 胶囊按钮
   */
  button?: LiveButtonModel;
  /*
   * 胶囊前台展示时长
   */
  time?: number;
  /**
   * 播控图标切换动效，默认无动效
   */
  iconAnimationType?: LiveCapsuleIconAnimationType = LiveCapsuleIconAnimationType.Default;
  /**
   * 副文本图标
   */
  tailIcon?: image.PixelMap;
  /**
   * 是否显示副文本图标
   */
  isTailIconDisplayed: boolean = false;

  isText(): this is LiveCapsuleTextModel {
    return this.capsuleType === LiveCapsuleType.TEXT;
  }

  isTimer(): this is LiveCapsuleTimerModel {
    return this.capsuleType === LiveCapsuleType.TIMER;
  }

  isProgress(): this is LiveCapsuleProgressModel {
    return this.capsuleType === LiveCapsuleType.PROGRESS;
  }

  getCapsuleType(): LiveCapsuleType {
    return this.capsuleType;
  }

  getExtendTextContent(): string {
    if (this.isContentDisplayed === false) {
      return '';
    }
    if (this.isText()) {
      return this.content ?? '';
    }
    if (this.isTimer()) {
      return this.content ?? '';
    }
    if (this.isProgress()) {
      return this.content ?? '';
    }
    return '';
  }
}