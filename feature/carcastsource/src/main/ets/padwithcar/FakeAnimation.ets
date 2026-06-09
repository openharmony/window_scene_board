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

const TAG = 'FakeAnimation';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HICAR, TAG);
const ANIMATION_MASK_SIZE = 1;
const ANIMATION_MASK_DURATION = 500;
const ANIMATION_Z_ORDER = 10001;

/*
 * 触发渲染帧的动画，避免由于投屏丢帧导致的白屏、黑屏、卡帧的问题
 */
@Component
export struct FakeAnimation {
  duration: number = ANIMATION_MASK_DURATION;
  finishCallback?: Function;
  @State mOpacity: number = 0;

  private showAnimation() {
    this.mOpacity = 1;
    animateTo({
      curve: Curve.Linear,
      duration: this.duration,
      onFinish: () => {
        log.showInfo('showAnimation end');
        this.finishCallback?.();
      }
    }, () => {
      this.mOpacity = 0;
    });
  }

  aboutToAppear(): void {
    log.showDebug('aboutToAppear');
    this.showAnimation();
  }

  aboutToDisappear(): void {
    log.showDebug('aboutToDisappear');
  }

  build() {
    if (this.mOpacity > 0) {
      Stack()
        .size({ width: ANIMATION_MASK_SIZE, height: ANIMATION_MASK_SIZE })
        .backgroundColor(Color.Gray)
        .opacity(this.mOpacity)
        .position({
          x: 0,
          y: 0
        })
        .zIndex(ANIMATION_Z_ORDER)
        .hitTestBehavior(HitTestMode.None)
    }
  }
}