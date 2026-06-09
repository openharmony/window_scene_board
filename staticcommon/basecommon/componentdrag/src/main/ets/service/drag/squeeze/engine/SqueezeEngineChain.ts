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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DragGridItem } from '../../common/type/CommonTypes';
import { SqueezeEngineType, SqueezeResult } from '../../common/type/SqueezeTypes';
import { Engine } from './Engine';
import { EngineFactory } from './EngineFactory';

const TAG = 'SqueezeEngineChain';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 挤位引擎责任链，根据业务传入的挤位引擎类型，把对应的挤位引擎形成责任链，并返回最终的挤位结果
 */
export class SqueezeEngineChain {
  private squeezeEngines: Engine[] = new Array<Engine>();
  private squeezeResult: Map<DragGridItem, SqueezeResult> = new Map();
  private isZSqueeze: boolean = true;

  /**
   * 创建挤位引擎责任链类
   *
   * @param isZSqueeze 是否为Z字形挤位（当前手机桌面为Z字形挤位、PC桌面为N字形挤位）
   * Z字形挤位：发生挤位时，被挤位的元素，优先在当前行移动位置，如果当前行已满，则移动到附近行；
   * N字形挤位：发生挤位时，被挤位的元素，优先在当前列移动位置，如果当前列已满，则移动到附近列；
   */
  constructor(isZSqueeze: boolean) {
    this.isZSqueeze = isZSqueeze;
  }

  /**
   * 添加挤位引擎类型（业务侧调用该方法时需要保证，每种引擎最多只能加入一次，避免形成环形责任链）
   *
   * @param engineType 挤位引擎类型
   */
  public addSqueezeEngineType(engineType: SqueezeEngineType): void {
    let squeezeEngin: Engine = EngineFactory.getEngine(engineType);
    if (squeezeEngin) {
      log.showInfo(`add squeeze engine type: ${engineType}`);
      this.squeezeEngines.push(squeezeEngin);
    }
  }

  /**
   * 获取挤位结果
   *
   * @param x 被拖拽item的x坐标
   * @param y 被拖拽item的y坐标
   * @returns 挤位结果 DragGridItem:被挤位元素, SqueezeResult:被挤位元素对应宫格的起点和终点的行列值
   */
  public getSqueezeResult(x: number, y: number): Map<DragGridItem, SqueezeResult> {
    this.squeezeResult.clear();
    for (let i = 0; i < this.squeezeEngines.length; ++i) {
      let squeezeEngine: Engine = this.squeezeEngines[i];
      this.squeezeResult = squeezeEngine.computeSqueezeResult(x, y, this.isZSqueeze);
      if (this.squeezeResult.size !== 0) {
        log.showDebug(`the ${i} engin squeeze success`);
        return this.squeezeResult;
      }
    }
    return this.squeezeResult;
  }
}