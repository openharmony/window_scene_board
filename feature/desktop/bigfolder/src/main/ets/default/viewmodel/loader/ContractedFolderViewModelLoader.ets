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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  ContractedFolderLayoutViewModel,
  ContractedFolderViewModelManager,
  ContractedFolderViewModelType, FolderStyleManager } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { FolderAppEventViewModel } from '../app/FolderAppEventViewModel';
import { downloadAniMgr } from '../download/DownloadActionManager';
import { DownloadViewModel } from '../download/DownloadViewModel';
import { dragAniMgr } from '../drag/DragActionManager';
import { DragViewModel } from '../drag/DragViewModel';
import { eventFolderMgr } from '../event/ContractedFolderEventViewModel';
import { folderAniMgr } from '../event/FolderCommonActionManager';
import { OpenCloseViewModel } from '../openclose/OpenCloseViewModel';
import { pressAniMgr } from '../press/LongPressActionManager';
import { LongPressViewModel } from '../press/LongPressViewModel';
import { RenameViewModel } from '../rename/RenameViewModel';
import { uninstallAniMgr } from '../uninstall/UninstallActionManager';
import { UninstallViewModel } from '../uninstall/UninstallViewModel';

const TAG = 'ContractedFolderViewModelLoader';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹ViewModel配置加载器,产品侧继承该类实现差异化业务加载
 */
export class ContractedFolderViewModelLoader {
  protected mConfigList: Map<ContractedFolderViewModelType, () => void> = new Map();

  protected constructor() {
    this.initConfig();
  }

  /**
   * 初始化文件夹业务ViewModel
   */
  protected initConfig(): void {
    this.mConfigList.set(ContractedFolderViewModelType.LONG_PRESS, () => OpenCloseViewModel.getInstance());
    this.mConfigList.set(ContractedFolderViewModelType.DRAG, () => DragViewModel.getInstance());
    this.mConfigList.set(ContractedFolderViewModelType.OPEN_CLOSE, () => OpenCloseViewModel.getInstance());
    this.mConfigList.set(ContractedFolderViewModelType.LONG_PRESS, () => LongPressViewModel.getInstance());
    this.mConfigList.set(ContractedFolderViewModelType.RENAME, () => RenameViewModel.getInstance());
    this.mConfigList.set(ContractedFolderViewModelType.UNINSTALL, () => UninstallViewModel.getInstance());
    this.mConfigList.set(ContractedFolderViewModelType.DOWNLOAD, () => DownloadViewModel.getInstance());
    this.mConfigList.set(ContractedFolderViewModelType.APP_EVENT, () => FolderAppEventViewModel.getInstance());
    ContractedFolderViewModelManager.getInstance().register(ContractedFolderViewModelType.EVENT, eventFolderMgr);
  }

  /**
   * 加载文件夹业务ViewModel
   *
   * @param configs viewModel加载参数配置列表
   */
  public loadViewModelConfig(configs: ContractedFolderViewModelType[]): ContractedFolderViewModelLoader {
    configs.forEach(config => {
      let loadCallback: (() => void) | undefined = this.mConfigList.get(config);
      if (loadCallback) {
        log.showInfo('load folder feature view model %{public}d success', config);
        loadCallback();
      }
    });
    return this;
  }

  /**
   * 加载config配置
   *
   * @returns
   */
  public loadFolderStyle(): ContractedFolderViewModelLoader {
    FolderStyleManager.getInstance().initConfig();
    return this;
  }

  /**
   * 加载config配置值
   *
   * @returns
   */
  public loadFolderConfig(config: number): ContractedFolderViewModelLoader {
    ContractedFolderLayoutViewModel.getInstance().updateEnableAction(config);
    return this;
  }

  /**
   * 加载动效事件
   *
   * @returns
   */
  public loadAnimationEvent(): ContractedFolderViewModelLoader {
    uninstallAniMgr.registerActionEvent();
    pressAniMgr.registerActionEvent();
    folderAniMgr.registerFolderActionLife();
    dragAniMgr.registerDragActionEvent();
    downloadAniMgr.registerActionEvent();
    return this;
  }
}
