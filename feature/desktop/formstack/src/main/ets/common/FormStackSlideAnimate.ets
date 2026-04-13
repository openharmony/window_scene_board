/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import { LogHelper, LogDomain } from '@ohos/basicutils';
import { CommonConstants } from '@ohos/launchercommon';

const TAG: string = 'FormStackSlideAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormStackSlideAnimate {
  public slideAnimateParam?: SlideAnimateParam;

  /**
   * 根据卡片尺寸类型，获取滑动动效参数配置信息
   *
   * @param 堆叠卡cardDimension
   */
  public initAnimateParam(cardDimension: number): void {
    log.showWarn(`init form stack animate param, cardDimension is ${cardDimension}`);
    switch (cardDimension) {
      case CommonConstants.CARD_DIMENSION_1x2:
        this.slideAnimateParam = new SlideAnimateParam(1.06, 0.9, -40, 0.85, 0.85, -80, -15);
        break;
      case CommonConstants.CARD_DIMENSION_2x2:
      case CommonConstants.CARD_DIMENSION_2x4:
        this.slideAnimateParam = new SlideAnimateParam(1.05, 0.88, -40, 0.85, 0.85, -80, -15);
        break;
      case CommonConstants.CARD_DIMENSION_4x4:
        this.slideAnimateParam = new SlideAnimateParam(1.04, 0.84, -40, 0.85, 0.84, -80, -15);
        break;
      default:
        this.slideAnimateParam = new SlideAnimateParam(1.05, 0.88, -40, 0.85, 0.85, -80, -15);
    }
  }
}

export class SlideAnimateParam {
  public downMaxScaleX: number;

  public downMaxScaleY: number;

  public downMaxRotateAngle: number;

  public downFinalScaleX: number;

  public downFinalScaleY: number;

  public downFinalRotateAngle: number;

  public behindFormRotateAngle: number;

  constructor(downMaxScaleX: number, downMaxScaleY: number, downMaxRotateAngle: number,
    downFinalScaleX: number, downFinalScaleY: number, downFinalRotateAngle: number, behindFormRotateAngle: number) {
    this.downMaxScaleX = downMaxScaleX;
    this.downMaxScaleY = downMaxScaleY;
    this.downMaxRotateAngle = downMaxRotateAngle;
    this.downFinalScaleX = downFinalScaleX;
    this.downFinalScaleY = downFinalScaleY;
    this.downFinalRotateAngle = downFinalRotateAngle;
    this.behindFormRotateAngle = behindFormRotateAngle;
  }
}