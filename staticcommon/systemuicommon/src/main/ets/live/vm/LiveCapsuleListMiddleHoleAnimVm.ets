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

import curves from '@ohos.curves';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AnimateParams, AnimationBase } from '../../animation/AnimationBase';
import { LiveStyle } from '../constants/LiveStyle';
import { CapsuleShowType } from '../model/LiveCommonModel';
import { LiveNotification } from '../model/LiveNotification';
import { LiveCapsuleListAnimBaseVm, LiveCapsuleCollapseAnimState } from './LiveCapsuleListAnimBaseVm';
import { CapsuleTransferParam } from '../interface/ILiveCapsuleListVm';
import { ResourceVm } from '../../vm/ResourceVm';
import { LiveHiSysEvent } from '../sysEvent/LiveHiSysEvent';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';
import { ILiveCapsuleVm } from '../interface/ILiveCapsuleVm';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { CurveUtil } from '../../utils/CurveUtil';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'LiveCapsuleListMiddleHoleAnimVm');

/**
 * 胶囊出现和收回动效曲线
 */
const CAPSULE_CURVE = curves.interpolatingSpring(0, 1, 247, 25);

@ObservedV2
export class LiveCapsuleListMiddleHoleAnimVm extends LiveCapsuleListAnimBaseVm {
  public expandListDelayTime: number = LiveStyle.METABALL_HIGHEST_DURATION + 34;
  public cutoutVm = CutoutVm.instance;

  // 根据挖孔位置计算胶囊上顶位移，防止上移超出屏幕顶或物理挖孔下端
  @Trace public maxOffsetY: number =
    -Math.min(((this.cutoutVm.holes[0]?.centerY ?? 0) - LiveStyle.CAPSULE_HEIGHT * 1.15 / 2) * 0.75,
      LiveStyle.CAPSULE_HEIGHT * (this.cutoutVm.holeNum === 2 ? 1.15 : 1) / 2 - (this.cutoutVm.holes[0]?.radius ?? 0));

  public async setCapsuleListFinalState(capsuleTransferParam?: CapsuleTransferParam): Promise<void> {
    const isResetTime = this.setInitalCapsuleState(capsuleTransferParam);
    this.collapseCapsuleList(capsuleTransferParam, !isResetTime);
    this.setCapsuleTransferState(capsuleTransferParam);
    const promise = Promise.all([
      this.expandCapsuleList(capsuleTransferParam),
      SystemUICommonUtil.sleep(LiveStyle.METABALL_HIGHEST_DURATION),
    ]);

    if (isResetTime) {
      log.showInfo('reset capsule list start time.');
      this.lastCapsuleAnimStartTime = Date.now();
    }

    await promise;
  }

  public async collapseCapsuleList(capsuleTransferParam?: CapsuleTransferParam, conflict?: boolean): Promise<void> {
    const collapseAnimation: AnimationBase = new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_COLLAPSE_ANIMATION);
    const isUpwards = capsuleTransferParam?.isUpwards ?? false;
    const cmds: AnimateParams[] = [];
    for (const live of this.vmInjector.getCapsuleListVm().liveList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      if (capsuleVm.offsetX === 0) {
        continue;
      }
      if (capsuleVm.isRemindShow) {
        cmds.push(...this.collapseRemindCapsule(live));
      } else {
        cmds.push(...this.collapseOtherCapsule(live, isUpwards, conflict ?? false));
      }
    }

