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
import { LiveNotification } from '../model/LiveNotification';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveStyle } from '../constants/LiveStyle';
import curves from '@ohos.curves';
import { LiveCapsuleCollapseAnimState, LiveCapsuleListAnimBaseVm } from './LiveCapsuleListAnimBaseVm';
import { CapsuleTransferParam } from '../interface/ILiveCapsuleListVm';
import { AnimateParams, AnimationBase } from '../../animation/AnimationBase';
import { ResourceVm } from '../../vm/ResourceVm';
import { LiveHiSysEvent } from '../sysEvent/LiveHiSysEvent';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';
import { ILiveCapsuleVm } from '../interface/ILiveCapsuleVm';
import { CapsuleShowType } from '../model/LiveCommonModel';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'LiveCapsuleListWithoutHoleAnimVm');

/**
 * 胶囊出现和收回动效曲线
 */
const CAPSULE_EXPAND_CURVE = curves.springMotion(0.513, 0.69);
const CAPSULE_COLLAPSE_CURVE = Curve.Linear;

const ANIMATION_DURATION = 300;
const ANIMATION_DURATION_FAST = 160;

// 圆饼+gap
const CAPSULE_GAP = 34;

export interface State {
  width: number;
  offsetX: number;
  // 缩放目标宽度
  collapseWidth: number;
  // 缩放目标位移
  collapseOffsetX: number;
}

export class LiveCapsuleListWithoutHoleAnimVm extends LiveCapsuleListAnimBaseVm {
  public expandListDelayTime: number = 150;

  async setCapsuleListFinalState(capsuleTransferParam?: CapsuleTransferParam): Promise<void> {
    const isResetTime = this.setInitalCapsuleState(capsuleTransferParam);
    this.collapseCapsuleList(capsuleTransferParam);
    this.setCapsuleTransferState(capsuleTransferParam);
    const promise = Promise.all([
      this.expandCapsuleList(capsuleTransferParam),
      SystemUICommonUtil.sleep(333),
    ]);

    if (isResetTime) {
      log.showInfo('reset capsule list start time.');
      this.lastCapsuleAnimStartTime = Date.now();
    }

    await promise;
  }

  async collapseCapsuleList(capsuleTransferParam?: CapsuleTransferParam): Promise<void> {
    const collapseAnimation: AnimationBase =
      new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_COLLAPSE_ANIMATION_WITHOUT_HOLE);
    const cmds: AnimateParams[] = [];
    const showCapsuleList: LiveNotification[] = [...this.vmInjector.getCapsuleListVm().liveList];

    for (const live of showCapsuleList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      log.showInfo(`collapse list: ${live.hashCode}-${capsuleVm.isRemindShow}-offsetx:${capsuleVm.offsetX}`);

      // 胶囊初始状态设置
      this.initHiddenCapsule(capsuleVm, collapseAnimation);

      // 当前与动效后都未显示的胶囊不做动效
      if (capsuleVm.scaleX === 0 && capsuleVm.scaleY === 0 && !capsuleVm.isShow) {
        continue;
      }

      if (capsuleVm.isRemindShow) {
        cmds.push(...this.collapseRemindCapsule(live, capsuleTransferParam));
      } else {
        cmds.push(...this.collapseOtherCapsule(live, capsuleTransferParam));
      }
    }

    // 更新capsuleList组件的宽度，触发通知图标跟随移动动效
    const layoutVm = this.vmInjector.getCapsuleListLayoutVm();
    cmds.push({
      curve: CAPSULE_COLLAPSE_CURVE,
      duration: ANIMATION_DURATION_FAST,
      event: () => {
        layoutVm.capsuleListWidth =  this.getCollapseCapsuleWidth() +
          this.getCapsuleCollapseOffset() +
          LiveStyle.CAPSULE_STATUS_BAR_GAP_WITHOUT_HOLE;
      }
    });

