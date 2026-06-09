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
import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import { localEventManager } from '@ohos/frameworkwrapper';
import { EventConstants } from '@ohos/launchercommon/src/main/ets/constants/EventConstants';
import AppBubbleParams from '@ohos/launchercommon/src/main/ets/buildernode/AppBubbleParams';
import AppBubbleCommonParams from '@ohos/launchercommon/src/main/ets/buildernode/AppBubbleCommonParams';
import { OpenFolderAppBubbleNode } from './OpenFolderAppBubbleNode';
import { OpenFolderAddBubbleNode } from './OpenFolderAddBubbleNode';
import { FolderEventConstants } from '@ohos/launchercommon/src/main/ets/constants/FolderEventConstants';
import {
  openFolderAppBubbleLayout
} from '@ohos/launchercommon/src/main/ets/folder/viewmdoel/OpenFolderAppBubbleLayout';
import { FolderLayoutCacheManager } from '@ohos/launchercommon/src/main/ets/cache/layout/FolderLayoutCacheManager';
import { BaseNodeManager } from '@ohos/launchercommon/src/main/ets/buildernode/BaseNodeManager';
import { FolderManager } from '@ohos/launchercommon/src/main/ets/folder/next/common/model/FolderManager';
import { FolderLifeCyclePriority } from '@ohos/launchercommon/src/main/ets/folder/next/common/FolderCommonConstant';
import GridLayoutItemInfo from '@ohos/launchercommon/src/main/ets/bean/GridLayoutItemInfo';

const TAG = 'FolderAppBubbleNodeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

//NodeControllerManager
/**
 * 组件节点控制器统一管理
 */
export class OpenFolderAppBubbleNodeManager extends BaseNodeManager<AppBubbleParams, OpenFolderAppBubbleNode> {
  private static sInstance: OpenFolderAppBubbleNodeManager;
  private appBubbleCommonParams: AppBubbleCommonParams = new AppBubbleCommonParams();
  private openFolderNodeKeys = new Map<string, string[]>();

  private regisLocalListener = () => {
    localEventManager.registerEventListener({
      onReceiveEvent: (event: string, params: string) => {
        log.showInfo(`update node keys in open folder by event ${event}, params: ${params}`);
        // app升级时，删除节点缓存
        if (event === EventConstants.EVENT_FOLDER_APP_PACKAGE_CHANGED) {
          const bundleNameChanged: string = params;
          this.openFolderNodeKeys.forEach((nodeKeys: string[], folderId: string) => {
            // 反选添加图标节点不删除
            const deleteNodeKeys = nodeKeys.filter((nodeKey: string) =>
              (nodeKey.includes(bundleNameChanged) && !nodeKey.includes(FolderEventConstants.KEY_FOLDER_ADD)));
            if (deleteNodeKeys.length > 0) {
              for (const deleteKey of deleteNodeKeys) {
                log.showInfo(`delete folderAppBubble nodeKey ${deleteKey}`);
                this.deleteNodeController(deleteKey);
              }
              this.openFolderNodeKeys.set(folderId, nodeKeys.filter(key => !deleteNodeKeys.includes(key)));
            }
          });
        } else if (event === EventConstants.EVENT_FOLDER_DELETE_ALL_NODE_CACHE) {
          // 清空所有文件夹展开态的缓存
          this.deleteAllOpenFolderAppNode();
        }
      }
    }, [
      EventConstants.EVENT_FOLDER_APP_PACKAGE_CHANGED,
      EventConstants.EVENT_FOLDER_DELETE_ALL_NODE_CACHE,
    ]);
  };

  private registerFolderDataListener: () => void = () => {
    FolderManager.getInstance().registerDataLifeListener({
      description: TAG,
      priority:FolderLifeCyclePriority.LOW,
      updateFolder: (folderId: string, updateItems: GridLayoutItemInfo[]) => {
        this.updateNodeKeysInOpenFolder(folderId as string, updateItems.map(item => item.keyName));
      },
      updateOpenFolder: (updateFolder: GridLayoutItemInfo) => {
        this.updateNodeKeysInOpenFolder(updateFolder.folderId as string,
          (updateFolder.layoutInfo || []).flat().map(item => item.keyName));
      },
      removeFolder: (folder: GridLayoutItemInfo) => {
        if (folder) {
          this.updateNodeKeysInOpenFolder(folder.folderId, []);
        }
      },
      updateFolderItems: (folderId: string, modifiedItems: GridLayoutItemInfo[]) => {
        let newKeys: string[] = modifiedItems.map(item => item.keyName);
        const oldFolderNodeKeys: string[] = this.openFolderNodeKeys.get(folderId) || [];
        if (CheckEmptyUtils.isEmptyArr(oldFolderNodeKeys)) {
          return;
        }
        this.updateNodeKeysInOpenFolder(folderId, newKeys);
      }
    });
  };

