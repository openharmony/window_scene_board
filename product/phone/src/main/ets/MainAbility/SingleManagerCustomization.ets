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

/* 注意！本文件不允许引入非ohos底座以及SingleManager以外的模块，否则容易导致SingleManager循环依赖 */
import { SingleContext, singleManager } from '@ohos/basicutils';
import hilog from '@ohos.hilog';

const TAG = 'SingleManagerCustomization';
const SCB = 0x01b00;

/**
 * 产品定制化单例管理模块：
 * 1. 定制管理模块的列参数以及context参数
 * 2. 定制selector回调，定义每列对应的产品功能/形态
 */
export class SingleManagerCustomization {
  public static init(): void {
    singleManager.initial(2, this.initialSingleContext, this.selectSingleItem);
  }

  private static initialSingleContext(ctx: SingleContext): void {
    hilog.info(SCB, TAG, 'initial single context');
    /**
     * 如果是扩展屏，可以:
     * ctx.extendScreenId = 0;  // 使变量有效，不代表id一直为0。
     */
  }

  private static selectSingleItem(ctx: SingleContext): number {
    hilog.info(SCB, TAG, 'select single item');
    return 0;
    /**
     * 如果是扩展屏，可以:
     * if (ctx.extendScreenId === 0) return 0; // 主屏返回第1个，下标是0
     * return 1; // 其他扩展屏均返回第2个，下标是1
     */
  }
}

SingleManagerCustomization.init();