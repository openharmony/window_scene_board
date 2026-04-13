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
import {
  PromiseInterrupt,
  interruptMgr
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/manager/PromiseInterruptManager';
import { InterruptName } from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/common/ImmersiveInterruptName';

// 沉浸锁屏模块拦截器统一管理
class ImmersiveInterruptHelper {
  // 通知列表数据更新拦截器
  public readonly ntfDataChangeIt: PromiseInterrupt = interruptMgr.getInterrupt(InterruptName.NTF_DATA_CHANGE);

  // 通知列表item堆叠动效刷新拦截器
  public readonly ntfItemAnimIt: PromiseInterrupt = interruptMgr.getInterrupt(InterruptName.NTF_ITEM_ANIM_PARAS);

  // 胶囊过渡列表动效拦截器
  public readonly animCap2ListIt: PromiseInterrupt = interruptMgr.getInterrupt(InterruptName.ANIM_CAP_TO_LIST);

  // 沉浸卡片数据更新拦截器
  public readonly cardDataChangeIt: PromiseInterrupt = interruptMgr.getInterrupt(InterruptName.CARD_DATA_CHANGE);

  // 列表过渡大卡动效finish拦截器
  public readonly animListCardIt: PromiseInterrupt = interruptMgr.getInterrupt(InterruptName.ANIM_LIST_CARD);
}

// 单例
export let interruptHelper: ImmersiveInterruptHelper = new ImmersiveInterruptHelper();