  /**
   * Get instance of UpdateManager
   * @returns instance of UpdateManager
   */
  public static getInstance(): OpenFolderAppBubbleNodeManager {
    if (!OpenFolderAppBubbleNodeManager.sInstance) {
      OpenFolderAppBubbleNodeManager.sInstance = new OpenFolderAppBubbleNodeManager();
      OpenFolderAppBubbleNodeManager.sInstance.registerFolderDataListener();
      OpenFolderAppBubbleNodeManager.sInstance.regisLocalListener();
    }
    return OpenFolderAppBubbleNodeManager.sInstance;
  }

  // 重写删除缓存节点方法：同时删除动效数据
  deleteNodeController(key: string): void {
    super.deleteNodeController(key);
    openFolderAppBubbleLayout.deleteIconData(key);
    openFolderAppBubbleLayout.deleteNameData(key);
  }

  /**
   * 更新文件夹展开态缓存节点nodeKey
   */
  updateNodeKeysInOpenFolder(folderId: string, newNodeKeys: string[]): void {
    const filterNewKeys = newNodeKeys.filter(key => !!key);
    const oldFolderNodeKeys = this.openFolderNodeKeys.get(folderId) || [];
    const isDeleteAll = filterNewKeys.length === 0;
    // 反选添加图标节点不删除
    const deletedNodeKeys = isDeleteAll ? oldFolderNodeKeys : oldFolderNodeKeys.filter(key =>
      (!filterNewKeys.includes(key) && !key.includes(FolderEventConstants.KEY_FOLDER_ADD)));
    if (deletedNodeKeys.length !== 0) {
      log.showInfo(`folderId:${folderId},delete folderAppBubble nodeKeys:${deletedNodeKeys}`);
    }
    deletedNodeKeys.forEach((deleteNodeKey) => this.deleteNodeController(deleteNodeKey));
    if (isDeleteAll) {
      this.openFolderNodeKeys.delete(folderId);
    } else {
      this.openFolderNodeKeys.set(folderId, this.mixFolderAdd(filterNewKeys, oldFolderNodeKeys));
    }
  }

  /**
   * 删除所有展开态节点缓存
   */
  deleteAllOpenFolderAppNode(): void {
    for (let entry of this.openFolderNodeKeys.entries()) {
      // 遍历map中所有的值
      entry[1].forEach((nodeKey: string) => {
        this.deleteNodeController(nodeKey);
      })
    }
  }

  /**
   * 获取appBubble公共参数
   */
  getAppBubbleCommonParams(): AppBubbleCommonParams {
    return this.appBubbleCommonParams;
  }

  /**
   * 设置appBubble公共参数
   */
  setAppBubbleCommonParams(commonParams: AppBubbleCommonParams): void {
    this.appBubbleCommonParams = commonParams;
  }

  /**
   * 创建节点时校验节点是否有效：图标动效参数iconData存在iconId，则图标正常，否则为空白图标
   */
  protected checkNodeValid(node: OpenFolderAppBubbleNode, nodeKey: string): boolean {
    const nodeId = node.rootNode?.getFrameNode()?.getUniqueId();
    const iconId = openFolderAppBubbleLayout.getIconData(nodeKey)?.iconId;
    if (nodeId && !CheckEmptyUtils.checkStrIsEmpty(iconId)) {
      return true;
    }
    return false;
  }

  protected createNode(nodeKey: string, params: AppBubbleParams): OpenFolderAppBubbleNode {
    let newNode: OpenFolderAppBubbleNode;
    if (nodeKey.includes(FolderEventConstants.KEY_FOLDER_ADD)) {
      newNode = new OpenFolderAddBubbleNode(params);
    } else {
      newNode = new OpenFolderAppBubbleNode(params);
    }
    return newNode;
  }

  protected createParam(): AppBubbleParams {
    return new AppBubbleParams();
  }

  /**
   * 批量删除节点
   */
  private deleteNodeControllers(folderId: string, deleteNodeKeys: string[]): void {
    if (deleteNodeKeys.length === 0) {
      return;
    }

    log.showInfo(`delete folderAppBubble folderId ${folderId} nodeKeys ${deleteNodeKeys}`);
    deleteNodeKeys.forEach(nodeKey => this.deleteNodeController(nodeKey));
  }

  /**
   * 补充混合+组件
   */
  private mixFolderAdd(cacheNodeKeys: string[], nodeKeys: string[]): string[] {
    const cacheFolderAdd: string | undefined = cacheNodeKeys.find(
      nodeKey => nodeKey.includes(FolderEventConstants.KEY_FOLDER_ADD));
    if (cacheFolderAdd !== undefined) {
      // 已经包含了+组件
      return cacheNodeKeys;
    }
    const folderAdd: string | undefined = nodeKeys.find(
      nodeKey => nodeKey.includes(FolderEventConstants.KEY_FOLDER_ADD));
    if (folderAdd === undefined) {
      // 原本没有+组件
      return cacheNodeKeys;
    }
    return [...cacheNodeKeys, folderAdd as string];
  }
}
