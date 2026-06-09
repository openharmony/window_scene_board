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
import {
  LogDomain,
  LogHelper,
  SingletonHelper
} from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  GridItemPositionUtil,
  DragGridParam,
  DragGridPosition,
  DragPosition
} from '@ohos/componentdrag';
import { DebugCommand, DebugCommandManager } from '@ohos/frameworkwrapper';
import { FolderItemInfo, GridLayoutItemInfo, GridLayoutUtil } from '../../TsIndex';
import { Position } from '@kit.ArkUI';

const TAG: string = 'FolderGridPositionHelp';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 计算文件夹内网格位置工具类
 */
export class FolderGridPositionHelp {
  private isLoaded: boolean = false;
  private hookMap: Map<string, FolderGridPositionHook> = new Map();
  private gridMap: Map<string, GridItemPositionUtil> = new Map();
  private debug = new FolderGridPositionHelpDebug();

  public static getInstance(): FolderGridPositionHelp {
    return SingletonHelper.getInstance(FolderGridPositionHelp, TAG);
  }

  public load(): void {
    this.isLoaded = true;
  }

  public unload(): void {
    this.isLoaded = false;
    this.hookMap.clear();
    this.gridMap.clear();
  }

  /**
   * 注册文件夹布局钩子
   * @param hook
   */
  public registerHook(hook: FolderGridPositionHook): void {
    log.showInfo('registerHook %{public}s', hook.folderId);
    this.hookMap.set(hook.folderId ?? '', hook);
  }

  /**
   * 删除文件夹布局钩子
   * @param hook
   */
  public unregisterHook(hook: FolderGridPositionHook): void {
    log.showInfo('unregisterHook %{public}s', hook.folderId);
    this.hookMap.delete(hook.folderId ?? '');
  }

  /**
   * 获取文件夹的唯一id
   * @param folderItemInfo
   * @returns
   */
  public getUniqueId(folderItemInfo: GridLayoutItemInfo | FolderItemInfo): string {
    return GridLayoutUtil.generateUniqueKey(folderItemInfo as Object as GridLayoutItemInfo);
  }

  /**
   * 获取文件夹内某个grid的位置信息
   * @param folderItemInfo
   * @param row
   * @param col
   * @returns
   */
  public getPositionByRowCol(folderId: string, row: number, col: number): GridItemPositionInfo | undefined {
    log.showInfo('getPositionByRowCol folder: %{public}s row: %{public}s col: %{public}s', folderId, row, col);
    let gridItemPositionUtil = this.getFolderPositionUtil(folderId);
    if (gridItemPositionUtil) {
      const gridItemPosition: DragGridPosition = {
        row: row,
        column: col
      };
      const mLeftPosition: DragPosition = gridItemPositionUtil.getPosition(gridItemPosition);
      let leftTopX = mLeftPosition.x;
      let leftTopY = mLeftPosition.y;
      const mCenterPosition: DragPosition = gridItemPositionUtil.getCenterPosition({
        row: gridItemPosition.row,
        column: gridItemPosition.column,
        area: [1, 1]
      });
      let centerX = mCenterPosition.x;
      let centerY = mCenterPosition.y;
      return {
        leftTopX,
        leftTopY,
        centerX,
        centerY,
        width: Math.abs((leftTopX - centerX) * 2),
        height: Math.abs((leftTopY - centerY) * 2)
      };
    } else {
      return undefined;
    }
  }

  private getFolderPositionUtil(folderId: string): GridItemPositionUtil | undefined {
    const hook: FolderGridPositionHook | undefined = this.hookMap.get(folderId);
    if (!hook) {
      return undefined;
    }
    let gridParams: DragGridParam | undefined = hook.gridParamsCallback?.();
    if (!gridParams) {
      return undefined;
    }
    let paramsStr: string = Object.values(gridParams).join('_');

    let gridItemPositionUtil: GridItemPositionUtil | undefined = this.gridMap.get(paramsStr);
    if (typeof gridItemPositionUtil === 'undefined') {
      gridItemPositionUtil = new GridItemPositionUtil();
      gridItemPositionUtil.initPosition(gridParams);
      this.gridMap.set(paramsStr, gridItemPositionUtil);
    }
    return gridItemPositionUtil;
  }
}

export class FolderGridPositionHook {
  public folderId?: string;
  public gridParamsCallback?: () => DragGridParam;

  public init(folderId: string, gridParamsCallback: () => DragGridParam): void {
    log.showInfo('init folderHook %{public}s', this.folderId);
    this.folderId = folderId;
    this.gridParamsCallback = gridParamsCallback;
    FolderGridPositionHelp.getInstance().registerHook(this);
  }

  public destroy(): void {
    log.showInfo('destroy folderHook %{public}', this.folderId);
    FolderGridPositionHelp.getInstance().unregisterHook(this);
  }
}

export class GridItemPositionInfo {
  public width: number = 0;
  public height: number = 0;
  public leftTopX: number = 0;
  public leftTopY: number = 0;
  public centerX: number = 0;
  public centerY: number = 0;
}

export class FolderGridPositionHookCallbackParams {
  public dragGridParam?: DragGridParam;
  public centerX: number = 0;
  public centerY: number = 0;
}

/**
 * 多选拖拽 debug命令配置
 */
export class FolderGridPositionHelpDebug {
  constructor() {
    const debugCommand: DebugCommand[] = [
      {
        cmdName: 'getRect',
        callback: (args: Array<string>): string => {
          let params = args.join('').split('/');
          let rect = FolderGridPositionHelp.getInstance().getPositionByRowCol(
            params[0], Number(params[1]), Number(params[2])
          );
          return JSON.stringify(rect);
        }
      }
    ];
    DebugCommandManager.getInstance().register('folderGrid', debugCommand);
  };
}