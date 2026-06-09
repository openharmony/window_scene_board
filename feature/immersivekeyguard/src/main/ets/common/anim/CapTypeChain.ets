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
import { CommonUtils } from '@ohos/basicutils';
import { CapsulePositionType } from '../ImmersiveConstants';

/**
 * 胶囊类型链式链条
 */
export class CapTypeChain {
  /**
   * 胶囊类型
   */
  private capPosType: CapsulePositionType = CapsulePositionType.TYPE_NONE;

  /**
   * 下一个节点
   */
  private nextChain?: CapTypeChain;

  /**
   * 构造
   *
   * @param capPosType 胶囊类型
   */
  constructor(capPosType: CapsulePositionType) {
    this.capPosType = capPosType;
  }

  /**
   * 添加链条节点
   *
   * @param chain 节点
   * @returns 链式
   */
  addChain(chain: CapTypeChain): CapTypeChain {
    if (CommonUtils.isInvalid(this.nextChain)) {
      this.nextChain = chain;
    } else {
      this.nextChain?.addChain(chain);
    }
    return this;
  }

  /**
   * 胶囊类型
   *
   * @returns 胶囊类型
   */
  getCapType(): CapsulePositionType {
    return this.capPosType;
  }

  /**
   * 下一个节点
   *
   * @returns 节点
   */
  getNext(): CapTypeChain | undefined {
    return this.nextChain;
  }
}