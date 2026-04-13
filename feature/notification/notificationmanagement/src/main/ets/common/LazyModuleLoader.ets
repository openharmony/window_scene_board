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

import {
  FontScaleManager,
  fontScaleManager } from '@ohos/managementcomponent';
import NotificationManagenmentViewModel from '../vm/notificationManagenmentViewModel';

interface NtfAndStatusLazyLoadResult {
  viewModel: NotificationManagenmentViewModel;
  fontScaleManager: FontScaleManager;
}

/**
 * 初始化懒加载模块
 * @returns
 */
export function initLazyModules(): void {
  fontScaleManager.initFontScaleState();
}

/**
 * 初始化通知和状态栏懒加载模块
 * @returns
 */
export function initLazyModulesForNtfAndStatusBar(): NtfAndStatusLazyLoadResult {
  initLazyModules();
  const result: NtfAndStatusLazyLoadResult = {
    viewModel: new NotificationManagenmentViewModel(),
    fontScaleManager,
  };
  return result;
}