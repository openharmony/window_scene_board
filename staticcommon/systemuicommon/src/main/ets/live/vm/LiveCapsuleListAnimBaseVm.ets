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
import { AnimateParams, AnimationBase } from '../../animation/AnimationBase';
import { CapsuleShowType } from '../model/LiveCommonModel';
import { LiveNotification } from '../model/LiveNotification';
import { LiveBaseVm } from './LiveBaseVm';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ILiveCapsuleListAnimVm } from '../interface/ILiveCapsuleListAnimVm';
import { CapsuleTransferParam } from '../interface/ILiveCapsuleListVm';
import { DeviceRotateVm } from '../../vm/DeviceRotateVm';
import { CurveUtil } from '../../utils/CurveUtil';
import { LiveStyle } from '../constants/LiveStyle';
import { ILiveCapsuleVm } from '../interface/ILiveCapsuleVm';

const TAG = 'LiveCapsuleListAnimBaseVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const CAPSULE_WIDTH_CHANGE_CURVE = curves.interpolatingSpring(0, 1, 130, 16);
const CAPSULE_TEXT_SHOW_HIDE_CURVE = curves.cubicBezierCurve(0.10, 0.00, 0.20, 1.00);
const CAPSULE_TEXT_SHOW_HIDE_DURATION = 300;
const CAPSULE_TEXT_SHOW_ANIMATION_TIME_INTERVAL: number = 150;
const INSTANT_CAPSULE_UPDATE_DURATION: number = 130;

export interface LiveCapsuleCollapseAnimState {
  beforeWidth: number;
  beforeOffsetX: number;
  afterWidth: number;
  afterOffsetX: number;
  beforeScale?: number;
  afterScale?: number;
}

