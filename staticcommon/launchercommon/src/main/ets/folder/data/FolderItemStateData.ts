/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
 *
 * 文件夹状态类，一个文件夹对应一个状态实例，提供统一读取状态变量接口
 */

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';

import type GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import GridLayoutUtil from '../../utils/GridLayoutUtil';
import { FolderState } from '../common/FolderConstans';
import { BaseFolderState, } from '../state/BaseFolderState';
import { SmallCloseState } from '../state/SmallCloseState';
import { FolderOpenStaticState } from '../state/FolderOpenStaticState';
import { FolderOpenSwipingState } from '../state/FolderOpenSwipingState';
import { BigOpeningState } from '../state/BigOpeningState';
import { SmallCloseShowingEndPageState } from '../state/SmallCloseShowingEndPageState';
import { BigCloseState } from '../state/BigCloseState';
import { SmallOpeningState } from '../state/SmallOpeningState';
import { SmallClosingState } from '../state/SmallClosingState';
import { BigClosingState } from '../state/BigClosingState';
import { ConvertingSmallToBigState } from '../state/ConvertingSmallToBigState';
import { ConvertingBigToSmallState } from '../state/ConvertingBigToSmallState';

const TAG = 'FolderItemStateData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

const stateLegalNext: Map<FolderState, FolderState> = new Map<FolderState, FolderState>([
  [FolderState.CONVERTING_SMALL_TO_BIG, FolderState.BIG_FOLDER_CLOSE],
  [FolderState.CONVERTING_BIG_TO_SMALL, FolderState.SMALL_FOLDER_CLOSE],
  [FolderState.SMALL_FOLDER_OPENING, FolderState.FOLDER_OPEN_STATIC],
  [FolderState.BIG_FOLDER_OPENING, FolderState.FOLDER_OPEN_STATIC],
  [FolderState.SMALL_FOLDER_CLOSING, FolderState.SMALL_FOLDER_CLOSE],
  [FolderState.BIG_FOLDER_CLOSING, FolderState.BIG_FOLDER_CLOSE],
]);

export class FolderItemStateData {
  private mFolderState: FolderState;
  private mFolderStateContext: BaseFolderState;

  constructor(item: GridLayoutItemInfo) {
    this.mFolderState = GridLayoutUtil.isSmallFolder(item) ? FolderState.SMALL_FOLDER_CLOSE : FolderState.BIG_FOLDER_CLOSE;
    this.mFolderStateContext = this.getFolderStateContextByState(this.mFolderState);
    log.showInfo(`FolderItemStateData constructor ${item.folderId} set state ${this.mFolderState}`);
  }

  /**
   * 获取文件夹状态
   *
   * @returns FolderState 文件夹当前状态
   */
  public getFolderState(): FolderState {
    return this.mFolderState;
  }

  /**
   * 获取展开态当前页数
   *
   * @returns number 展开态当前页数
   */
  public getOpenFolderPageIndex(): number | undefined {
    return AppStorage.get('openFolderPageIndex');
  }

  /**
   * 设置展开态当前页数
   *
   * @returns number 展开态当前页数
   */
  public setOpenFolderPageIndex(index: number): void {
    AppStorage.setOrCreate('openFolderPageIndex', index);
  }

  /**
   * 中间状态结束后，转移到下一个合法的稳定状态
   *
   * @returns boolean 是否转移成功
   */
  public setTransitionFinish(): boolean {
    let nextState: FolderState | undefined = stateLegalNext.get(this.mFolderState);
    if (nextState) {
      log.showInfo(`setTransitionFinish ${this.mFolderState} to ${nextState}`);
      this.mFolderState = nextState;
      this.mFolderStateContext = this.getFolderStateContextByState(nextState);
      return true;
    }
    return false;
  }

  /**
   * 设置文件夹当前状态
   *
   * @param nextState 下一个状态
   */
  public setFolderState(nextState: FolderState): void {
    log.showInfo(`setFolderState ${this.mFolderState} to ${nextState}`);
    this.mFolderState = nextState;
    this.mFolderStateContext = this.getFolderStateContextByState(nextState);
  }

  /**
   * 设置文件夹当前状态对应的操作类
   *
   * @return BaseFolderState 对应操作类的实例
   */
  public getFolderStateContext(): BaseFolderState {
    return this.mFolderStateContext;
  }

  /**
   * 当前展开态是否在滑动中
   *
   * @return boolean 是否在滑动中
   */
  public isFolderOpenSwiping(): boolean {
    return this.mFolderState === FolderState.FOLDER_OPEN_SWITCHING;
  }

  private getFolderStateContextByState(folderState: FolderState): BaseFolderState {
    switch (folderState) {
      case FolderState.SMALL_FOLDER_CLOSE:
        return new SmallCloseState();
      case FolderState.SMALL_FOLDER_CLOSE_ENDING_PAGE:
        return new SmallCloseShowingEndPageState();
      case FolderState.BIG_FOLDER_CLOSE:
        return new BigCloseState();
      case FolderState.SMALL_FOLDER_OPENING:
        return new SmallOpeningState();
      case FolderState.BIG_FOLDER_OPENING:
        return new BigOpeningState();
      case FolderState.SMALL_FOLDER_CLOSING:
        return new SmallClosingState();
      case FolderState.BIG_FOLDER_CLOSING:
        return new BigClosingState();
      case FolderState.FOLDER_OPEN_STATIC:
        return new FolderOpenStaticState();
      case FolderState.CONVERTING_SMALL_TO_BIG:
        return new ConvertingSmallToBigState();
      case FolderState.CONVERTING_BIG_TO_SMALL:
        return new ConvertingBigToSmallState();
      case FolderState.FOLDER_OPEN_SWITCHING:
        return new FolderOpenSwipingState();
      default:
        log.showError(`getFolderStateContextByState error ,state = ${folderState}`);
        return new BaseFolderState();
    }
  }
}

