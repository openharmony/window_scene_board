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
import type {
  IInitialized
} from '@ohos/systemuicommon';
import {
  parserCtrlMgr
} from '@ohos/systemuicommon';
import type common from '@ohos.app.ability.common';
import {
  ImmersiveKgParserCtrlType
} from '@ohos/systemuicommon';
import { ImmersiveKgParserController } from './ImmersiveKgParserController';
import { ImmersiveNtfDataParserController } from './ImmersiveNtfParserController';
import { SingletonHelper } from '@ohos/basicutils';

const TAG = 'ImmersiveKgInitializeService';

/**
 * 沉浸实况模块初始化服务
 */
class ImmersiveKgInitializeService implements IInitialized {
  /**
   * 初始化
   *
   * @param ctx 环境
   */
  init(ctx?: common.Context): void {
    // 加入数据解析控制器
    parserCtrlMgr.addParserController(ImmersiveKgParserCtrlType.TYPE_IMMERSIVE_KG, new ImmersiveKgParserController());
    // 加入数据解析控制器
    parserCtrlMgr.addParserController(ImmersiveKgParserCtrlType.TYPE_IMMERSIVE_NTF_DATA,
      new ImmersiveNtfDataParserController());
  }
}

// 单例
export let immersiveKgInit: ImmersiveKgInitializeService =
  SingletonHelper.getInstance(ImmersiveKgInitializeService, TAG);