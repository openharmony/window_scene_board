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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { AnimationDataArray, ControlCenterAnimationData } from '../model/ControlCenterAnimationData';
import ControlCenterAnim from '../common/ControlCenterAnimParm';
import Curves from '@ohos.curves';

const TAG = 'Ctrl.ControlCenterAnimation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const ANIMATE_ROW_NUM = 10;
const ANIMATE_DELAY = 32;
const ANIMATE_DELAY_SMALLER = 10;

/**
 * 控制中心下拉收起动效viewModel
 */
export class ControlCenterAnimationViewModel {
  public viewDataArray: AnimationDataArray;

  constructor(viewDataArray: AnimationDataArray, length: number) {
    for (let i = 0; i < length; i++) {
      viewDataArray.push(new ControlCenterAnimationData(ControlCenterAnim.SCALE_VAL, 0, 0,
        -px2vp(ControlCenterAnim.TRANSITION_Y)));
    }
    this.viewDataArray = viewDataArray;
  }

  /**
   * 根据开关行数更新动效参数列表
   *
   * @param toggleRows  当前开关行数
   * @param isControlCenterVisible  控制中心是否可见
   */
  public updateViewDataArray(toggleRows: number, isControlCenterVisible: boolean): void {
    let curLength: number = this.viewDataArray.length;
    log.showInfo(`updateViewDataArray length ${curLength} ,row: ${toggleRows}`);
    if (curLength < toggleRows) {
      for (let i = 0; i < toggleRows - curLength; i++) {
        if (isControlCenterVisible) {
          this.viewDataArray.push(new ControlCenterAnimationData(1, 1, 0, 0));
        } else {
          this.viewDataArray.push(new ControlCenterAnimationData(ControlCenterAnim.SCALE_VAL, 0, 0,
            -px2vp(ControlCenterAnim.TRANSITION_Y)));
        }
      }
    } else if (curLength > toggleRows) {
      this.viewDataArray.splice(toggleRows);
    }
    log.showInfo(`updateViewDataArray length end: ${this.viewDataArray.length}`);
  }

  /**
   * 下拉回弹动效
   *
   * @param progress
   * @param itemSize
   * @param isStretch 当为true的时候，为控制中心下拉动效的跟手拖拽松手回弹效果；为false的时候，为已经下拉之后，继续跟手拖拽松手回弹效果
   */
  public touchEndCheckAnim(progress: number, itemSize: number, isStretch: boolean) {
    if (progress == 0) {
      return;
    }
    log.showInfo(`touchEndCheckAnim start itemSize=${itemSize} arrLength=${this.viewDataArray.length}`);
    itemSize = Math.min(itemSize, this.viewDataArray.length);
    for (let i = 0; i < itemSize; i++) {
      animateTo({
        curve: Curves.springCurve(0, 1, 228, 30),
        delay: isStretch ? i * ANIMATE_DELAY : i * ANIMATE_DELAY_SMALLER,
        iterations: 1,
        playMode: PlayMode.Normal,
      }, () => {
        try {
          if (!CheckEmptyUtils.isEmpty(this.viewDataArray[i])) {
            this.viewDataArray[i].translate = 0;
          }
        } catch (e) {
          log.showError(`touchEndCheckAnim error: ${e}`);
        }
      })
    }
  }

  public resetData(isShow: boolean) {
    for (let i = 0; i < this.viewDataArray.length; i++) {
      this.viewDataArray[i].scale = isShow ? 1 : ControlCenterAnim.SCALE_VAL;
      this.viewDataArray[i].opacity = isShow ? 1 : 0;
      this.viewDataArray[i].itemTranslate = isShow ? 0 : -px2vp(ControlCenterAnim.TRANSITION_Y);
    }
  }
}