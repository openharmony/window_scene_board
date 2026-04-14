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
import { BuilderNode, FrameNode, NodeController } from '@kit.ArkUI';
import { HashMap } from '@kit.ArkTS';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GridItemParams } from '../common/components/GridItemReuseComponent';
import { GridLayoutItemInfo, CommonConstants } from '@ohos/launchercommon';

const TAG = 'GridItemsPool';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
type NodeBuilder<T> = (params: T) => void;

/**
 * 桌面GridItem的节点对象
 */
class NodeItem<GridItemParam extends GridItemParams> extends NodeController {
  protected type: string = '';
  protected data: GridItemParams | null = null;
  protected node: BuilderNode<[GridItemParam]> | null = null;
  protected builder: NodeBuilder<GridItemParam> | null = null;

  constructor(builder: NodeBuilder<GridItemParam>, type: string, data: GridItemParams) {
    super();
    this.builder = builder;
    this.type = type;
    this.data = data;
  }

  makeNode(uiContext: UIContext): FrameNode | null {
    if (!this.node) {
      let node: BuilderNode<[GridItemParam]> = new BuilderNode<[GridItemParam]>(uiContext);
      node.build(new WrappedBuilder<[GridItemParam]>(this.builder), this.data);
      this.node = node;
      log.showInfo('NodeItem makeNode create');
    } else {
      log.showInfo('NodeItem makeNode reuse');
    }
    return this.node.getFrameNode();
  }

  update(data: GridItemParams) {
    this.node?.update(data);
    this.data = data;
  }

  aboutToAppear(): void {
    log.showInfo(`NodeItem aboutToAppear type:${this.type}`);
    GridItemsPool.getInstance().setNodeCache(this.type, this as object as NodeItem<GridItemParams>);
  }

  aboutToDisappear(): void {
    log.showInfo(`NodeItem aboutToDisappear type:${this.type}`);
    if (GridItemsPool.getInstance().getIsRelease()) {
      GridItemsPool.getInstance().release(this.data?.item);
    }
  }

  release(): void {
    // 立即清理NodeContainer节点，调用后，节点组件会立即走aboutToDisappear
    this.node?.dispose();
    this.node = null;
    this.builder = null;
    this.data = null;
  }
}

/**
 * 桌面GridItem的缓存池
 */
export class GridItemsPool {
  private static instance: GridItemsPool;
  private nodePool: HashMap<string, NodeItem<GridItemParams>>;
  private isRelease: boolean = true;

  private constructor() {
    this.nodePool = new HashMap<string, NodeItem<GridItemParams>>();
  }

  public static getInstance() {
    if (!GridItemsPool.instance) {
      GridItemsPool.instance = new GridItemsPool();
    }
    return GridItemsPool.instance;
  }

  setIsRelease(isRelease: boolean): void {
    log.showInfo(`setIsRelease: from ${this.isRelease} to ${isRelease}`);
    this.isRelease = isRelease;
  }

  getIsRelease(): boolean {
    return this.isRelease;
  }

  public getNode(data: GridItemParams,
    builder: NodeBuilder<GridItemParams>): NodeItem<GridItemParams> | undefined {
    let type: string = this.getReuseItemKey(data.item);
    let node: NodeItem<GridItemParams> | undefined = this.nodePool.get(type);
    if (CheckEmptyUtils.isEmpty(type) || !node) {
      node = new NodeItem(builder, type, data);
    } else {
      node.update(data);
    }
    return node;
  }

  public setNodeCache(type: string, node: NodeItem<GridItemParams>): void {
    let prevNode: NodeItem<GridItemParams> = this.nodePool.get(type);
    if (CheckEmptyUtils.isEmpty(type)) {
      log.showWarn('node item type is empty');
      return;
    }
    if (!prevNode) {
      this.nodePool.set(type, node);
    }
    log.showInfo(`recycleNode length:${this.nodePool.length}`);
  }

  public release(item?: GridLayoutItemInfo): void {
    try {
      if (!item) {
        this.nodePool.forEach(node => node?.release());
        this.nodePool.clear();
      } else {
        let type: string = this.getReuseItemKey(item);
        this.nodePool.remove(type)?.release();
      }
      log.showInfo(`after release size ${this.nodePool.length}`);
    } catch (error) {
      log.showError(`release error, code: ${error?.code}, message: ${error?.message}`);
    }
  }

  public getReuseItemKey(item: GridLayoutItemInfo): string {
    let key: string = '';
    if (CheckEmptyUtils.isEmpty(item)) {
      return key;
    }
    switch (item.typeId) {
      case CommonConstants.TYPE_APP:
        key = `${item.bundleName}${item.appIndex ?? 0}`;
        break;
      case CommonConstants.TYPE_CARD:
        key = item.cardId ?? '';
        break;
      case CommonConstants.TYPE_REGION_FOLDER:
        key = item.folderId ?? '';
        break;
      case CommonConstants.TYPE_FILE_FOLDER:
        key = item.ino ?? '';
        break;
      case CommonConstants.TYPE_SHORTCUT_ICON:
        key = item.keyName ?? '';
        break;
      default:
        log.showWarn(`getReuseItemKey invalid type:${item.typeId}, keyName:${item.keyName}`);
        break;
    }
    if (CheckEmptyUtils.isEmpty(key)) {
      return key;
    }
    return `${item.typeId}${key}`;
  }
}