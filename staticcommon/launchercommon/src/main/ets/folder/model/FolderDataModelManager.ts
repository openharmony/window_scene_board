/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
} from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { FolderState } from '../common/FolderConstans';

import FolderDataModel from '../data/FolderDataModel';
import { BaseFolderState } from '../state/BaseFolderState';

const TAG = 'FolderDataModelManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class FolderDataModelManager {
  private static mInstance: FolderDataModelManager;
  private AllFolderItemMap: Map<String, FolderDataModel> = new Map<String, FolderDataModel>();
  private openFolderId: string = '';
  private mBackgroundBrightness: number = ResUtils.getNumber($r('app.float.ohos_id_blur_style_thin_brightness'));
  private mDegree: number = 0;
  private folderSwiperController?: SwiperController;

  protected constructor() {
  }

  static getInstance(): FolderDataModelManager {
    if (!FolderDataModelManager.mInstance) {
      log.showInfo('getInstance FolderDataModelManager');
      FolderDataModelManager.mInstance = new FolderDataModelManager();
    }
    return FolderDataModelManager.mInstance;
  }

  setSwiperController(swiperController: SwiperController | undefined): void {
    this.folderSwiperController = swiperController;
  }

  getSwiperController(): SwiperController | undefined {
    return this.folderSwiperController;
  }

  setBackgroundBrightness(backgroundBrightness: number): void {
    this.mBackgroundBrightness = backgroundBrightness;
  }

  getBackgroundBrightness(): number {
    return this.mBackgroundBrightness;
  }

  getDegree(): number {
    return this.mDegree;
  }

  setDegree(mDegree: number): void {
    this.mDegree = mDegree;
  }

  /**
   * updateFolderDataModel
   * @param item 布局信息
   * @returns 在Map中更新对应的FolderModel对象
   */
  public updateFolderDataModel(item: GridLayoutItemInfo): void {
    if (CheckEmptyUtils.checkStrIsEmpty(item.folderId)) {
      log.showWarn('createNewFolder fail because folderId is undefined');
      return;
    }
    if (!this.AllFolderItemMap.has(item.folderId as string)) {
      try {
        let newFolderItem = new FolderDataModel(item);
        log.showInfo(`folderId ready to set ${item.folderId}`);
        this.AllFolderItemMap.set(item.folderId as string, newFolderItem);
      } catch (err) {
        log.showError('FolderDataModel does not exist: failed %{public}d:%{public}s', err.code, err.message);
      }
    } else {
      this.AllFolderItemMap.get(item.folderId ?? '')?.setFolderItem(item);
      log.showInfo(`folderid ${item.folderId} has been set.`);
    }
  }

  /**
   * 判断传入的folderId是否在Map中注册
   * @param folderId
   * @returns boolean 传入的folderId是否在Map中注册
   */
  public isRegisteredFolderId(folderId: string): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(folderId)) {
      log.showWarn(`isRegisteredFolderId ineffective folderId is ${folderId}`);
      return false;
    }
    if (this.AllFolderItemMap.has(folderId as string)) {
      return true;
    } else {
      log.showWarn(`folderId: ${folderId} is not registered in the hash table`);
      return false;
    }
  }

  /**
   * 在Map中根据id删除对应的对象
   * @param folderId
   */
  public deleteFolderInMap(folderId: string): void {
    if (!this.isRegisteredFolderId(folderId)) {
      log.showWarn(`deleteFolderInMap, ineffective folderId is ${folderId}`);
      return;
    }
    log.showInfo(`deleteFolderInMap succeed, folderId is ${folderId}`);
    this.AllFolderItemMap.delete(folderId);
  }

  /**
   * 传入FolderDataList
   * @param folderList
   */
  public initFolderData(folderList: GridLayoutItemInfo[]): void {
    folderList.forEach((folderItem: GridLayoutItemInfo) => {
      this.updateFolderDataModel(folderItem);
    });
  }

  /**
   * 判断传入的folderId是否在Map中注册
   * @param folderId
   * @returns boolean 传入的folderId是否在Map中注册
   */
  public getFolderDataModelById(folderId: string): FolderDataModel | undefined {
    if (!this.isRegisteredFolderId(folderId)) {
      log.showWarn(`getFolderDataModelById, ineffective folderId is ${folderId}`);
      return undefined;
    }
    return this.AllFolderItemMap.get(folderId);
  }

  /**
   * 获取当前文件夹的状态
   * @param folderId
   * @returns FolderState 文件夹当前状态
   */
  public getFolderStateById(folderId: string): FolderState | undefined {
    if (!this.isRegisteredFolderId(folderId)) {
      log.showWarn(`getFolderStateById, ineffective folderId is ${folderId}`);
      return undefined;
    }
    return this.AllFolderItemMap.get(folderId)?.getState();
  }

  /**
   * 获取对应folderId的文件夹状态对应的操作类
   * @param folderId
   * @returns BaseFolderState 文件夹状态类对应的操作类
   */
  public getFolderStateContextById(folderId: string): BaseFolderState | undefined {
    if (!this.isRegisteredFolderId(folderId)) {
      log.showWarn(`getFolderStateContextById, ineffective folderId is ${folderId}`);
      return undefined;
    }
    return this.AllFolderItemMap.get(folderId)?.getStateContext();
  }

  /**
   * 设置对应folderId的文件夹状态对应的操作类
   * @param folderId
   * @param nextFolderState
   * @returns BaseFolderState 文件夹状态类对应的操作类
   */
  public setFolderStateById(folderId: string, nextFolderState: FolderState): void {
    if (!this.isRegisteredFolderId(folderId)) {
      log.showWarn(`setFolderStateById, ineffective folderId is ${folderId}`);
      return;
    }
    let nowState: FolderState | undefined = this.getFolderStateById(folderId);
    log.showInfo(`folderId: ${folderId} current state: ${nowState}, next state:${nextFolderState}`);
    this.AllFolderItemMap.get(folderId)?.setFolderState(nextFolderState);
  }

  /**
   * 获取当前展开态文件夹Id
   * @returns string 当前展开态文件夹Id
   */
  public getOpenFolderId(): string {
    return this.openFolderId;
  }

  /**
   * 设置当前展开态文件夹Id
   * @param openFolderId
   */
  public setOpenFolderId(openFolderId: string): void {
    if (CheckEmptyUtils.isEmpty(openFolderId)) {
      log.showWarn(`Ineffective openFolderId is ${openFolderId}`);
      return;
    }
    this.openFolderId = openFolderId;
  }

  /**
   * 文件夹打开或切页后，判断是否需要预加载下一页
   * @param folderId 文件夹Id
   * @param currentIndex 当前页
   */
  public onFolderPageChange(folderId: string, currentIndex: number): void {
    let folderDataModel: FolderDataModel | undefined = this.getFolderDataModelById(folderId);
    if (folderDataModel) {
      folderDataModel.setPageLoaded(currentIndex);
      if (folderDataModel.needPreLoadPage(currentIndex + 1)) {
        this.folderSwiperController?.preloadItems([currentIndex + 1], () => {
          folderDataModel?.setPageLoaded(currentIndex + 1);
          log.showInfo(`onFolderPageChange preload ${currentIndex + 1} success.`);
        });
      }
    }
  }
}
