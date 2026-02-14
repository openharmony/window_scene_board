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
import { IconExtendParam } from './IconExtendParam';

/**
 * 任务信息
 */
export class TaskInfo {
  // 包名
  bundleName: string;

  // 模块名
  moduleName: string;

  // 能力名
  abilityName: string;

  // 扩展参数
  param: IconExtendParam;

  constructor(bundleName: string, moduleName: string, abilityName: string, param: IconExtendParam) {
    this.bundleName = bundleName;
    this.moduleName = moduleName;
    this.abilityName = abilityName;
    this.param = param;
  }

}