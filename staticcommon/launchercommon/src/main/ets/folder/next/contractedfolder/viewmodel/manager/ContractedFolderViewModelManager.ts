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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { IContractedFolderRenameViewModel } from './IContracedFolderRenameViewModel';
import { IContractedFolderAppEventViewModel } from './IContractedFolderAppEventViewModel';
import { IContractedFolderDownloadViewModel } from './IContractedFolderDownloadViewModel';
import { IContractedFolderDragViewModel } from './IContractedFolderDragViewModel';
import { IContractedFolderEventViewModel } from './IContractedFolderEventViewModel';
import { IContractedFolderLongPressViewModel } from './IContractedFolderLongPressViewModel';
import { IContractedFolderOpenCloseViewModel } from './IContractedFolderOpenCloseViewModel';
import { IContractedFolderUninstallViewModel } from './IContractedFolderUninstallViewModel';

const TAG = 'ContractedFolderViewModelManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 折叠态文件feature层ViewModel管理器
 */
export class ContractedFolderViewModelManager {
  private static instance: ContractedFolderViewModelManager;

  private constructor() {
  }

  public static getInstance(): ContractedFolderViewModelManager {
    if (!ContractedFolderViewModelManager.instance) {
      ContractedFolderViewModelManager.instance = new ContractedFolderViewModelManager();
    }
    return ContractedFolderViewModelManager.instance;
  }

  /* TODO: 提前创建 */
  private array: Array<ContractedFolderViewModel> = [];

  /**
   * 注册feature层业务的ViewModel
   *
   * @param type 业务类型
   * @param viewModel 业务ViewModel
   */
  public register(type: ContractedFolderViewModelType, viewModel: ContractedFolderViewModel): void {
    if (this.array[type]) {
      log.showWarn(`the view model(${type}) has been registered, we will replace it ..`);
    }
    this.array[type] = viewModel;
  }

  /**
   * 根据业务类型获取业务ViewModel
   *
   * @param type 业务类型
   * @returns 业务ViewModel
   */
  public get(type: ContractedFolderViewModelType): ContractedFolderViewModel | undefined {
    return this.array[type];
  }
}

export type ContractedFolderViewModel = IContractedFolderOpenCloseViewModel |
IContractedFolderRenameViewModel | IContractedFolderLongPressViewModel | IContractedFolderDragViewModel |
IContractedFolderUninstallViewModel | IContractedFolderEventViewModel |
IContractedFolderDownloadViewModel | IContractedFolderAppEventViewModel;

/**
 * 业务类型的枚举
 */
export enum ContractedFolderViewModelType {
  RESIZE,
  RENAME,
  DRAG,
  OPEN_CLOSE,
  LONG_PRESS,
  CONVERT_SIZE,
  UNINSTALL,
  EVENT,
  DOWNLOAD,
  APP_EVENT
}