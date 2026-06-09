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
import { LiveNotification } from '../model/LiveNotification';
import { CapsuleShowType } from '../model/LiveCommonModel';
import { NotificationArray } from '../../model/NotificationBase';
import { ILiveCapsuleVm } from '../interface/ILiveCapsuleVm';
import { ILiveCapsuleListLayoutVm } from '../interface/ILiveCapsuleLayoutVm';
import { LiveCapsuleListLayoutBaseVm, StackIconStyle } from './LiveCapsuleListLayoutBaseVm';
import { LiveStyle } from '../constants/LiveStyle';
import { StatusBarHeightVm } from '../../statusbar/vm/StatusBarHeightVm';
import { ILiveCapsuleMarqueeVm } from '../interface/ILiveCapsuleMarqueeVm';
import { StatusBarCapsulePosition } from '../../statusbar/model/StatusBarCapsulePosition';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { LiveCardScoreModel } from '../model/LiveCardScoreModel';

const TAG = 'LiveCapsuleListMiddleHoleLayoutVm';
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

interface ISpaceInfo {
  leftTotalFreeSpace: number;
  rightTotalFreeSpace: number;
  leftUsedSpace: number;
  rightUsedSpace: number;
  leftRemainSpace: number;
  rightRemainSpace: number;
};

@ObservedV2
export class LiveCapsuleListMiddleHoleLayoutVm extends LiveCapsuleListLayoutBaseVm implements ILiveCapsuleListLayoutVm {
  public readonly capsuleStateGap: number = 4;
  public readonly hangingDoubleCapsuleGap: number = 0;
  public readonly hangingCapsuleGap: number = DeviceInfoVm.instance.isCustomDevice ? 1 : 2;
  public readonly shadowCapsuleGap: number = 0;
  public readonly leftHoleGap: number = 0;
  public readonly rightHoleGap: number = 4;
  private leftMinFreeSpace: number = 0;
  private leftWithoutTimeTotalFreeSpace: number = 0;
  private leftTotalFreeSpace: number = 0;
  private rightTotalFreeSpace: number = 0;
  private rightTotalSpace: number = 0;
  private avoidStart: number = 0;
  private avoidEnd: number = 0;
  /**
   * 双端挂孔胶囊两端宽度差异大于75%时需进行宽度调整
   */
  private adjustPercent: number = 0.75;
  private isUpdate: boolean = false;
  private showCapsuleList: NotificationArray<LiveNotification>[] =
    [new NotificationArray<LiveNotification>(), new NotificationArray<LiveNotification>(),
      new NotificationArray<LiveNotification>()]; /* 分别记录进度，录屏和长时胶囊数 */

  public computeCapsuleFixedWithAndOffset(liveList: LiveNotification[], isUpdate: boolean = true): void {
    const position = this.vmInjector.getCapsuleListVm().position;
    if (!this.checkParam(liveList, position)) {
      log.showWarn('check parm is invalid.');
      return;
    }
    this.initParam(position, isUpdate);
    this.filterShowCapsuleList(liveList);
    this.moveScreen2ProgressCapsule();
    this.setHangingHoleDoubleEndedShowType();
    this.updateFixedWidth();
    this.updateFixedOffset();
    this.modifyFixedWidthAndFixedOffsetByShowType();
    this.modifyFixedWidthAndFixedOffsetForRightIcon();
    this.updateStatusBarHeight();
    this.printFixedWithAndeOffset(liveList);
  }

  // 中孔场景状态栏高度更新，统计胶囊数量时会忽略只有录屏胶囊的场景。
  private updateStatusBarHeight(): void {
    const showCapsuleNum = this.vmInjector.getCapsuleListVm().getShowCapsuleListNum();
    if (showCapsuleNum > 0) {
      const avoidHeight = StatusBarHeightVm.getInstance().getAvoidHeight();
      StatusBarHeightVm.getInstance().preSetShowHeight(avoidHeight + 1, this.statusbarHeightChangeTag);
    } else {
      StatusBarHeightVm.getInstance().clearShowHeight(this.statusbarHeightChangeTag);
    }
  }

  private checkParam(liveList: LiveNotification[], position?: StatusBarCapsulePosition): boolean {
    if (liveList.length === 0) {
      log.showInfo('live list length is zero.');
      return false;
    }

    if (!position) {
      log.showInfo('position is null.');
      return false;
    }

    if (position.capsuleLeftMin > position.capsuleRightMax) {
      log.showWarn(`capsule left min(${position.capsuleLeftMin}) is larger than capsule right max(${position.capsuleRightMax}).`);
      return false;
    }

    if (position.left < 0 || position.width < 0) {
      log.showWarn(`positon left ${position.left} and width ${position.width} is invalid.`);
      return false;
    }

    return true;
  }

  private initParam(position?: StatusBarCapsulePosition, isUpdate?: boolean) {
    if (!position) {
      return;
    }
    this.avoidStart = position.left;
    this.avoidEnd = position.left + position.width;
    log.showInfo(`position.capsuleLeftMin ${position.capsuleLeftMin} position.capsuleRightMax ${position.capsuleRightMax} this.avoidStart ${this.avoidStart} this.avoidEnd ${this.avoidEnd} .`);
    this.leftMinFreeSpace = this.getAvoidLeftTotalFreeSpace(position.capsuleLeftMax, position.capsuleRightMax) -
    this.getSpaceBetweenCapsuleAndStatusBar();
    this.leftWithoutTimeTotalFreeSpace =
      this.getAvoidLeftTotalFreeSpace(position.capsuleLeftMinWithoutTime, position.capsuleRightMax);
    this.leftTotalFreeSpace = this.getAvoidLeftTotalFreeSpace(position.capsuleLeftMin, position.capsuleRightMax) -
    this.getSpaceBetweenCapsuleAndStatusBar();
    this.rightTotalFreeSpace = this.getAvoidRightTotalFreeSpace(position.capsuleLeftMin, position.capsuleRightMax) -
    this.getSpaceBetweenCapsuleAndStatusBar();
    this.rightTotalSpace = this.getAvoidRightTotalFreeSpace(position.capsuleLeftMin, position.capsuleRightAllMax);
    log.showInfo(`initParam rightTotalSpace ${this.rightTotalSpace}.`);
    this.clearShowCapsuleList();
    this.isUpdate = isUpdate ?? true;
  }

