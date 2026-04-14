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

// import { BallParams, MetaballController } from '@hms.hds.Metaball';
import { StatusBarCapsulePosition } from '../../statusbar/model/StatusBarCapsulePosition';
import { LiveMetaBallScene } from '../model/LiveCommonModel';
import { CustomPromise } from '@ohos/frameworkwrapper';
import { CapsuleTransferParam } from './ILiveCapsuleListVm';
import type { Hole } from '../../statusbar/vm/CutoutVm';

/**
 * 融球组件VM
 */
export interface ILiveMetaBallVm {
  // controller: MetaballController;
  controller: ESObject;
  scaleX: number;
  scaleY: number;
  offsetY: number;
  /**
   * 融球当前所属场景
   */
  sceneSet: Set<LiveMetaBallScene>

  /**
   * 获取融球组件宽度
   */
  getWidth(capsulePosition: StatusBarCapsulePosition): number;

  /**
   * 获取融球组件高度
   */
  getHeight(capsulePosition: StatusBarCapsulePosition): number;

  /**
   * 获取融球组件布局位置
   * @returns
   */
  getPosition(capsulePosition: StatusBarCapsulePosition): LocalizedEdges | Edges;

  /**
   * 获取中间孔
   */
  getMiddleHole(): Hole;

  // /**
  //  * 获取融球配置信息
  //  */
  // getBallParam(capsulePosition: StatusBarCapsulePosition): BallParams[];

  /**
   * 融球状态切换
   * @param scene 目标场景
   */
  toggleState(capsuleTransferParam?: CapsuleTransferParam): Promise<void>;

  /**
   * 设置场景
   */
  setScene(scene: LiveMetaBallScene, isAdd: boolean): void;

  /**
   * 更新vm的某些属性，在vm切换时调用，如有孔vm切换至无孔vm，需要保证切换前后数据一致性
   * @param vm
   */
  updateProperty(vm: ILiveMetaBallVm): void;

  /**
   * 组件销毁的处理
   */
  onDisappear(): void;
}