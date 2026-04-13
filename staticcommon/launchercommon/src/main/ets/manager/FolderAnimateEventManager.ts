/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
import { GlobalContext } from '@ohos/frameworkwrapper';
import type ctx from '@ohos.app.ability.common';
import { FolderEventConstants } from '../constants/FolderEventConstants';

const TAG = 'FolderAnimateEventManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹动效事件管理类
 */
export class FolderAnimateEventManager {
  private static mInstance: FolderAnimateEventManager;

  static getInstance(): FolderAnimateEventManager {
    if (!FolderAnimateEventManager.mInstance) {
      FolderAnimateEventManager.mInstance = new FolderAnimateEventManager();
    }
    return FolderAnimateEventManager.mInstance;
  }

  private getContext(): ctx.ServiceExtensionContext {
    return (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
  }

  /**
   * 转场动效等待落位动效布局刷新完成事件
   *
   * @param groupId 对应的文件夹ID
   */
  public getWaitForDropAnimateRefreshEvent(foldId: string): string {
    log.showInfo('GetWaitForDropAnimateRefreshEvent foldId ：%{public}s ', foldId);
    return `${FolderEventConstants.FOLDER_WAIT_FOR_DROP_ANIMATE_REFRESH_EVENT}${foldId}`;
  }


  /**
   * 转场动效中落位动效布局刷新完成事件发送
   *
   * @param groupId 对应的文件夹ID
   */
  public sendWaitForDropAnimateRefreshEvent(foldId: string): void {
    log.showInfo('Send WaitForDropAnimateRefreshEvent  foldId ：%{public}s', foldId);
    this.getContext()?.eventHub.emit(this.getWaitForDropAnimateRefreshEvent(foldId));
  }
}