  private getAvoidLeftTotalFreeSpace(capsuleLeftMin: number, capsuleRightMax: number): number {
    if (capsuleRightMax <= capsuleLeftMin) {
      log.showError(`capsule right max(${capsuleRightMax}) is smaller than capsule left min ${capsuleLeftMin}.`);
      return 0;
    }

    if (capsuleLeftMin > (this.avoidEnd)) {
      log.showWarn(`capsule left min(${capsuleLeftMin}) is larger than cutout right ${this.avoidEnd}.`);
      return 0;
    }

    if (capsuleRightMax < this.avoidStart) {
      log.showWarn(`capsule right max(${capsuleRightMax}) is smaller than cutout left ${this.avoidStart}.`);
      return capsuleRightMax - capsuleLeftMin;
    }

    return this.avoidStart - capsuleLeftMin;
  }

  private getAvoidRightTotalFreeSpace(capsuleLeftMin: number, capsuleRightMax: number): number {
    if (capsuleRightMax <= capsuleLeftMin) {
      log.showError(`capsule right max(${capsuleRightMax}) is smaller than capsule left min ${capsuleLeftMin}.`);
      return 0;
    }

    if (capsuleLeftMin > this.avoidEnd) {
      log.showWarn(`capsule left min(${capsuleLeftMin}) is larger than cutout right ${this.avoidEnd}.`);
      return capsuleRightMax - capsuleLeftMin;
    }

    if (capsuleRightMax < this.avoidStart) {
      log.showWarn(`capsule right max(${capsuleRightMax}) is smaller than cutout left ${this.avoidStart}.`);
      return 0;
    }

    return capsuleRightMax - this.avoidEnd;
  }

  private clearShowCapsuleList(): void {
    for (const liveCapsuleList of this.showCapsuleList) {
      liveCapsuleList.clear();
    }
  }

  public setRemindCapsuleWidth(live: LiveNotification, isUpdateImmediately: boolean): void {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    // 融球宽度
    const holeWidth = this.vmInjector.getCapsuleListVm().position.width;

    capsuleVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
    capsuleVm.fixedWidth = 0;
    // 强提醒先判断是否能显示副文本

    const leftMaxWidth = this.leftWithoutTimeTotalFreeSpace;
    const rightMaxWidth = this.rightTotalSpace;
    capsuleVm.fixedWidth = 0;
    capsuleVm.fixedShowType = CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED;
    const minCapsuleFrontSize = this.getCapsuleFontSize(live, true);
    const minLeftCapsuleWidth =
      this.getHangingHoleDoubleCapsuleRealWidth(live, minCapsuleFrontSize, true);
    const minRightCapsuleWidth =
      this.getHangingHoleDoubleCapsuleRealWidth(live, minCapsuleFrontSize, false);
    let rightWidth: number = 0;
    let leftWidth: number = 0;
    log.showInfo(`setRemindCapsuleWidth minLeftCapsuleWidth ${minLeftCapsuleWidth} minRightCapsuleWidth ${minRightCapsuleWidth}`);
    if (minRightCapsuleWidth > minLeftCapsuleWidth) {
      rightWidth =
        this.adjustFixedWidthForHangingHoleDoubleEndedType(live, false, rightMaxWidth, 0, isUpdateImmediately, true);
      leftWidth = Math.min(rightWidth, leftMaxWidth);
      this.adjustFixedWidth2SpecifyWidth(live, true, leftWidth, isUpdateImmediately);
    } else {
      leftWidth =
        this.adjustFixedWidthForHangingHoleDoubleEndedType(live, true, leftMaxWidth, 0, isUpdateImmediately, true);
      rightWidth = Math.min(leftWidth, rightMaxWidth);
      this.adjustFixedWidth2SpecifyWidth(live, false, rightWidth, isUpdateImmediately);
    }
    const capsuleWidth = rightWidth > 0 ? (leftWidth + rightWidth + holeWidth) : (leftWidth + holeWidth);
    capsuleVm.fixedShowType = rightWidth > 0 ? capsuleVm.fixedShowType : CapsuleShowType.HANGING_HOLE;
    capsuleVm.fixedOffsetX = -leftWidth;
    capsuleVm.fixedWidth = capsuleWidth;
    capsuleVm.isShow = true;
    capsuleVm.fixedIsShowRightIcon = super.isShowRightIcon(live);
    log.showWarn(`setRemindCapsuleWidth leftWidth ${leftWidth} rightWidth ${rightWidth} holeWidth ${holeWidth},
    textWidth:${capsuleMarqueeVm.fixedTextWidth}, isUpdateImmediately ${isUpdateImmediately}`);
  }

  private filterShowCapsuleList(liveList: LiveNotification[]): void {
    for (const live of liveList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      if (!capsuleVm.isVisible) {
        capsuleVm.isShow = false;
        capsuleVm.fixedShowType = CapsuleShowType.NONE;
        capsuleVm.fixedWidth = 0;
        capsuleVm.fixedOffsetX = 0;
        continue;
      }
      /* 抢占态胶囊出场不参与布局，需要先计算自适应宽度 */
      if (live.isInstant()) {
        if (!capsuleVm.isShowed) {
          this.setRemindCapsuleWidth(live, this.isUpdate);
          continue;
        }
      }

      if (live.isInstant()) {
        this.setRemindCapsuleWidth(live, this.isUpdate);
        continue;
      }

      if (live.isFlip()) {
        if (this.vmInjector.getLiveRemindVm().isCurrentRemindCapsule(live)) {
          capsuleVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
          capsuleVm.isShow = true;
          this.setRemindCapsuleWidth(live, this.isUpdate);
          continue;
        }
      }

      if (live.isScreenRecorder()) {
        this.pushLiveCapsule2List(this.showCapsuleList[CapsuleType.SCREEN_RECORDING], live, capsuleVm,
          [CapsuleShowType.RETRACTABLE_ROUND_CAKE]);
        continue;
      }

      this.pushLiveCapsule2List(this.showCapsuleList[CapsuleType.PROGRESS], live, capsuleVm,
        [CapsuleShowType.HANGING_HOLE, CapsuleShowType.ROUND_CAKE, CapsuleShowType.SHADOW]);
    }
  }

