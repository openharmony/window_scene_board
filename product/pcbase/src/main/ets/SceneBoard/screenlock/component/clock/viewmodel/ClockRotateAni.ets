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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ClockWidgetVD } from './ClockWidgetVD';
import { curves } from '@kit.ArkUI';
import { ClockAniParamConst } from '../common/Constants';

const TAG = 'ScreenLock-ClockRotateAni';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class ClockRotateAni {
  private viewData: ClockWidgetVD = new ClockWidgetVD();

  public initAnimate(data: ClockWidgetVD, isAnimate: boolean = true): void {
    this.viewData = data;
  }

  private animateToHorizontal(): void {
    animateTo({
      duration: 600,
      curve: curves.cubicBezierCurve(0.4, 0, 0.2, 1),
      onFinish: () => {
        log.showInfo(`animateToHorizontal is finished`);
      }
    }, () => {
      this.viewData.rotateParam = ClockAniParamConst.HORIZONTAL;
    });
  }

  private animateFromHorizontal(): void {
    animateTo({
      duration: 600,
      curve: curves.cubicBezierCurve(0.4, 0, 0.2, 1),
      onFinish: () => {
        log.showInfo(`animateFromHorizontal is finished`);
      }
    }, () => {
      this.viewData.rotateParam = ClockAniParamConst.VERTICAL;
    });
  }

  public destroy(): void {}
}