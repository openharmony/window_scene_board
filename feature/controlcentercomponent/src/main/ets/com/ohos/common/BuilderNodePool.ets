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

import { BuilderNode, FrameNode, NodeController, UIContext } from '@kit.ArkUI';
import { HashMap } from '@kit.ArkTS';
import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';

const TAG: string = 'Ctrl.BuilderNodePool';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const MAX_ID: number = 10000;

/**
 * 继承NodeController，创建可以复用的子组件
 */
export class NodeItem extends NodeController {
  public builder: WrappedBuilder<ESObject> | null = null;
  public node: BuilderNode<ESObject> | null = null;
  public data: ESObject = {};

  // 子组件类型，复用时会根据type查找对应的子组件使用
  public type: string = '';
  public id: number = 0;

  aboutToDisappear(): void {
    // 当子组件下树时回收组件到复用池中
    NodePool.getInstance().recycleNode(this.type, this);
  }

  update(data: ESObject) {
    this.data = data;
    this.node?.reuse(data);
  }

  /**
   * 创建节点
   */
  makeNode(uiContext: UIContext): FrameNode | null {
    if (!this.node) {
      this.node = new BuilderNode(uiContext);
      this.node.build(this.builder, this.data);
    } else {
      this.update(this.data);
    }
    return this.node.getFrameNode();
  }
}

/**
 * 全局组件复用池
 */
export class NodePool {
  private static instance: NodePool;
  private idGen: number;
  private nodePool: HashMap<string, NodeItem[]>;

  private constructor() {
    this.nodePool = new HashMap();
    this.idGen = 0;
  }

  /**
   * 使用单例模式，用于全局管理组件复用池
   */
  public static getInstance() {
    log.showInfo('getInstance')
    if (!NodePool.instance) {
      NodePool.instance = new NodePool();
    }
    return NodePool.instance;
  }

  /**
   * 获取组件ID
   */
  public getNextId(): number {
    if (this.idGen >= MAX_ID) {
      this.idGen = 0;
    }
    this.idGen += 1;
    return this.idGen;
  }

  /**
   * 根据type获取子组件，如果有则直接复用，如果没有则创建新的子组件
   */
  public getNode(type: string, item: ESObject,
    builder: WrappedBuilder<ESObject>): NodeItem | undefined {
    log.showDebug('type:' + type);
    let nodeItem: NodeItem | undefined = this.nodePool.get(type)?.pop();
    if (!nodeItem) {
      log.showDebug('new NodeItem:' + type);
      nodeItem = new NodeItem();
      nodeItem.builder = builder;
      nodeItem.data = item;
      nodeItem.type = type;
    } else {
      nodeItem.data = item;
    }
    return nodeItem;
  }

  /**
   * 回收子组件到复用池中
   */
  public recycleNode(type: string, node: NodeItem) {
    let nodeArray: NodeItem[] = this.nodePool.get(type);
    if (!nodeArray) {
      nodeArray = [];
      this.nodePool.set(type, nodeArray);
    }
    nodeArray.push(node);
  }
}