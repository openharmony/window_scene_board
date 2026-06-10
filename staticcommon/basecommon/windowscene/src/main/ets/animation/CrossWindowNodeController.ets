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

import { BuilderNode, FrameNode } from '@ohos.arkui.node';
import { UIContext } from '@ohos.arkui.UIContext';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NodeBuildParams } from './NodeBuildParams';
import { NodeController } from '@kit.ArkUI';

const TAG = 'Animation-CrossWindowNodeController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

type NodeBuilder<T> = (params: T) => void;

/**
 * 跨窗口共享组件节点控制器
 */
export class CrossWindowNodeController<T extends object> extends NodeController {
  /**
   * 共享组件构造器
   */
  protected builder: NodeBuilder<T> | null;
  /**
   * 共享组件创建参数
   */
  protected nodeParams?: T;
  /**
   * 共享组件节点上下树标志
   */
  protected isShow: boolean = false;
  /**
   * 共享组件节点
   */
  public node?: BuilderNode<[T]> | null;
  /**
   * 共享组件分组
   */
  public shareNodeGroup: string;

  constructor(params: NodeBuildParams<T>, shareNode: BuilderNode<[T]>) {
    super();
    this.isShow = params.isShow;
    this.builder = params.builder;
    this.nodeParams = params.nodeParams;
    this.shareNodeGroup = params.shareNodeGroup;
    if (shareNode) {
      this.node = shareNode;
    }
  }

  /**
   * 创建FrameNode
   *
   * @param uiContext 上下文
   * @param from 节点创建来源
   * @returns FrameNode
   */
  makeNode(uiContext: UIContext, from?: string): FrameNode | null {
    if (!this.node) {
      this.node = new BuilderNode(uiContext);
      this.node.build(new WrappedBuilder<[T]>(this.builder), this.nodeParams);
      log.showInfo(`makeNode rootNode is null from ${from} ${this.node.getFrameNode()?.getUniqueId()}`);
    }
    if (!this.isShow) {
      return null;
    }
    log.showInfo(`makeNode rootNode reuse from ${from} ${this.node.getFrameNode()?.getUniqueId()}`);
    return this.node.getFrameNode();
  }

  /**
   * 展示共享组件节点
   */
  toShow(): void {
    this.isShow = true;
    this.rebuild();
  }

  /**
   * 隐藏共享组件节点
   */
  toHide(): void {
    this.isShow = false;
    this.rebuild();
  }

  /**
   * 更新节点参数
   *
   * @param nodeParams 共享组件创建参数
   */
  updateParams(nodeParams?: T): void {
    if (!nodeParams || !this.node) {
      log.showInfo('updateParams return');
      return;
    }
    this.nodeParams = nodeParams;
    this.node.update(nodeParams);
  }

  /**
   * 清理资源
   */
  delResource(): void {
    // 立即清理NodeContainer节点，调用后，节点组件会立即走aboutToDisappear
    this.node?.dispose();
    this.node = null;
    this.builder = null;
  }
}