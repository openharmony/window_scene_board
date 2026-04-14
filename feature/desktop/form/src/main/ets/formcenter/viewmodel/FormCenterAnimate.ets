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

import curves from '@ohos.curves';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { StyleConstants } from '@ohos/launchercommon';

const TAG: string = 'FormCenterAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

enum CardArea {
  SMALL,
  MIDDLE,
  LARGE
};

export interface CardAnimParams {
  params: AnimateParam;
  scale: number;
};

export class FormCenterAnimateUtil {
  public static mInstance: FormCenterAnimateUtil;

  public static getInstance(): FormCenterAnimateUtil {
    if (FormCenterAnimateUtil.mInstance == null) {
      FormCenterAnimateUtil.mInstance = new FormCenterAnimateUtil();
    }
    return FormCenterAnimateUtil.mInstance;
  }

  private getFormArea(cardDimension: number): number {
    switch (cardDimension) {
      case FormDimension.Dimension_1_2:
      case FormDimension.Dimension_2_1:
        return CardArea.SMALL;
      case FormDimension.Dimension_2_2:
      case FormDimension.Dimension_2_4:
        return CardArea.MIDDLE;
      case FormDimension.Dimension_4_4:
      default:
        return CardArea.LARGE;
    }
  }

  public getPressAnimParams(isZoomOut: boolean, cardDimension: number): CardAnimParams {
    let params: CardAnimParams = { params: { playMode: PlayMode.Normal }, scale: 1 };
    let area = this.getFormArea(cardDimension);
    if (!isZoomOut) {
      params.params.duration = 250;
      params.params.curve = Curve.Friction;
      return params;
    }
    if (area === CardArea.SMALL) {
      params.params.curve = curves.interpolatingSpring(1, 1, 410, 38);
      params.scale = StyleConstants.DEFAULT_LONG_PRESS_SCALE_90;
    } else if (area === CardArea.MIDDLE) {
      params.params.curve = curves.interpolatingSpring(0.5, 1, 350, 35);
      params.scale = StyleConstants.DEFAULT_LONG_PRESS_SCALE_95;
    } else {
      params.params.curve = curves.interpolatingSpring(0, 1, 240, 28);
      params.scale = StyleConstants.DEFAULT_LONG_PRESS_SCALE_95;
    }
    return params;
  }
}