  private pushLiveCapsule2List(capsuleList: NotificationArray<LiveNotification> | undefined,
    liveCapsule: LiveNotification,
    capsuleVm: ILiveCapsuleVm, showTypeArray: CapsuleShowType[]) {
    if (!capsuleList) {
      return;
    }
    const totalCnt: number = showTypeArray.length;
    let currentCnt: number = capsuleList.length;
    const currentShowType = showTypeArray[currentCnt] ?? CapsuleShowType.NONE;
    if (currentCnt < totalCnt) {
      /* 过滤后的列表中没有，则设置显示类型后，添加进入过来后的列表 */
      if (capsuleList.findIndex((value) => value.hashCode === liveCapsule.hashCode) === -1) {
        capsuleVm.fixedShowType = currentShowType;
        capsuleVm.isShow = true;
        capsuleList.push(liveCapsule);
      }
      return;
    }
    /* 有记录过，则已经修改过vm中的showType，不能再进行修改 */
    if (capsuleList.findIndex((value) => value.hashCode === liveCapsule.hashCode) !== -1) {
      return;
    }
    /* 其他的胶囊，均设置为不显示 */
    capsuleVm.isShow = false;
    capsuleVm.fixedShowType = CapsuleShowType.NONE;
    capsuleVm.fixedWidth = 0;
    capsuleVm.fixedOffsetX = 0;
  }

  private getCapsuleGap(liveCapsuleVm: ILiveCapsuleVm): number {
    if (liveCapsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
      return this.hangingDoubleCapsuleGap;
    }

    if (liveCapsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE) {
      return this.hangingCapsuleGap;
    }

    if (liveCapsuleVm.fixedShowType === CapsuleShowType.SHADOW) {
      return this.shadowCapsuleGap;
    }

    if (liveCapsuleVm.fixedShowType === CapsuleShowType.TOP) {
      return this.capsuleStateGap;
    }

    if (liveCapsuleVm.fixedShowType === CapsuleShowType.LEFT_HOLE) {
      return this.leftHoleGap;
    }

    if (liveCapsuleVm.fixedShowType === CapsuleShowType.RIGHT_HOLE) {
      return this.rightHoleGap;
    }
    return this.capsuleStateGap;
  }

  private updateFixedWidth(): void {
    let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray();
    const mandatoryElementCnt: number = this.generateCapsuleShowListByPrioritySort(capsuleShowList);
    const leftTotalFreeSpace = this.getLeftTotalFreeSpace();
    const rightTotalFreeSpace = this.rightTotalFreeSpace;
    let spaceInfo: ISpaceInfo =
      this.computeCapsuleShowFlagBySpace(capsuleShowList, mandatoryElementCnt, leftTotalFreeSpace, rightTotalFreeSpace);
    this.adjustShowCapsuleWidth(spaceInfo, capsuleShowList);
    return;
  }

  private getLeftTotalFreeSpace(): number {
    // 1. A ，含A(P)和A(P+S)
    if (this.showCapsuleList[CapsuleType.SCREEN_RECORDING].length === 0 &&
      this.showCapsuleList[CapsuleType.PERSISTENT].length === 0 &&
      this.showCapsuleList[CapsuleType.PROGRESS].length === 1) {
      return this.leftMinFreeSpace;
    }

    if (this.showCapsuleList[CapsuleType.SCREEN_RECORDING].length === 0 &&
      this.showCapsuleList[CapsuleType.PERSISTENT].length === 0 &&
      this.showCapsuleList[CapsuleType.PROGRESS].length > 0) {
      const progressCapsuleList: NotificationArray<LiveNotification> = this.showCapsuleList[CapsuleType.PROGRESS];
      const liveNotification = progressCapsuleList[0];
      let extendTextContent = liveNotification.capsule?.getExtendTextContent() ?? ''
      if (this.vmInjector.getCapsuleVm(liveNotification).isScoreScene(liveNotification)) {
        extendTextContent = (liveNotification.card as LiveCardScoreModel).layoutGuestScore ?? '';
      }
      if (extendTextContent.length === 0) {
        return this.leftMinFreeSpace;
      }
    }

    if (this.showCapsuleList[CapsuleType.SCREEN_RECORDING].length > 0 &&
      this.showCapsuleList[CapsuleType.PERSISTENT].length === 0 &&
      this.showCapsuleList[CapsuleType.PROGRESS].length === 1) {
      const progressCapsuleList: NotificationArray<LiveNotification> = this.showCapsuleList[CapsuleType.PROGRESS];
      const liveNotification = progressCapsuleList[0];
      let extendTextContent = liveNotification.capsule?.getExtendTextContent() ?? '';
      if (this.vmInjector.getCapsuleVm(liveNotification).isScoreScene(liveNotification)) {
        extendTextContent = (liveNotification.card as LiveCardScoreModel).layoutGuestScore ?? '';
      }
      if (extendTextContent.length === 0) {
        return this.leftMinFreeSpace;
      }
    }
    return this.leftTotalFreeSpace;
  }

