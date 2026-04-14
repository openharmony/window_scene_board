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
import { BuilderNode, FrameNode, NodeController, UIContext } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'BaseNodeController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

type NodeBuilder<T> = (params: T) => void

/**
 * 组件控制器类
 * 支持在组件生命周期中增加业务逻辑、更新组件数据，可以继承当前类进行自定义。
 */
export class BaseNodeController<T extends object> extends NodeController {
  protected node?: BuilderNode<[T]>;
  protected builder: NodeBuilder<T>;
  protected params?: T;

  constructor(builder: NodeBuilder<T>, params?: T) {
    super();
    this.builder = builder;
    this.params = params;
  }

  public aboutToAppear(): void {
    log.showInfo('aboutToAppear');
  }

  public aboutToDisappear(): void {
    log.showInfo('aboutToDisappear');
  }

  public destroy(): void {
    this.node?.dispose();
    this.node = undefined;
  }

  /**
   * 创建FrameNode
   * @param uiContext 上下文
   * @returns FrameNode
   */
  public makeNode(uiContext: UIContext): FrameNode | null {
    if (!this.node) {
      this.node = new BuilderNode<[T]>(uiContext);
      this.node.build(new WrappedBuilder<[T]>(this.builder), this.params);
    }
    return this.node.getFrameNode() || null;
  }

  /**
   * 更新组件数据
   * @param params 新组件数据
   */
  public update(params: T): void {
    this.params = params;
    this.node?.update(params);
  }
}
