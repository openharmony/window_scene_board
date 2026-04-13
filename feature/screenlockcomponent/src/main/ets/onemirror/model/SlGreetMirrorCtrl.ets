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

import { MirrorAnimState } from '../constants/MirrorToEndConst';
import IComponentMirrorCtrl from './IComponentMirrorCtrl';

const TAG = 'SlGreetMirrorCtrl';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const AOD_ALPHA = 1; // AOD下透明度

// 锁头、签名一镜到底动效管理
export class SlGreetMirrorCtrl implements IComponentMirrorCtrl {
  /**
   *
   *  动画结束设值
   *
   * @param scene
   */
  setUiBindState(scene: string): void {
  }

  setPartUiBindState(scene: string): void {
  }

  /**
   *  做的的一镜到底动画
   *
   * @param scene 动画场景
   */
  setAnimState(scene: string): void {
  }

  setAnimEmoji(scene: string): void {

  }

  setPartAodUiBindState(scene: string): void {
  }

  setPartAodAnimState(scene: string): void {
  }


  /**
   *  动效启停，相关
   *
   * @param scene
   * @param state
   * @param isStart
   */
  startAnim(scene: string, state: MirrorAnimState, isStart: boolean): void {
  }

  clearAnimating(): void {
  }

  isSceneAnimating(scene: string): boolean {
    return false;
  }
}