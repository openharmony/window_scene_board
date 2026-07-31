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

import { AnimationItem } from '@ohos/lottie';
import { SwiperItem } from '../settings/model/SwiperItem';
import { UIExtensionContentSession } from '@kit.AbilityKit';
import { ThreeButtonUpgradeConstants, ThreeButtonUpgradeParam } from '../ThreeButtonUpgradeConstants';

/**
 * 三键导航升级向导参数
 */
export class ThreeButtonUpgradeData {
  public session?: UIExtensionContentSession;
  public renderingSettings: RenderingContextSettings = new RenderingContextSettings(true);
  public swiperController: SwiperController = new SwiperController();
  public upgradeParam: ThreeButtonUpgradeParam = ThreeButtonUpgradeConstants.THREE_BUTTON_UPGRADE_PHONE_PARAM;
  public screenWidth: number = 0;
  public screenHeight: number = 0;
}

/**
 * 三键导航升级向导刷新页面的参数
 */
@Observed
export class ThreeButtonUpgradeViewData {
  public renderingContexts: CanvasRenderingContext2D[] = [];
  public buttonOpacity: number = 0;
  public canvasSize: number = 0;
  public lottieMoveUpDistance: number = 0;
  public swiperWidth: number = 0;
  public swiperHeight: number = 0;
  public buttonWidth: number = 0;
  public horizontal: number = 0;
  public lottieItems: AnimationItem[] = [];
  public swiperItems: Array<SwiperItem> =
    ThreeButtonUpgradeConstants.THREE_BUTTON_UPGRADE_SWIPER_ITEM;
  public animationData: object | null = null;
}