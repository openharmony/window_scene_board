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

import { OpenFolderAppBubbleNodeManager } from '@ohos/bigfolder';
import {
  ContractedFolderViewModelLoader
} from '@ohos/bigfolder/src/main/ets/default/viewmodel/loader/ContractedFolderViewModelLoader';
import { AppBubbleParams } from '@ohos/launchercommon/Index';
import { FolderEventConstants } from '@ohos/launchercommon/src/main/ets/constants/FolderEventConstants';
import { desktopUtil } from '@ohos/componenthelper';
import { FolderSnapshotManager } from '@ohos/launchercommon/Index';

/**
 * 手机文件夹ViewModel配置加载器
 */
export class PhoneFolderViewModelLoader extends ContractedFolderViewModelLoader {
  constructor() {
    super();
  }

  /**
   * 初始化设备相关配置
   */
  public loadCommonConfig(): ContractedFolderViewModelLoader {
    this.preloadAddBubble();
    FolderSnapshotManager.getInstance()
      .setIsSupportPreviewMode(desktopUtil.isBarPhoneStatus() && !desktopUtil.isFold());
    return this;
  }

  /**
   * 预加载一个文件夹加号图标
   */
  private preloadAddBubble(): void {
    const addIconKey: string = FolderEventConstants.KEY_FOLDER_ADD;
    const appParams: AppBubbleParams = OpenFolderAppBubbleNodeManager.getInstance().getNodeParams(addIconKey || '');
    OpenFolderAppBubbleNodeManager.getInstance().updateNodeParams(addIconKey, appParams);
  }
}