    await collapseAnimation.executeAnimation(cmds, 'collapseCapsuleListWithoutHole');
  }

  async expandCapsuleList(capsuleTransferParam?: CapsuleTransferParam): Promise<void> {
    const expandAnimation: AnimationBase =
      new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_EXPAND_ANIMATION_WITHOUT_HOLE);
    const delay = capsuleTransferParam?.delay ?? this.expandListDelayTime;
    const cmds: AnimateParams[] = [];

    log.showInfo(`expand capsule list: delay-${capsuleTransferParam?.delay} ${delay}`);

    for (const live of this.vmInjector.getCapsuleListVm().liveList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
      if (!capsuleVm.isShow) {
        cmds.push({
          curve: Curve.Linear,
          duration: 90,
          delay: delay,
          event: () => {
            capsuleVm.scaleX = 0;
            capsuleVm.scaleY = 0;
            capsuleMarqueeVm.isBuildScoreText = capsuleVm.isScoreScene(live);
          }
        });
        continue;
      }

      if (capsuleVm.isRemindShow) {
        cmds.push(...this.expandRemindCapsule(live, delay));
      } else {
        cmds.push(...this.expandOtherCapsule(live, capsuleTransferParam));
      }

      LiveHiSysEvent.reportCapsuleShow(live);
    }

    // 更新capsuleList组件的宽度，触发通知图标跟随移动动效
    const layoutVm = this.vmInjector.getCapsuleListLayoutVm();
    cmds.push({
      curve: CAPSULE_EXPAND_CURVE,
      delay: delay,
      event: () => {
        layoutVm.capsuleListWidth =  layoutVm.capsuleListFixedWidth;
      }
    });

    if (!cmds.length) {
      return;
    }
    await expandAnimation.executeAnimation(cmds, 'expandCapsuleList');
  }

  public setCapsuleTransferState(capsuleTransferParam?: CapsuleTransferParam): void {
    const transferAnimation: AnimationBase =
      new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_TRANS_ANIMATION_WITHOUT_HOLE);

    const cmds: AnimateParams[] = this.setCapsuleTransferStateToAnchor(capsuleTransferParam);
    transferAnimation.executeAnimation(cmds, 'setCapsuleTransferStateWithoutHole');
  }

  protected getCapsuleCollapseState(live: LiveNotification): LiveCapsuleCollapseAnimState {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);

    return {
      beforeWidth: capsuleVm.width,
      beforeOffsetX: capsuleVm.offsetX,
      afterWidth: this.getCollapseCapsuleWidth(),
      afterOffsetX: this.getCapsuleCollapseOffset(),
      beforeScale: capsuleVm.scaleX,
      afterScale: 1,
    };
  }

  protected getCollapseRatio(diff: number): number {
    return diff / ANIMATION_DURATION_FAST;
  }

  protected getCapsuleCollapseOffset(): number {
    return LiveStyle.CAPSULE_LEFT_STATUS_BAR_GAP_WITHOUT_HOLE;
  }

  protected setCollapseCapsuleState(
    capsuleVm: ILiveCapsuleVm, state: LiveCapsuleCollapseAnimState, ratio: number): void {
    super.setCollapseCapsuleState(capsuleVm, state, ratio);

    // 重置收回时胶囊缩放
    const beforeScale = state.beforeScale ?? 1;
    const afterScale = state.afterScale ?? 1;
    const scale = beforeScale - (beforeScale - afterScale) * ratio;
    capsuleVm.scaleX = scale;
    capsuleVm.scaleY = scale;
  }

  protected initHiddenCapsule(capsuleVm: ILiveCapsuleVm, collapseAnimation: AnimationBase): void {
    if (capsuleVm.opacity === 0) {
      collapseAnimation.setInitialState(() => {
        capsuleVm.width = this.getCollapseCapsuleWidth();
        capsuleVm.offsetX = this.getCapsuleCollapseOffset();
        capsuleVm.offsetY = 0;
        capsuleVm.scaleX = 0;
        capsuleVm.scaleY = 0;
        capsuleVm.blur = 0;
        capsuleVm.contentOpacity = 0;
        capsuleVm.contentScaleX = this.getCollapseCapsuleWidth() / capsuleVm.fixedWidth;
        capsuleVm.contentScaleY = this.getCollapseCapsuleWidth() / capsuleVm.fixedWidth;
        capsuleVm.backgroundColor = 'rgba(0, 0, 0, 1)';
        capsuleVm.opacity = 1;
      });
    }
  }

  private setCapsuleTransferStateToAnchor(capsuleTransferParam?: CapsuleTransferParam): AnimateParams[] {
    const delay = capsuleTransferParam?.delay ?? this.expandListDelayTime;
    const cmds: AnimateParams[] = [];
    for (const live of this.vmInjector.getCapsuleListVm().liveList) {
      const capsule = this.vmInjector.getCapsuleVm(live);
      const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
      const lightWaveVm = this.vmInjector.getCapsuleLightWaveVm(live);

      if (capsule.isShow) {
        cmds.push({
          duration: 1,
          delay: delay,
          event: () => {
            const isShadow = capsule.fixedShowType === CapsuleShowType.SHADOW;
            const isRoundCake = capsule.fixedShowType === CapsuleShowType.ROUND_CAKE;

            capsule.showType = capsule.fixedShowType;
            capsule.zIndex = LiveStyle.CAPSULE_INDEX;
            capsule.isRemindShow = live.isInstant()
              ? !capsule.isShowed
              : this.vmInjector.getLiveRemindVm().isCurrentRemindCapsule(live);
            capsule.isShowed = true;
            capsule.contentScaleX = this.getCollapseCapsuleWidth() / capsule.fixedWidth;
            capsule.contentScaleY = this.getCollapseCapsuleWidth() / capsule.fixedWidth;
            capsuleMarqueeVm.isMarqueeEnabled = false;
            capsuleMarqueeVm.isExtendTextMarqueeEnabled = false;
            capsuleMarqueeVm.isBuildScoreText = capsule.isScoreScene(live);
            capsule.isShowRightIcon = capsule.fixedIsShowRightIcon;

            if (isRoundCake) {
              capsule.zIndex = LiveStyle.CAPSULE_ROUND_CAKE_INDEX;
            }

            if (isShadow) {
              capsule.zIndex = LiveStyle.CAPSULE_LOW_INDEX;
            }
          }
        });
      } else {
        cmds.push({
          duration: 1,
          delay: delay,
          event: () => {
            capsule.zIndex = LiveStyle.CAPSULE_LOW_INDEX;
            capsule.isRemindShow = false;
            lightWaveVm.setAnimFinishState();
          }
        });
      }

      if (capsuleTransferParam?.isUpdateImmediately === false) {
        cmds.push({
          duration: 1,
          delay: delay + 50, // 等跑马灯文字上树后再更新跑马灯文字属性
          event: () => {
            capsuleMarqueeVm.updateUIProperty();
          }
        })
      }
    }
    return cmds;
  }

  /**
   *  更新胶囊的宽度和位移
   *
   * @param liveList 当前胶囊列表
   * @param live 待更新内容的胶囊
   * @returns
   */
  async updateCapsuleWidthAndOffset(liveList: LiveNotification[], live?: LiveNotification): Promise<void> {
    await this.updateCapsuleAttribute(liveList, live);
  }

  /**
   * 收起其他胶囊
   * @param live
   * @returns
   */
  private collapseOtherCapsule(live: LiveNotification, capsuleTransferParam?: CapsuleTransferParam):
    AnimateParams[] {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    const cmds: AnimateParams[] = [];

    cmds.push({
      curve: CAPSULE_COLLAPSE_CURVE,
      duration: ANIMATION_DURATION_FAST,
      event: () => {
        capsuleVm.disableOutline = true;

        capsuleVm.contentScaleX = this.getCollapseCapsuleWidth() / capsuleVm.width;
        capsuleVm.contentScaleY = this.getCollapseCapsuleWidth() / capsuleVm.width;
        capsuleVm.width = this.getCollapseCapsuleWidth();
        capsuleVm.offsetX = this.getCapsuleCollapseOffset();
        capsuleVm.contentOpacity = 0;
        capsuleVm.backgroundColor = 'rgba(0, 0, 0, 1)';
        capsuleVm.scaleX = 1;
        capsuleVm.scaleY = 1;
        capsuleMarqueeVm.radius = 30;
        this.setCollapseCapsuleScale(capsuleVm);
      }
    })

    return cmds;
  }

  private collapseRemindCapsule(live: LiveNotification, capsuleTransferParam?: CapsuleTransferParam): AnimateParams[] {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    const cmds: AnimateParams[] = [];

    cmds.push({
      curve: CAPSULE_COLLAPSE_CURVE,
      duration: ANIMATION_DURATION_FAST,
      event: () => {
        capsuleVm.disableOutline = true;

        // 胶囊动效
        capsuleVm.contentScaleX = this.getCollapseCapsuleWidth() / capsuleVm.width;
        capsuleVm.contentScaleY = this.getCollapseCapsuleWidth() / capsuleVm.width;
        capsuleVm.width = this.getCollapseCapsuleWidth();
        capsuleVm.offsetX = this.getCapsuleCollapseOffset();
        capsuleVm.contentOpacity = 0;
        capsuleVm.backgroundColor = 'rgba(0, 0, 0, 1)';
        capsuleVm.scaleX = 1;
        capsuleVm.scaleY = 1;
        capsuleMarqueeVm.radius = 30;
        this.setCollapseCapsuleScale(capsuleVm);
      }
    });

    return cmds;
  }

  async expandLightWave(capsuleTransferParam?: CapsuleTransferParam): Promise<void> {
    const delay = capsuleTransferParam?.delay ?? this.expandListDelayTime;
    // 避免扫光动画在setTransfer中被打断
    await SystemUICommonUtil.sleep(delay + 200);
    const lightAnimation: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_CAPSULE_LIGHT_ANIMATION, true);
    let cmds: AnimateParams[] = [];
    for (const live of this.vmInjector.getCapsuleListVm().liveList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      if (!capsuleVm.isShow) {
        continue;
      }
      const lightWaveVm = this.vmInjector.getCapsuleLightWaveVm(live);
      if (lightWaveVm.lightShow) {
        const OUT_DISTANCE = -30;
        let endPosition = ResourceVm.instance.isRTL ? OUT_DISTANCE : capsuleVm.fixedWidth;
        let startPosition = ResourceVm.instance.isRTL ? capsuleVm.fixedWidth : OUT_DISTANCE;
        lightWaveVm.setAnimStartState(startPosition);
        const waveAnimation = lightWaveVm.doWaveAnim(0, endPosition);
        for (let param of waveAnimation) {
          cmds.push(param);
        }
      }
    }
    if (!cmds.length) {
      return;
    }
    await lightAnimation.executeAnimation(cmds, 'expandCapsuleLight');
  }

  /**
   * 显示其他胶囊
   * @param live
   * @returns
   */
  private expandOtherCapsule(live: LiveNotification, capsuleTransferParam?: CapsuleTransferParam): AnimateParams[] {
    const delay = capsuleTransferParam?.delay ?? this.expandListDelayTime;
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    const cmds: AnimateParams[] = [];

    cmds.push(
      {
        curve: CAPSULE_EXPAND_CURVE,
        delay: delay,
        event: () => {
          // 胶囊位移至原始位置
          capsuleVm.offsetX = capsuleVm.fixedOffsetX;
          capsuleVm.width = capsuleVm.fixedWidth;

          capsuleVm.backgroundColor = undefined;
          capsuleVm.scaleX = 1;
          capsuleVm.scaleY = 1;

          capsuleVm.contentOpacity = 1;
          capsuleVm.contentScaleX = 1;
          capsuleVm.contentScaleY = 1;
          capsuleVm.disableOutline = false;
          this.setExpandCapsuleScale(capsuleVm);
        }
      },
      {
        curve: Curve.Linear,
        delay: delay,
        duration: ANIMATION_DURATION,
        event: () => {
          capsuleMarqueeVm.radius = 0;
        }
      }
    );

    return cmds;
  }

  /**
   * 显示抢占态胶囊
   * @param live
   * @returns
   */
  private expandRemindCapsule(live: LiveNotification, delay: number): AnimateParams[] {
    let animateParams: AnimateParams[] = [];
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    animateParams.push(
      {
        curve: Curve.Linear,
        delay: delay,
        duration: ANIMATION_DURATION,
        event: () => {
          capsuleMarqueeVm.radius = 0;
        }
      },
      {
        curve: CAPSULE_EXPAND_CURVE,
        delay: delay,
        event: () => {
          // 胶囊位移至原始位置
          capsuleVm.width = capsuleVm.fixedWidth;
          capsuleVm.offsetX = capsuleVm.fixedOffsetX;

          capsuleVm.backgroundColor = undefined;
          capsuleVm.scaleX = 1;
          capsuleVm.scaleY = 1;

          capsuleVm.contentOpacity = 1;
          capsuleVm.contentScaleX = 1;
          capsuleVm.contentScaleY = 1;
          capsuleVm.disableOutline = false;
          this.setExpandCapsuleScale(capsuleVm);
        }
      }
    );
    return animateParams;
  }

  /**
   * 获取动效中转初始值，需要一定差值diff才可执行动效
   * @param value
   * @param diff
   * @returns
   */
  protected getTransferState(value: number, diff: number = 0.01): number {
    return value + diff;
  }

  protected getCollapseCapsuleWidth(): number {
    return this.getTransferState(LiveStyle.CAPSULE_CIRCLE_WIDTH);
  }

  protected getOpacityAnimExtraDelay(): number {
    return 60;
  }

  protected setCollapseCapsuleScale(capsuleVm: ILiveCapsuleVm): void {

  }

  protected setExpandCapsuleScale(capsuleVm: ILiveCapsuleVm): void {

  }
}