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
import { LauncherScreenFaItem } from './LauncherScreenFaItem';
import { LauncherStackInfo } from './LauncherStackInfo';

/**
 * 桌面所有的卡片和堆叠信息
 *
 * @since 2025-01-08
 */
export class LauncherFormAndFormStackInfo {
  /**
   * 屏幕索引
   */
  public screenIndex: number = 0;

  /**
   * FA信息
   */
  public forms?: LauncherScreenFaItem[] = [];

  /**
   * 堆叠信息
   */
  public stacks?: LauncherStackInfo[] = [];
}