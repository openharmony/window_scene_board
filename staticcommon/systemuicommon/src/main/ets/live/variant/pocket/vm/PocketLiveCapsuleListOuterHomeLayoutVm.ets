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
import { LiveNotification } from '../../../model/LiveNotification';
import { CapsuleShowType } from '../../../model/LiveCommonModel';
import { ILiveCapsuleVm } from '../../../interface/ILiveCapsuleVm';
import { ILiveCapsuleListLayoutVm } from '../../../interface/ILiveCapsuleLayoutVm';
import { CapsuleType, LiveCapsuleListWithoutHoleLayoutVm } from '../../../vm/LiveCapsuleListWithoutHoleLayoutVm';
import { LiveStyle } from '../../../constants/LiveStyle';
import { PocketManager } from '../manager/PocketManager';
import { EnvVm } from '../../../../vm/EnvVm';
import { DeviceInfoVm } from '../../../../vm/DeviceInfoVm';
import { ResUtils } from '@ohos/windowscene';

@ObservedV2
export class PocketLiveCapsuleListOuterHomeLayoutVm extends LiveCapsuleListWithoutHoleLayoutVm
implements ILiveCapsuleListLayoutVm {
  protected TAG: string = 'PocketLiveCapsuleListOuterHomeLayoutVm';

  protected readonly showCapsuleTypeSequence: number[] = [CapsuleShowType.TOP, CapsuleShowType.SHADOW];

  private envVm = EnvVm.instance;

  private deviceInfoVm = DeviceInfoVm.instance;

  public getMinWidth(live: LiveNotification, isLeft: boolean = true): number {
    if (this.vmInjector.getCapsuleVm(live).fixedShowType === CapsuleShowType.SHADOW) {
      return LiveStyle.SHADOW_CAPSULE_SMALL_OFFSET;
    }
    if (this.vmInjector.getCapsuleVm(live).fixedShowType === CapsuleShowType.ROUND_CAKE) {
      return LiveStyle.CAPSULE_SMALL_CIRCLE_WIDTH;
    }
    return super.getMinWidth(live, isLeft);
  }

  public computeCapsuleFixedWithAndOffset(liveList: LiveNotification[], isUpdate: boolean = true): void {
    const position = this.vmInjector.getCapsuleListVm().position;
    if (!this.checkParam(liveList, position)) {
      this.log.showWarn('check parm is invalid.');
      this.computeCapsuleListWidth(liveList);
      return;
    }
    this.initParam(position, isUpdate);
    this.clearShowCapsuleList();
    this.filterShowCapsuleList(liveList);
    if (this.showCapsuleList[CapsuleType.PROGRESS].length &&
      this.showCapsuleList[CapsuleType.SCREEN_RECORDING].length) {
      const capsuleVm = this.vmInjector.getCapsuleVm(this.showCapsuleList[CapsuleType.SCREEN_RECORDING][0]);
      capsuleVm.fixedShowType = CapsuleShowType.ROUND_CAKE;
      const lightVm = this.vmInjector.getCapsuleLightWaveVm(this.showCapsuleList[CapsuleType.SCREEN_RECORDING][0]);
      lightVm.lightShow = false;
      this.log.showInfo('Set screen recorder fixedShowType to roundCake, close lightShow');
    }
    PocketManager.updateCapsuleShowStyle(liveList, this.vmInjector);
    this.updateFixedWidth();
    this.updateFixedOffset();
    this.modifyFixedWidthAndFixedOffsetByShowType();
    this.updateStatusBarHeight(liveList);
    this.computeCapsuleListWidth(liveList);
    this.printFixedWithAndeOffset(liveList);
  }

  public adjustFixedWidth(space: number, live: LiveNotification, isUpdateImmediately: boolean,
    isLeft: boolean = true): number {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    // 外屏支持副文本显示
    capsuleVm.fixedIsLayoutSupportExtendShow = true;
    capsuleVm.fixedIsShowRightIcon = this.isShowRightIcon(live);
    return this.adjustFixedWidthForNoHangingHoleType(live, space, isUpdateImmediately);
  }

  protected isNeedShow(capsuleVm: ILiveCapsuleVm): boolean {
    return capsuleVm.fixedShowType === CapsuleShowType.TOP ||
      capsuleVm.fixedShowType === CapsuleShowType.ROUND_CAKE ||
      capsuleVm.fixedShowType === CapsuleShowType.RETRACTABLE_ROUND_CAKE ||
      capsuleVm.fixedShowType === CapsuleShowType.SHADOW;
  }

  private modifyFixedWidthAndFixedOffsetByShowType(): void {
    for (const liveCapsule of this.showCapsuleList[CapsuleType.PROGRESS]) {
      const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
      if (!capsuleVm.isShow) {
        continue;
      }
      if (capsuleVm.fixedShowType !== CapsuleShowType.SHADOW) {
        continue;
      }

      capsuleVm.fixedWidth = LiveStyle.CAPSULE_SMALL_HEIGHT + LiveStyle.SHADOW_CAPSULE_SMALL_OFFSET;
      capsuleVm.fixedOffsetX = capsuleVm.fixedOffsetX - LiveStyle.CAPSULE_SMALL_HEIGHT;
      this.log.showInfo(`modifyFixedWidthAndFixedOffsetByShowType capsule type` +
        `(${capsuleVm.fixedShowType}) ${liveCapsule.hashCode} offset ${capsuleVm.fixedOffsetX}).`);
    }
  }

  protected getRemindCapsuleOffset(): number {
      return super.getRemindCapsuleOffset();
  }

  protected getRemindCapsuleMaxWidth(): number {
      return super.getRemindCapsuleMaxWidth();
  }

  protected getBaseGap(): number {
      return super.getBaseGap();
  }

  protected getCapsuleGap(liveCapsuleVm: ILiveCapsuleVm): number {
      return super.getCapsuleGap(liveCapsuleVm);
  }

  protected getSpaceBetweenCapsuleAndStatusBar(): number {
      return super.getSpaceBetweenCapsuleAndStatusBar();
  }

  protected getCapsuleMarqueeWithoutTextWidth(live: LiveNotification, isExtend?: boolean,
    realTotalLength?: number): number {
    let width = super.getCapsuleMarqueeWithoutTextWidth(live, isExtend);
    const remindWidth = width;
    return width;
  }

  private shouldIgnoreCapsuleGap(liveCapsuleVm: ILiveCapsuleVm) {
    // 圆饼, 阴影, 伸缩圆饼前不需要gap
    if (liveCapsuleVm.fixedShowType === CapsuleShowType.ROUND_CAKE ||
      liveCapsuleVm.fixedShowType === CapsuleShowType.SHADOW ||
      liveCapsuleVm.fixedShowType === CapsuleShowType.RETRACTABLE_ROUND_CAKE) {
      return true;
    }
    // 无圆饼时，只有一个胶囊+阴影，不需要gap
    if (this.showCapsuleList[CapsuleType.PROGRESS].length &&
      !this.showCapsuleList[CapsuleType.SCREEN_RECORDING].length) {
      return true;
    }
    return false;
  }

  protected isExtendShow(live: LiveNotification): boolean {
    const extendTextLen: number = this.getExtendTextContent(live).length;
    this.log.showInfo(`isPocketOuterHomeExtendCapsuleShow extendText len ${extendTextLen} display width ${DeviceInfoVm.instance.width}.`);
    return extendTextLen !== 0;
  }

  protected getText(live: LiveNotification, isExtend?: boolean, inMarquee: boolean = false): string {
    // 进aod后计时会刷新成aod提示文本, 文本内容和组件宽度需同时刷新，在此之前布局计算中，需要提前使用将要刷新的文本计算宽度
    return super.getText(live, isExtend, inMarquee);
  }
}