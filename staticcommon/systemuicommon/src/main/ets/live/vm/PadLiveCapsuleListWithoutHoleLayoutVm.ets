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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NotificationArray } from '../../model/NotificationBase';
import { LiveStyle } from '../constants/LiveStyle';
import { ILiveCapsuleVm } from '../interface/ILiveCapsuleVm';
import { CapsuleShowType } from '../model/LiveCommonModel';
import { LiveNotification } from '../model/LiveNotification';
import { LiveCapsuleListWithoutHoleLayoutVm } from './LiveCapsuleListWithoutHoleLayoutVm';

const TAG = 'PadLiveCapsuleListWithoutHoleLayoutVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

enum CapsuleType {
  /**
   *  进度
   */
  PROGRESS = 0,
  /**
   *  录屏
   */
  SCREEN_RECORDING = 1,
  /**
   * 长时
   *
   */
  PERSISTENT = 2,
};

@ObservedV2
export class PadLiveCapsuleListWithoutHoleLayoutVm extends LiveCapsuleListWithoutHoleLayoutVm {
  protected readonly showCapsuleTypeSequence: number[] =
    [CapsuleShowType.TOP, CapsuleShowType.SELF_ADAPTIVE_ROUND_CAKE, CapsuleShowType.ROUND_CAKE, CapsuleShowType.SHADOW];

  protected updateFixedOffset(): void {
    super.updateFixedOffset();
    this.updateShadowFixedOffset();
  }

  protected isNeedShow(capsuleVm: ILiveCapsuleVm): boolean {
    return capsuleVm.fixedShowType === CapsuleShowType.TOP ||
      capsuleVm.fixedShowType === CapsuleShowType.ROUND_CAKE ||
      capsuleVm.fixedShowType === CapsuleShowType.RETRACTABLE_ROUND_CAKE ||
      capsuleVm.fixedShowType === CapsuleShowType.SELF_ADAPTIVE_ROUND_CAKE ||
      capsuleVm.fixedShowType === CapsuleShowType.SHADOW;
  }

  protected computeSingleCapsuleShowFlagForPad(liveCapsule: LiveNotification, usedSpace: number, freeSpace: number) {
    const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
    const capsuleWidth = capsuleVm.fixedShowType === CapsuleShowType.TOP ? this.getRealCapsuleWith(liveCapsule) :
    this.getMinWidth(liveCapsule);
    if (this.isNeedShow(capsuleVm)) {
      const newLeftUsedSpace = usedSpace + capsuleWidth + this.getCapsuleGap(capsuleVm);
      if (freeSpace >= newLeftUsedSpace) {
        usedSpace = newLeftUsedSpace;
        capsuleVm.isShow = true;
        capsuleVm.fixedWidth = capsuleWidth;
      } else {
        capsuleVm.isShow = false;
        capsuleVm.fixedWidth = 0;
        capsuleVm.fixedOffsetX = 0;
      }
    } else {
      capsuleVm.isShow = false;
      capsuleVm.fixedWidth = 0;
      capsuleVm.fixedOffsetX = 0;
    }
    return usedSpace;
  }

  protected computeCapsuleShowFlag(capsuleShowList: NotificationArray<LiveNotification>, mandatoryElementIdx: number,
    freeSpace: number): number {
    let usedSpace: number = this.baseGap;
    for (let capsuleIdx = 0; capsuleIdx < capsuleShowList.length; capsuleIdx++) {
      const liveCapsule = capsuleShowList[capsuleIdx];
      const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
      if (capsuleVm.fixedShowType === CapsuleShowType.RETRACTABLE_ROUND_CAKE ||
        capsuleVm.fixedShowType === CapsuleShowType.TOP) {
        usedSpace = this.computeSingleCapsuleShowFlagForPad(liveCapsule, usedSpace, freeSpace);
      } else if (capsuleVm.fixedShowType === CapsuleShowType.SELF_ADAPTIVE_ROUND_CAKE) {
        usedSpace = this.computeRightAllCapsulesShowFlag(capsuleShowList, capsuleIdx, usedSpace, freeSpace);
      }
    }
    let remainSpace = freeSpace - usedSpace;
    log.showInfo(`computeCapsuleShowFlag (freeSpace:${freeSpace} usedSpace:${usedSpace} remainSpace:${remainSpace})`);
    return remainSpace;
  }

  protected isNeedAdjustWidth(space: number, showType: CapsuleShowType): boolean {
    if (space < 0) {
      return false;
    }

    if (showType === CapsuleShowType.LEFT_HOLE || showType === CapsuleShowType.RIGHT_HOLE ||
      showType === CapsuleShowType.ROUND_CAKE || showType === CapsuleShowType.SHADOW ||
      showType === CapsuleShowType.SELF_ADAPTIVE_ROUND_CAKE) {
      return false;
    }
    return true;
  }

  private updateShadowFixedOffset(): void {
    for (const liveCapsule of this.showCapsuleList[CapsuleType.PROGRESS]) {
      const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
      if (!capsuleVm.isShow) {
        continue;
      }
      if (capsuleVm.fixedShowType === CapsuleShowType.SHADOW) {
        capsuleVm.fixedWidth = LiveStyle.SHADOW_CAPSULE_CIRCLE_WIDTH;
        capsuleVm.fixedOffsetX =
          capsuleVm.fixedOffsetX - (LiveStyle.SHADOW_CAPSULE_CIRCLE_WIDTH - LiveStyle.SHADOW_CAPSULE_SHOW_WIDTH);
        log.showInfo(`updateShadowFixedOffset capsule type(${capsuleVm.fixedShowType}) ${liveCapsule.hashCode} offset ${capsuleVm.fixedOffsetX}).`);
        break;
      }
    }
  }

