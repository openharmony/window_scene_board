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

import { BuilderNode, FrameNode, NodeController } from '@ohos.arkui.node';
import { UIContext } from '@ohos.arkui.UIContext';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BaseNodeParams } from './BaseNodeParams';

const TAG = 'BaseNodeController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 节点控制器构造器
 */
export type NodeBuilder<T extends BaseNodeParams> = () => T;

/**
 * mission info
 */
export class BaseNodeController<T extends BaseNodeParams> extends NodeController {
  /**
   * 布局装饰器
   */
  wrapBuilder?: WrappedBuilder<[T]> | null = null;

  /**
   * 根节点
   */
  public rootNode: BuilderNode<[T]> | null = null;

  /**
   * 控制器中的相关参数
   */
  public params?: BaseNodeParams;

  /**
   * 创建节点
   */
  makeNode(uiContext: UIContext, from?: string): FrameNode | null {
    if (this.rootNode === null) {
      this.rootNode = new BuilderNode(uiContext);
      this.rootNode.build(this.wrapBuilder, this.params);
      log.showInfo(`makeNode rootNode is null create from ${from} ${this.rootNode.getFrameNode()?.getUniqueId()}`);
    } else {
      log.showInfo(`makeNode rootNode reuse from ${from} ${this.rootNode.getFrameNode()?.getUniqueId()}`);
    }
    return this.rootNode.getFrameNode();
  }

  /**
   * 传递touch事件
   */
  postTouchEvent(touchEvent: TouchEvent): void {
    if (this.rootNode === null) {
      return;
    }
    this.rootNode.postTouchEvent(touchEvent);
  }

  /**
   * 更新参数
   */
  updateParams(params: BaseNodeParams): void {
    if ((params === undefined || params === null) ||
      (this.rootNode === undefined || this.rootNode === null)) {
      log.showInfo('updateParams return');
      return;
    }
    this.params = params;
    this.rootNode.update(params);
  }

  /**
   * 清理资源
   */
  delResource(): void {
    // 立即清理NodeContainer节点，调用后，节点组件会立即走aboutToDisappear
    this.rootNode?.dispose();
    this.rootNode = null;
    this.wrapBuilder = null;
  }
}