    await collapseAnimation.executeAnimation(cmds, 'collapseCapsuleList');
  }

  public setCapsuleTransferState(capsuleTransferParam?: CapsuleTransferParam): void {
    const transferAnimation: AnimationBase = new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_TRANS_ANIMATION);
    const delay = capsuleTransferParam?.delay ?? this.expandListDelayTime;
    const isUpwards = capsuleTransferParam?.isUpwards ?? false;
    const cmds: AnimateParams[] = [];
    for (const live of this.vmInjector.getCapsuleListVm().liveList) {
      const capsule = this.vmInjector.getCapsuleVm(live);
      const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
      cmds.push({
        duration: 1,
        delay: delay,
        event: () => {
          capsuleMarqueeVm.isRunning = false;
          capsuleMarqueeVm.isExtendRunning = false;
          if (capsule.isShow) {
            capsule.showType = capsule.fixedShowType;
            capsule.updateLinearGradient();
            capsuleMarqueeVm.radius = 0;

            // 设置动效初始状态
            if (live.isScreenRecorder() && capsule.showType === CapsuleShowType.ROUND_CAKE) {
              this.setRecordCapsuleState(capsule);
            } else if (capsule.showType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
              this.setHangingCapsuleState(capsule, isUpwards);
            } else {
              this.setOtherCapsuleState(capsule, isUpwards);
            }

            // 更新抢占标志
            if (live.isInstant()) {
              capsule.isRemindShow = !capsule.isShowed;
            } else {
              capsule.isRemindShow = this.vmInjector.getLiveRemindVm().isCurrentRemindCapsule(live);
            }

            // 更新显示状态
            capsule.setCakeShowVal();
            capsule.isShowed = true;
            capsuleMarqueeVm.isMarqueeEnabled = false;
            capsuleMarqueeVm.isExtendTextMarqueeEnabled = false;
            capsuleMarqueeVm.isBuildScoreText = capsule.isScoreScene(live);
            capsule.isShowRightIcon = capsule.fixedIsShowRightIcon;
          } else {
            capsule.width = this.vmInjector.getCapsuleListVm().position.width;
            capsule.offsetX = 0;
            capsule.scaleX = 1;
            capsule.scaleY = 1;
            capsule.opacity = 0;
            capsule.zIndex = LiveStyle.CAPSULE_LOW_INDEX;
            capsule.isRemindShow = false;
          }
        }
      });
      if (capsuleTransferParam?.isUpdateImmediately === false) {
        cmds.push({
          duration: 1,
          delay: delay + 50,
          event: () => {
            capsuleMarqueeVm.updateUIProperty();
          }
        })
      }
    }

    transferAnimation.executeAnimation(cmds, 'setCapsuleTransferState');
  }

  protected getCapsuleCollapseState(live: LiveNotification): LiveCapsuleCollapseAnimState {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    const capsulePositionWidth = this.vmInjector.getCapsuleListVm().position.width;
    const isCircle = capsuleVm.showType === CapsuleShowType.ROUND_CAKE ||
      capsuleVm.showType === CapsuleShowType.SHADOW;

    return {
      beforeWidth: capsuleVm.width,
      beforeOffsetX: capsuleVm.offsetX,
      afterWidth: isCircle ? LiveStyle.CAPSULE_CIRCLE_WIDTH : capsulePositionWidth,
      afterOffsetX: isCircle ? capsulePositionWidth - LiveStyle.CAPSULE_CIRCLE_WIDTH : 0,
    };
  }

  protected getCollapseRatio(diff: number): number {
    return CurveUtil.getSpringProgress({ mass: 1, stiffness: 247, damping: 25 }, diff / 1000) / 100
  }

  private setRecordCapsuleState(capsule: ILiveCapsuleVm): void {
    capsule.width = capsule.fixedWidth;
    capsule.offsetX = capsule.fixedOffsetX;
    capsule.opacity = this.getTransferState(0);
    capsule.scaleX = this.getTransferState(0);
    capsule.scaleY = this.getTransferState(0);
    capsule.offsetY = 0;
    capsule.blur = 15;
    capsule.zIndex = LiveStyle.CAPSULE_INDEX;
    capsule.contentScaleX = 1;
    capsule.contentScaleY = 1;
    capsule.contentOpacity = 1;
    capsule.disableOutline = false;
    capsule.backgroundColor = LiveStyle.CAPSULE_BACKGROUND_COLOR;
  }

  private setHangingCapsuleState(capsule: ILiveCapsuleVm, isUpwards: boolean): void {
    const capsulePositionWidth = this.vmInjector.getCapsuleListVm().position.width;
    // 胶囊内容缩小为挖孔区宽度与计算的展开宽度的比值，使展开时内容和底板速度一致
    capsule.contentScaleX = capsulePositionWidth / capsule.fixedWidth;
    capsule.contentScaleY = capsulePositionWidth / capsule.fixedWidth;
    capsule.width = this.getTransferState(capsulePositionWidth, -1);
    capsule.offsetX = this.getTransferState(LiveStyle.CAPSULE_TRANSFER_OFFSET, -1);
    capsule.opacity = 1;
    capsule.scaleX = 1;
    // 融球高度从1.15倍缩小到1.1倍时胶囊出现
    capsule.scaleY = 1.1;
    capsule.offsetY = 0;
    capsule.blur = 0;
    capsule.zIndex = LiveStyle.CAPSULE_INDEX;
    capsule.contentOpacity = this.getTransferState(0);
    capsule.backgroundColor = 'rgba(0, 0, 0, 0.99)';
    capsule.disableOutline = false;
    if (isUpwards) {
      capsule.offsetY = this.getTransferState(this.maxOffsetY);
    }
  }

  private setOtherCapsuleState(capsule: ILiveCapsuleVm, isUpwards: boolean): void {
    const isRoundCake = capsule.showType === CapsuleShowType.ROUND_CAKE;
    const isShadow = capsule.showType === CapsuleShowType.SHADOW;
    const capsulePositionWidth = this.vmInjector.getCapsuleListVm().position.width;

    // 胶囊内容缩小为挖孔区宽度与计算的展开宽度的比值，使展开时内容和底板速度一致
    capsule.contentScaleX = capsulePositionWidth / capsule.fixedWidth;
    capsule.contentScaleY = capsulePositionWidth / capsule.fixedWidth;
    capsule.width = this.getTransferState(capsulePositionWidth, -1);
    capsule.offsetX = this.getTransferState(LiveStyle.CAPSULE_TRANSFER_OFFSET, -1);
    capsule.scaleX = 1;
    // 单任务融球高度从1.15倍缩小到1.1倍时胶囊出现，多任务缩小到1.05倍时胶囊出现
    capsule.scaleY = this.vmInjector.getCapsuleListVm().getShowCapsuleListNum() > 1 ? 1.05 : 1.1;
    capsule.offsetY = 0;
    capsule.opacity = 1;
    capsule.zIndex = LiveStyle.CAPSULE_INDEX;
    capsule.contentOpacity = this.getTransferState(0);
    capsule.backgroundColor = 'rgba(0, 0, 0, 0.99)';
    capsule.disableOutline = this.vmInjector.getCapsuleListVm().getShowCapsuleListNum(true) > 1;
    capsule.blur = 0;
    if (isUpwards) {
      capsule.offsetY = this.getTransferState(this.maxOffsetY);
    }

    if (isRoundCake) {
      capsule.width = this.getTransferState(LiveStyle.CAPSULE_CIRCLE_WIDTH, -1);
      capsule.offsetX = this.getTransferState(capsulePositionWidth - LiveStyle.CAPSULE_CIRCLE_WIDTH, -1);
      capsule.scaleX = this.getTransferState(0);
      capsule.scaleY = this.getTransferState(0);
      capsule.contentScaleX = this.getTransferState(0);
      capsule.contentScaleY = this.getTransferState(0);
      capsule.opacity = 0;
      capsule.zIndex = LiveStyle.CAPSULE_ROUND_CAKE_INDEX;
    }

    if (isShadow) {
      capsule.width = this.getTransferState(LiveStyle.CAPSULE_CIRCLE_WIDTH, -1);
      capsule.offsetX = this.getTransferState(capsulePositionWidth - LiveStyle.CAPSULE_CIRCLE_WIDTH, -1);
      capsule.opacity = 0;
      capsule.zIndex = LiveStyle.CAPSULE_LOW_INDEX;
    }
  }

  public async expandCapsuleList(capsuleTransferParam?: CapsuleTransferParam): Promise<void> {
    const expandAnimation: AnimationBase = new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_EXPAND_ANIMATION);
    const delay = capsuleTransferParam?.delay ?? this.expandListDelayTime;
    const isUpwards = capsuleTransferParam?.isUpwards ?? false;
    const cmds: AnimateParams[] = [];
    for (const live of this.vmInjector.getCapsuleListVm().liveList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      if (!capsuleVm.isShow) {
        continue;
      }
      if (capsuleVm.isRemindShow) {
        cmds.push(...this.expandRemindCapsule(live, delay));
      } else {
        cmds.push(...this.expandOtherCapsule(live, delay, isUpwards));
      }
      LiveHiSysEvent.reportCapsuleShow(live);
    }

    if (!cmds.length) {
      return;
    }
    await expandAnimation.executeAnimation(cmds, 'expandCapsuleList');
  }

  /**
   * 胶囊边框扫光
   * @param capsuleTransferParam
   * @returns
   */
  async expandLightWave(capsuleTransferParam?: CapsuleTransferParam): Promise<void> {
    const delay = capsuleTransferParam?.delay ?? this.expandListDelayTime;
    // 避免扫光动画在setTransfer中被打断
    await SystemUICommonUtil.sleep(delay + 100);
    const lightAnimation: AnimationBase = new AnimationBase(AnimationBase.NAMES.LIVE_CAPSULE_LIGHT_ANIMATION, true);
    let cmds: AnimateParams[] = [];
    for (const live of this.vmInjector.getCapsuleListVm().liveList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      if (!capsuleVm.isShow) {
        continue;
      }
      const lightWaveVm = this.vmInjector.getCapsuleLightWaveVm(live);
      const rightWaveVm = this.vmInjector.getCapsuleRightLightWaveVm(live);
      if (capsuleTransferParam?.isNeedLight &&
        (capsuleVm.showType === CapsuleShowType.HANGING_HOLE ||
          capsuleVm.showType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) ||
      capsuleVm.isRemindShow) {
        lightWaveVm.lightShow = true;
        rightWaveVm.lightShow = capsuleVm.showType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED;
      }
      if (capsuleVm.fixedWidth <= LiveStyle.CAPSULE_CIRCLE_WIDTH) {
        lightWaveVm.lightShow = false;
        rightWaveVm.lightShow = false;
      }
      if (lightWaveVm.lightShow) {
        const OUT_DISTANCE = -36;
        // 单侧扫光
        if (capsuleVm.showType !== CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
          let startPosition = ResourceVm.instance.isRTL ? OUT_DISTANCE : capsuleVm.fixedWidth - 50;
          let endPosition = ResourceVm.instance.isRTL ? capsuleVm.fixedWidth : OUT_DISTANCE;
          lightWaveVm.setAnimStartState(startPosition);
          const waveAnimation = lightWaveVm.doWaveAnim(0, endPosition);
          for (let param of waveAnimation) {
            cmds.push(param);
          }
          log.showInfo(`expandLightWave only left start anim`)
        } else {
          // 双边扫光
          rightWaveVm.lightShow = true;
          const leftCapsuleWidth = Math.abs(capsuleVm.fixedOffsetX);
          const rightCapsuleWidth = capsuleVm.fixedWidth - Math.abs(capsuleVm.fixedOffsetX);
          let startPosition =
            ResourceVm.instance.isRTL ? rightCapsuleWidth - this.vmInjector.getCapsuleListVm().position.width / 2 - 14 :
              leftCapsuleWidth + (this.vmInjector.getCapsuleListVm().position.width - 28) / 2 - 9;
          let leftEndPosition = OUT_DISTANCE;
          let rightEndPosition = capsuleVm.fixedWidth;
          lightWaveVm.setAnimStartState(startPosition);
          const waveAnimation = lightWaveVm.doWaveAnim(0, leftEndPosition);
          for (let param of waveAnimation) {
            cmds.push(param);
          }
          rightWaveVm.setAnimStartState(startPosition);
          const rightWaveAnimation = rightWaveVm.doWaveAnim(0, rightEndPosition);
          for (let param of rightWaveAnimation) {
            cmds.push(param);
          }
          log.showInfo(`expandLightWave double direction start anim`)
        }
      }
    }
    if (!cmds.length) {
      return;
    }
    await lightAnimation.executeAnimation(cmds, 'expandCapsuleLight');
  }

  /**
   * 收起其他胶囊
   * @param live
   * @returns
   */
  private collapseOtherCapsule(live: LiveNotification, isUpwards: boolean, conflict: boolean): AnimateParams[] {
    const capsule = this.vmInjector.getCapsuleVm(live);
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    const isRoundCake = capsule.showType === CapsuleShowType.ROUND_CAKE;
    const isShadow = capsule.showType === CapsuleShowType.SHADOW;
    const isMultipleCapsules = this.vmInjector.getCapsuleListVm().getShowCapsuleListNum(true) > 1;
    const capsulePositionWidth = this.vmInjector.getCapsuleListVm().position.width;
    const animateParams: AnimateParams[] = [];
    if (live.isScreenRecorder() && capsule.showType === CapsuleShowType.ROUND_CAKE) {
      return [
        {
          curve: curves.springMotion(0.3, 1),
          event: () => {
            capsule.scaleX = 0;
            capsule.scaleY = 0;
            capsule.opacity = 0;
          }
        },
        {
          curve: Curve.Linear,
          duration: 50,
          event: () => {
            capsule.blur = 15;
          }
        }
      ];
    }

    if (capsule.showType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
      animateParams.push(
        {
          curve: CAPSULE_CURVE,
          event: () => {
            // 胶囊内容缩小为挖孔区宽度与收起前宽度的比值，使收起时内容和底板速度一致
            capsule.contentScaleX = capsulePositionWidth / capsule.width;
            capsule.contentScaleY = capsulePositionWidth / capsule.width;
            // 胶囊隐藏至锚点
            capsule.offsetX = 0;
            // 胶囊缩小到挖孔区宽度
            capsule.width = capsulePositionWidth;
            // 胶囊适配融球高度变化（融球最高放大到1.15倍）
            capsule.scaleY = 1.15;
            if (isUpwards) {
              capsule.offsetY = this.maxOffsetY;
            }
          }
        },
        {
          curve: Curve.Linear,
          duration: 180,
          event: () => {
            // 内容渐隐
            capsule.contentOpacity = 0;
            // 胶囊背板颜色变黑
            capsule.backgroundColor = 'rgba(0, 0, 0, 1)';
          }
        },
        {
          curve: Curve.Linear,
          duration: 1,
          delay: LiveStyle.METABALL_HIGHEST_DURATION,
          event: () => {
            capsule.opacity = 0;
          }
        }
      );
      if (capsule.disableOutline !== isMultipleCapsules) {
        animateParams.push({
          curve: Curve.Linear,
          duration: 60,
          delay: 120,
          event: () => {
            capsule.disableOutline = isMultipleCapsules;
          }
        });
      }
      return animateParams;
    }

    animateParams.push(
      {
        curve: CAPSULE_CURVE,
        event: () => {
          // 胶囊隐藏至锚点
          capsule.offsetX = 0;
          // 胶囊缩小到挖孔区宽度
          capsule.width = capsulePositionWidth;
          capsule.scaleY = 1.15;
          capsule.contentScaleX = 0;
          capsule.contentScaleY = 0;
          // 圆饼胶囊整体缩小
          if (!conflict && (isRoundCake || isShadow)) {
            capsule.offsetX = capsulePositionWidth - LiveStyle.CAPSULE_CIRCLE_WIDTH;
            capsule.width = LiveStyle.CAPSULE_CIRCLE_WIDTH;
            capsule.scaleX = 0;
            capsule.scaleY = 0;
          }
          if (isUpwards) {
            capsule.offsetY = this.maxOffsetY;
          }
        }
      },
      {
        curve: Curve.Linear,
        duration: 180,
        event: () => {
          // 内容渐隐
          capsule.contentOpacity = 0;
          // 胶囊背板颜色变黑
          capsule.backgroundColor = 'rgba(0, 0, 0, 1)';
        }
      },
      {
        curve: Curve.Linear,
        duration: 1,
        delay: LiveStyle.METABALL_HIGHEST_DURATION,
        event: () => {
          capsule.opacity = 0;
        }
      }
    );
    if (capsule.disableOutline !== isMultipleCapsules) {
      animateParams.push({
        curve: Curve.Linear,
        duration: 60,
        delay: 120,
        event: () => {
          capsule.disableOutline = isMultipleCapsules;
        }
      });
    }
    return animateParams;
  }

  /**
   * 收起抢占态胶囊
   * @param live
   * @returns
   */
  private collapseRemindCapsule(live: LiveNotification): AnimateParams[] {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    const isMultipleCapsules = this.vmInjector.getCapsuleListVm().getShowCapsuleListNum(true) > 1;
    const capsulePositionWidth = this.vmInjector.getCapsuleListVm().position.width;
    const animateParams: AnimateParams[] = [];
    if (capsuleVm.showType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
      animateParams.push(
        {
          curve: CAPSULE_CURVE,
          event: () => {
            // 胶囊内容缩小为挖孔区宽度与收起前宽度的比值，使收起时内容和底板速度一致
            capsuleVm.contentScaleX = capsulePositionWidth / capsuleVm.width;
            capsuleVm.contentScaleY = capsulePositionWidth / capsuleVm.width;
            // 胶囊隐藏至锚点
            capsuleVm.offsetX = 0;
            // 胶囊缩小到挖孔区宽度
            capsuleVm.width = capsulePositionWidth;
            // 胶囊适配融球高度变化
            capsuleVm.scaleY = 1.15;
          }
        },
        {
          curve: Curve.Linear,
          duration: 180,
          event: () => {
            capsuleVm.contentOpacity = 0;
            capsuleVm.backgroundColor = 'rgba(0, 0, 0, 1)';
          }
        },
        {
          curve: Curve.Linear,
          duration: 1,
          delay: LiveStyle.METABALL_HIGHEST_DURATION,
          event: () => {
            capsuleVm.opacity = 0;
          }
        }
      );
      if (capsuleVm.disableOutline !== isMultipleCapsules) {
        animateParams.push({
          curve: Curve.Linear,
          duration: 60,
          delay: 120,
          event: () => {
            capsuleVm.disableOutline = isMultipleCapsules;
          }
        });
      }
      return animateParams;
    }

    animateParams.push(
      {
        curve: Curve.Linear,
        duration: LiveStyle.METABALL_HIGHEST_DURATION,
        event: () => {
          capsuleVm.width = capsulePositionWidth;
          capsuleVm.offsetX = 0;
          capsuleVm.scaleY = 1.15;
        }
      },
      {
        curve: Curve.Linear,
        duration: 180,
        event: () => {
          capsuleVm.contentOpacity = 0;
          capsuleVm.backgroundColor = 'rgba(0, 0, 0, 1)';
        }
      },
      {
        curve: Curve.Linear,
        duration: 1,
        delay: LiveStyle.METABALL_HIGHEST_DURATION,
        event: () => {
          capsuleVm.scaleY = 1;
          capsuleVm.opacity = 0;
        }
      }
    );
    if (capsuleVm.disableOutline !== isMultipleCapsules) {
      animateParams.push({
        curve: Curve.Linear,
        duration: 60,
        delay: 120,
        event: () => {
          capsuleVm.disableOutline = isMultipleCapsules;
        }
      });
    }
    return animateParams;
  }

  /**
   * 显示其他胶囊
   * @param live
   * @returns
   */
  private expandOtherCapsule(live: LiveNotification, delay: number, isUpwards: boolean): AnimateParams[] {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    const isRoundCake = capsuleVm.fixedShowType === CapsuleShowType.ROUND_CAKE;
    const isShadow = capsuleVm.fixedShowType === CapsuleShowType.SHADOW;
    const animateParams: AnimateParams[] = [];
    if (live.isScreenRecorder() && capsuleVm.showType === CapsuleShowType.ROUND_CAKE) {
      return [
        {
          curve: CAPSULE_CURVE,
          delay: delay + 80,
          event: () => {
            capsuleVm.scaleX = 1;
            capsuleVm.scaleY = 1;
            capsuleVm.opacity = 1;
          }
        },
        {
          curve: curves.cubicBezierCurve(0.33, 0.00, 0.67, 1.00),
          delay: delay + 180,
          duration: 167,
          event: () => {
            capsuleVm.blur = 0;
          }
        }
      ];
    }

    if (capsuleVm.showType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
      animateParams.push(
        {
          curve: CAPSULE_CURVE,
          delay: delay,
          event: () => {
            // 胶囊位移至原始位置
            capsuleVm.offsetX = capsuleVm.fixedOffsetX;
            // 胶囊宽度复原
            capsuleVm.width = capsuleVm.fixedWidth;
            // 胶囊适配融球高度变化
            capsuleVm.scaleY = 1;
            // 胶囊背板变透明
            capsuleVm.backgroundColor = undefined;
            // 内容恢复
            capsuleVm.contentScaleX = 1;
            capsuleVm.contentScaleY = 1;
          }
        },
        {
          curve: Curve.Linear,
          duration: 290,
          delay: delay,
          event: () => {
            // 内容透明度恢复
            capsuleVm.contentOpacity = 1;
          }
        }
      );
      if (isUpwards) {
        animateParams.push({
          curve: curves.interpolatingSpring(0, 1, 1755, 84),
          delay: delay,
          event: () => {
            capsuleVm.offsetY = 0;
          }
        })
      }
      return animateParams;
    }

    animateParams.push(
      {
        curve: CAPSULE_CURVE,
        delay: delay,
        event: () => {
          capsuleVm.scaleX = 1;
          capsuleVm.scaleY = 1;
          capsuleVm.offsetX = capsuleVm.fixedOffsetX;
          capsuleVm.width = capsuleVm.fixedWidth;
          capsuleVm.contentScaleX = 1;
          capsuleVm.contentScaleY = 1;
        }
      },
      {
        curve: Curve.Linear,
        duration: 290,
        delay: delay,
        event: () => {
          capsuleVm.backgroundColor = undefined;
          capsuleVm.contentOpacity = 1;
        }
      },
      {
        duration: 1,
        delay: delay + 100,
        event: () => {
          if (isShadow) {
            capsuleVm.opacity = 1;
          }
        }
      },
      {
        curve: Curve.Linear,
        duration: 220,
        delay: delay + 80,
        event: () => {
          if (isRoundCake) {
            capsuleVm.opacity = 1;
          }
        }
      }
    );
    if (capsuleVm.disableOutline) {
      animateParams.push({
        curve: Curve.Linear,
        duration: 140,
        delay: delay + 50,
        event: () => {
          capsuleVm.disableOutline = false;
        }
      });
    }
    if (isUpwards) {
      animateParams.push({
        curve: curves.interpolatingSpring(0, 1, 1755, 84),
        delay: delay,
        event: () => {
          capsuleVm.offsetY = 0;
        }
      })
    }
    return animateParams;
  }

  /**
   * 显示抢占态胶囊
   * @param live
   * @returns
   */
  private expandRemindCapsule(live: LiveNotification, delay: number): AnimateParams[] {
    const animateParams: AnimateParams[] = [];
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);

    if (capsuleVm.showType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
      animateParams.push(
        {
          curve: CAPSULE_CURVE,
          delay: delay,
          event: () => {
            // 胶囊位移至原始位置
            capsuleVm.offsetX = capsuleVm.fixedOffsetX;
            // 胶囊宽度复原
            capsuleVm.width = capsuleVm.fixedWidth;
            // 胶囊适配融球高度变化
            capsuleVm.scaleY = 1;
            // 胶囊背板变透明
            capsuleVm.backgroundColor = undefined;
            // 内容恢复
            capsuleVm.contentScaleX = 1;
            capsuleVm.contentScaleY = 1;
          }
        },
        {
          curve: Curve.Linear,
          duration: 290,
          delay: delay,
          event: () => {
            // 内容透明度恢复
            capsuleVm.contentOpacity = 1;
          }
        },
      );
      return animateParams;
    }

    animateParams.push(
      {
        duration: 1,
        delay: delay,
        event: () => {
          capsuleVm.scaleY = 1.1;
          capsuleVm.offsetX = 0;
        }
      },
      {
        curve: CAPSULE_CURVE,
        delay: delay,
        event: () => {
          capsuleVm.scaleY = 1.0;
          capsuleVm.width = capsuleVm.fixedWidth;
          capsuleVm.offsetX = capsuleVm.fixedOffsetX;
          capsuleVm.backgroundColor = undefined;
          capsuleVm.contentScaleX = 1;
          capsuleVm.contentScaleY = 1;
        }
      },
      {
        curve: Curve.Linear,
        duration: 290,
        delay: delay,
        event: () => {
          capsuleVm.contentOpacity = 1;
        }
      }
    );
    if (capsuleVm.disableOutline) {
      animateParams.push({
        curve: Curve.Linear,
        duration: 140,
        delay: delay + 50,
        event: () => {
          capsuleVm.disableOutline = false;
        }
      });
    }
    return animateParams;
  }

  /**
   * 获取动效中转初始值，需要一定差值diff才可执行动效
   * @param value
   * @param diff
   * @returns
   */
  private getTransferState(value: number, diff: number = 0.01): number {
    return value + diff;
  }

  /**
   *  更新胶囊的宽度和位移
   *
   * @param liveList 当前胶囊列表
   * @param live 待更新的胶囊
   * @returns
   */
  async updateCapsuleWidthAndOffset(liveList: LiveNotification[], live?: LiveNotification): Promise<void> {
    return this.updateCapsuleAttribute(liveList, live);
  }
}
