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
export class BitUtil {
  private constructor() {
  }

  /**
   * 根据索引修改某一位的值
   * @param base 待修改的数据
   * @param idx 要修改位的索引
   * @param isOn 开或关(即置1或置0)
   * @returns 将 base 进行修改后的值
   */
  public static changeByIdx(base: number, idx: number, isOn: boolean): number {
    if (isOn) {
      return base | (1 << idx);
    } else {
      return base & (~(1 << idx));
    }
  }

  /**
   * 获取数据指定位的索引
   * @param base 数据
   * @param idx 索引
   * @returns 数据的指定位索引是否为1
   */
  public static getStateByIdx(base: number, idx: number): boolean {
    return (base & (1 << idx)) === (1 << idx);
  }
}