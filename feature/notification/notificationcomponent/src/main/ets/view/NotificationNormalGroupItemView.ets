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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  BaseGesture,
  INotificationNormalGroupVm,
  INotificationSwipeVm,
  NotificationVmInjector,
  INotificationCardVm,
} from '@ohos/systemuicommon/newIndex';
import { NotificationNormalView } from './NotificationNormalView';
import { NormalNotification, NormalNotificationGroup } from '@ohos/systemuicommon/newTsIndex';
import { NotificationMenuView } from './NotificationMenuView';
import { curves, LengthMetrics } from '@kit.ArkUI';

const TAG = 'NotificationNormalGroupItemView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

@ComponentV2
export struct NotificationNormalGroupItemView {
  @Consumer() ntfVmInjector: NotificationVmInjector = NotificationVmInjector.HOLDER;
  @Param @Require groupNtf: NormalNotificationGroup;
  @Param @Require ntf: NormalNotification;
  @Local contentGesture: BaseGesture = new BaseGesture();

  @Computed
  get swipeVm(): INotificationSwipeVm | undefined {
    const swipeVm = this.ntfVmInjector.getSwipeVm(this.ntf);
    if (swipeVm) {
      this.contentGesture.destroy();
      this.contentGesture.addGesture(swipeVm.getPanGestureHandler());
    }
    return swipeVm;
  }

  @Computed
  get normalGroupVm(): INotificationNormalGroupVm | undefined {
    return this.ntfVmInjector.getNormalGroupVm(this.groupNtf);
  }
  @Computed get cardVm(): INotificationCardVm {
    return this.ntfVmInjector.getCardVm(this.ntf);
  }

  build() {
    Stack({ alignContent: Alignment.End }) {
      Column() {
        NotificationNormalView({
          ntf: this.ntf,
          textTranAnimParam: this.normalGroupVm?.getContentTextAnimation(),
          groupNtf: this.groupNtf,
        })
      }
      .offset({ start: LengthMetrics.vp(this.swipeVm?.offsetX) })
      .enabled(this.normalGroupVm?.isChildEnable())

      // 性能、内存优化：默认不创建卡片菜单组件，卡片滑动时才创建.
      if (this.swipeVm?.offsetX !== 0) {
        NotificationMenuView({ ntf: this.ntf, isInGroup: true })
      }
    }
    .id(this.ntfVmInjector.getId(`${TAG}_${this.ntf.hashCode}`))
    .width('100%')
    .transition(TransitionEffect.asymmetric(
      TransitionEffect.OPACITY.animation({ duration: 350 }),
      TransitionEffect.OPACITY.animation({ duration: 167, curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1) })
    ))
    .onTouch((event: TouchEvent) => {
      if (event.type === TouchType.Down) {
        this.cardVm.isTouching = true;
        return;
      }
      if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
        this.cardVm.isTouching = false;
        return;
      }
    })
    .gestureModifier(this.contentGesture)
  }
}