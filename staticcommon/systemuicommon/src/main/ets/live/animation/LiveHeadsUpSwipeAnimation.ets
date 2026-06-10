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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { AnimationBase } from '../../animation/AnimationBase';
import { ILiveHeadsUpCommonCardVm } from '../interface/ILiveHeadsUpCommonCardVm';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'LiveHeadsUpSwipeAnimation');

export class LiveHeadsUpSwipeAnimation extends AnimationBase {

  private cardVm: ILiveHeadsUpCommonCardVm;

  constructor(cardVm: ILiveHeadsUpCommonCardVm) {
    super(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
    this.cardVm = cardVm;
  }

  /**
   * 触摸卡片
   * @param touchDown
   * @returns
   */
  public async touch(touchDown: boolean) {
    await this.executeAnimation([
      {
        curve: Curve.Linear,
        duration: 200,
        event: () => {
          this.cardVm.containerScale = touchDown ? { x: 0.95, y: 0.95 } : { x: 1, y: 1};
        }
      }
    ], `touch ${touchDown ? 'down' : 'up'} card`)
  }
}