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

import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import { DesktopUtils, GridLayoutUtil } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { LaunchLayoutCacheManager } from '@ohos/launchercommon/src/main/ets/cache/layout/LaunchLayoutCacheManager';

const TAG = 'SCBDesktop';

export class SCBDesktopDebugCommand {
  private static mInstance: SCBDesktopDebugCommand;

  public static getInstance(): SCBDesktopDebugCommand {
    if (!SCBDesktopDebugCommand.mInstance) {
      SCBDesktopDebugCommand.mInstance = new SCBDesktopDebugCommand();
    }
    return SCBDesktopDebugCommand.mInstance;
  }

  public register(): void {
    let cmds: DebugCommand[] = [
      {
        cmdName: 'info',
        callback: (args: string[]): string => {
          return this.debugDesktopLayoutInfo(args);
        }
      },
      {
        cmdName: 'list',
        callback: (args: string[]): string => {
          return this.debugDesktopLayoutList(args);
        }
      },
      {
        cmdName: 'foldState',
        callback: (args: string[]): string => {
          return this.debugDesktopFoldState(args);
        }
      }
    ];
    DebugCommandManager.getInstance().register(TAG, cmds);
  }

  public unregister(): void {
    DebugCommandManager.getInstance().unregister(TAG);
  }

  private debugDesktopLayoutInfo(args: string[]): string {
    let layoutItemList = LaunchLayoutCacheManager.getInstance().getGridLayoutItemList();
    let ret = '';
    if (args.length === 0) {
      layoutItemList.forEach((item) => {
        ret += DesktopUtils.desktopItemsToString(item);
        ret += '\n';
      });
      return ret;
    }
    return DesktopUtils.desktopItemsToString(layoutItemList.find(item => GridLayoutUtil.generateUniqueKey(item) ===
    args[0]));
  }

  private debugDesktopLayoutList(args: string[]): string {
    let layoutItemList = LaunchLayoutCacheManager.getInstance().getGridLayoutItemList();
    let ret: string = '';
    layoutItemList.forEach((item) => {
      ret += GridLayoutUtil.generateUniqueKey(item) + `: ${item.folderName}/${item.fileFolderName}/${item.infoName} \n`;
    });
    return ret;
  }

  private debugDesktopFoldState(args: string[]): string {
    let ret: string = '';
    return ret;
  }
}
