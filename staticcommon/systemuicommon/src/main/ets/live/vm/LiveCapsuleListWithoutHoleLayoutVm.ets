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
import { LiveNotification } from '../model/LiveNotification';
import { CapsuleShowType } from '../model/LiveCommonModel';
import { NotificationArray } from '../../model/NotificationBase';
import { ILiveCapsuleVm } from '../interface/ILiveCapsuleVm';
import { ILiveCapsuleListLayoutVm } from '../interface/ILiveCapsuleLayoutVm';
import { LiveType } from '../model/LiveCommonModel';
import { LiveCapsuleListLayoutBaseVm } from './LiveCapsuleListLayoutBaseVm';
import { StatusBarCapsulePosition } from '../../statusbar/model/StatusBarCapsulePosition';
import { LiveStyle } from '../constants/LiveStyle';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { StatusBarHeightVm } from '../../statusbar/vm/StatusBarHeightVm';

const TAG = 'LiveCapsuleListWithoutHoleLayoutVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export enum CapsuleType {
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
export class LiveCapsuleListWithoutHoleLayoutVm extends LiveCapsuleListLayoutBaseVm
implements ILiveCapsuleListLayoutVm {
  public readonly baseGap: number = 4;
  public readonly capsuleStateGap: number = 4;
  public readonly shadowCapsuleGap: number = 0;
  @Trace public capsuleListWidth?: number | undefined = 0;
  public capsuleListFixedWidth?: number | undefined = 0;
  protected totalFreeSpace: number = 0;
  protected isUpdate: boolean = false;
  protected showCapsuleList: NotificationArray<LiveNotification>[] =
    [new NotificationArray<LiveNotification>(), new NotificationArray<LiveNotification>(),
      new NotificationArray<LiveNotification>()]; /* 分别记录进度，录屏和长时胶囊数 */

  protected readonly showCapsuleTypeSequence: number[] =
    [CapsuleShowType.TOP, CapsuleShowType.SELF_ADAPTIVE_ROUND_CAKE, CapsuleShowType.ROUND_CAKE];
  protected readonly capsuleSpaceAllocationSequence: CapsuleType[] =
    [CapsuleType.PROGRESS, CapsuleType.SCREEN_RECORDING, CapsuleType.PERSISTENT];

  // 计算整个胶囊列表所占的宽度
  protected computeCapsuleListWidth(liveList:LiveNotification[]): void {
    let offsetRight = 0;
    for (const live of liveList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      offsetRight = Math.max(offsetRight, capsuleVm.fixedOffsetX + capsuleVm.fixedWidth);
    }
    // 胶囊和通知图标间隔为6vp，通知图标本身有4vp margin，所以如果存在胶囊，整个胶囊列表右侧预留2vp宽度
    this.capsuleListFixedWidth = offsetRight > 0 ? offsetRight + 2 : offsetRight;
    log.showInfo(`total capsuleList fixed length: ${this.capsuleListFixedWidth}, now length: ${this.capsuleListWidth}`);
  }

  public computeCapsuleFixedWithAndOffset(liveList: LiveNotification[], isUpdate: boolean = true): void {
    const position = this.vmInjector.getCapsuleListVm().position;
    if (!this.checkParam(liveList, position)) {
      log.showWarn('check parm is invalid.');
      this.computeCapsuleListWidth(liveList);
      return;
    }
    this.initParam(position, isUpdate);
    this.clearShowCapsuleList();
    this.filterShowCapsuleList(liveList);
    this.updateFixedWidth();
    this.updateFixedOffset();
    this.updateStatusBarHeight(liveList);
    this.computeCapsuleListWidth(liveList);
    this.printFixedWithAndeOffset(liveList);
  }

  // 无孔场景状态栏高度更新，统计胶囊数量时需考虑只有录屏胶囊的场景。
  protected updateStatusBarHeight(liveList: LiveNotification[]): void {
    let showCapsuleNum = 0;
    for (const live of liveList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      if (!capsuleVm.isShow) {
        continue;
      }
      showCapsuleNum += 1;
    }
    if (showCapsuleNum > 0) {
      const avoidHeight = StatusBarHeightVm.getInstance().getAvoidHeight();
      StatusBarHeightVm.getInstance().preSetShowHeight(avoidHeight + 1, this.statusbarHeightChangeTag);
    } else {
      StatusBarHeightVm.getInstance().clearShowHeight(this.statusbarHeightChangeTag);
    }
  }

  protected checkParam(liveList: LiveNotification[], position?: StatusBarCapsulePosition): boolean {
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

  protected initParam(position?: StatusBarCapsulePosition, isUpdate?: boolean) {
    if (!position) {
      return;
    }

    this.totalFreeSpace = this.getFreeSpace(position.capsuleLeftMin, position.capsuleRightMax);
    this.totalFreeSpace =
      this.totalFreeSpace > this.getSpaceBetweenCapsuleAndStatusBar() ?
        this.totalFreeSpace - this.getSpaceBetweenCapsuleAndStatusBar() :
      this.totalFreeSpace;
    this.clearShowCapsuleList();
    this.isUpdate = isUpdate ?? true;
  }

  protected clearShowCapsuleList(): void {
    for (const liveCapsuleList of this.showCapsuleList) {
      liveCapsuleList.clear();
    }
  }

  public setRemindCapsuleWidth(live: LiveNotification, isUpdateImmediately: boolean): void {
    const capsuleVm = this.vmInjector.getCapsuleVm(live);
    const capsuleMarqueeVm = this.vmInjector.getCapsuleMarqueeVm(live);
    const maxWidth = this.getRemindCapsuleMaxWidth();

    capsuleVm.fixedShowType = CapsuleShowType.TOP;
    capsuleVm.fixedWidth = 0;
    this.adjustFixedWidth(maxWidth, live, isUpdateImmediately);
    capsuleVm.fixedOffsetX = this.getRemindCapsuleOffset();
    // 强提醒
    if (live.isFlip()) {
      return;
    }

    // 长时、即时
    capsuleVm.isShow = true;
    this.capsuleListFixedWidth = capsuleVm.fixedWidth + capsuleVm.fixedOffsetX + 2;
    log.showInfo(`remind capsuleWidth ${capsuleVm.fixedWidth}, ${capsuleMarqueeVm.fixedTextWidth}`);
  }

  protected filterShowCapsuleList(liveList: LiveNotification[]) {
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
          capsuleVm.fixedShowType = CapsuleShowType.TOP;
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
        this.showCapsuleTypeSequence);
    }
    log.showInfo(`progress capsule hashcode list(${this.showCapsuleList[CapsuleType.PROGRESS].map((value) => value.hashCode)
      .join(',')})`);
    log.showInfo(`progress capsule show type list(${this.showCapsuleList[CapsuleType.PROGRESS].map((value) => this.vmInjector.getCapsuleVm(value)
      .fixedShowType).join(',')})`);
    log.showInfo(`screen recording capsule hashcode list(${this.showCapsuleList[CapsuleType.SCREEN_RECORDING].map((value) => value.hashCode)
      .join(',')}`);
    log.showInfo(`screen recording capsule hashcode list(${this.showCapsuleList[CapsuleType.SCREEN_RECORDING].map((value) => this.vmInjector.getCapsuleVm(value)
      .fixedShowType).join(',')}`);
  }

  protected pushLiveCapsule2List(capsuleList: NotificationArray<LiveNotification> | undefined,
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

  protected getCapsuleGap(liveCapsuleVm: ILiveCapsuleVm): number {
    if (liveCapsuleVm.fixedShowType === CapsuleShowType.SHADOW) {
      return this.shadowCapsuleGap;
    }
    return this.capsuleStateGap;
  }

  protected updateFixedWidth(): void {
    let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray();
    const mandatoryElementIdx: number = this.generateCapsuleShowListByPrioritySort(capsuleShowList);

    log.showInfo(`updateFixedWidth capsuleShowList ${capsuleShowList.map((value) => value.hashCode).join(',')}}`);
    log.showInfo(`updateFixedWidth capsuleShowList ${capsuleShowList.map((value) => this.vmInjector.getCapsuleVm(value)
      .fixedShowType).join(',')}}`);
    const freeSpace = this.totalFreeSpace;
    log.showInfo(`updateFixedWidth freeSpace ${freeSpace}.`);
    let remainSpace = this.computeCapsuleShowFlag(capsuleShowList, mandatoryElementIdx, freeSpace);

    /* 常驻态胶囊，剩余空间分配顺序，先录屏，再进度，最后长时。 */
    const remainSpaceAllocationSequence: number[] =
      [CapsuleType.SCREEN_RECORDING, CapsuleType.PROGRESS, CapsuleType.PERSISTENT];
    for (const capsuleType of remainSpaceAllocationSequence) {
      remainSpace = this.adjustShowCapsuleWidth(remainSpace, this.showCapsuleList[capsuleType], capsuleType);
    }
    return;
  }

  protected getCapsuleType(live: LiveNotification): CapsuleType {
    if (live.isScreenRecorder()) {
      return CapsuleType.SCREEN_RECORDING;
    }
    return CapsuleType.PROGRESS;
  }

  protected computeCapsuleShowFlag(capsuleShowList: NotificationArray<LiveNotification>, mandatoryElementIdx: number,
    freeSpace: number): number {
    let usedSpace: number = this.getBaseGap();
    let isFoundHideCapsuleMap: Map<CapsuleType, boolean> =
      new Map([[CapsuleType.PROGRESS, false], [CapsuleType.SCREEN_RECORDING, false], [CapsuleType.PERSISTENT, false]]);
    for (let capsuleIdx = 0; capsuleIdx < capsuleShowList.length; capsuleIdx++) {
      const liveCapsule = capsuleShowList[capsuleIdx];
      const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
      if (capsuleVm.fixedShowType === CapsuleShowType.SELF_ADAPTIVE_ROUND_CAKE) {
        usedSpace =
          this.computeSelfAdaptiveRoundCakeCapsule(usedSpace, liveCapsule, isFoundHideCapsuleMap, freeSpace, capsuleVm);
      } else {
        usedSpace = this.computeSingleCapsuleShowFlag(liveCapsule, isFoundHideCapsuleMap, usedSpace, freeSpace);
      }

      if (capsuleIdx === mandatoryElementIdx && freeSpace > usedSpace) {
        usedSpace = this.reservedSpaceForMandatoryElement(mandatoryElementIdx, capsuleShowList, freeSpace, usedSpace);
      }
    }
    let remainSpace = freeSpace - usedSpace;
    log.showInfo(`computeCapsuleShowFlag (freeSpace:${freeSpace} usedSpace:${usedSpace} remainSpace:${remainSpace})`);
    return remainSpace;
  }

  protected reservedSpaceForMandatoryElement(mandatoryElementIdx: number,
    capsuleShowList: NotificationArray<LiveNotification>,
    freeSpace: number, usedSpace: number) {
    if (mandatoryElementIdx < 0) {
      return usedSpace;
    }

    for (let idx = 0; idx <= mandatoryElementIdx; idx++) {
      const liveCapsule = capsuleShowList[idx];
      const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
      if (capsuleVm.fixedShowType === CapsuleShowType.RETRACTABLE_ROUND_CAKE && capsuleVm.isShow) {
        const capsuleWidth = this.getMinWidth(liveCapsule);
        const expectCapsuleWidth = this.getExpectWidth(liveCapsule);
        const increaseWidth = expectCapsuleWidth - capsuleWidth;
        if (increaseWidth > 0 && freeSpace > usedSpace + increaseWidth) {
          usedSpace = usedSpace + increaseWidth;
          capsuleVm.fixedWidth = expectCapsuleWidth;
        }
      }
    }
    return usedSpace;
  }

  protected computeSelfAdaptiveRoundCakeCapsule(usedSpace: number, liveCapsule: LiveNotification,
    isFoundHideCapsuleMap: Map<CapsuleType, boolean>,
    freeSpace: number, capsuleVm: ILiveCapsuleVm) {
    const showTypeList: CapsuleShowType[] = [CapsuleShowType.TOP, CapsuleShowType.ROUND_CAKE];
    let i = 0;
    for (; i < showTypeList.length; i++) {
      capsuleVm.fixedShowType = showTypeList[i];
      usedSpace =
        this.computeSingleCapsuleShowFlag(liveCapsule, isFoundHideCapsuleMap, usedSpace, freeSpace);
      const capsuleType = this.getCapsuleType(liveCapsule);
      if (!isFoundHideCapsuleMap.get(capsuleType)) {
        break;
      }

      if (i !== showTypeList.length - 1) {
        isFoundHideCapsuleMap.set(capsuleType, false);
      }
    }
    return usedSpace;
  }

  protected computeSingleCapsuleShowFlag(liveCapsule: LiveNotification,
    isFoundHideCapsuleMap: Map<CapsuleType, boolean>, usedSpace: number, freeSpace: number) {
    const capsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
    const capsuleWidth = this.getMinWidth(liveCapsule);
    const capsuleType = this.getCapsuleType(liveCapsule);
    if (this.isNeedShow(capsuleVm) && !isFoundHideCapsuleMap.get(capsuleType)) {
      const newLeftUsedSpace = usedSpace + capsuleWidth + this.getCapsuleGap(capsuleVm);
      if (freeSpace >= newLeftUsedSpace) {
        usedSpace = newLeftUsedSpace;
        capsuleVm.isShow = true;
        capsuleVm.fixedWidth = capsuleWidth;
      } else {
        log.showInfo(`computeCapsuleShowFlag ${usedSpace} newLeftUsedSpace ${newLeftUsedSpace} leftFreeSpace ${freeSpace}`);
        isFoundHideCapsuleMap.set(capsuleType, true);
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

  protected adjustShowCapsuleWidth(remainSpace: number, capsuleList: NotificationArray<LiveNotification>,
    capsuleType: CapsuleType): number {
    for (const live of capsuleList) {
      const capsuleVm = this.vmInjector.getCapsuleVm(live);
      if (!capsuleVm.isShow) {
        continue;
      }
      log.showInfo(`adjustShowCapsuleWidth live capsule(type ${capsuleType}) ` +
        `hashCode ${live.hashCode} remainSpace ${remainSpace}`);
      if (this.isNeedShow(capsuleVm)) {
        const usedSpace = this.adjustFixedWidth(remainSpace, live, this.isUpdate);
        remainSpace = remainSpace - usedSpace;
        if (remainSpace <= 0) {
          continue;
        }
      }
    }
    return remainSpace;
  }

  protected generateCapsuleShowListByPrioritySort(capsuleShowList: NotificationArray<LiveNotification>): number {
    let mandatoryElementIdx: number = -1;
    this.capsuleSpaceAllocationSequence.forEach(type => {
      const capsuleList = this.showCapsuleList[type];
      if (!capsuleList) {
        return;
      }
      if (capsuleList.length > 0) {
        capsuleShowList.push(capsuleList[0]);
        mandatoryElementIdx++;
      }
    });
    this.capsuleSpaceAllocationSequence.forEach(type => {
      const capsuleList = this.showCapsuleList[type];
      if (!capsuleList) {
        return;
      }
      for (let idx = 1; idx < capsuleList.length; idx++) {
        capsuleShowList.push(capsuleList[idx]);
      }
    });
    return mandatoryElementIdx;
  }

  protected isNeedShow(capsuleVm: ILiveCapsuleVm): boolean {
    return capsuleVm.fixedShowType === CapsuleShowType.TOP ||
      capsuleVm.fixedShowType === CapsuleShowType.ROUND_CAKE ||
      capsuleVm.fixedShowType === CapsuleShowType.RETRACTABLE_ROUND_CAKE;
  }

  protected getFreeSpace(capsuleLeftMin: number, capsuleRightMax: number): number {
    return (capsuleRightMax > capsuleLeftMin) ? (capsuleRightMax - capsuleLeftMin) : 0;
  }

  protected updateFixedOffset(): void {
    /* 常驻态胶囊，布局顺序，先录屏，再长时，最后进度。 */
    const capsuleLayoutSequence: number[] =
      [CapsuleType.SCREEN_RECORDING, CapsuleType.PERSISTENT, CapsuleType.PROGRESS];
    let capsuleShowList: NotificationArray<LiveNotification> = new NotificationArray();

    for (const capsuleType of capsuleLayoutSequence) {
      for (const liveCapsule of this.showCapsuleList[capsuleType]) {
        const liveCapsuleVm = this.vmInjector.getCapsuleVm(liveCapsule);
        if (!liveCapsuleVm.isShow) {
          continue;
        }
        capsuleShowList.push(liveCapsule);
      }
    }

    log.showInfo(`updateFixedOffset PROGRESS ${capsuleShowList.map((value) => value.hashCode)
      .join(',')}}`);
    log.showInfo(`updateFixedOffset PROGRESS ${capsuleShowList.map((value) => this.vmInjector.getCapsuleVm(value)
      .fixedShowType).join(',')}}`);

    let totalOffset: number = this.getBaseGap();
    for (let i = 0; i < capsuleShowList.length; i++) {
      const currentCapsuleVm = this.vmInjector.getCapsuleVm(capsuleShowList[i]);
      if (i === 0) {
        totalOffset = totalOffset + this.getCapsuleGap(currentCapsuleVm);
        currentCapsuleVm.fixedOffsetX = totalOffset;
        continue;
      }
      const lastCapsuleVm = this.vmInjector.getCapsuleVm(capsuleShowList[i - 1]);
      totalOffset = totalOffset + (this.getCapsuleGap(currentCapsuleVm) + lastCapsuleVm.fixedWidth);
      currentCapsuleVm.fixedOffsetX = totalOffset;
    }
  }

  protected printFixedWithAndeOffset(liveList: LiveNotification[]) {
    for (const live of liveList) {
      const capsule = this.vmInjector.getCapsuleVm(live);
      log.showInfo(`liveList ${live.hashCode}} (fixedWidth: ${capsule.fixedWidth} fixedOffset:${capsule.fixedOffsetX} ` +
        `showType:${capsule.fixedShowType} isShow:${capsule.isShow}).`);
    }
    for (let i = CapsuleType.PROGRESS; i <= CapsuleType.PERSISTENT; i++) {
      this.printCapsuleListVmFixedWidthAndOffset(this.showCapsuleList[i], i);
    }
  }

  protected printCapsuleListVmFixedWidthAndOffset(liveCapsuleList: NotificationArray<LiveNotification>,
    capsuleType: CapsuleType) {
    for (const liveCapsule of liveCapsuleList) {
      const capsule = this.vmInjector.getCapsuleVm(liveCapsule);
      log.showInfo(`capsule type(${capsuleType}) ${liveCapsule.hashCode}} (fixedWidth:${capsule.fixedWidth} ` +
        `fixedOffset:${capsule.fixedOffsetX} showType:${capsule.fixedShowType} isShow:${capsule.isShow}).`);
    }
  }

  protected getBaseGap(): number {
    return this.baseGap;
  }

  protected getRemindCapsuleOffset(): number {
    return LiveStyle.CAPSULE_LEFT_STATUS_BAR_GAP_WITHOUT_HOLE;
  }

  protected getRemindCapsuleMaxWidth(): number {
    return LiveStyle.CAPSULE_REMIND_MAX_WIDTH;
  }
}