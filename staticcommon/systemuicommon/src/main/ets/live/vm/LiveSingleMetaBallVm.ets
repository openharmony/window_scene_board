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

// import { BallParams, MetaballAnimationScene } from '@hms.hds.Metaball';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { StatusBarCapsulePosition } from '../../statusbar/model/StatusBarCapsulePosition';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { LiveStyle } from '../constants/LiveStyle';
import { LiveMetaBallBaseVm } from './LiveMetaBallBaseVm';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuiutils/src/main/ets/base/LayoutUtils';
import { ResourceVm } from '../../vm/ResourceVm';
import type { Hole } from '../../statusbar/vm/CutoutVm';

const TAG = 'LiveSingleMetaBallVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

// 融球组件画布宽度与融球直径比例为(2.0/0.4)
const widthFactor = 5.0;

// 融球组件画布高度与融球直径比例为(0.64/0.4)
const heightFactor = 1.6;

@ObservedV2
export class LiveSingleMetaBallVm extends LiveMetaBallBaseVm {
  public animStatusBarHeight: number = LiveStyle.CAPSULE_HEIGHT * heightFactor / 2 + this.cutoutVm.holes[0].centerY;
  @Trace public maxOffsetY: number =
    -Math.min(((this.cutoutVm.holes[0]?.centerY ?? 0) - LiveStyle.CAPSULE_HEIGHT * 1.15 / 2) * 0.75,
      LiveStyle.CAPSULE_HEIGHT / 2 - (this.cutoutVm.holes[0]?.radius ?? 0));

  public getWidth(capsulePosition: StatusBarCapsulePosition): number {
    return capsulePosition.width * widthFactor;
  }

  public getHeight(capsulePosition: StatusBarCapsulePosition): number {
    return capsulePosition.height * heightFactor;
  }

  public getPosition(capsulePosition: StatusBarCapsulePosition): Edges {
    if (LayoutUtils.isXTProductType() && DeviceInfoVm.instance.xtLayoutType === XTLayoutType.F) {
      // XT设备由于屏幕分辨率原因，top要往下0.3vp融球才能和挖孔较好重叠
      return {
        left: -capsulePosition.width * (widthFactor - 1) / 2,
        top: -capsulePosition.height * (heightFactor - 1) / 2 + 0.3
      };
    }
    return {
      left: -capsulePosition.width * (widthFactor - 1) / 2,
      top: -capsulePosition.height * (heightFactor - 1) / 2
    };
  }

  // public getBallParam(capsulePosition: StatusBarCapsulePosition): BallParams[] {
  //   const centerX = capsulePosition.holes[0].centerX - capsulePosition.left;
  //   const centerY = capsulePosition.holes[0].centerY - capsulePosition.top;
  //   const metaBallRadius: number = LiveStyle.CAPSULE_HEIGHT / 2;
  //   return [{
  //     centerX: centerX,
  //     centerY: centerY,
  //     radius: metaBallRadius,
  //     isIsolated: true
  //   }];
  // }

  public getMiddleHole(): Hole {
    return this.cutoutVm.holes[0];
  }

  toggleToDeskTop(isUpwards?: boolean, duration?: number): Promise<void> {
    // const capsuleListVm = this.vmInjector.getCapsuleListVm();
    // const showCapsuleNum = capsuleListVm.getShowCapsuleListNum();
    // const status: boolean[] = showCapsuleNum === 0 ? [] : showCapsuleNum === 1 ? [true] : [false];
    // return this.fusionBall(status, [], {
    //   animateParam: this.getAnimateParam(duration),
    //   scene: MetaballAnimationScene.NORMAL,
    // }, isUpwards);
    return  Promise.resolve();
  }

  toggleToHeadUp(duration?: number): Promise<void> {
    // const showCapsuleNum = this.vmInjector.getCapsuleListVm().getShowCapsuleListNum();
    // const status: boolean[] = showCapsuleNum === 0 ? [] : showCapsuleNum === 1 ? [true] : [false];
    // return this.fusionBall(status, [], {
    //   animateParam: this.getAnimateParam(duration),
    //   scene: MetaballAnimationScene.NORMAL
    // });
    return  Promise.resolve();

  }

  toggleToLiveList(duration?: number): Promise<void> {
    // return this.fusionBall([], [], {
    //   animateParam: this.getAnimateParam(duration),
    //   scene: MetaballAnimationScene.NORMAL
    // });
    return  Promise.resolve();

  }

  async toggleToPanel(duration?: number): Promise<void> {
    // const isMetaBallShow = this.vmInjector.getMetaBallVisibleVm().isMetaBallShow();
    // if (isMetaBallShow) {
    //   return this.fusionBall([], [], {
    //     animateParam: this.getAnimateParam(duration),
    //     scene: MetaballAnimationScene.NORMAL
    //   });
    // } else {
    //   return new Promise((resolve) => {
    //     resolve();
    //   });
    // }
    return  Promise.resolve();

  }

  toggleToRemind(duration?: number): Promise<void> {
    // return this.fusionBall([true], [], {
    //   animateParam: this.getAnimateParam(duration),
    //   scene: MetaballAnimationScene.NORMAL
    // });
    return  Promise.resolve();

  }

  toggleToImmersive(duration?: number): Promise<void> {
    // return this.fusionBall([], [], {
    //   animateParam: this.getAnimateParam(duration),
    //   scene: MetaballAnimationScene.NORMAL
    // });
    return  Promise.resolve();

  }
}