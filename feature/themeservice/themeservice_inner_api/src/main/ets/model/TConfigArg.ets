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
import { Qualifier, TargetType } from '../constant/TSTypes';

export interface TConfigArg {
  /**
   * 目标目录
   */
  target: TargetType;

  /**
   * 限定符
   */
  qualifier?: Qualifier;

  /**
   *文件名称（如："lock_config.json"）
   */
  fileName: string;

  /**
   * 需要写入的内容
   */
  value: string

  /**
   * 需要拷贝的原始路径，可以不传
   */
  originPath?: string
}