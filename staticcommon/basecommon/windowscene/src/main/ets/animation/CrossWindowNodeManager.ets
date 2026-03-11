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
import sceneSessionManager from '@ohos.sceneSessionManager';
import { CrossWindowNodeController } from './CrossWindowNodeController';
import { BuilderNode } from '@kit.ArkUI';
import { NodeBuildParams } from './NodeBuildParams';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { HashMap } from '@kit.ArkTS';

const TAG = 'Animation-CrossWindowNodeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * 跨窗口组件迁移管理器
 */
export class CrossWindowNodeManager<T extends object> {
  /**
   * 共享组件创建参数Map
   */
  protected paramsMap: HashMap<string, T> = new HashMap();
  /**
   * 共享组件节点Map
   */
  protected nodeGroup: HashMap<string, BuilderNode<[T]>> = new HashMap();
  /**
   * 节点控制器Map
   */
  protected nodeControllerMap: HashMap<string, CrossWindowNodeController<T>> = new HashMap();

  /**
   * 注册节点控制器
   *
   * @param nodeControllerKey 节点控制器key
   * @param crossWindowNodeController 节点控制器
   */
  public registerNodeController(nodeControllerKey: string,
    crossWindowNodeController: CrossWindowNodeController<T>): void {
    if (!this.hasNodeController(nodeControllerKey)) {
      this.nodeControllerMap.set(nodeControllerKey, crossWindowNodeController);
    }
  }

  /**
   * 获取节点控制器
   *
   * @param nodeControllerKey 节点控制器key
   * @return CrossWindowNodeController 节点控制器
   */
  public getNodeController(nodeControllerKey: string): CrossWindowNodeController<T> | undefined {
    return this.nodeControllerMap.get(nodeControllerKey);
  }

  /**
   * 判断是否有节点控制器
   *
   * @param nodeControllerKey 节点控制器key
   * @return boolean 是否有节点控制器
   */
  public hasNodeController(nodeControllerKey: string): boolean {
    return this.nodeControllerMap.hasKey(nodeControllerKey);
  }

  /**
   * 删除节点控制器
   *
   * @param nodeControllerKey 节点控制器key
   */
  public deleteNodeController(nodeControllerKey: string): void {
    const curNodeController = this.nodeControllerMap.get(nodeControllerKey);
    // 先释放节点控制器缓存资源，再删除controller
    curNodeController?.delResource();
    this.nodeControllerMap.remove(nodeControllerKey);
    this.paramsMap.remove(nodeControllerKey);
  }

  /**
   * 清空节点控制器
   */
  public clear(): void {
    this.nodeControllerMap.clear();
    this.paramsMap.clear();
  }

  /**
   * 创建或更新共享组件节点
   *
   * @param params 跨窗口组件节点创建参数
   * @return CrossWindowNodeController 节点控制器
   */
  public createOrUpdateNode(params: NodeBuildParams<T>): CrossWindowNodeController<T> {
    log.showInfo(`setOrUpdateNodeParams ${params.nodeControllerKey} from ${params.from}`);
    this.paramsMap.set(params.nodeControllerKey, params.nodeParams);
    if (this.hasNodeController(params.nodeControllerKey)) {
      let nodeController = this.nodeControllerMap.get(params.nodeControllerKey);
      nodeController.updateParams(params.nodeParams);
      this.nodeGroup.set(params.shareNodeGroup, nodeController.node);
      // 节点更新后要同步更新同组其他节点控制器
      this.nodeControllerMap.forEach((value, key) => {
        if (key !== params.nodeControllerKey && value?.shareNodeGroup === nodeController.shareNodeGroup) {
          value?.updateParams(params.nodeParams);
        }
      });
      return nodeController;
    }

    let shareNode = this.nodeGroup.get(params.shareNodeGroup);
    let newNodeController = this.createNodeController(params, shareNode);
    newNodeController.makeNode(sceneSessionManager.getRootSceneUIContext(), params.from);
    if (!shareNode) {
      this.nodeGroup.set(params.shareNodeGroup, newNodeController.node);
    }
    this.registerNodeController(params.nodeControllerKey, newNodeController);
    return newNodeController;
  }

  /**
   * 创建新节点控制器
   *
   * @param params 跨窗口组件节点创建参数
   * @return CrossWindowNodeController 节点控制器
   */
  protected createNodeController(params: NodeBuildParams<T>,
    shareNode: BuilderNode<[T]>): CrossWindowNodeController<T> {
    return new CrossWindowNodeController(params, shareNode);
  }

  /**
   * 展示指定的共享组件节点
   *
   * @param nodeControllerKey 节点控制器key
   * @param shareNodeGroup 共享组件节点分组
   */
  public showNode(nodeControllerKey: string, shareNodeGroup: string): void {
    let nodeController = this.getNodeController(nodeControllerKey);
    if (nodeController) {
      nodeController.node = this.nodeGroup.get(shareNodeGroup);
      nodeController.toShow();
    } else {
      log.showError(`get nodeController fail by nodeControllerKey : ${nodeControllerKey}`);
    }
  }

  /**
   * 隐藏指定的共享组件节点
   *
   * @param nodeControllerKey 节点控制器key
   * @param shareNodeGroup 共享组件节点分组
   */
  public hideNode(nodeControllerKey: string, shareNodeGroup: string): void {
    let nodeController = this.getNodeController(nodeControllerKey);
    if (nodeController) {
      this.nodeGroup.set(shareNodeGroup, nodeController.node);
      nodeController.toHide();
    } else {
      log.showError(`get nodeController fail by nodeControllerKey : ${nodeControllerKey}`);
    }
  }
}