  private adjustShowCapsuleWidth(spaceInfo: ISpaceInfo, capsuleList: NotificationArray<LiveNotification>) {
    for (const live of capsuleList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      if (!capsuleVm.isShow) {
        continue;
      }
      log.showInfo(`adjustShowCapsuleWidth hashCode ${live.hashCode}` +
        ` leftRemainSpace ${spaceInfo.leftRemainSpace} rightRemainSpace ${spaceInfo.rightRemainSpace}`);
      let rightWidth = this.getMinWidth(live, false);
      if (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
        if (spaceInfo.rightRemainSpace > 0 && live.capsule) {
          const rightUsedSpace = this.adjustFixedWidth(spaceInfo.rightRemainSpace, live, this.isUpdate, false);
          spaceInfo.rightRemainSpace = spaceInfo.rightRemainSpace - rightUsedSpace;
          log.showInfo(`capsuleVm.fixedWidth ${capsuleVm.fixedWidth} rightUsedSpace ${rightUsedSpace} rightWidth ${rightWidth}`);
          capsuleVm.fixedWidth = capsuleVm.fixedWidth + rightUsedSpace;
          const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
          log.showInfo(`adjustShowCapsuleWidth rightUsedSpace ${rightUsedSpace} capsuleMarqueeVm.fixedExtendTextSize ${capsuleMarqueeVm.fixedExtendTextSize} capsuleMarqueeVm.fixedExtendTextWidth ${capsuleMarqueeVm.fixedExtendTextWidth}.`);
          rightWidth = rightWidth + rightUsedSpace;
        }

        if (spaceInfo.leftRemainSpace > 0 && live.capsule) {
          const minCapsuleFrontSize = this.getCapsuleFontSize(live, true);
          const minLeftCapsuleWidth =
            this.getHangingHoleDoubleCapsuleRealWidth(live, minCapsuleFrontSize, true);
          const leftMinWidth = this.getMinWidth(live, true);
          log.showInfo(`minLeftCapsuleWidth ${minLeftCapsuleWidth} spaceInfo.leftRemainSpace ${spaceInfo.leftRemainSpace} rightWidth ${rightWidth} leftMinWidth ${leftMinWidth}`);

          if (rightWidth >= minLeftCapsuleWidth && spaceInfo.leftRemainSpace + leftMinWidth >= rightWidth) {
            this.adjustFixedWidth2SpecifyWidth(live, true, rightWidth, this.isUpdate);
            const leftUsedSpace = rightWidth - leftMinWidth;
            spaceInfo.leftRemainSpace = spaceInfo.leftRemainSpace - leftUsedSpace;
            capsuleVm.fixedWidth = capsuleVm.fixedWidth + leftUsedSpace;
            const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
            log.showInfo(`adjustFixedWidth2SpecifyWidth leftUsedSpace ${leftUsedSpace} capsuleMarqueeVm.fixedTextSize ${capsuleMarqueeVm.fixedTextSize} capsuleMarqueeVm.fixedTextWidth ${capsuleMarqueeVm.fixedTextWidth} capsuleVm.fixedWidth ${capsuleVm.fixedWidth}.`);
          } else {
            // 如果左侧没有文本，又做不到绝对对称，则伸展到尽可能长的长度。在有录屏胶囊和一个双端挂孔胶囊且双端挂孔胶囊只有主文本时出现
            let text: string = this.getText(live, false);
            let leftUsedSpace = spaceInfo.leftRemainSpace; // 在只有主文本时，默认全占完空间
            if ((spaceInfo.leftRemainSpace + leftMinWidth) < rightWidth && !text) {
              this.adjustFixedWidth2SpecifyWidth(live, true, spaceInfo.leftRemainSpace + leftMinWidth, this.isUpdate);
              capsuleVm.fixedWidth = capsuleVm.fixedWidth + spaceInfo.leftRemainSpace;
              spaceInfo.leftRemainSpace = 0;
            } else {
              leftUsedSpace = this.adjustFixedWidth(spaceInfo.leftRemainSpace, live, this.isUpdate, true);
              spaceInfo.leftRemainSpace = spaceInfo.leftRemainSpace - leftUsedSpace;
              capsuleVm.fixedWidth = capsuleVm.fixedWidth + leftUsedSpace;
            }
            const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
            log.showInfo(`adjustShowCapsuleWidth leftUsedSpace ${leftUsedSpace} capsuleMarqueeVm.fixedTextSize ${capsuleMarqueeVm.fixedTextSize} capsuleMarqueeVm.fixedTextWidth ${capsuleMarqueeVm.fixedTextWidth}.`);
          }
        }
        // 如果胶囊两端文本长度差异过大（短边长度小于长边的75%），将短边长度调整为长边的75%
        this.adjustTo75Percent(live, spaceInfo, rightWidth);
        continue;
      }

      if (this.isShowHoleLeft(live, capsuleVm)) {
        if (spaceInfo.leftRemainSpace > 0 && live.capsule) {
          const usedSpace = this.adjustFixedWidth(spaceInfo.leftRemainSpace, live, this.isUpdate);
          spaceInfo.leftRemainSpace = spaceInfo.leftRemainSpace - usedSpace;
        }
        continue;
      }

      if (this.isShowHoleRight(live, capsuleVm)) {
        if (spaceInfo.rightRemainSpace > 0 && live.capsule) {
          const usedSpace = this.adjustFixedWidth(spaceInfo.rightRemainSpace, live, this.isUpdate);
          spaceInfo.rightRemainSpace = spaceInfo.rightRemainSpace - usedSpace;
        }
        continue;
      }
    }
  }

