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
import { SlLayoutData } from './SlLayoutData';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { curves } from '@kit.ArkUI';
import { LayoutAniParamConst } from '../common/AniParamConst';
import { SCBPropertyChangeReason, SCBScreenProperty, SCBScreenSessionManager } from '@ohos/windowscene';
import { RotationConstants } from '@ohos/commonconstants';

const TAG = 'ScreenLock-SlLayoutRotateAni';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class SlLayoutRotateAni {
  private slLayoutData: SlLayoutData = new SlLayoutData();

  public initAni(data: SlLayoutData, isAnimate: boolean = true): void {
    this.slLayoutData = data;
    if (isAnimate) {
      SCBScreenSessionManager.getInstance().registerScreenPropertyChangeCallbacks(this.screenPropChangeCallback);
    }
  }

  private screenPropChangeCallback = (screenProp: SCBScreenProperty, reason: SCBPropertyChangeReason) => {
    log.showInfo(`update ScreenLock layout reason: ${reason}, ` +
      `screen number: ${SCBScreenSessionManager.getInstance().getScreenSessionList().length}`);

    if (reason !== SCBPropertyChangeReason.ROTATION) {
      log.showInfo(`screenPropChangeCallback reason is not rotation`);
      return;
    }

    if (screenProp.rotation === RotationConstants.ROTATION_90 ||
      screenProp.rotation === RotationConstants.ROTATION_270) {
      this.animateToHorizontal();
    } else {
      this.animateFromHorizontal();
    }
  }

  private animateToHorizontal(): void {
    animateTo({
      duration: 600,
      curve: curves.cubicBezierCurve(0.4, 0, 0.2, 1),
      onFinish: () => {
        log.showInfo(`animateToHorizontal is finished`);
      }
    }, () => {
      this.slLayoutData.rotateParam = LayoutAniParamConst.HORIZONTAL;
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
      this.slLayoutData.rotateParam = LayoutAniParamConst.VERTICAL;
    });
  }

  public destroy(): void {
    SCBScreenSessionManager.getInstance().unRegisterScreenPropertyChangeCallbacks(this.screenPropChangeCallback);
  }
}