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
import { BaseNodeController } from './BaseNodeController';
import { BaseNodeParams } from './BaseNodeParams';
import sceneSessionManager from '@ohos.sceneSessionManager';

const TAG = 'BaseNodeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 组件节点控制器统一管理基类
 */
export abstract class BaseNodeManager<P extends BaseNodeParams, N extends BaseNodeController<P>> {
  protected paramsMap: Map<string, P> = new Map();
  protected nodeControllerMap: Map<string, N> = new Map();

  /**
   * 创建节点时校验节点是否有效
   *
   * @param node 节点
   * @param nodeKey 节点key
   */
  protected checkNodeValid(node: N, nodeKey: string): boolean {
    const nodeId = node.rootNode?.getFrameNode()?.getUniqueId();
    if (nodeId) {
      return true;
    }
    return false;
  }

  /**
   * 注册节点
   *
   * @param nodeKey 节点key
   * @param nodeControl 节点
   */
  public addNodeController(nodeKey: string, nodeControl: N): void {
      this.nodeControllerMap.set(nodeKey, nodeControl);
  }

  /**
   * 判断是否有节点
   *
   * @param nodeKey: 节点key
   * @return 是否有节点
   */
  public hasNodeController(nodeKey: string): boolean {
    return this.nodeControllerMap.has(nodeKey);
  }

  /**
   * 删除节点
   *
   * @param nodeKey 节点key
   */
  public deleteNodeController(nodeKey: string): void {
    log.showInfo(`deleteNodeController ${nodeKey}`);
    const curNodeController = this.nodeControllerMap.get(nodeKey);
    // 先释放节点缓存资源，再删除controller
    curNodeController?.delResource();
    this.nodeControllerMap.delete(nodeKey);
    this.paramsMap.delete(nodeKey);
  }

  /**
   * 清空节点
   */
  public clear(): void {
    this.nodeControllerMap.clear();
    this.paramsMap.clear();
  }

  /**
   * 获取节点参数
   *
   * @param nodeKey 节点key
   * @returns initNodeParams
   */
  public getNodeParams(nodeKey: string): P {
    let params: P | undefined = this.paramsMap.get(nodeKey);
    if (params) {
      return params;
    }
    params = this.createParam();
    this.paramsMap.set(nodeKey, params);
    return params;
  }

  /**
   * 更新节点参数并更新节点
   *
   * @param nodeKey 节点key
   */
  public updateNodeParams(nodeKey: string, params: P, from?: string): void {
    log.showInfo(`updateNodeParams ${nodeKey} from ${from}`);
    this.paramsMap.set(nodeKey, params);
    this.getOrCreateNode(nodeKey, from);
  }

  /**
   * 创建节点控制器
   *
   * @param nodeKey 节点key
   *
   * @returns 节点控制器
   */
  public getOrCreateNode(nodeKey: string, from?: string): N {
    let params: P = this.getNodeParams(nodeKey);
    if (this.hasNodeController(nodeKey)) {
      let node: N = this.nodeControllerMap.get(nodeKey) as N;
      log.showInfo(`getOrCreateNode hasNodeController ${nodeKey} from ${from}`);
      if (this.checkNodeValid(node, nodeKey)) {
        log.showInfo(`getOrCreateNode checkNodeValid ${nodeKey} from ${from}`);
        node.updateParams(params);
        return node;
      }
      log.showInfo(`getOrCreateNode delete controller of null rootNode ${nodeKey} from ${from}`);
      this.deleteNodeController(nodeKey);
    }
    let newNode: N = this.createNode(nodeKey, params);
    newNode.makeNode(sceneSessionManager.getRootSceneUIContext(), ` ${nodeKey} ${from}`);
    this.addNodeController(nodeKey, newNode);
    return newNode;
  }

  /**
   * 创建新节点
   *
   * @param nodeKey 节点key
   * @param params 节点参数
   *
   * @returns 新建节点
   */
  protected abstract createNode(nodeKey: string, params: P): N;

  /**
   * 创建新属性
   */
  protected abstract createParam(): P;
}