  // 双端挂孔胶囊如果两端胶囊宽度差异超过75%，则将短的一边调整至宽的一边的75%
  private adjustTo75Percent(live: LiveNotification, spaceInfo: ISpaceInfo, rightWidth: number): void {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    const cutoutWidth = this.avoidEnd - this.avoidStart;
    const leftWidth = capsuleVm.fixedWidth - rightWidth - cutoutWidth;
    const leftCmpWidth = capsuleVm.fixedWidth - rightWidth - cutoutWidth / 2;
    const rightCmpWidth = rightWidth + cutoutWidth / 2;
    const percent = Math.min(leftCmpWidth , rightCmpWidth) / Math.max(leftCmpWidth , rightCmpWidth);
    const delta = Math.max(leftCmpWidth , rightCmpWidth) * this.adjustPercent - Math.min(leftCmpWidth , rightCmpWidth);
    let adjustedLeftWidth = leftWidth;
    let adjustedRightWidth = rightWidth;
    if (percent  >= this.adjustPercent) {
      return;
    }
    if (leftCmpWidth < rightCmpWidth && spaceInfo.leftRemainSpace >= delta) {
      this.adjustFixedWidth2SpecifyWidth(live, true, leftWidth + delta, this.isUpdate);
      spaceInfo.leftRemainSpace = spaceInfo.leftRemainSpace - delta;
      capsuleVm.fixedWidth = capsuleVm.fixedWidth + delta;
      adjustedLeftWidth = leftWidth + delta;
    } else if (leftCmpWidth > rightCmpWidth && spaceInfo.rightRemainSpace >= delta) {
      this.adjustFixedWidth2SpecifyWidth(live, false, rightWidth + delta, this.isUpdate);
      spaceInfo.rightRemainSpace = spaceInfo.rightRemainSpace - delta;
      capsuleVm.fixedWidth = capsuleVm.fixedWidth + delta;
      adjustedRightWidth = rightWidth + delta;
    }
    log.showInfo(`adjustTo75Percent, percent: ${percent}, delta: ${delta}, adjustedLeftWidth: ${adjustedLeftWidth}, adjustedRightWidth: ${adjustedRightWidth}, fixedWidth: ${capsuleVm.fixedWidth}`);
  }

  private computeCapsuleShowFlagBySpace(capsuleShowList: NotificationArray<LiveNotification>,
    mandatoryElementCnt: number, leftTotalFreeSpace: number, rightTotalFreeSpace: number): ISpaceInfo {

    let spaceInfo: ISpaceInfo = {
      leftTotalFreeSpace: leftTotalFreeSpace,
      rightTotalFreeSpace: rightTotalFreeSpace,
      leftUsedSpace: 0,
      rightUsedSpace: 0,
      leftRemainSpace: leftTotalFreeSpace,
      rightRemainSpace: rightTotalFreeSpace
    };
    let currentCnt: number = 0;
    for (const liveCapsule of capsuleShowList) {
      currentCnt++;
      const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
      if (!capsuleVm.isShow) {
        continue;
      }
      if (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
        const leftCapsuleWidth = this.getMinWidth(liveCapsule, true);
        const isLeftSpaceEnough: boolean =
          this.computeLeftUsedSpace(spaceInfo, leftCapsuleWidth, capsuleVm, currentCnt, mandatoryElementCnt);
        log.showInfo(`computeCapsuleShowFlagBySpace leftCapsuleWidth ${leftCapsuleWidth} isLeftSpaceEnough ${isLeftSpaceEnough}`);
        const rightCapsuleWidth = this.getMinWidth(liveCapsule, false);
        const isRightSpaceEnough: boolean = this.computeRightUseSpace(spaceInfo, rightCapsuleWidth, capsuleVm);
        log.showInfo(`computeCapsuleShowFlagBySpace rightCapsuleWidth ${rightCapsuleWidth} isRightSpaceEnough ${isRightSpaceEnough}`);
        if (isLeftSpaceEnough && isRightSpaceEnough) {
          capsuleVm.isShow = true;
          capsuleVm.fixedWidth = leftCapsuleWidth + rightCapsuleWidth + (this.avoidEnd - this.avoidStart);
          log.showInfo(`computeCapsuleShowFlagBySpace capsuleVm.fixedWidth ${capsuleVm.fixedWidth} avoid witdth ${this.avoidEnd -
          this.avoidStart}`);
          continue;
        }
        log.showInfo(`computeCapsuleShowFlagBySpace showType ${capsuleVm.fixedShowType} leftCapsuleWidth ${leftCapsuleWidth} rightCapsuleWidth ${rightCapsuleWidth}.`);
        // TODO:
        capsuleVm.isShow = true;
        capsuleVm.fixedWidth = 0;
        capsuleVm.fixedOffsetX = 0;
        continue;
      }

      const capsuleWidth = this.getMinWidth(liveCapsule);
      if (this.isShowHoleLeft(liveCapsule, capsuleVm)) {
        this.computeLeftUsedSpace(spaceInfo, capsuleWidth, capsuleVm, currentCnt, mandatoryElementCnt);
        continue;
      }

      if (this.isShowHoleRight(liveCapsule, capsuleVm)) {
        this.computeRightUseSpace(spaceInfo, capsuleWidth, capsuleVm);
        continue;
      }
      capsuleVm.isShow = false;
      capsuleVm.fixedWidth = 0;
      capsuleVm.fixedOffsetX = 0;
    }
    spaceInfo.leftRemainSpace = spaceInfo.leftTotalFreeSpace - spaceInfo.leftUsedSpace;
    spaceInfo.rightRemainSpace = spaceInfo.rightTotalFreeSpace - spaceInfo.rightUsedSpace;
    return spaceInfo;
  }

  private computeRightUseSpace(spaceInfo: ISpaceInfo, capsuleWidth: number, capsuleVm: ILiveCapsuleVm): boolean {
    const newRightUsedSpace = spaceInfo.rightUsedSpace + capsuleWidth + this.getCapsuleGap(capsuleVm);
    if (spaceInfo.rightTotalFreeSpace >= newRightUsedSpace) {
      spaceInfo.rightUsedSpace = newRightUsedSpace;
      capsuleVm.isShow = true;
      capsuleVm.fixedWidth = capsuleWidth;
      return true;
    }

    capsuleVm.isShow = false;
    capsuleVm.fixedWidth = 0;
    capsuleVm.fixedOffsetX = 0;
    return false;
  }

