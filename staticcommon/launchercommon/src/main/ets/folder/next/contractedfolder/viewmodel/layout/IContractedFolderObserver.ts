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

import { FolderAppItemInfo, GridLayoutItemInfo } from '../../../../../TsIndex';
import { image } from '@kit.ImageKit';
import { IObserver } from '../../../common/observer/IObserver';

/**
 * 折叠态文件夹View组件的控制接口，用于控制调用方，目前仅对LayoutViewModel使用
 */
export interface IContractedFolderObserver {
  setMode(msg: string, mode: ContractedFolderMode): void;

  getChildOsr(msg: string, type: number): IObserver;

  setStatus(msg: string, type: number, isOn: boolean): void;

  getStatus(type: number): boolean;

  setData(msg: string, type: number, items: GridLayoutItemInfo[] | FolderAppItemInfo[]): void;

  getData(type: number): GridLayoutItemInfo[] | FolderAppItemInfo[];

  setImage(msg: string, type: number, image: image.PixelMap): void;

  getImage(type: number): image.PixelMap | null;

  setFolderTitleOpacity(msg: string, opacity: number): void;

  setFolderName(folderName: string): void;

  setDownloadOpacity(msg: string, opacity: number): void;

  getDownloadOpacity(): number;

  getObserverType(): number;

  updateBadge(items: GridLayoutItemInfo[]): void;

  getBadgeNumber(): number;

  updateBadgeAniType(type: number): void;

  isFolderImageMode(): boolean;

  /**
   * 设置多选选中元素的keyname列表
   *
   * @param selectNames 选中元素的keyname列表
   */
  setSelectItemNames(selectNames: string[]): void

  /**
   * 获取多选选中元素的keyname列表
   *
   * @returns 选择元素的keyname列表
   */
   getSelectItemNames(): string[]

  /**
   * 更新文件夹折叠态无障碍播报内容
   */
   updateAccessibilityText(accessibilityText: string): void
}

/**
 * 折叠态文件夹布局模式,包含菜单预览图模式和常规组件模式
 */
export enum ContractedFolderMode {
  MODE_COMPONENT,
  MODE_IMAGE,
}

/**
 * 折叠态文件夹observer类型
 */
export enum ContractedFolderObserverType {
  CONTRACTED_FOLDER_VIEW,
  CONTRACTED_FOLDER_BASE,
  CONTRACTED_FOLDER_DATA
}