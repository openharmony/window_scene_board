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
import { LauncherFolderInfo } from './LauncherFolderInfo';
import type { LauncherScreenFaItem } from './LauncherScreenFaItem';
import type { LauncherScreenItem } from './LauncherScreenItem';
import type { LauncherStackInfo } from './LauncherStackInfo';

/**
 * 桌面某一屏展示的内容
 *
 * @since 2023-10-08
 */
export class LauncherScreenPageInfo {
  /**
   * docker区域展示的内容
   */
  public docker: LauncherScreenItem[] = [];

  /**
   * 该屏幕大文件夹展示内容
   */
  public bigFolderList: LauncherFolderInfo[] = [];

  /**
   * 普通展示的应用信息
   */
  public apps: LauncherScreenItem[] = [];

  /**
   * 普通展示的FA信息
   */
  public forms: LauncherScreenFaItem[] = [];

  /**
   * 该屏幕对应的堆叠卡片内容
   */
  public stacks?: LauncherStackInfo[] = [];

  /**
   * 组合卡片信息
   */
  public combineForms?: object[] = [];
}