  private computeLeftUsedSpace(spaceInfo: ISpaceInfo, capsuleWidth: number, capsuleVm: ILiveCapsuleVm,
    currentCnt: number, mandatoryElementCnt: number): boolean {
    const newLeftUsedSpace = spaceInfo.leftUsedSpace + capsuleWidth + this.getCapsuleGap(capsuleVm);
    if (spaceInfo.leftTotalFreeSpace >= newLeftUsedSpace) {
      spaceInfo.leftUsedSpace = newLeftUsedSpace;
      capsuleVm.isShow = true;
      capsuleVm.fixedWidth = capsuleWidth;
      return true;
    }

    if (currentCnt <= mandatoryElementCnt &&
      this.leftTotalFreeSpace > spaceInfo.leftTotalFreeSpace &&
      this.leftTotalFreeSpace >= newLeftUsedSpace) {
      log.showInfo(`current is mandatory element, with portrait time space(${this.leftTotalFreeSpace}) is enough for ${newLeftUsedSpace}.`);
      spaceInfo.leftTotalFreeSpace = this.leftTotalFreeSpace;
      spaceInfo.leftUsedSpace = newLeftUsedSpace;
      capsuleVm.isShow = true;
      capsuleVm.fixedWidth = capsuleWidth;
      return true;
    }

    if (currentCnt <= mandatoryElementCnt &&
      this.leftWithoutTimeTotalFreeSpace > spaceInfo.leftTotalFreeSpace &&
      this.leftWithoutTimeTotalFreeSpace >= newLeftUsedSpace) {
      log.showInfo(`current is mandatory element, without time space(${this.leftWithoutTimeTotalFreeSpace}) is enough for ${newLeftUsedSpace}.`);
      spaceInfo.leftTotalFreeSpace = this.leftWithoutTimeTotalFreeSpace;
      spaceInfo.leftUsedSpace = newLeftUsedSpace;
      capsuleVm.isShow = true;
      capsuleVm.fixedWidth = capsuleWidth;
      return true;
    }

    log.showInfo(`leftUsedSpace ${spaceInfo.leftUsedSpace} newLeftUsedSpace ${newLeftUsedSpace} leftFreeSpace ${spaceInfo.leftTotalFreeSpace}`);
    capsuleVm.isShow = false;
    capsuleVm.fixedWidth = 0;
    capsuleVm.fixedOffsetX = 0;
    return false;
  }

  private generateCapsuleShowListByPrioritySort(capsuleShowList: NotificationArray<LiveNotification>): number {
    let mandatoryElementCnt: number = 0;
    let progressCapsuleList: NotificationArray<LiveNotification> = this.showCapsuleList[CapsuleType.PROGRESS];
    if (progressCapsuleList.length > 0) {
      capsuleShowList.push(progressCapsuleList[0]);
      mandatoryElementCnt++;
    }
    for (const liveCapsule of this.showCapsuleList[CapsuleType.SCREEN_RECORDING]) {
      capsuleShowList.push(liveCapsule);
    }
    mandatoryElementCnt = mandatoryElementCnt + this.showCapsuleList[CapsuleType.SCREEN_RECORDING].length;

    for (let idx = 0; idx < progressCapsuleList.length; idx++) {
      if (idx === 0) {
        continue;
      }

      if (idx === 1) {
        mandatoryElementCnt++;
        capsuleShowList.push(progressCapsuleList[idx]);
        continue;
      }

      if (idx === 2) {
        for (const liveCapsule of this.showCapsuleList[CapsuleType.PERSISTENT]) {
          capsuleShowList.push(liveCapsule);
        }
      }

      capsuleShowList.push(progressCapsuleList[idx]);
    }
    if (progressCapsuleList.length <= 2) {
      for (const liveCapsule of this.showCapsuleList[CapsuleType.PERSISTENT]) {
        capsuleShowList.push(liveCapsule);
      }
    }

    log.showInfo(`generateCapsuleShowListByPrioritySort capsuleShowList ${capsuleShowList.map((value) => value.hashCode)
      .join(',')}.`);
    log.showInfo(`generateCapsuleShowListByPrioritySort capsuleShowList ${capsuleShowList.map((value) => this.vmInjector.getCapsuleVm(value)
      .fixedShowType).join(',')} mandatoryElementCnt ${mandatoryElementCnt}.`);
    return mandatoryElementCnt;
  }

  private isShowHoleRight(live: LiveNotification, capsuleVm: ILiveCapsuleVm): boolean {
    return capsuleVm.fixedShowType === CapsuleShowType.RIGHT_HOLE ||
      capsuleVm.fixedShowType === CapsuleShowType.SHADOW ||
      (capsuleVm.fixedShowType === CapsuleShowType.ROUND_CAKE);
  }

  private isShowHoleLeft(live: LiveNotification, capsuleVm: ILiveCapsuleVm): boolean {
    return capsuleVm.fixedShowType === CapsuleShowType.TOP || capsuleVm.fixedShowType === CapsuleShowType.LEFT_HOLE ||
      capsuleVm.fixedShowType === CapsuleShowType.RETRACTABLE_ROUND_CAKE ||
      capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE ||
      capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED;
  }

  /*
    常驻态胶囊排列顺序，按照进度、长时最后录屏的顺序放置。
   */
  private updateFixedOffset(): void {
    let totalOffset: number = this.updateProgressCapsuleFixedOffset();
    totalOffset =
      this.updateFixedOffsetByOffset(totalOffset, this.showCapsuleList[CapsuleType.PERSISTENT], CapsuleType.PERSISTENT);
    totalOffset = this.updateFixedOffsetByOffset(totalOffset, this.showCapsuleList[CapsuleType.SCREEN_RECORDING],
      CapsuleType.SCREEN_RECORDING);
  }

