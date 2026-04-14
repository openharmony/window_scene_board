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
import { CheckEmptyUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { FolderEventConstants } from '@ohos/launchercommon/src/main/ets/constants/FolderEventConstants';
import { CommonConstants, GridLayoutItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { OpenFolderAppMoveVm } from './OpenFolderAppMoveVM';

const TAG = 'OpenFolderAppMoveVMManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹内图标是预加载节点,关闭文件夹不会销毁
 * 需要将负责挤位的OpenFolderAppMoveVM集中管理
 * 给OpenFolderDragHandler提供接口做动效
 */
class OpenFolderAppMoveVMManager {
  private openFolderAppMoveVmItems: Array<OpenFolderAppMoveVm> = [];

  /**
   * vm添加到array中
   *
   * @param openFolderAppMoveVm 待添加的Vm
   */
  public registerItem(openFolderAppMoveVm: OpenFolderAppMoveVm): void {
    log.showInfo('registerItem %{public}s ', openFolderAppMoveVm);
    this.openFolderAppMoveVmItems.push(openFolderAppMoveVm);
  }

  /**
   * 通过布局信息item从array中获取挤位的itemVm
   *
   * @param item 待查找元素的布局信息item
   * @returns 查找到的itemVm,若为空则new一个itemVm返回
   */
  public getMoveVmByItem(item: GridLayoutItemInfo): OpenFolderAppMoveVm {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showError('item is undefined');
      return new OpenFolderAppMoveVm();
    }
    let id = this.generatedItemId(item);
    let index: number = this.openFolderAppMoveVmItems.findIndex(itemVm => {
      return itemVm.id === id;
    }) ?? CommonConstants.INVALID_VALUE;
    // 安装之后应用还没刷新,使用安装之前的节点做动效
    if (index === CommonConstants.INVALID_VALUE) {
      let findIndex: number = this.openFolderAppMoveVmItems.findIndex(itemVm => {
        return itemVm.id.startsWith(item.bundleName);
      })
      if (findIndex === CommonConstants.INVALID_VALUE) {
        log.showWarn('getMoveVmById find fail : %{public}s', id);
        return new OpenFolderAppMoveVm();
      }
      index = findIndex;
    }
    return this.openFolderAppMoveVmItems[index];
  }

  /**
   * 从array中删去item的vm,通过对象地址进行比较删除
   *
   * @param keyName 待移除item的keyName
   */
  public unregisterItem(openFolderAppMoveVm: OpenFolderAppMoveVm): void {
    let index: number = this.openFolderAppMoveVmItems.findIndex(item => {
      return item === openFolderAppMoveVm;
    }) ?? CommonConstants.INVALID_VALUE;
    if (index !== CommonConstants.INVALID_VALUE) {
      this.openFolderAppMoveVmItems.splice(index, 1);
      log.showInfo('unregisterItem succeed %{public}s ', openFolderAppMoveVm.id);
      return;
    }
    log.showInfo('unregisterItem fail %{public}s ', openFolderAppMoveVm.id);
    return;
  }

  /**
   * 通过布局信息生成唯一id
   *
   * @param item 原始布局信息
   */
  public generatedItemId(item: GridLayoutItemInfo): string {
    let itemKeyName = item.keyName ?? item.bundleName;
    return itemKeyName;
  }

  /**
   * 重置偏移量
   *
   * @param item 原始布局信息
   */
  public resetTransLate(): void {
    this.openFolderAppMoveVmItems.forEach((itemVm: OpenFolderAppMoveVm) => {
      if (itemVm.translateX !== 0 || itemVm.translateY !== 0) {
        itemVm.translateX = 0;
        itemVm.translateY = 0;
      }
    })
  }

}

export let openFolderAppMoveVMManager: OpenFolderAppMoveVMManager =
  SingletonHelper.getInstance(OpenFolderAppMoveVMManager, TAG);