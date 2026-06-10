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

import { image } from '@kit.ImageKit';
import { Want } from '@kit.AbilityKit';
import type { LiveCardFlightModel } from './LiveCardFlightModel';
import type { LiveCardNavigationModel } from './LiveCardNavigationModel';
import type { LiveCardOtherModel } from './LiveCardOtherModel';
import type { LiveCardPickupModel } from './LiveCardPickupModel';
import type { LiveCardProgressModel } from './LiveCardProgressModel';
import type { LiveCardScoreModel } from './LiveCardScoreModel';
import type { LiveCardSystemModel } from './LiveCardSystemModel';
import { LiveCardType } from './LiveCommonModel';

/**
 * 系统实况卡片数据
 */
export abstract class LiveCardModel {
  /**
   * 实况类型
   */
  abstract readonly cardType: LiveCardType;

  /**
   * 锁屏沉浸大图
   * 系统实况/三方实况均涉及
   */
  immersivePic?: image.PixelMap;

  /**
   * 沉浸大图场景UIExtension的want
   * 系统实况/三方实况均涉及
   */
  immersiveWant?: Want;

  /**
   * 沉浸大图UIExtension是否允许交互
   * 系统实况/三方实况均涉及
   */
  isImmersiveInteraction?: boolean;

  /**
   * 沉浸态常亮开关，默认关闭
   * 系统实况/三方实况均涉及
   */
  isKeepScreenOnEnable?: boolean;

  /**
   * 沉浸态权益值
   * 系统实况/三方实况均涉及
   */
  immersiveCardAuthLevel?: number;

  abstract releaseImages(newCard?: LiveCardModel): void;

  public isSystemCard(): this is LiveCardSystemModel {
    return this.cardType === LiveCardType.TYPE_SYSTEM;
  }

  public isOtherCard(): this is LiveCardOtherModel {
    return this.cardType !== LiveCardType.TYPE_SYSTEM;
  }

  public isNoLayoutCard(): this is LiveCardOtherModel {
    return this.cardType === LiveCardType.NO_LAYOUT;
  }

  public isFlightCard(): this is LiveCardFlightModel {
    return this.cardType === LiveCardType.FLIGHT;
  }

  public isNavigationCard(): this is LiveCardNavigationModel {
    return this.cardType === LiveCardType.NAVIGATION;
  }

  public isPickupCard(): this is LiveCardPickupModel {
    return this.cardType === LiveCardType.PICK_UP;
  }

  public isProgressCard(): this is LiveCardProgressModel {
    return this.cardType === LiveCardType.PROGRESS;
  }

  public isScoreCard(): this is LiveCardScoreModel {
    return this.cardType === LiveCardType.SCORE;
  }

  public isSmallCard(): boolean {
    // 1x4卡片：系统实况，无扩展区，导航无方向图标
    if (this.isSystemCard() || this.isNoLayoutCard() || (this.isNavigationCard() &&
      (this.layoutNavigationIcons?.length === 0 || this.layoutNavigationIcons?.length === undefined))) {
      return true;
    }
    return false;
  }
}