  private updateProgressCapsuleFixedOffset() {
    let progressCapsuleList: NotificationArray<LiveNotification> = this.showCapsuleList[CapsuleType.PROGRESS];
    const holeLeftCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
    const holeRightCapsuleList: NotificationArray<LiveNotification> = new NotificationArray<LiveNotification>();
    for (const liveCapsule of progressCapsuleList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
      if (!capsuleVm.isShow) {
        continue;
      }
      if (this.isShowHoleLeft(liveCapsule, capsuleVm)) {
        holeLeftCapsuleList.push(liveCapsule);
        continue;
      }
      if (this.isShowHoleRight(liveCapsule, capsuleVm)) {
        holeRightCapsuleList.push(liveCapsule);
        continue;
      }
    }
    let totalRightOffset: number = 0;
    for (let i = 0; i < holeRightCapsuleList.length; i++) {
      const capsuleVm = this.vmInjector.getCapsuleVm(holeRightCapsuleList[i]);
      if (i === 0) {
        totalRightOffset = totalRightOffset + (this.avoidEnd - this.avoidStart) + this.getCapsuleGap(capsuleVm);
        capsuleVm.fixedOffsetX = totalRightOffset;
        continue;
      }

      const preCapsuleVm = this.vmInjector.getCapsuleVm(holeRightCapsuleList[i - 1]);
      totalRightOffset = totalRightOffset + preCapsuleVm.fixedWidth + this.getCapsuleGap(capsuleVm);
      capsuleVm.fixedOffsetX = totalRightOffset;
      log.showInfo(`updateProgressRightCapsuleFixedOffset ${holeRightCapsuleList[i].hashCode} offset ${capsuleVm.fixedOffsetX} totalRightOffset ${totalRightOffset}`);
    }

    let totalLeftOffset: number = 0;
    for (let i = holeLeftCapsuleList.length - 1; i >= 0; i--) {
      const liveCapsule = holeLeftCapsuleList[i];
      const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
      if (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
        const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(liveCapsule);
        totalLeftOffset = totalLeftOffset -
          (this.getCapsuleGap(capsuleVm) + this.getLeftCapsuleWidth(capsuleVm, capsuleMarqueeVm, liveCapsule));
      } else {
        totalLeftOffset = totalLeftOffset - (this.getCapsuleGap(capsuleVm) + capsuleVm.fixedWidth);
      }

      capsuleVm.fixedOffsetX = totalLeftOffset;
      log.showInfo(`updateProgressLeftCapsuleFixedOffset ${holeLeftCapsuleList[i].hashCode} offset ${capsuleVm.fixedOffsetX} totalLeftOffset ${totalLeftOffset}`);
    }
    return totalLeftOffset;
  }

  private updateFixedOffsetByOffset(totalOffset: number, liveCapsuleList: NotificationArray<LiveNotification>,
    capsuleType: CapsuleType): number {
    for (const liveCapsule of liveCapsuleList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
      if (!capsuleVm.isShow) {
        continue;
      }
      totalOffset = totalOffset - (this.getCapsuleGap(capsuleVm) + capsuleVm.fixedWidth);
      capsuleVm.fixedOffsetX = totalOffset;
      log.showInfo(`updateFixedOffsetByOffset capsule type(${capsuleType}) ${liveCapsule.hashCode} offset ${capsuleVm.fixedOffsetX} totalOffset ${totalOffset}`);
    }
    return totalOffset;
  }

  private getLeftCapsuleWidth(capsuleVm: ILiveCapsuleVm, capsuleMarqueeVm: ILiveCapsuleMarqueeVm,
    liveCapsule: LiveNotification): number {
    return capsuleVm.fixedWidth - capsuleMarqueeVm.fixedExtendTextWidth -
    this.getCapsuleMarqueeWithoutTextWidth(liveCapsule, true) - (this.avoidEnd - this.avoidStart);
  }

  private modifyFixedWidthAndFixedOffsetByShowType(): void {
    for (const liveCapsule of this.showCapsuleList[CapsuleType.SCREEN_RECORDING]) {
      const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
      capsuleVm.fixedShowType = CapsuleShowType.ROUND_CAKE;
    }

    for (const liveCapsule of this.showCapsuleList[CapsuleType.PROGRESS]) {
      const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
      if (!capsuleVm.isShow) {
        continue;
      }
      if (capsuleVm.fixedShowType === CapsuleShowType.SHADOW) {
        capsuleVm.fixedWidth = LiveStyle.SHADOW_CAPSULE_CIRCLE_WIDTH;
        capsuleVm.fixedOffsetX =
          capsuleVm.fixedOffsetX - (LiveStyle.SHADOW_CAPSULE_CIRCLE_WIDTH - LiveStyle.SHADOW_CAPSULE_SHOW_WIDTH);
        continue;
      }

      if (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE) {
        log.showInfo(`modifyFixedWidthAndFixedOffsetByShowType capsule type(${capsuleVm.fixedShowType}) ${liveCapsule.hashCode} offset ${capsuleVm.fixedOffsetX} fixedWidth ${capsuleVm.fixedWidth}).`);
        capsuleVm.fixedWidth = capsuleVm.fixedWidth + this.getCapsuleGap(capsuleVm) + (this.avoidEnd - this.avoidStart);
        log.showInfo(`modifyFixedWidthAndFixedOffsetByShowType capsule type(${capsuleVm.fixedShowType}) ${liveCapsule.hashCode} offset ${capsuleVm.fixedOffsetX} fixedWidth ${capsuleVm.fixedWidth}).`);
        continue;
      }

      if (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
        continue;
      }

      log.showInfo(`modifyFixedWidthAndFixedOffsetByShowType capsule type(${capsuleVm.fixedShowType}) ${liveCapsule.hashCode} offset ${capsuleVm.fixedOffsetX}).`);
    }
  }

