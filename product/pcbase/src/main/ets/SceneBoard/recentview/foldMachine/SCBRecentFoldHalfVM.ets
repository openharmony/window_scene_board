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

import { curves } from '@kit.ArkUI';
import { LogDomain, LogHelper, Trace } from '@ohos/basicutils';
import { SCBRecentStyle, SCBRecentStyleManager } from './SCBRecentStyle';
import { AnimationType, CustomAnimateParam, SCBRecentFoldMachineVM } from './SCBRecentFoldMachineVM';

const TAG = 'Recent-SCBRecentFoldHalfVM';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

/**
 * 大屏幕机半折叠态
 */
export class SCBRecentFoldHalfVM extends SCBRecentFoldMachineVM {

  protected static instance: SCBRecentFoldHalfVM;

  private isActive: boolean = false;
  private foldAnimateParam: CustomAnimateParam = { duration: 300, curve: Curve.Friction, needUpdateStack: true };
  private avoidAnimateParam: CustomAnimateParam = {
    animationKey: AnimationType.AVOID_ANIMATION,
    duration: 700,
    curve: curves.springCurve(0, 7, 50, 30),
    onFinish: () => Trace.end(AnimationType.AVOID_ANIMATION),
    needUpdateStack: false
  };

  public static getInstance(): SCBRecentFoldHalfVM {
    if (!SCBRecentFoldHalfVM.instance) {
      SCBRecentFoldHalfVM.instance = new SCBRecentFoldHalfVM();
    }
    return SCBRecentFoldHalfVM.instance;
  }

  runAnimation(key: AnimationType, screenID: number, param?: CustomAnimateParam): void {
    if (key === AnimationType.FOLD_ANIMATION && param) {
      param.animationKey = key;
      param.onFinish = () => {
        Trace.end(key);
      }
    }
    super.executeAnimation(key, screenID, param);
  }

  public refreshAxisPosition(screenID: number): void {
    if (!this.isActive || !AppStorage.get('showRecent')) {
      log.showInfo('not in halfFold or recent, no need to refresh medialAxis');
      return;
    }
    this.runAnimation(AnimationType.AVOID_ANIMATION, screenID);
  }

  public runScrollAnimate(sceneID: number, yOffset?: number): void {
    if (!this.isActive) {
      return;
    }
    const animateParam: CustomAnimateParam = { curve: curves.responsiveSpringMotion(), yOffset: yOffset };
    this.runAnimation(AnimationType.SCROLL_ANIMATION, sceneID, animateParam);
  }

  public runAvoidAnimate(sceneID: number): void {
    if (!this.isActive) {
      return;
    }
    this.runAnimation(AnimationType.AVOID_ANIMATION, sceneID, this.avoidAnimateParam);
  }
}