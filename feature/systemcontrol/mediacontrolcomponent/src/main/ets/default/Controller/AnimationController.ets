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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { AnimationState, MediaAnimeScene } from '../viewmodel/AnimationState';
import { curves } from '@kit.ArkUI';
import { default as NotificationStateManager } from '@ohos/screenlockcommon/src/main/ets/notification/NotificationStateManager';
import { WidgetAnimState } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/base/bean/WidgetAnimState';

const TAG = 'AnimationController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);
const isAnimEnable: boolean = true;

/**
 * 播控动效控制器，控制动效状态变更
 */
export class AnimationController {
  private static state: AnimationState = new AnimationState();

  // 沉浸大卡中实况卡片动效管理器
  private static immLiveCardAnim?: WidgetAnimState;

  /**
   * 赋值实况卡片动效管理器
   *
   * @param animSt 动效管理器
   */
  public static setImmLiveCardAnim(animSt: WidgetAnimState): void {
    AnimationController.immLiveCardAnim = animSt;
  }

  /**
   * 取值实况卡片动效管理器
   *
   * @returns 动效管理器
   */
  public static getImmLiveCardAnim(): WidgetAnimState | undefined {
    return AnimationController.immLiveCardAnim;
  }

  /**
   * 获取动效状态
   *
   * @returns 动效状态
   */
  public static getAnimationState(): AnimationState {
    return AnimationController.state;
  }

  private static prepareAnimation(scene: MediaAnimeScene) {
    log.showInfo(`prepareAnimation ${scene}`);
    if (scene === MediaAnimeScene.CAPSULE_TO_CARD) {
      AnimationController.state.isCardGeo = true;
      AnimationController.state.isCapsuleGeo = true;
      AnimationController.state.isCardShow = false;
    }
    if (scene === MediaAnimeScene.CARD_TO_CAPSULE) {
      AnimationController.state.isCardGeo = true;
      AnimationController.state.isCapsuleGeo = true;
      AnimationController.state.isCapsuleShow = false;
    }
    if (scene === MediaAnimeScene.LIST_TO_CARD) {
      AnimationController.state.isCardGeo = true;
      AnimationController.state.isListGeo = true;
      AnimationController.state.isCardShow = false;
    }
    if (scene === MediaAnimeScene.CARD_TO_LIST) {
      AnimationController.state.isCardGeo = true;
      AnimationController.state.isListGeo = true;
      AnimationController.state.isListShow = false;
    }
  }

  private static doAnimation(scene: MediaAnimeScene) {
    log.showInfo(`doAnimation ${scene}`);
    if (scene === MediaAnimeScene.CARD_TO_CAPSULE) {
      AnimationController.state.isCardShow = false;
      AnimationController.state.isCapsuleShow = true;
    }
    if (scene === MediaAnimeScene.CAPSULE_TO_CARD) {
      AnimationController.state.isCapsuleShow = false;
      AnimationController.state.isCardShow = true;
    }
    if (scene === MediaAnimeScene.LIST_TO_CARD) {
      AnimationController.state.isListShow = false;
      AnimationController.state.isCardShow = true;
    }
    if (scene === MediaAnimeScene.CARD_TO_LIST) {
      AnimationController.state.isCardShow = false;
      AnimationController.state.isListShow = true;
    }
  }

  private static reset() {
    log.showInfo(`reset`);
    AnimationController.state.reset();
  }

  /**
   * 开启胶囊到大卡动效, 需要在起始卡片和终点卡片同时在树上时调用, 且各只能有一张卡片
   */
  public static startCapsuleToCardAnim() {
    log.showInfo('startCapsuleToCardAnim');
    if (!isAnimEnable) {
      return;
    }
    AnimationController.reset();
    AnimationController.prepareAnimation(MediaAnimeScene.CAPSULE_TO_CARD);
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 228, 24.5),
      onFinish: () => {
        AnimationController.reset();
      }
    }, () => {
      AnimationController.doAnimation(MediaAnimeScene.CAPSULE_TO_CARD);
    });
  }

  /**
   * 开启大卡到胶囊动效, 需要在起始卡片和终点卡片同时在树上时调用, 且各只能有一张卡片
   */
  public static startCardToCapsuleAnim() {
    log.showInfo('startCardToCapsuleAnim');
    if (!isAnimEnable) {
      return;
    }
    AnimationController.reset();
    AnimationController.prepareAnimation(MediaAnimeScene.CARD_TO_CAPSULE);
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 228, 24.5),
      onFinish: () => {
        AnimationController.reset();
      }
    }, () => {
      AnimationController.doAnimation(MediaAnimeScene.CARD_TO_CAPSULE);
    });
  }

  /**
   * 开启列表到大卡动效, 需要在起始卡片和终点卡片同时在树上时调用, 且各只能有一张卡片
   */
  public static startListToCardAnim() {
    log.showInfo('startListToCardAnim');
    if (!isAnimEnable) {
      return;
    }
    AnimationController.reset();
    AnimationController.prepareAnimation(MediaAnimeScene.LIST_TO_CARD);
    let delay = NotificationStateManager.notificationState.isClockAnimDelay ? 75 : 0; // 跟随时钟元素时延
    animateTo({
      delay: delay,
      curve: curves.interpolatingSpring(0, 1, 228, 24.5),
      onFinish: () => {
        AnimationController.reset();
      }
    }, () => {
      AnimationController.doAnimation(MediaAnimeScene.LIST_TO_CARD);
    });
  }

  /**
   * 开启大卡到列表动效, 需要在起始卡片和终点卡片同时在树上时调用, 且各只能有一张卡片
   */
  public static startCardToListAnim() {
    log.showInfo('startCardToListAnim');
    if (!isAnimEnable) {
      return;
    }
    AnimationController.reset();
    AnimationController.prepareAnimation(MediaAnimeScene.CARD_TO_LIST);
    animateTo({
      curve: curves.interpolatingSpring(0, 1, 228, 24.5),
      onFinish: () => {
        AnimationController.reset();
      }
    }, () => {
      AnimationController.doAnimation(MediaAnimeScene.CARD_TO_LIST);
    });
  }
}