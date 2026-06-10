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

/**
 * 播控锁屏动效场景
 */
export enum MediaAnimeScene {
  CAPSULE_TO_CARD = 'CAPSULE_TO_CARD',
  CARD_TO_CAPSULE = 'CARD_TO_CAPSULE',
  LIST_TO_CARD = 'LIST_TO_CARD',
  CARD_TO_LIST = 'CARD_TO_LIST',
  CAPSULE_TO_LIST = 'CAPSULE_TO_LIST',
  LIST_TO_CAPSULE = 'LIST_TO_CAPSULE'
}

/**
 * 播控锁屏一镜到底动效状态
 */
@Observed
export class AnimationState {

  /**
   * 是否胶囊在做动效
   */
  public isCapsuleGeo: boolean = false;

  /**
   * 是否胶囊需要展示
   */
  public isCapsuleShow: boolean = true;

  /**
   * 是否大卡在做动效
   */
  public isCardGeo: boolean = false;

  /**
   * 是否大卡需要展示
   */
  public isCardShow: boolean = true;

  /**
   * 是否列表在做动效
   */
  public isListGeo: boolean = false;

  /**
   * 是否列表需要展示
   */
  public isListShow: boolean = true;

  /**
   * 重置动效状态
   */
  public reset() {
    this.isCapsuleGeo = false;
    this.isCapsuleShow = true;
    this.isCardGeo = false;
    this.isCardShow = true;
    this.isListGeo = false;
    this.isListShow = true;
  }
}