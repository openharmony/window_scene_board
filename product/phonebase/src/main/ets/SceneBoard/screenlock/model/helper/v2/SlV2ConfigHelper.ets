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

import { SlStateMgr } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { SlV2OuterConfigHelper } from './SlV2OuterConfigHelper';

/**
 * 锁屏V2样式配置辅助工具
 */
class SlV2ConfigHelper {
  // 通用样式配置初始化
  private readonly initComConfig: () => void = () => {
  }

  // 小外屏设备样式配置初始化
  private readonly initOuterConfig: () => void = () => {
    let helper: SlV2OuterConfigHelper = new SlV2OuterConfigHelper();
    helper.initOuterConfig();
  }

  // 初始化配置集
  private readonly config: Map<SlStateMgr, Function> = new Map([
    [SlStateMgr.MGR_COMMON, this.initComConfig],
    [SlStateMgr.MGR_OUTER_SCREEN, this.initOuterConfig]
  ]);

  /**
   * 启动样式配置初始化
   *
   * @param stateMgr 状态管理分类
   */
  public initStyleConfig(stateMgr: SlStateMgr): void {
    this.config.get(stateMgr)?.();
  }
}

// 单例，V2样式配置辅助工具
export const slV2Config: SlV2ConfigHelper = new SlV2ConfigHelper();