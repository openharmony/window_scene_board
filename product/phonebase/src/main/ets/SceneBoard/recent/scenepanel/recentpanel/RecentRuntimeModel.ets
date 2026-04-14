/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray
} from '@ohos/windowscene';
import {
  DebugCommand,
  DebugCommandManager,
  DeviceHelper,
  HiSysEventUtil,
  ReportParams,
} from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { recentLayoutConfigInstance } from '@ohos/recents/src/main/ets/TsIndex';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import {
  GoIntoRecentParams,
  MidSceneState,
  ReturnToHomeParams
} from '@ohos/frameworkwrapper/src/main/ets/hisysevent/ReportParams';
import { HiSysReturnHomeData } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/HiSysData';

const TAG = 'RecentRuntimeModel';

export class RecentRuntimeModel {
  public readonly MAX_COUNTS_SHOW_IN_RECENT_SINGLE_ROW: number = 16;
  public readonly MAX_COUNTS_SHOW_IN_RECENT_MULTI_ROW: number = 18;
  public containerCountsShowInRecent: number = 0;

  public notRemovingSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
  public needRemoveSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
  public autoCenterColumn: number = -1;
  public touchEvent: TouchEvent | null = null;
  public touchContainerIndex: number = -1;
  private startPos: number[] = [];
  private endPos: number[] = [];
  constructor() {
    this.registerDebugCommand();
  }

  public init(totalContainerSessionList: SCBSceneContainerSessionArray): void {
    if (!totalContainerSessionList) {
      return;
    }
    this.notRemovingSessionList.clear();
    totalContainerSessionList.forEach((item) => {
      if (!item.pendingRemove) {
        this.notRemovingSessionList.push(item);
      }
    });
    this.initContainerCountsShowInRecent();
  }

  public update(totalContainerSessionList: SCBSceneContainerSessionArray): void {
    if (!totalContainerSessionList) {
      return;
    }
    this.notRemovingSessionList.clear();
    totalContainerSessionList.forEach((item) => {
      if (!item.pendingRemove) {
        this.notRemovingSessionList.push(item);
      }
    });
  }

  public initContainerCountsShowInRecent(): void {
    this.containerCountsShowInRecent = Math.min(RecentRuntimeModel.getMaxCountsShowInRecent(),
      this.notRemovingSessionList.length);
  }

  public get autoCenterContainerSession(): SCBSceneContainerSession | undefined {
    let autoCenterIndex = this.getAbsoluteIndexByColumn(this.autoCenterColumn);
    return this.notRemovingSessionList?.[autoCenterIndex];
  }

  public get touchContainerSession(): SCBSceneContainerSession | undefined {
    return this.notRemovingSessionList?.[this.touchContainerIndex];
  }

  public get leftBoundaryIndex(): number {
    return Math.max(0, this.notRemovingSessionList.length - this.containerCountsShowInRecent);
  }

  public get rightBoundaryIndex(): number {
    return Math.max(0, this.notRemovingSessionList.length - 1);
  }

  public get leftBoundaryColumn(): number {
    if (!recentLayoutConfigInstance.isNeedMultiRowLayout()) {
      return this.leftBoundaryIndex;
    }
    return Math.floor((this.leftBoundaryIndex + 1) / 2);
  }

  public get rightBoundaryColumn(): number {
    if (!recentLayoutConfigInstance.isNeedMultiRowLayout()) {
      return this.rightBoundaryIndex;
    }
    return this.leftBoundaryColumn + Math.floor((this.rightBoundaryIndex - this.leftBoundaryIndex) / 2);
  }

  public getSafeIndex(index: number): number {
    return Math.max(Math.min(index,
      recentRuntimeInstance.rightBoundaryIndex), recentRuntimeInstance.leftBoundaryIndex);
  }

  public getAbsoluteColumn(index: number): number {
    if (!recentLayoutConfigInstance.isNeedMultiRowLayout()) {
      return index;
    }
    return Math.floor((index - recentRuntimeInstance.leftBoundaryIndex +
      (recentRuntimeInstance.rightBoundaryIndex - recentRuntimeInstance.leftBoundaryIndex + 1) % 2) / 2) +
    recentRuntimeInstance.leftBoundaryColumn;
  }

  public getRelativeColumn(index: number): number {
    return this.getAbsoluteColumn(index) - recentRuntimeInstance.leftBoundaryColumn;
  }

  public getAbsoluteIndexByColumn(column: number): number {
    if (!recentLayoutConfigInstance.isNeedMultiRowLayout()) {
      return column;
    }
    // 先计算显示在多任务中的列对应的index，再加上左边界index，计算的结果是同一列中的大的index
    let index = (column - recentRuntimeInstance.leftBoundaryColumn) * 2 +
      (recentRuntimeInstance.containerCountsShowInRecent + 1) % 2 +
    recentRuntimeInstance.leftBoundaryIndex;
    return recentRuntimeInstance.getSafeIndex(index);
  }

