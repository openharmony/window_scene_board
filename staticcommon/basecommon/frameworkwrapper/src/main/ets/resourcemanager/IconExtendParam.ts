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

/**
 * IconExtendParam 图标扩展参数
 */
export class IconExtendParam {
  // 应用分身index
  appIndex: number = 0;

  // 图标名称
  iconName: string;

  // 应用使用默认模板
  isTemplatedIcon: boolean = false;

  // 通过hds处理时使用的包名（应用在包名基础上追加_template）
  bundleName: string;

  // 是否描边
  hasBorder: boolean = false;

  // 是否有透明边框
  isTransparentBorder: boolean = false;

  //是否获取获取ability图标资源
  isNeedAbilityIcon?: boolean;

  constructor() {}

}