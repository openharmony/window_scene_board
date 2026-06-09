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
import { CapShowType } from '../../constants/ImmCapConst';

/**
 * 胶囊类型链式链条
 */
export class CapTypeChainV2 {
  /**
   * 胶囊类型
   */
  private capType: CapShowType = CapShowType.CAP_NONE;

  /**
   * 下一个节点
   */
  private nextChain?: CapTypeChainV2;

  /**
   * 构造
   *
   * @param capType 胶囊类型
   */
  constructor(capType: CapShowType) {
    this.capType = capType;
  }

  /**
   * 添加链条节点
   *
   * @param chain 节点
   * @returns 链式
   */
  addChain(chain: CapTypeChainV2): CapTypeChainV2 {
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
  getCapType(): CapShowType {
    return this.capType;
  }

  /**
   * 下一个节点
   *
   * @returns 节点
   */
  getNext(): CapTypeChainV2 | undefined {
    return this.nextChain;
  }
}