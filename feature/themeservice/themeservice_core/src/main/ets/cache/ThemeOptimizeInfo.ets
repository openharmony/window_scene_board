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
import { OriginType } from '@ohos/themeservice_inner_api/Index';

/**
 * ThemeOptimizeInfo 记录主题原始文件hash映射(当前仅记录预置主题包文件hash)
 */
export class ThemeOptimizeInfo {
  /**
   * 主题ID
   */
  public themeId: string = '';
  /**
   * 主题类型
   */
  public originType: OriginType = 'preset';
  /**
   * 优化资源类型
   */
  public optType: string = '';
  /**
   * 原始文件名称
   */
  public name: string = '';
  /**
   * 文件hash值
   */
  public hash: string = '';

  constructor(themeId: string, originType: OriginType, optType: string, name: string, hash: string) {
    this.themeId = themeId;
    this.originType = originType;
    this.optType = optType;
    this.name = name;
    this.hash = hash;
  }
}