  public set navigationStartPos(startPos: number[]) {
    this.startPos = startPos;
  }

  public get navigationStartPos(): number[] {
    return this.startPos;
  }

  public set navigationEndPos(endPos: number[]) {
    this.endPos = endPos;
  }

  public get navigationEndPos(): number[] {
    return this.endPos;
  }

  public static getMaxCountsShowInRecent(): number {
    return recentLayoutConfigInstance.isNeedMultiRowLayout() ?
    recentRuntimeInstance.MAX_COUNTS_SHOW_IN_RECENT_MULTI_ROW :
    recentRuntimeInstance.MAX_COUNTS_SHOW_IN_RECENT_SINGLE_ROW;
  }

  public exit(): void {
    this.notRemovingSessionList.clear();
    this.autoCenterColumn = -1;
    this.touchEvent = null;
    this.touchContainerIndex = -1;
    this.containerCountsShowInRecent = 0;
    this.needRemoveSessionList.clear();
  }

  public touchEventEqualTo(event: TouchEvent): boolean {
    if (!event || !this.touchEvent) {
      return false;
    }
    if (event.type !== this.touchEvent.type) {
      return false;
    }
    if (event.touches.length !== this.touchEvent.touches.length) {
      return false;
    }
    if ((event.touches[0]?.displayX === this.touchEvent.touches[0]?.displayX) &&
      (event.touches[0]?.displayY === this.touchEvent.touches[0]?.displayY)) {
      return true;
    }
    return false;
  }

  public static getInstance(): RecentRuntimeModel {
    return SingletonHelper.getInstance(RecentRuntimeModel, TAG);
  }

  /**
   * 获取任务中心显示的containerList
   * @returns
   */
  public getVisibleContainerList(): SCBSceneContainerSessionArray {
    const array = new SCBSceneContainerSessionArray();
    for (let index = this.leftBoundaryIndex; index <= this.rightBoundaryIndex; index++) {
      array.push(this.notRemovingSessionList[index]);
    }
    return array;
  }

  /**
   * 手势上滑回桌面
   *
   * @param from APP:从应用上滑，DESKTOP:从桌面上滑
   * @param startPos 手势起始位置
   * @param endPos 手势抬手位置
   * @param curBundleName 当前应用包名
   */
  public reportReturnToHome(from: string, curBundleName?: string, isMidScene?: boolean): void {
    let params: ReturnToHomeParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      FROM: from,
      START_POS: recentRuntimeInstance.navigationStartPos,
      END_POS: recentRuntimeInstance.navigationEndPos,
      DEVICE_STATUS: DeviceHelper.isFold() ? (DeviceHelper.isFoldExpanded() ? 1 : 2) : 0,
      ORIENTATION: DeviceHelper.getOrientation(),
      CUR_BUNDLE_NAME: curBundleName,
      SCREEN_TYPE: 0,
      IS_MIDSCENE: isMidScene ? MidSceneState.IS_MID_SCENE : MidSceneState.IS_NOT_MID_SCENE,
      INTELLIGENT_SCENE_MODE_ID: from === HiSysReturnHomeData.FROM_APP ? HiSysEventUtil.getIntelligentSceneModeId() : '-1',
    };
    HiSysEventUtil.reportReturnToHome(params);
  }

  /**
   * 大数据打点，进入多任务
   */
  public reportGoIntoRecent(from: string, deviceStatus: number, orientation: number, curBundleName: string,
    sessionNumber: number, isMidScene?: boolean): void {
    let params: GoIntoRecentParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      FROM: from,
      START_POS: recentRuntimeInstance.navigationStartPos,
      END_POS: recentRuntimeInstance.navigationEndPos,
      DEVICE_STATUS: deviceStatus,
      ORIENTATION: orientation,
      CUR_BUNDLE_NAME: curBundleName,
      SESSION_NUMBER: sessionNumber,
      IS_MIDSCENE: isMidScene ? MidSceneState.IS_MID_SCENE : MidSceneState.IS_NOT_MID_SCENE,
      SCREEN_TYPE: 0
    };
    HiSysEventUtil.reportGoIntoRecent(params);
  }

  private debugCommand(): string {
    let ret = 'not removing container session list length: ' + this.notRemovingSessionList.length.toString();
    ret += '\r\n';
    ret += 'auto center column: ' + this.autoCenterColumn.toString();
    ret += '\r\n';
    ret += 'touch container index: ' + this.touchContainerIndex.toString();
    return ret;
  }

  private registerDebugCommand(): void {
    let cmds: DebugCommand[] = [
      {
        cmdName: 'info',
        callback: (args: string[]): string => {
          return this.debugCommand();
        }
      }
    ];
    DebugCommandManager.getInstance().register(TAG, cmds);
  }
}

export const recentRuntimeInstance = RecentRuntimeModel.getInstance();