@ObservedV2
export abstract class LiveCapsuleListAnimBaseVm extends LiveBaseVm implements ILiveCapsuleListAnimVm {
  protected readonly TAG: string = 'LiveCapsuleListAnimBaseVm';
  private capsuleWidthOffsetChangeAnimation: AnimationBase =
    new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_WIDTH_OFFSET_CHANGE_ANIMATION);
  private capsuleTextShowAnimation: AnimationBase =
    new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_TEXT_SHOW_ANIMATION, true);
  private capsuleTextHideAnimation: AnimationBase =
    new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_TEXT_HIDE_ANIMATION, true);

  protected expandListDelayTime = 0;
  protected lastCapsuleAnimStartTime?: number;
  protected lastCapsuleStateMap: Map<string, LiveCapsuleCollapseAnimState> = new Map();
  protected lastCapsuleListWidth?: number;

  /**
   * 初始状态重置
   * @param delay
   * @param isInitCapsuleListWidth
   * @returns 是否重置记录的时间
   */
  protected setInitalCapsuleState(capsuleTransferParam?: CapsuleTransferParam): boolean {
    const now = Date.now();
    const capsuleListVm = this.vmInjector.getCapsuleListVm();
    const capsuleAnimStartTime = this.lastCapsuleAnimStartTime ?? 0;
    const delay = capsuleTransferParam?.delay ?? this.expandListDelayTime;
    const diff = now - capsuleAnimStartTime;

    log.showInfo(`diff time: ${diff}`);

    if (diff >= 0 && diff < delay) {
      const ratio = this.getCollapseRatio(diff);

      log.showWarn(`reset capsule list state before animate, last excute ratio: ${ratio}`);

      animateToImmediately({ duration: 0 }, () => {
        for (const live of capsuleListVm.liveList) {
          const capsuleVm = this.vmInjector.getCapsuleVm(live);
          if (live.isScreenRecorder() && capsuleVm.showType === CapsuleShowType.ROUND_CAKE) {
            // 录屏圆饼不需要重置
            continue;
          }

          const state = this.lastCapsuleStateMap.get(live.hashCode);
          if (!state) {
            // 未找到胶囊不需要重置
            continue;
          }

          if (capsuleVm.offsetX === 0) {
            // 动效后不显示的胶囊不进行重置
            continue;
          }

          log.info(`start reset capsule(${live.hashCode})`, state);

          this.setCollapseCapsuleState(capsuleVm, state, ratio);
        }

        if (this.lastCapsuleListWidth !== undefined) {
          const layoutVm = this.vmInjector.getCapsuleListLayoutVm();
          const gap = this.getCollapseCapsuleWidth() +
          LiveStyle.CAPSULE_LEFT_STATUS_BAR_GAP_WITHOUT_HOLE +
          LiveStyle.CAPSULE_STATUS_BAR_GAP_WITHOUT_HOLE;
          layoutVm.capsuleListWidth = this.lastCapsuleListWidth - (this.lastCapsuleListWidth - gap) * ratio;
        }
      });

      return false;
    }

    this.lastCapsuleStateMap = capsuleListVm.liveList.reduce((map, live) => {
      map.set(live.hashCode, this.getCapsuleCollapseState(live));
      return map;
    }, new Map<string, LiveCapsuleCollapseAnimState>());
    this.lastCapsuleListWidth = this.vmInjector.getCapsuleListLayoutVm().capsuleListWidth;
    log.showInfo(`lastCapsuleListWidth: ${this.lastCapsuleListWidth}`);
    return true;
  }

  protected abstract getCapsuleCollapseState(live: LiveNotification): LiveCapsuleCollapseAnimState;

  protected abstract getCollapseRatio(diff: number): number;

  protected getCollapseCapsuleWidth(): number {
    return LiveStyle.CAPSULE_CIRCLE_WIDTH;
  }

  protected setCollapseCapsuleState(
    capsuleVm: ILiveCapsuleVm, state: LiveCapsuleCollapseAnimState, ratio: number): void {
    capsuleVm.width = state.beforeWidth - (state.beforeWidth - state.afterWidth) * ratio;
    capsuleVm.offsetX = state.beforeOffsetX - (state.beforeOffsetX - state.afterOffsetX) * ratio;
  }

  /**
   *  更新胶囊的属性
   *
   * @param liveList 当前胶囊列表
   * @param updated 待更新的胶囊
   * @returns 更新Promise
   */
  protected async updateCapsuleAttribute(liveList: LiveNotification[], updatedLive?: LiveNotification): Promise<void> {
    const isNeedUpdateText = this.checkIsNeedUpdateCapsuleText(updatedLive);
    if (!updatedLive || !isNeedUpdateText) {
      this.updateCapsuleTextProperty(liveList);
      this.changeCapsuleWidthAndOffset(liveList);
      return;
    }
    this.changeCapsuleWidthAndOffset(liveList);
    if (updatedLive.isInstant()) {
      return this.updateInstantCapsuleTextContent(liveList, updatedLive);
    }
    return this.updateCapsuleTextContent(liveList, updatedLive);
  }

  private checkIsNeedUpdateCapsuleText(live?: LiveNotification): boolean {
    if (!live) {
      return false;
    }

    if (!live.isFromPush && !live.isInstant()) {
      return false;
    }

    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    if (capsuleVm.fixedShowType === CapsuleShowType.NONE) {
      return false;
    }
    if (!capsuleVm.isShow || !capsuleVm.isVisible) {
      return false;
    }

    // 赛事比分场景不走文本更新动效，避免和翻牌动效叠加
    if (capsuleVm.isScoreScene()) {
      return false;
    }

    /**
     * 进度类胶囊不走文本更新动效
     */
    if (live.capsule?.isProgress()) {
      return false;
    }

    if (live.capsule?.isTimer()) {
      return false;
    }

    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    if (capsuleMarqueeVm.getText() !== capsuleMarqueeVm.getText(live, capsuleVm.fixedShowType)) {
      return true;
    }
    if (capsuleMarqueeVm.isExtendShow &&
      capsuleMarqueeVm.getExtendText() !== capsuleMarqueeVm.getExtendText(live, capsuleVm.fixedShowType)) {
      return true;
    }
    return false;
  }

  private updateCapsuleTextProperty(liveList: LiveNotification[]) {
    for (const live of liveList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      if (!capsuleVm.isShow) {
        continue;
      }
      const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
      capsuleMarqueeVm.updateUIProperty();
      const cmds: AnimateParams[] = [{
        duration: 0,
        event: () => {
          capsuleMarqueeVm.isBuildScoreText = capsuleVm.isScoreScene(live);
          capsuleVm.isShowRightIcon = capsuleVm.fixedIsShowRightIcon;
        }
      }];
      this.capsuleWidthOffsetChangeAnimation.executeAnimation(cmds, 'changeMarqueeProperty');
      capsuleVm.isLayoutSupportExtendShow = capsuleVm.fixedIsLayoutSupportExtendShow;
    }
  }

  private async updateCapsuleTextContent(liveList: LiveNotification[],
    updatedLive: LiveNotification): Promise<void> {
    this.hideCapsuleText(updatedLive);
    await SystemUICommonUtil.sleep(CAPSULE_TEXT_SHOW_ANIMATION_TIME_INTERVAL);
    this.updateCapsuleTextProperty(liveList);
    this.vmInjector.updateVmByLive(updatedLive, TAG);
    return this.showCapsuleText(updatedLive);
  }

  private async updateInstantCapsuleTextContent(liveList: LiveNotification[],
    updatedLive: LiveNotification): Promise<void> {
    this.hideInstantCapsuleText(updatedLive);
    await SystemUICommonUtil.sleep(CAPSULE_TEXT_SHOW_ANIMATION_TIME_INTERVAL);
    this.updateCapsuleTextProperty(liveList);
    this.vmInjector.updateVmByLive(updatedLive, TAG);
    return this.showInstantCapsuleText(updatedLive);
  }

  private changeCapsuleWidthAndOffset(liveList: LiveNotification[]): Promise<void> {
    const cmds: AnimateParams[] = [];
    for (const live of liveList) {
      const capsule = this.vmInjector.getCapsuleVm(live);
      if (!capsule.isShow) {
        continue;
      }
      if (capsule.offsetX === capsule.fixedOffsetX && capsule.width === capsule.fixedWidth) {
        continue;
      }

      cmds.push({
        curve: CAPSULE_WIDTH_CHANGE_CURVE,
        event: () => {
          const capsule = this.vmInjector.getCapsuleVm(live);
          // 胶囊位移至原始位置
          capsule.offsetX = capsule.fixedOffsetX;
          // 胶囊宽度复原
          capsule.width = capsule.fixedWidth;
          capsule.updateLinearGradient();
        }
      });
    }

    if (!cmds.length) {
      return Promise.resolve();
    }
    const layoutVm = this.vmInjector.getCapsuleListLayoutVm();
    cmds.push({
      curve: CAPSULE_WIDTH_CHANGE_CURVE,
      event: () => {
        layoutVm.capsuleListWidth = layoutVm.capsuleListFixedWidth;
      }
    });
    return this.capsuleWidthOffsetChangeAnimation.executeAnimation(cmds, 'changeCapsuleWidthAndOffset');
  }

  async showCapsuleText(live: LiveNotification): Promise<void> {
    return this.capsuleTextShowAnimation.executeAnimation([{
      curve: CAPSULE_TEXT_SHOW_HIDE_CURVE,
      duration: CAPSULE_TEXT_SHOW_HIDE_DURATION,
      event: () => {
        const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
        capsuleMarqueeVm.scaleX = 1;
        capsuleMarqueeVm.scaleY = 1;
        capsuleMarqueeVm.opacity = 1;
        capsuleMarqueeVm.radius = 0;
        capsuleMarqueeVm.offsetX = 0;
      }
    }], 'showCapsuleText');
  }

  async hideCapsuleText(live: LiveNotification): Promise<void> {
    return this.capsuleTextHideAnimation.executeAnimation([{
      curve: CAPSULE_TEXT_SHOW_HIDE_CURVE,
      duration: CAPSULE_TEXT_SHOW_HIDE_DURATION,
      event: () => {
        // 更新胶囊内容时，生效隐藏老的文本内容
        const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
        capsuleMarqueeVm.scaleX = 0.8;
        capsuleMarqueeVm.scaleY = 0.8;
        capsuleMarqueeVm.opacity = 0;
        capsuleMarqueeVm.radius = 30;
        capsuleMarqueeVm.offsetX = capsuleMarqueeVm.fixedOffsetX;
      }
    }], 'hideCapsuleText');
  }

  async showInstantCapsuleText(live: LiveNotification): Promise<void> {
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    capsuleMarqueeVm.offsetX = capsuleMarqueeVm.needFixOffsetX;
    return this.capsuleTextShowAnimation.executeAnimation([{
      curve: CAPSULE_TEXT_SHOW_HIDE_CURVE,
      duration: INSTANT_CAPSULE_UPDATE_DURATION,
      event: () => {
        capsuleMarqueeVm.scaleX = 1;
        capsuleMarqueeVm.scaleY = 1;
        capsuleMarqueeVm.opacity = 1;
        capsuleMarqueeVm.radius = 0;
        capsuleMarqueeVm.offsetX = 0;
      }
    }], 'showInstantCapsuleText');
  }

  async hideInstantCapsuleText(live: LiveNotification): Promise<void> {
    return this.capsuleTextHideAnimation.executeAnimation([{
      curve: CAPSULE_TEXT_SHOW_HIDE_CURVE,
      duration: INSTANT_CAPSULE_UPDATE_DURATION,
      event: () => {
        // 更新胶囊内容时，生效隐藏老的文本内容
        const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
        capsuleMarqueeVm.scaleX = 0.8;
        capsuleMarqueeVm.scaleY = 0.8;
        capsuleMarqueeVm.opacity = 0;
        capsuleMarqueeVm.radius = 30;
        capsuleMarqueeVm.offsetX = capsuleMarqueeVm.fixedOffsetX;
      }
    }], 'hideInstantCapsuleText');
  }

  abstract setCapsuleTransferState(capsuleTransferParam?: CapsuleTransferParam | undefined): void;

  abstract collapseCapsuleList(capsuleTransferParam?: CapsuleTransferParam | undefined,
    conflict?: boolean): Promise<void>;

  abstract expandCapsuleList(capsuleTransferParam?: CapsuleTransferParam | undefined): Promise<void>;

  abstract setCapsuleListFinalState(capsuleTransferParam?: CapsuleTransferParam | undefined): Promise<void>;

  abstract updateCapsuleWidthAndOffset(liveList: LiveNotification[],
    live?: LiveNotification | undefined): Promise<void>;

  abstract expandLightWave(capsuleTransferParam?: CapsuleTransferParam | undefined): Promise<void>;

}