  private computeRightCakeCapsuleSpace(capsuleShowList: NotificationArray<LiveNotification>, index: number): number {
    let rightNeddSpace: number = 0;
    for (let capsuleIdx = index; capsuleIdx < capsuleShowList.length; capsuleIdx++) {
      const liveCapsule = capsuleShowList[capsuleIdx];
      const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
      if (!capsuleVm.isShow) {
        continue;
      }
      rightNeddSpace += (this.getMinWidth(liveCapsule) + this.getCapsuleGap(capsuleVm));
    }
    return rightNeddSpace;
  }

  private computeRightAllCapsulesShowFlag(capsuleShowList: NotificationArray<LiveNotification>, index: number,
    usedSpace: number, freeSpace: number) {
    const adaptiveCapsule = capsuleShowList[index];
    const adaptiveCapsuleVm = this.vmInjector.getCapsuleVm(adaptiveCapsule);
    const capsuleGap = this.getCapsuleGap(adaptiveCapsuleVm);
    const realCapsuleWidthForExtend = this.getRealCapsuleWith(adaptiveCapsule);
    const realCapsuleWidth = this.getRealCapsuleWith(adaptiveCapsule, true);

    let capsuleWidth: number = 0;
    let isAdaptiveCapsule2Cake: boolean = false;
    let rightNeedSpace: number = this.computeRightCakeCapsuleSpace(capsuleShowList, index + 1);
    log.showInfo(`computeRightAllCapsulesShowFlag freeSpace: ${freeSpace}, usedSpace: ${usedSpace}, rightNeedSpace: ${rightNeedSpace}` +
      ` realCapsuleWidthForExtend: ${realCapsuleWidthForExtend},realCapsuleWidth: ${realCapsuleWidth}`);
    if (this.isExtendShow(adaptiveCapsule) &&
      (freeSpace >= usedSpace + rightNeedSpace + realCapsuleWidthForExtend + capsuleGap)) {
      capsuleWidth = realCapsuleWidthForExtend;
      usedSpace += (capsuleWidth + capsuleGap);
    } else if (freeSpace >= usedSpace + rightNeedSpace + realCapsuleWidth + capsuleGap) {
      capsuleWidth = realCapsuleWidth;
      usedSpace += (capsuleWidth + capsuleGap);
    } else {
      isAdaptiveCapsule2Cake = true;
      capsuleWidth = LiveStyle.CAPSULE_CIRCLE_WIDTH;
      usedSpace += capsuleWidth;
    }
    adaptiveCapsuleVm.isShow = true;
    adaptiveCapsuleVm.fixedWidth = capsuleWidth;

    usedSpace =
      this.computeRightCakeCapsuleShow(capsuleShowList, index + 1, isAdaptiveCapsule2Cake, usedSpace, freeSpace);
    return usedSpace;
  }

  private getRealCapsuleWith(liveCapsule: LiveNotification, isOnlyShowMainText: boolean = false): number {
    let text: string = this.getText(liveCapsule);
    const capsuleFontSize = this.getCapsuleFontSize(liveCapsule, false);
    const textWidth = this.getTextWidthBySize(capsuleFontSize, text);
    const capsuleWidth = textWidth + this.getCapsuleMarqueeWithoutTextWidth(liveCapsule, false);
    const isShowForExtend: boolean = this.isExtendShow(liveCapsule);
    if (isOnlyShowMainText || !isShowForExtend) {
      return this.getExpectWidth(liveCapsule, false, capsuleWidth);
    }
    let extendText: string = this.getText(liveCapsule, true);
    const extendTextWidth: number = this.getTextWidthBySize(capsuleFontSize, extendText);
    const capsuleWidthForExtend =
      textWidth + extendTextWidth + this.getCapsuleMarqueeWithoutTextWidth(liveCapsule, true);
    return this.getExpectWidth(liveCapsule, true, capsuleWidthForExtend);
  }

  private computeRightCakeCapsuleShow(capsuleShowList: NotificationArray<LiveNotification>, index: number,
    isAdaptiveCapsule2Cake: boolean, usedSpace: number, freeSpace: number): number {
    for (let capsuleIdx = index; capsuleIdx < capsuleShowList.length; capsuleIdx++) {
      const liveCapsule = capsuleShowList[capsuleIdx];
      const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
      if (!capsuleVm.isShow) {
        continue;
      }
      if (capsuleVm.fixedShowType === CapsuleShowType.ROUND_CAKE) {
        capsuleVm.fixedShowType = isAdaptiveCapsule2Cake ? CapsuleShowType.SHADOW : CapsuleShowType.ROUND_CAKE;
        usedSpace = this.computeSingleCapsuleShowFlagForPad(liveCapsule, usedSpace, freeSpace);
      } else if (capsuleVm.fixedShowType === CapsuleShowType.SHADOW) {
        if (isAdaptiveCapsule2Cake) {
          capsuleVm.isShow = false;
          capsuleVm.fixedWidth = 0;
          capsuleVm.fixedOffsetX = 0;
        } else {
          usedSpace = this.computeSingleCapsuleShowFlagForPad(liveCapsule, usedSpace, freeSpace);
        }
      }
    }
    return usedSpace;
  }
}