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
import { SlWidgetId } from '../../../constants/SlWidgetConst';
import { SlStateMgr } from '../constants/SlStateConst';

/**
 * 锁屏模块组件ID辅助工具
 */
export class SlIdHelper {
  private constructor() {
  }

  /**
   * 组件拼接ID
   *
   * @param stateMgr 状态扩展适配
   * @param id 静态ID名
   * @returns 拼接ID名
   */
  public static getViewId(stateMgr: SlStateMgr, id: SlWidgetId): string {
    // 根ID无需拼接
    if (id === SlWidgetId.ROOT_ID) {
      return id;
    }
    return `${stateMgr}_${id}`;
  }
}