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
import { AccessibilityManager, ResourceManager, GlobalContext } from '@ohos/frameworkwrapper';
import { CommonConstants, FolderCommonUtil, GridLayoutItemInfo, GridLayoutUtil } from '@ohos/launchercommon';
import type ctx from '@ohos.app.ability.common';
import { BigFolderViewModel } from '../viewmodel/BigFolderViewModel';
import { batchUninstallChain, ForwardType } from '@ohos/launchercommon/Index';

const TAG: string = 'FolderAccessibilityUtils';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹无障碍屏幕朗读相关方法类
 */
export class FolderAccessibilityUtils {
  /**
   * 在无障碍模式打开文件夹主动播报
   */
  public static async textAnnouncedForFolderOpen(folderInfo:GridLayoutItemInfo): Promise<void> {
    const accessibilityManager = AccessibilityManager.getInstance();
    const isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode) {
      let readerText: string = GlobalContext.getContext()?.resourceManager
        .getPluralStringValueSync($r('app.plural.folder_is_open_and_total_screen').id,
          folderInfo.layoutInfo?.length || 1) || '';
      readerText = `${BigFolderViewModel.getInstance().getRealFolderName(folderInfo.folderName || '')},${readerText}`;
      log.showInfo(`textAnnouncedForFolderOpen ${readerText}`);
      accessibilityManager.sendTextAnnouncedForAccessibility(readerText, 'textAnnouncedForFolderOpen');
    }
  }

  /**
   * 在无障碍模式关闭文件夹主动播报
   */
  public static async textAnnouncedForFolderClose(folderName: string): Promise<void> {
    const accessibilityManager = AccessibilityManager.getInstance();
    const isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode && batchUninstallChain.currentType != ForwardType.DRAG_DROP) {
      let readerText: string = await ResourceManager.getInstance()
        .getStringByIdSync($r('app.string.folder_is_closed').id);
      readerText = `${FolderCommonUtil.getRealFolderName(folderName)},${readerText}`;
      log.showInfo(`textAnnouncedForFolderClose ${readerText}`);
      accessibilityManager.sendTextAnnouncedForAccessibility(readerText, 'textAnnouncedForFolderClose');
    }
  }

  /**
   * 在无障碍模式清除文件夹名主动播报
   */
  public static async textAnnouncedForNameCleared(): Promise<void> {
    const accessibilityManager = AccessibilityManager.getInstance();
    const isAccessibilityMode: boolean = accessibilityManager.getIsAccessibilityMode();
    if (isAccessibilityMode) {
      let readerText: string = await ResourceManager.getInstance()
        .getStringByIdSync($r('app.string.folder_rename_cleared').id);
      log.showInfo(`textAnnouncedForNameCleared ${readerText}`);
      accessibilityManager.sendTextAnnouncedForAccessibility(readerText, 'textAnnouncedForNameCleared');
    }
  }

  /**
   * 获取在无障碍模式下文件夹内图标点击事件名称
   */
  public static getFolderItemAccessibilityClickEventName(folderItem:GridLayoutItemInfo): string {
    return GridLayoutUtil.isAddIcon(folderItem) ? `folderAddIconClickEvt` : `folderAppItemClickEvt-${folderItem.keyName}`;
  }

  /**
   * 在无障碍模式下主动聚焦到目标文件夹
   * @param folderId
   */
  public static updateAccessibilityFocusable(folderId: string, isInterrupt: boolean = true): void {
    const isAccessibilityMode: boolean = AccessibilityManager.getInstance().getIsAccessibilityMode();
    if (isAccessibilityMode && batchUninstallChain.currentType != ForwardType.DRAG_DROP) {
      AccessibilityManager.getInstance().requestFocusAccessibility(
        CommonConstants.FOLDER_ACCESSIBILITY_TAG + folderId, isInterrupt);
    }
  }
}
