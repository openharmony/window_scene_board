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

/**
 * 沉浸锁屏模块数据解析控制器类型
 */
export enum ImmersiveKgParserCtrlType {
  TYPE_IMMERSIVE_KG = 'ImmersiveKgData',

  /**
   * 沉浸锁屏类型
   */
  TYPE_IMMERSIVE_NTF_DATA = 'ImmersiveNtfData'
}

// 数据解析控制器对外统一类型
export type ParserControllerType = ImmersiveKgParserCtrlType;