  /**
   * 胶囊有右侧图标时刷新布局
   */
  private modifyFixedWidthAndFixedOffsetForRightIcon(): void {
    let isScoreHangingHole: boolean = false;
    for (const live of this.showCapsuleList[CapsuleType.PROGRESS]) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      if (capsuleVm.isScoreScene(live)) {
        if (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
          return;
        }
        if (capsuleVm.fixedShowType === CapsuleShowType.HANGING_HOLE) {
          isScoreHangingHole = true;
          break;
        }
      }
    }
    if (!isScoreHangingHole) {
      return;
    }

    let needSpace: number = StackIconStyle.STACK_ICON_MAX_MARGIN;
    let freeSpace: number = 0;
    if (this.showCapsuleList[CapsuleType.SCREEN_RECORDING].length) {
      const capsuleVm = this.vmInjector.getCapsuleVm(this.showCapsuleList[CapsuleType.SCREEN_RECORDING][0]);
      freeSpace = this.leftTotalFreeSpace + capsuleVm.fixedOffsetX;
      // 有录屏时优先把右边堆叠图标偏移距离缩短到12vp，如果还不够再挤压时间
      if (freeSpace < StackIconStyle.STACK_ICON_MIN_MARGIN_WITH_TIME) {
        freeSpace = this.leftWithoutTimeTotalFreeSpace + capsuleVm.fixedOffsetX;
      }
    } else {
      const capsuleVm = this.vmInjector.getCapsuleVm(this.showCapsuleList[CapsuleType.PROGRESS][0]);
      freeSpace = this.leftTotalFreeSpace + capsuleVm.fixedOffsetX;
    }
    needSpace = Math.min(freeSpace, needSpace);

    if (this.showCapsuleList[CapsuleType.SCREEN_RECORDING].length) {
      const capsuleVm = this.vmInjector.getCapsuleVm(this.showCapsuleList[CapsuleType.SCREEN_RECORDING][0]);
      capsuleVm.fixedOffsetX -= needSpace;
    }
    const capsuleVm = this.vmInjector.getCapsuleVm(this.showCapsuleList[CapsuleType.PROGRESS][0]);
    capsuleVm.fixedWidth += needSpace;
    capsuleVm.fixedOffsetX -= needSpace;
    capsuleVm.stackIconMargin = needSpace;
  }

  private setHangingHoleDoubleEndedShowType() {
    let progressCapsuleList: NotificationArray<LiveNotification> = this.showCapsuleList[CapsuleType.PROGRESS];
    if (progressCapsuleList.length !== 1) {
      return;
    }

    for (const liveCapsule of progressCapsuleList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
      if (capsuleVm.fixedShowType !== CapsuleShowType.HANGING_HOLE) {
        continue;
      }
      capsuleVm.fixedShowType = CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED;
    }
  }

  private moveScreen2ProgressCapsule() {
    if (this.showCapsuleList[CapsuleType.SCREEN_RECORDING].length > 0 &&
      this.showCapsuleList[CapsuleType.PROGRESS].length === 0 &&
      this.showCapsuleList[CapsuleType.PERSISTENT].length === 0) {
      for (const liveCapsule of this.showCapsuleList[CapsuleType.SCREEN_RECORDING]) {
        const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
        capsuleVm.fixedShowType = CapsuleShowType.HANGING_HOLE;
      }
      const screenCapsule = this.showCapsuleList[CapsuleType.SCREEN_RECORDING].splice(0);
      this.showCapsuleList[CapsuleType.PROGRESS].push(...screenCapsule);
      return;
    }
  }

  private printFixedWithAndeOffset(liveList: LiveNotification[]) {
    for (const liveCapsule of liveList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
      const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(liveCapsule);
      log.showInfo(`liveList ${liveCapsule.hashCode} (fixedWidth: ${capsuleVm.fixedWidth} fixedTextWidth:${capsuleMarqueeVm.fixedTextWidth} textWidth:${capsuleMarqueeVm.textWidth} ` +
        `fixedOffset:${capsuleVm.fixedOffsetX} ` +
        `fixedIsSplicing:${capsuleMarqueeVm.fixedIsSplicing} extendTextWidth:${capsuleMarqueeVm.extendTextWidth}` +
        `fixedExtendTextWidth:${capsuleMarqueeVm.fixedExtendTextWidth}` +
        `showType:${capsuleVm.fixedShowType} isShow:${capsuleVm.isShow} type: ${liveCapsule.type} typeCode: ${liveCapsule.typeCode} ` +
        `isVisible:${capsuleVm.isVisible}).`);
    }
    for (let i = CapsuleType.PROGRESS; i <= CapsuleType.PERSISTENT; i++) {
      this.printCapsuleListVmFixedWidthAndOffset(this.showCapsuleList[i], i);
    }
  }

  private printCapsuleListVmFixedWidthAndOffset(liveCapsuleList: NotificationArray<LiveNotification>,
    capsuleType: CapsuleType) {
    for (const liveCapsule of liveCapsuleList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
      const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(liveCapsule);
      log.showInfo(`capsule type(${capsuleType}) ${liveCapsule.hashCode} (fixedWidth:${capsuleVm.fixedWidth} ` +
        `fixedTextWidth:${capsuleMarqueeVm.fixedTextWidth} textWidth:${capsuleMarqueeVm.textWidth} ` +
        `fixedIsSplicing:${capsuleMarqueeVm.fixedIsSplicing} fixedTextWidth:${capsuleMarqueeVm.fixedTextWidth}` +
        `fixedExtendTextWidth:${capsuleMarqueeVm.fixedExtendTextWidth}` +
        `fixedOffset:${capsuleVm.fixedOffsetX} showType:${capsuleVm.fixedShowType} isShow:${capsuleVm.isShow} ` +
        `type: ${liveCapsule.type} typeCode: ${liveCapsule.typeCode} isVisible:${capsuleVm.isVisible}).`);
    }
  }
}