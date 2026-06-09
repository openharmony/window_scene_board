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

import image from '@ohos.multimedia.image';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { FolderAppItemInfo, GridLayoutItemInfo } from '../../../../../TsIndex';
import { BadgeAnimationType } from '../../../../../uicomponents/CustomBadge';
import { FolderCommonConstants } from '../../../common/FolderCommonConstant';
import { BaseObserver } from '../../../common/observer/BaseObserver';
import { IObserver } from '../../../common/observer/IObserver';
import { ContractedFolderLayoutViewModel } from './ContractedFolderLayoutViewModel';
import {
  ContractedFolderMode,
  ContractedFolderObserverType,
  IContractedFolderObserver
} from './IContractedFolderObserver';

const TAG = 'ContractedFolderObserver';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 折叠态文件夹observer父类
 */
export class ContractedFolderObserver implements IContractedFolderObserver {
  @Track public folderId: string = '';
  private registered: boolean = false;
  protected type: number = ContractedFolderObserverType.CONTRACTED_FOLDER_BASE

  public constructor(folderId?: string) {
    if (folderId) {
      this.register(folderId);
    }
  }

  setImage(msg: string, type: number, image: image.PixelMap): void {
  }

  getImage(type: number): image.PixelMap | null {
    return null;
  }

  setData(msg: string, type: number, items: GridLayoutItemInfo[] | FolderAppItemInfo[]): void {
  }

  getData(type: number): GridLayoutItemInfo[] | FolderAppItemInfo[] {
    return [];
  }

  setStatus(msg: string, type: number, isOn: boolean): void {
  }

  getStatus(type: number): boolean {
    return false;
  }

  getChildOsr(msg: string, type: number): IObserver {
    return new BaseObserver();
  }

  setFolderName(folderName: string): void {
  }

  setDownloadOpacity(msg: string, opacity: number): void {
  }

  getDownloadOpacity(): number {
    return 0;
  }

  setFolderTitleOpacity(msg: string, opacity: number): void {
  }

  getObserverType(): number {
    return this.type;
  }

  setMode(msg: string, mode: ContractedFolderMode): void {
  }

  getBadgeNumber(): number {
    return 0;
  }

  updateBadge(items: GridLayoutItemInfo[]): void {
  }

  updateBadgeAniType(type: BadgeAnimationType): void {
  }

  isFolderImageMode(): boolean {
    return false;
  }

  updateAccessibilityText(accessibilityText: string): void {
  }

  /**
   * 注册文件夹observer信息
   *
   * @param folderId 文件夹id
   */
  public register(folderId: string): void {
    if (this.registered) {
      log.showInfo(`the observer of contracted folder(${this.folderId}) has been registered before ..`);
      return;
    }
    log.showInfo('register the observer %{public}s', this.folderId);
    this.folderId = folderId;
    ContractedFolderLayoutViewModel.getInstance().addObserver(folderId, this);
    // 填加一个默认observer，用于异常场景处理
    ContractedFolderLayoutViewModel.getInstance()
      .addObserver(FolderCommonConstants.INVALID_FOLDER_ID, new ContractedFolderObserver());
    this.registered = true;
  }

  /**
   * 取消文件夹observer的注册
   *
   * @param msg DFX日志
   */
  public release(msg: string): void {
    log.showInfo('release the observer %{public}s %{public}s', msg, this.folderId);
    ContractedFolderLayoutViewModel.getInstance().removeObserver(this.folderId);
    this.registered = false;
  }

  /**
   * 设置多选选中元素的keyname列表
   *
   * @param selectNames 选中元素的keyname列表
   */
  public setSelectItemNames(selectNames: string[]): void {
  }

  /**
   * 获取多选选中元素的keyname列表
   *
   * @returns 选择元素的keyname列表
   */
  public getSelectItemNames(): string[] {
    return [];
  }
}