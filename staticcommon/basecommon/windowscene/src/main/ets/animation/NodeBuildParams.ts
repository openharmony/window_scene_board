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

type NodeBuilder<T> = (params: T) => void;

/**
 * 跨窗口组件节点创建参数
 */
export class NodeBuildParams<T extends object> {
  /**
   * 是否显示共享组件
   */
  isShow: boolean;
  /**
   * 共享组件构造器
   */
  builder: NodeBuilder<T>;
  /**
   * 节点控制器key
   */
  nodeControllerKey: string;
  /**
   * 共享组件分组
   */
  shareNodeGroup: string;
  /**
   * 共享组件创建参数
   */
  nodeParams?: T;
  /**
   * 节点创建来源
   */
  from?: string;
}