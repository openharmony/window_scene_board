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
import { DropAnimationCancelReason } from '../config/DropAnimationConfig';

/**
 * 用于ts文件调用落位动效的接口
 */
export class DropAnimationTsAdapter {
  /**
   * 取消落位动效的方法，由DropAnimationManager设置
   */
  public static cancelFunc?: (reason: DropAnimationCancelReason) => void;

  /**
   * 取消落位动效
   *
   * @param reason 取消落位动效的原因
   */
  public static cancelDropAnimation(reason: DropAnimationCancelReason): void {
    DropAnimationTsAdapter.cancelFunc?.(reason);
  }
}