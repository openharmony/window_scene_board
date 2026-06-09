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

import { SingletonHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { OpenFolderAppBubbleLayout } from '../../../../viewmdoel/OpenFolderAppBubbleLayout';
import { AppIconData } from '../../../../../launchericon/viewmodel/AppIconData';

const TAG: string = 'ContractedFolderIconDataManager';

/**
 * 文件夹折叠态内的图标布局参数管理,包含图标布局参数和名称布局参数
 */
export class ContractedFolderIconDataManager extends OpenFolderAppBubbleLayout {
  // 有自定义蒙层的数据列表，用于拖拽改变文件夹大小过程中避免改变蒙层亮度
  private customMasks: AppIconData[] = [];

  /**
   * 获取做动效图标数量
   */
  public getIconDataLength(): number {
    return this.iconItems.size;
  }

  /**
   * 设置自定义蒙层的数据
   *
   * @param iconData AppIconData
   */
  public setCustomMask(iconData: AppIconData): void {
    this.customMasks.push(iconData);
  }

  /**
   * 是否有自定义蒙层
   *
   * @param iconData AppIconData
   * @returns true：有自定义蒙层
   */
  public isCustomMask(iconData: AppIconData): boolean {
    return this.customMasks.includes(iconData);
  }

  /**
   * 清空自定义蒙层数据
   */
  public clearCustomMasks(): void {
    this.customMasks = [];
  }
}

// 单例
export let folderIconDataMgr: ContractedFolderIconDataManager =
  SingletonHelper.getInstance(ContractedFolderIconDataManager, TAG);